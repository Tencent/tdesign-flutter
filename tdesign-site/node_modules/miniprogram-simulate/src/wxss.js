const postcss = require('postcss')
const path = require('path')
const less = require('less')
const csso = require('csso')

const _ = require('./utils')

const wxssCache = {}

/**
 * 追加 class 前缀插件
 */
const addClassPrefixPlugin = function(prefix = '') {
    return postcss.plugin('addClassPrefix', () => root => {
        // eslint-disable-next-line consistent-return
        root.walk(child => {
            if (child.type === 'rule') {
                const selectors = []

                child.selectors.forEach(selector => {
                    // 处理 class 选择器
                    selectors.push(selector.replace(/(.)?\.([-_a-zA-Z0-9]+)/igs, (all, $1, $2) => (/\d/.test($1) ? all : `${$1 || ''}.${prefix}--${$2}`)))
                })

                child.selectors = selectors
            }
        })
    })
}

/**
 * 获取 import 列表
 */
function getImportList(wxss, filePath) {
    const reg = /@import\s+(?:(?:"([^"]+)")|(?:'([^']+)'));/ig
    const importList = []
    let execRes = reg.exec(wxss)

    while (execRes && (execRes[1] || execRes[2])) {
        importList.push({
            code: execRes[0],
            path: path.join(path.dirname(filePath), execRes[1] || execRes[2]),
        })
        execRes = reg.exec(wxss)
    }

    return importList
}

/**
 * 获取 wxss 内容
 */
function getContent(filePath) {
    // 判断缓存
    if (wxssCache[filePath]) {
        return wxssCache[filePath]
    }

    let wxss = _.readFile(filePath)

    if (wxss) {
        const importList = getImportList(wxss, filePath)

        importList.forEach(item => {
            wxss = wxss.replace(item.code, getContent(item.path))
        })
    }

    // 缓存 wxss
    wxssCache[filePath] = wxss || ''

    return wxssCache[filePath]
}

/**
 * 编译 wxss
 */
function compile(wxss, options = {}) {
    if (options.less) {
        less.render(wxss, (err, output) => {
            if (!err) wxss = output.css
        })
    }

    wxss = postcss([addClassPrefixPlugin(options.prefix)]).process(wxss, {
        from: undefined, // 主要是不想看到那个 warning
        map: null,
    }).css

    // 压缩
    return csso.minify(wxss, {restructure: false}).css
}

/**
 * 插入 wxss
 */
function insert(wxss, id) {
    if (!Array.isArray(wxss)) {
        wxss = [wxss]
    }

    // 删除已插入的
    document.querySelectorAll(`style#${id}`).forEach(style => {
        style.parentNode.removeChild(style)
    })

    const style = document.createElement('style')
    style.type = 'text/css'
    style.id = id
    style.innerHTML = _.transformRpx(wxss.join(''))

    const head = document.getElementsByTagName('head')
    if (head && head.length) head.item(0).appendChild(style)
}


module.exports = {
    getContent,
    compile,
    insert,
}
