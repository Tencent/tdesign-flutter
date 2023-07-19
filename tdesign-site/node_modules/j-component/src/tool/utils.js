/**
 * 获取随机 id，生成 15 位
 */
let seed = 1e14 + Math.floor(Math.random() * 9e14)
const charString = 'abcdefghij'
function getId(notNumber) {
  const id = ++seed
  return notNumber ? id.toString().split('').map(item => charString[+item]).join('') : id
}

/**
 * 复制对象
 */
function copy(src) {
  if (typeof src === 'object' && src !== null) {
    let dest

    if (Array.isArray(src)) {
      dest = src.map(item => copy(item))
    } else {
      dest = {}
      Object.keys(src).forEach(key => dest[key] = copy(src[key]))
    }

    return dest
  }

  if (typeof src === 'symbol') return undefined
  return src
}

/**
 * 判断是否是 html 标签
 */
const tags = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'data', 'datalist', 'dd', 'del', 'dfn', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'legend', 'li', 'link', 'main', 'map', 'mark', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rb', 'rp', 'rt', 'rtc', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'sup', 'table', 'tbody', 'td', 'template', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u', 'ul', 'var', 'video', 'wbr']
function isHtmlTag(tagName) {
  return tags.indexOf(tagName) >= 0
}

/**
 * 判断是否是小程序内置组件
 */
const officialTags = [
  'view', 'scroll-view', 'swiper', 'movable-view', 'cover-view', 'cover-view',
  'icon', 'text', 'rich-text', 'progress',
  'button', 'checkbox', 'form', 'input', 'label', 'picker', 'picker', 'picker-view', 'radio', 'slider', 'switch', 'textarea',
  'navigator', 'function-page-navigator',
  'audio', 'image', 'video', 'camera', 'live-player', 'live-pusher',
  'map',
  'canvas',
  'open-data', 'web-view', 'ad'
]
function isOfficialTag(tagName) {
  return officialTags.indexOf(tagName) >= 0 || officialTags.indexOf(`wx-${tagName}`) >= 0
}

/**
 * 转换 rpx 单位为 px 单位
 */
function transformRpx(style) {
  return style.replace(/(\d+)rpx/ig, '$1px')
}

/**
 * 转换连字符为驼峰
 */
function dashToCamelCase(dash) {
  return dash.replace(/-[a-z]/g, s => s[1].toUpperCase())
}

/**
 * 转换驼峰为连字符
 */
function camelToDashCase(camel) {
  return camel.replace(/([A-Z])/g, '-$1').toLowerCase()
}

/**
 * 转换动画对象为样式
 */
function animationToStyle({animates, option = {}}) {
  const {transformOrigin, transition} = option

  if (transition === undefined || animates === undefined) {
    return {
      transformOrigin: '',
      transform: '',
      transition: '',
    }
  }

  const addPx = value => (typeof value === 'number' ? value + 'px' : value)
  const transform = animates.filter(({type}) => type !== 'style').map(({type, args}) => {
    switch (type) {
      case 'matrix':
        return `matrix(${args.join(',')})`
      case 'matrix3d':
        return `matrix3d(${args.join(',')})`

      case 'rotate':
        return `rotate(${args[0]}deg)`
      case 'rotate3d':
        args[3] += 'deg'
        return `rotate3d(${args.join(',')})`
      case 'rotateX':
        return `rotateX(${args[0]}deg)`
      case 'rotateY':
        return `rotateY(${args[0]}deg)`
      case 'rotateZ':
        return `rotateZ(${args[0]}deg)`

      case 'scale':
        return `scale(${args.join(',')})`
      case 'scale3d':
        return `scale3d(${args.join(',')})`
      case 'scaleX':
        return `scaleX(${args[0]})`
      case 'scaleY':
        return `scaleY(${args[0]})`
      case 'scaleZ':
        return `scaleZ(${args[0]})`

      case 'translate':
        return `translate(${args.map(addPx).join(',')})`
      case 'translate3d':
        return `translate3d(${args.map(addPx).join(',')})`
      case 'translateX':
        return `translateX(${addPx(args[0])})`
      case 'translateY':
        return `translateY(${addPx(args[0])})`
      case 'translateZ':
        return `translateZ(${addPx(args[0])})`

      case 'skew':
        return `skew(${args.map(value => value + 'deg').join(',')})`
      case 'skewX':
        return `skewX(${args[0]}deg)`
      case 'skewY':
        return `skewY(${args[0]}deg)`
      default:
        return ''
    }
  }).join(' ')
  const style = animates.filter(({type}) => type === 'style').reduce((previous, current) => {
    previous[current.args[0]] = current.args[1]
    return previous
  }, {})

  return {
    style,
    transformOrigin,
    transform,
    transitionProperty: ['transform', ...Object.keys(style)].join(','),
    transition: `${transition.duration}ms ${transition.timingFunction} ${transition.delay}ms`,
  }
}

