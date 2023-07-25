// 替换所有 node_modules 为 npmDirname
const { slash } = require('./index');

module.exports = (filepath = '', npmDirname) =>
    slash(filepath).replace(/\/node_modules\//g, `/${npmDirname}/`);
