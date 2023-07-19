const path = require('path');
const fs = require('fs');
const loadJsonFile = require('load-json-file');
const { slash } = require('./utils');
const getPackageName = require('./utils/getPackageName');

// 分析 json 内容的 usingComponents 字段
function parseComps(jsonContent) {
    let moduleIdList = [];
    try {
        jsonContent = typeof jsonContent === 'string' ? JSON.parse(jsonContent) : jsonContent;
        const { usingComponents = {} } = jsonContent || {};
        moduleIdList = Object.values(usingComponents);
    } catch (e) { }
    return moduleIdList;
}

// 通过 moduleId 解析组件的完整路径
function resolveCompPath(moduleId, jsonPath, options) {
    const { alias = [] } = options || {};

    // alias module id
    let packageName = getPackageName(moduleId);
    if (packageName) {
        const pkgReg = new RegExp(`^${packageName}`);
        moduleId = moduleId.replace(pkgReg, alias[packageName] || packageName);
    }

    const resolvedPath = slash(path.resolve(path.dirname(jsonPath), moduleId));
    // 解析出的文件不是 npm 依赖包
    if (!/\/node_modules\//.test(resolvedPath)) return {};

    // 获取正确的 packageName
    packageName = getPackageName(resolvedPath);

    return {
        packageName,
        resolvedPath,
    };
}

// 递归遍历分析组件依赖树
async function lookupComponents(jsonContent, jsonPath, options) {
    const components = {};

    // 尝试分析 usingComponents 字段
    const moduleIdList = parseComps(jsonContent);

    await Promise.all(moduleIdList.map(async moduleId => {
        // 解析
        const {
            packageName,
            resolvedPath
        } = resolveCompPath(moduleId, jsonPath, options);
        if (!resolvedPath) return;

        // 组件路径
        let compJsonPath = `${resolvedPath}.json`;
        if (!fs.existsSync(path.normalize(compJsonPath))) {
            compJsonPath = path.posix.join(resolvedPath, 'index.json');
        }
        const componentPath = path.posix.dirname(compJsonPath);

        // 向下递归分析组件依赖的组件
        let compJson = {};
        try { compJson = await loadJsonFile(compJsonPath) || {}; } catch (e) { } // 加载组件 json
        const depComponents = await lookupComponents(compJson, compJsonPath, options);

        components[componentPath] = {
            moduleId, // 引入时的表达式
            name: packageName,
            tree: depComponents,
        };
    }));

    return components;
}

module.exports = lookupComponents;
