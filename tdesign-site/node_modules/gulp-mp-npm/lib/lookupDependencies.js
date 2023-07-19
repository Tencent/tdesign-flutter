const path = require('path');
const fs = require('fs');
const precinct = require('precinct');
const resolve = require('resolve');
const xmlParse = require('xml-parser');

const { slash } = require('./utils');
const getPackageName = require('./utils/getPackageName');

const natives = process.binding('natives');

// 自定义的类型映射
const typeMap = {
    wxss: 'css',
    wxs: 'commonjs'
};

// parseDeps 分析文件获取所有依赖模块 返回引入路径表达式列表
function parseDeps(filepath, fileContent, precinctOptions) {
    let moduleIdList;
    const type = path.extname(filepath).replace('.', '');

    // 依赖分析
    try {
        fileContent = fileContent || fs.readFileSync(path.normalize(filepath), 'utf8');

        moduleIdList = precinct(fileContent, {
            type: typeMap[type], // 指定自定义文件类型
            es6: { mixedImports: true },
            includeCore: false,
            ...precinctOptions,
        }).filter((d) => !natives[d]);
        // 对wxml处理wxs
        if (type === 'wxml') {
            // 加一层<div>包裹
            const nodes = xmlParse(`<div>${fileContent}</div>`).root.children;
            nodes.forEach((node) => {
                if (node.name === 'wxs') {
                    moduleIdList.push(node.attributes.src);
                }
            });
        }
    } catch (e) { }
    return moduleIdList || [];
}

// resolveDep 解析文件所依赖的 npm 模块名称 返回引入路径表达式与依赖包名及路径的映射
function resolveDep(moduleId, filepath, options) {
    const { alias = [] } = options || {};

    // alias module id
    let packageName = getPackageName(moduleId);
    if (packageName) {
        const pkgReg = new RegExp(`^${packageName}`);
        moduleId = moduleId.replace(pkgReg, alias[packageName] || packageName);
    }

    let depPath = '';
    try {
        depPath = resolve.sync(moduleId, {
            basedir: path.dirname(filepath),
            preserveSymlinks: true
        });
    } catch (error) { }

    const slashPath = slash(depPath);

    // 解析出的文件不是 npm 依赖包
    if (!depPath || !/\/node_modules\//.test(slashPath)) return {};

    // 获取正确的 packageName
    packageName = getPackageName(slashPath);

    return {
        packageName,
        depPath: slashPath,
    };
}

// lookupDependencies 递归分析依赖树
/**
 * @param {*} filepath
 * @param {*} fileContent
 * @param {*} options
 * @param {*} deps
 * @param {*} root
 * @param {*} extracted 全局的已提取的npm包文件路径map，如果一个包文件路径已经分析过，则没必要再次分析。
 * @returns
 */
function lookupDependencies(filepath, fileContent, options, deps = {}, root = true, extracted = {}) {
    if (!filepath) return deps;
    filepath = slash(filepath);
    if (extracted[filepath]) return deps;
    // 分析并解析依赖映射
    const moduleIdList = parseDeps(filepath, fileContent);
    moduleIdList.forEach(moduleId => {
        // 解析
        const {
            packageName,
            depPath
        } = resolveDep(moduleId, filepath, options);
        if (!depPath || deps[depPath]) return;
        deps[depPath] = {
            moduleId,
            name: packageName,
            isRoot: root,
        };
        // 递归依赖映射
        deps = lookupDependencies(depPath, null, options, deps, false, extracted);
    });

    return deps;
}

module.exports = lookupDependencies;
