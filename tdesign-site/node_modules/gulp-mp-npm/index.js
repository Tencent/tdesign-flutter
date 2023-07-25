const path = require('path');
const lead = require('lead');
const pumpify = require('pumpify');
const through = require('through2');
const vfs = require('vinyl-fs');
const logger = require('fancy-log');
const colors = require('ansi-colors');
const treeToList = require('tree-to-list');
const { slash } = require('./lib/utils');
const checkPackage = require('./lib/checkPackage');
const lookupComponents = require('./lib/lookupComponents');
const lookupDependencies = require('./lib/lookupDependencies');
const rewriteModuleId = require('./lib/rewriteModuleId');
const replaceNodeModulesPath = require('./lib/utils/replaceNodeModulesPath');

const log = (...args) => logger.info(`[${colors.gray('mp-npm')}]`, ...args);

// 小程序官方方案默认输出路径
const defaultNpmDirname = 'miniprogram_npm';

// 所有依赖包列表
let pkgList = {};
// 小程序专用 npm 依赖包名与构建路径的映射, 将作为 resolve 时的 alias
const mpPkgMathMap = {};
// 项目初始化缓存 (一个项目只初始化一次)
let projectInitCache = null;
// 复杂项目多次进入mpNpm时可共享缓存
const globalCache = {
    // 多实例只初始化一次
    instanceInitCache: false,
    // 多实例共享依赖文件解析
    extracted: {}
};
/**
 * gulp-mp-npm
 */
