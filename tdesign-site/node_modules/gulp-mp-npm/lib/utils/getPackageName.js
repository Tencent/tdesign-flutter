// 通过路径或表达式解析模块名
const path = require('path');
const { slash } = require('./index');
const getNodeModulesPath = require('./getNodeModulesPath');

module.exports = (filepath = '') => {
    filepath = slash(filepath);

    const nodeModulesPath = getNodeModulesPath(filepath);
    // 如果为路径, 则找到在 node_modules 下的相对路径
    if (nodeModulesPath) filepath = path.posix.relative(nodeModulesPath, filepath);

    let packageName = '';
    if (filepath[0] !== '/') {
        const parts = filepath.split('/');
        if (parts.length > 0 && parts[0][0] === '@') {
            packageName += `${parts.shift()}/`;
        }
        packageName += parts.shift();
    }
    // 如果 packageName 为 . 或 .. 则置为空
    if (['.', '..'].includes(packageName)) {
        packageName = '';
    }

    return packageName;
};