/**
 * 调整 exparser 的定义对象
 */
function adjustExparserDefinition(definition) {
  // 调整 properties
  const properties = definition.properties || {}
  Object.keys(properties).forEach(key => {
    const value = properties[key]
    if (value === null) {
      properties[key] = {type: null}
    } else if (value === Number || value === String || value === Boolean || value === Object || value === Array) {
      properties[key] = {type: value}
    } else if (value.public === undefined || value.public) {
      properties[key] = {
        type: value.type === null ? null : value.type,
        value: value.value,
        observer: value.observer,
      }
    }
  })

  return definition
}

/**
 * 存入标签名
 */
const idTagNameMap = {}
function setTagName(id, tagName) {
  idTagNameMap[id] = tagName
}

/**
 * 根据 id 获取标签名
 */
function getTagName(id) {
  return idTagNameMap[id]
}

/**
 * 缓存 componentManager 实例
 */
const CACHE = {}
function cache(id, instance) {
  if (instance) {
    // 存入缓存
    CACHE[id] = instance
  } else {
    // 取缓存
    return CACHE[id]
  }
}

/**
 * 解析事件语法
 */
function parseEvent(name, value) {
  const res = /^(capture-)?(mut-)?(bind|catch|)(?::)?(.*)$/ig.exec(name)

  if (res[3] && res[4]) {
    // 事件绑定
    const isCapture = !!res[1]
    const isMutated = !!res[2]
    const isCatch = res[3] === 'catch'
    const eventName = res[4]

    return {
      name: eventName,
      isMutated,
      isCapture,
      isCatch,
      handler: value,
    }
  }
}

/**
 * 标准化文件绝对路径
 */
function normalizeAbsolute(absolutePath) {
  if (!absolutePath) return null

  absolutePath = absolutePath.replace(/\\/g, '/')
  return absolutePath.split('/').filter(item => !!item).join('/')
}

/**
 * 文件相对路径转绝对路径，其中 basePath 路径必须是文件路径
 */
function relativeToAbsolute(basePath, relativePath) {
  let baseDirPath = normalizeAbsolute(basePath).split('/')
  baseDirPath.pop()
  baseDirPath = baseDirPath.join('/')

  const pathList = []
  normalizeAbsolute(`${baseDirPath}/${relativePath}`).split('/').forEach(item => {
    if (item === '..') {
      pathList.pop()
    } else if (item !== '.') {
      pathList.push(item)
    }
  })

  return pathList.join('/')
}

/**
 * 获取 exparser 节点对应的 dom 节点
 */
function getDom(exparserNode) {
  let dom = exparserNode.$$
  if (!dom) {
    dom = document.createElement('virtual')
    const fragment = document.createDocumentFragment()
    const shadowRoot = exparserNode.shadowRoot
    const childNodes = shadowRoot && shadowRoot.childNodes
    if (childNodes && childNodes.length) {
      childNodes.forEach(child => fragment.appendChild(getDom(child)))
    }
    dom.appendChild(fragment)
  }

  return dom
}

module.exports = {
  getId,
  copy,
  isHtmlTag,
  isOfficialTag,
  transformRpx,
  dashToCamelCase,
  camelToDashCase,
  animationToStyle,
  adjustExparserDefinition,
  setTagName,
  getTagName,
  cache,
  parseEvent,
  normalizeAbsolute,
  relativeToAbsolute,
  getDom,
}
