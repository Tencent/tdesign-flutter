/* 修改文件内容中引用 npm 依赖模块的路径 */
const path = require('path');
const importRegex = require('import-regex');
const trim = require('lodash/trim');
const { slash } = require('./utils');
const getPackageName = require('./utils/getPackageName');
const replaceNodeModulesPath = require('./utils/replaceNodeModulesPath');

const CSS_IMPORT_RE = /@import\s+(?:url\()?(.+(?=['")]))(?:\))?.*/i;
const IMPORT_RE = /(\bimport\s+(?:[^'"]+\s+from\s*)??)(['"])([^'"]+)(\2)/g;
const EXPORT_RE = /(\bexport\s+(?:[^'"]+\s+from\s*)??)(['"])([^'"]+)(\2)/g;
const REQUIRE_RE = /(\brequire\s*?\(\s*?)(['"])([^'"]+)(\2\s*?\))/g;

const defaultNpmDirname = 'miniprogram_npm'; // 小程序官方方案默认输出路径

module.exports = (file, pkgList, npmDirname = defaultNpmDirname) => {
    const { extname, contents } = file;
    const isCss = ['.css', '.wxss', '.less', '.sass'].includes(extname);
    const isJs = ['.js', '.wxs', '.jsx', '.ts'].includes(extname);
    const isJson = ['.json'].includes(extname);

    /* 修改文件路径 */
    // 如果是导出文件夹为官方小程序 miniprogram_npm 方案 并且 当引入依赖的是模块主入口时
    // 则需修改入口文件路径为 index 路径
    if (npmDirname === defaultNpmDirname && file.isPackageMain) {
        const mainPathReg = new RegExp(`${file.isPackageMain}$`);
        file.originPath = file.path;
        const slashPath = slash(file.path).replace(mainPathReg, `index${file.extname || '.js'}`);
        file.path = path.normalize(slashPath);
    }

    // 如果不是 css / js / json 则不处理
    if (!isCss && !isJs && !isJson) return file;

    /* 修改文件内容 */
    let fileContent = String(contents); // 获取文件内容

    // 如果 relativePath 不是相对路径则需追加上 ./
    const startsWith = (str, prefix) => str.slice(0, prefix.length) === prefix;
    // 重写 moduleId 路径的规则
    function rewriteRule(moduleId) {
        const pkgName = getPackageName(moduleId);
        const pkg = pkgList[pkgName];

        // 引入的如果是小程序包主入口文件 特殊处理 不用完全重写 仅拼接 main
        if (moduleId === pkgName && pkg && pkg.isMiniprogramPkg && !isJson) {
            const buildPathReg = new RegExp(`^${pkg.buildPath}`);
            moduleId = path.posix.join(moduleId, pkg.main.replace(buildPathReg, ''));
        }

        // 判断文件所用到的 moduleId 路径是否需要重写为相对路径
        const rewritable = (npmDirname === defaultNpmDirname && isCss) // 官方方案中所有 wxss 引入其他文件需要重写
            // 官方方案中主入口文件引入的相对文件路径时需要重写
            || (npmDirname === defaultNpmDirname && file.isPackageMain && !pkgName)
            // 非官方方案 moduleId 对应的 pkg 存在这需重写引用路径
            || (npmDirname !== defaultNpmDirname && pkgName && pkg);

        if (rewritable) {
            if (pkgName && pkg) { // pkg 存在
                let pkgPath = slash(pkg.path);
                // 如果引入的入口文件，则修改路径为包入口文件 main
                if (moduleId === pkgName && !isJson) {
                    if (npmDirname === defaultNpmDirname) { // 官方方案
                        pkgPath = path.posix.join(pkgPath, `index${path.extname(pkg.main) || '.js'}`);
                    } else { // 自定义提取方案时
                        if (pkg.isMiniprogramPkg) { // 小程序专用包入口替换 buildPath
                            const buildPathReg = new RegExp(`^${pkg.buildPath}`);
                            pkgPath = pkg.main.replace(buildPathReg, pkgPath);
                        } else { // 其他追加 main 路径
                            pkgPath = pkg.main;
                        }
                    }
                }
                const pkgPathSplit = pkgPath.split('/node_modules/');
                const pkgBase = path.normalize(
                    npmDirname === defaultNpmDirname
                        ? pkgPathSplit[0]
                        // 如果非官方方案, 则无多层依赖结构
                        : pkgPathSplit.slice(0, pkgPathSplit.length - 1).join('/node_modules/')
                );
                // 找出 pkgPath 在文件下的相对路径
                let relativePath = path.posix.relative(
                    // 同一 base
                    replaceNodeModulesPath(
                        file.dirname.replace(file.base, pkgBase), npmDirname
                    ),
                    replaceNodeModulesPath(pkgPath, npmDirname)
                );
                const pkgReg = new RegExp(`^${pkgName}`);
                if (!startsWith(relativePath, './') && !startsWith(relativePath, '../')) {
                    relativePath = `./${relativePath}`;
                }
                return moduleId.replace(pkgReg, relativePath);
            } else if (!pkgName && moduleId[0] !== '/') { // 引用的不是 pkg
                const targetPath = path.posix.join(
                    path.posix.dirname(slash(file.originPath || file.path)),
                    moduleId
                );
                // 找出 targetPath 在文件下的相对路径
                let relativePath = path.posix.relative(
                    replaceNodeModulesPath(file.dirname, npmDirname),
                    replaceNodeModulesPath(targetPath, npmDirname)
                );
                if (!startsWith(relativePath, './') && !startsWith(relativePath, '../')) {
                    relativePath = `./${relativePath}`;
                }
                return relativePath;
            } else {
                return moduleId;
            }
        } else {
            return moduleId;
        }
    }

    // 对于样式引用了 npm 依赖, 小程序解析路径, 需对内容路径进行替换
    if (isCss) {
        // 找出 css 中的 @import
        const matchList = fileContent.match(importRegex()) || [];
        // 循环替换
        matchList.forEach((oldString = '') => {
            // 匹配单个 css import 匹配 moduleId
            const m = oldString.match(CSS_IMPORT_RE) || [];
            const oldModuleId = m[1] ? trim(m[1], '\'"') : ''; // 找到 moduleId
            const newModuleId = rewriteRule(oldModuleId); // 替换新的 moduleId
            const newString = oldString.replace(oldModuleId, newModuleId);
            fileContent = fileContent.replace(oldString, newString);
        });
    }

    // 尝试替换原文件中的 moduleId
    if (isJs) {
        // 替换 js import / require 的引入
        const replacement = (_match, pre, quot, dep, post) =>
            `${pre}${quot}${rewriteRule(dep)}${post}`;
        fileContent = fileContent
            .replace(IMPORT_RE, replacement)
            .replace(EXPORT_RE, replacement)
            .replace(REQUIRE_RE, replacement);
    }

    // 如果是 json 文件则尝试替换 usingComponents 字段
    if (isJson) {
        let json = {};
        try { json = JSON.parse(fileContent) || {}; } catch (e) { }
        const { usingComponents } = json;
        if (usingComponents) {
            Object.keys(usingComponents).forEach(key => {
                const moduleId = usingComponents[key];
                if (typeof moduleId === 'string') {
                    usingComponents[key] = rewriteRule(moduleId);
                }
            });
            json.usingComponents = usingComponents;
            fileContent = JSON.stringify(json, null, 2);
        }
    }

    file.contents = Buffer.from(fileContent);

    return file;
};
