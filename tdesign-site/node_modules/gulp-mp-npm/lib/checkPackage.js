const path = require('path');
const fs = require('fs');
const { promisify } = require('util');
const readPackageTree = require('read-package-tree');
const treeToList = require('tree-to-list');
const { slash } = require('./utils');
const getNodeModulesPath = require('./utils/getNodeModulesPath');
const getPackageName = require('./utils/getPackageName');

const defaultPkgDist = 'miniprogram_dist'; // 默认小程序专用包的构建目录

// 判断是否为小程序专用 npm 包, 如果是则返回构建路径, 否则路径为空
async function checkIsMiniprogramPkg(pkgPath, pkgJson) {
    let pkgDist = defaultPkgDist;
    if (pkgJson.miniprogram && typeof pkgJson.miniprogram === 'string') {
        pkgDist = pkgJson.miniprogram;
    }
    // 拼接构建路径并判断是否路径存在
    try {
        pkgDist = path.posix.join(pkgPath, pkgDist);
        await promisify(fs.access)(path.normalize(pkgDist));
        const stat = await promisify(fs.stat)(path.normalize(pkgDist));
        if (stat && stat.isDirectory()) {
            return pkgDist;
        }
    } catch (e) { }

    return '';
}

// 检测所有模块, 并找出小程序专用的 npm 包
async function checkAllPkgs(cwd = process.cwd()) {
    const tree = await readPackageTree(cwd);

    const allList = treeToList([tree], 'children');

    const pkgMap = {};
    await Promise.all(allList.map(async module => {
        if (module.error) return;
        const modulePath = slash(module.path);
        const mpPkgBuildPath = await checkIsMiniprogramPkg(modulePath, module.package);
        let main = 'index.js';
        if (module.package.main && typeof module.package.main === 'string') {
            main = module.package.main;
        }
        // 如果已经检测到同名 pkg 则优先记录 node_modules 层级较浅的
        if (pkgMap[module.name]) {
            const separator = '/node_modules/';
            const depDeep = (filepath) => (filepath.split(separator).length - 1); // 依赖深度
            if (depDeep(modulePath) > depDeep(pkgMap[module.name].path)) {
                return; // 层级更深的不记录
            }
        }
        pkgMap[module.name] = {
            path: modulePath,
            main: path.posix.join(modulePath, main), // 入口文件
            isMiniprogramPkg: !!mpPkgBuildPath,
            buildPath: mpPkgBuildPath, // build 完整路径
        };
    }));

    return pkgMap;
}

// 通过一个文件路径, 找到文件所在的 npm 包
function resolveDepFile(filepath) {
    const nodeModulesPath = getNodeModulesPath(filepath); // 找到所在的 node_modules 文件夹
    const packageName = getPackageName(filepath); // 获取包名
    return {
        nodeModulesPath,
        packageName,
    };
}

module.exports = {
    checkIsMiniprogramPkg,
    checkAllPkgs,
    resolveDepFile,
};
