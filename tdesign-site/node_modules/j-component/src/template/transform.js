const CONSTANT = require('../tool/constant')
const _ = require('../tool/utils')

/**
 * 过滤属性
 */
function filterAttrs(attrs = {}) {
  const event = {}
  const normalAttrs = []
  let slotName = ''

  const attrsKeyList = Object.keys(attrs)

  for (const name of attrsKeyList) {
    const value = attrs[name] === undefined ? '' : attrs[name]
    const eventObj = _.parseEvent(name, value)

    if (eventObj) {
      // 事件绑定
      event[eventObj.name] = eventObj
    } else {
      // 普通属性
      if (name === 'name') slotName = value

      normalAttrs.push({name, value})
    }
  }

  return {
    event,
    normalAttrs,
    slotName,
  }
}

/**
 * 将 wcc 输出转化成 j-component 需要的结构
 */
function transformCompileResTree(obj, parent, usingComponents) {
  let node = null

  // 特别注意：使用 wcc 编译，不会产生 import、block、include、wxs、native（小程序不支持 div 等标签）；template 节点会当作 if 节点处理

  if (typeof obj === 'string' || (typeof obj === 'number' && obj % 1 === 0)) {
    // 文本节点
    node = {
      type: CONSTANT.TYPE_TEXT,
      tagName: '',
      componentId: '',
      content: '' + obj, // 文本节点的内容
      key: '', // 节点的 key，diff 用
      children: [],
      generics: [],
      attrs: [],
      event: {},
      slotName: '', // slot 节点的 name 属性
    }
  } else {
    // 其他节点
    const children = []
    const {
      tag, wxKey, wxXCkey, attr
    } = obj
    const tagName = tag.indexOf('wx-') === 0 && (tag === 'wx-slot' || !_.isOfficialTag(tag)) ? tag.substr(3) : tag
    const key = wxKey !== undefined && wxKey !== null ? '' + wxKey : undefined
    const {event, normalAttrs, slotName} = filterAttrs(attr)
    const isIf = wxXCkey === 1 || wxXCkey === 3
    const isFor = wxXCkey === 2 || wxXCkey === 4
    const isSlot = tagName === 'slot'
    const isRoot = tagName === 'shadow'
    let type = isRoot ? CONSTANT.TYPE_ROOT : isIf ? CONSTANT.TYPE_IF : isFor ? CONSTANT.TYPE_FOR : isSlot ? CONSTANT.TYPE_SLOT : CONSTANT.TYPE_COMPONENT

    if (parent && parent.type === CONSTANT.TYPE_FOR) {
      type = CONSTANT.TYPE_FORITEM
    }

    node = {
      type,
      tagName,
      componentId: usingComponents[tagName] || tagName,
      content: '', // 文本节点的内容
      key, // 节点的 key，diff 用
      children,
      generics: obj.generics,
      attrs: normalAttrs,
      event,
      slotName: isSlot ? slotName : '', // slot 节点的 name 属性
    }

    obj.children.forEach(child => children.push(transformCompileResTree(child, node, usingComponents)))
  }

  return node
}

module.exports = function (generateFunc, usingComponents) {
  return function (options = {}) {
    const data = options.data || {}
    const compileRes = generateFunc(data)

    if (compileRes.type !== CONSTANT.TYPE_ROOT && (compileRes.tag === 'wx-page' || compileRes.tag === 'shadow')) {
      // 进行 wcc 编译结果的转化
      compileRes.tag = 'shadow'
      return transformCompileResTree(compileRes, null, usingComponents)
    } else {
      return compileRes
    }
  }
}