module.exports = function mpNpm(options = {}) {
    const npmDirname = options.npmDirname || defaultNpmDirname;
    const { useGlobalCache } = options;
    let fullExtract = options.fullExtract || [];
    if (!Array.isArray(fullExtract)) fullExtract = [fullExtract];

    // 插件实例初始化缓存 (一次插件调用初始化一次)
    let instanceInitCache = useGlobalCache ? globalCache.instanceInitCache : null;

    // 已提取的包文件夹路径
    const extracted = useGlobalCache ? globalCache.extracted : {};

    /** init
     * 初始化
     */
    function init() {
        async function transform(file, enc, next) {
            const stream = this;
            /* 准备 */
            // 统一文件 base path
            file.base = path.resolve(file.cwd, file.base);
            file.path = path.resolve(file.cwd, file.path);

            /* 初始化 */
            // 仓库初始化：一个仓库只初始化一次
            if (!projectInitCache) {
                projectInitCache = (async () => {
                    // 找出所有依赖包
                    pkgList = await checkPackage.checkAllPkgs(process.cwd());
                    // 筛选出小程序专用 npm 依赖包
                    Object.keys(pkgList).forEach(pkgName => {
                        const pkg = pkgList[pkgName];
                        if (pkg.isMiniprogramPkg && pkg.buildPath) {
                            mpPkgMathMap[pkgName] = pkg.buildPath;
                        }
                    });
                })();
            }
            await projectInitCache;

            // 插件初始化：一个仓库只初始化一次
            if (!instanceInitCache) {
                instanceInitCache = (async () => {
                    // 找出需要全量提取的包
                    const fullExtractInfos = fullExtract.map(moduleName => {
                        const { packageName } = checkPackage.resolveDepFile(moduleName);
                        if (!packageName || !pkgList[packageName]) return false;
                        let modulePath = '';
                        if (mpPkgMathMap[packageName]) {
                            // 小程序包
                            const pkgReg = new RegExp(`^${packageName}`);
                            modulePath = moduleName.replace(pkgReg, mpPkgMathMap[packageName]);
                        } else {
                            // 普通包
                            modulePath = path.posix.resolve('node_modules', moduleName);
                        }
                        // 无glob规则，则补齐后缀
                        if (!modulePath.match(/[!?.*[\]()]/)) {
                            modulePath = `${modulePath.replace(/\/$/, '')}/**`;
                        }
                        return {
                            packageName,
                            moduleName,
                            path: modulePath,
                        };
                    }).filter(Boolean);

                    const fullExtractGlobs = fullExtractInfos.map(e => e.path);
                    if (!fullExtractGlobs.length) return;

                    await (new Promise((resolve, reject) => {
                        // 将需要全量提取的包追加至 stream 流中
                        lead(vfs.src(fullExtractGlobs, { cwd: file.cwd, base: file.cwd })
                            .pipe(through.obj((depFile, depEnc, depNext) => {
                                const originPath = slash(depFile.path);
                                if (depFile.isNull()
                                    || /\/package\.json$/.test(originPath) // 剔除 package.json
                                    || depFile.extname === '.md' // 剔除 *.md
                                ) return depNext(null, depFile);

                                const { packageName } = checkPackage.resolveDepFile(originPath);
                                if (!packageName) return depNext(null, depFile);

                                depFile.packageName = packageName;

                                // stream.push 追加文件
                                stream.push(depFile);
                                return depNext(null, depFile);
                            }))
                            .on('finish', resolve)
                            .on('error', reject));
                    }));
                })();
                if (useGlobalCache) globalCache.instanceInitCache = instanceInitCache;
            }
            await instanceInitCache;
            next(null, file);
        }
        return through.obj(transform);
    }

    /** extractComps
     * 提取小程序 npm 组件依赖, 将依赖文件追加至 stream 流中
     */
    function extractComps() {
        async function transform(file, enc, next) {
            const stream = this;
            if (file.isNull()) return next(null, file);

            // 如果不是 json 文件, 则跳过
            if (file.extname !== '.json') return next(null, file);

            const fileContent = String(file.contents); // 获取文件内容
            // 找出小程序组件依赖树
            const compTree = await lookupComponents(fileContent, file.path, {
                alias: mpPkgMathMap
            });
            // 展开树并去重处理为映射
            const npmComponents = treeToList(compTree, 'tree');
            // 展开依赖包构建路径列表
            const pathGlobs = Object.keys(npmComponents)
                .filter(e => !extracted[e])
                .map(compPath => `${slash(compPath)}/**`);

            if (!pathGlobs.length) return next(null, file);

            return lead(vfs.src(pathGlobs, { cwd: file.cwd, base: file.cwd })
                // 添加信息
                .pipe(through.obj((depFile, depEnc, depNext) => {
                    if (depFile.isNull()) return depNext(null, depFile);

                    const originPath = slash(depFile.path);
                    const { packageName } = checkPackage.resolveDepFile(originPath);
                    if (!packageName) return depNext(null, depFile);

                    depFile.packageName = packageName;

                    // stream.push 追加文件
                    stream.push(depFile);
                    return depNext(null, depFile);
                }))
                .on('finish', () => {
                    // 打印日志
                    Object.keys(npmComponents).forEach((componentPath) => {
                        const { packageName, moduleId } = npmComponents[componentPath];
                        // 记录提取
                        if (!extracted[componentPath]) {
                            extracted[componentPath] = true;
                            if (!compTree[componentPath]) return;
                            const moduleName = compTree[componentPath].moduleId || moduleId;
                            // 打印出根首层依赖的日志
                            if (moduleName && moduleName.indexOf(packageName) === 0) {
                                log(`Extracted \`${colors.cyan(moduleName)}\``);
                            }
                        }
                    });
                    next(null, file);
                })
                .on('error', next));
        }

        return through.obj(transform);
    }

    /** extractDeps
     * 提取普通依赖文件, 将依赖文件追加至 stream 流中
     */
    function extractDeps() {
        async function transform(file, enc, next) {
            const stream = this;
            if (file.isNull()) return next(null, file);

            const fileContent = String(file.contents); // 获取文件内容
            // 找出文件依赖树
            const lookupOpt = {
                alias: mpPkgMathMap
            };
            /*
            注意，这里的 extracted 存储的是已经提取过的npm包文件路径map，
            将它传入 lookupDependencies 的目的是在 lookupDependencies 内部分析一个文件路径时，
            遇到已经分析过的npm包时，可以直接跳过，以加快整个项目的分析提取速度，
            尤其在项目中越多的文件引用了同一个npm包时越能体现效果。
            */
            const deps = lookupDependencies(file.path, fileContent, lookupOpt, {}, true, extracted); // extracted 见上面注释
            // 展开依赖文件路径列表
            const depPaths = Object.keys(deps).filter(e => !extracted[e]);

            if (!depPaths.length) return next(null, file);

            return lead(vfs.src(depPaths, { cwd: file.cwd, base: file.cwd })
                // 添加信息
                .pipe(through.obj((depFile, depEnc, depNext) => {
                    if (depFile.isNull()) return depNext(null, depFile);

                    const slashPath = slash(depFile.path);

                    const matchedDep = deps[slashPath]; // 找到匹配依赖信息
                    if (!matchedDep) return depNext(null, depFile);

                    const { name: packageName, moduleId } = matchedDep;
                    depFile.packageName = packageName;
                    depFile.moduleId = moduleId;

                    // 记录提取
                    if (!extracted[slashPath]) {
                        extracted[slashPath] = true;
                        // 打印出根首层依赖的日志
                        if (deps[slashPath].isRoot) {
                            log(`Extracted \`${colors.cyan(
                                deps[slashPath].moduleId || moduleId
                            )}\``);
                        }
                    }

                    // stream.push 追加文件
                    stream.push(depFile);
                    return depNext(null, depFile);
                }))
                .on('finish', () => next(null, file))
                .on('error', next));
        }
        return through.obj(transform);
    }

    /** adjustPath
     * 调整文件及引用路径, 保证正确的输出
     */
    function adjustPath() {
        async function transform(file, enc, next) {
            if (file.isNull()) return next(); // 不输出空文件

            const { packageName, moduleId } = file;

            // 去掉小程序专用 npm 依赖包路径中的 buildPath 部分
            let filepath = slash(file.path);
            Object.keys(mpPkgMathMap).forEach((pkgName) => {
                const pkg = pkgList[pkgName];
                // build 相对路径
                const buildRelativePath = pkg.isMiniprogramPkg
                    ? path.posix.relative(pkg.path, pkg.buildPath) : '';
                // 替换路径
                filepath = filepath.replace(
                    path.posix.join('node_modules', pkgName, buildRelativePath),
                    path.posix.join('node_modules', pkgName)
                );
            });

            // 以 node_modules 分割路径
            const separator = '/node_modules/';
            const pathSplit = filepath.split(separator);

            // 仅 npm 需要重写 file.base
            // 取 pathSplit[0] 作为 path.base 用于 dest 替换
            if (packageName && pathSplit.length > 1) {
                file.base = path.normalize(
                    npmDirname === defaultNpmDirname
                        ? pathSplit[0]
                        // 如果非官方方案, 则无多层依赖结构
                        : pathSplit.slice(0, pathSplit.length - 1).join(separator)
                );
            }
            // 是否为依赖引用的主入口，如果是获取主入口在包内的相对路径
            file.isPackageMain = packageName && packageName === moduleId
                ? pathSplit[pathSplit.length - 1].replace(new RegExp(`^${packageName}/`), '')
                : false;

            // 重写 file.path
            // 以 npmDirname 替换 node_modules 将路径拼接
            file.path = path.normalize(replaceNodeModulesPath(filepath, npmDirname));
            file.base = path.normalize(replaceNodeModulesPath(file.base, npmDirname));

            // 重写源代码中模块引用依赖的moduleId
            file = rewriteModuleId(file, pkgList, npmDirname);

            return next(null, file);
        }

        return through.obj(transform);
    }

    /**
     * start
     */
    const pipeline = [
        init(),
        extractComps(),
        extractDeps(),
        adjustPath(),
    ];

    return lead(pumpify.obj(pipeline));
};
