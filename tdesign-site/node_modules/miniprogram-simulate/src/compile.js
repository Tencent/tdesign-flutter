const path = require('path')
const _ = require('./utils')

const compiler = _.getCompiler()
const wxmlCache = {}
const compilerResCache = {}

module.exports = {
    /**
     * 获取 wxml
     */
    getWxml(componentPath, config) {
        let wxml = wxmlCache[componentPath]

        if (wxml) return wxml
        if (config.compiler === 'official') {
            // 使用官方编译器
            if (!compiler) {
                wxml = _.readFile(`${componentPath}.wxml`)
                if (typeof wxml !== 'function') {
                    // 可能是用官方编译器编译好的函数，所以需要加此判断（如在 karma 测试）
                    throw new Error('not support official compiler, please use simulate compiler')
                }
            } else {
                let gwx
                if (compilerResCache[config.rootPath]) {
                    gwx = compilerResCache[config.rootPath]
                } else {
                    const compileString = compiler.wxmlToJs(config.rootPath, config.compilerOptions)
                    // eslint-disable-next-line no-new-func
                    const compileFunc = new Function(compileString)

                    gwx = compileFunc()
                    compilerResCache[config.rootPath] = gwx
                }

                let relativeWxmlPath = `${path.relative(config.rootPath, componentPath)}.wxml`
                relativeWxmlPath = relativeWxmlPath.replace(/\\/g, '/')

                // 构建编译结果为函数
                wxml = gwx(relativeWxmlPath)
            }
        } else {
            // 使用纯 js 实现的编译器
            wxml = _.readFile(`${componentPath}.wxml`)
        }

        // 缓存 wxml 内容
        wxmlCache[componentPath] = wxml

        return wxml
    }
}
