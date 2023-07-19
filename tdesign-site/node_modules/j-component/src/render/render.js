const exparser = require('miniprogram-exparser')
const CONSTANT = require('../tool/constant')
const _ = require('../tool/utils')

const transitionKeys = ['transition', 'transitionProperty', 'transform', 'transformOrigin', 'webkitTransition', 'webkitTransitionProperty', 'webkitTransform', 'webkitTransformOrigin']

/**
 * 更新 exparser 节点的属性
 */
function updateAttrs(exparserNode, attrs) {
  const isComponentNode = exparserNode instanceof exparser.Component
  const dataProxy = exparser.Component.getDataProxy(exparserNode)
  let needDoUpdate = false

  exparserNode.dataset = exparserNode.dataset || {}

  for (const {name, value} of attrs) {
    if (name === 'id' || name === 'slot' || (isComponentNode && name === 'class')) {
      // 普通属性
      exparserNode[name] = value || ''
    } else if (isComponentNode && name === 'style' && exparserNode.$$) {
      // style
      let animationStyle = exparserNode.__animationStyle || {}

      animationStyle = transitionKeys.map(key => {
        const styleValue = animationStyle[key.replace('webkitT', 't')]

        return styleValue !== undefined ? `${_.camelToDashCase(key)}:${styleValue}` : ''
      }).filter(item => !!item.trim()).join(';')

      exparserNode.setNodeStyle(_.transformRpx(value || '', true) + animationStyle)
    } else if (isComponentNode && exparser.Component.hasPublicProperty(exparserNode, _.dashToCamelCase(name))) {
      // public 属性，延迟处理
      dataProxy.scheduleReplace([_.dashToCamelCase(name)], value)
      needDoUpdate = true
    } else if (/^data-/.test(name)) {
      // dataset
      exparserNode.dataset[_.dashToCamelCase(name.slice(5).toLowerCase())] = value
      exparserNode.setAttribute(name, value)
    } else if (isComponentNode && name === 'animation') {
      // 动画
      if (exparserNode.$$ && value && value.actions && value.actions.length > 0) {
        let index = 0
        const actions = value.actions
        const length = actions.length
        const step = function () {
          if (index < length) {
            const styleObject = _.animationToStyle(actions[index])
            const extraStyle = styleObject.style

            transitionKeys.forEach(key => {
              exparserNode.$$.style[key] = styleObject[key.replace('webkitT', 't')]
            })

            Object.keys(extraStyle).forEach(key => {
              exparserNode.$$.style[key] = _.transformRpx(extraStyle[key])
            })

            exparserNode.__animationStyle = styleObject
          }
        }

        exparserNode.addListener('transitionend', () => {
          index += 1
          step()
        })
        step()
      }
    } else if (isComponentNode && exparserNode.hasExternalClass(_.camelToDashCase(name))) {
      // 外部样式类
      exparserNode.setExternalClass(_.camelToDashCase(name), value)
    }
  }

  if (needDoUpdate) dataProxy.doUpdates(true)
}

/**
 * 更新 exparser 节点的事件监听
 */
function updateEvent(exparserNode, event) {
  const convertEventTarget = (target, currentTarget) => {
    if (currentTarget && (target instanceof exparser.VirtualNode) && !target.id && !Object.keys(target.dataset).length) {
      // 如果 target 是 slot 且 slot 未设置 id 和 dataset，则兼容以前的逻辑：target === currentTarget
      target = currentTarget
    }

    return {
      id: target.id,
      offsetLeft: target.$$ && target.$$.offsetLeft || 0,
      offsetTop: target.$$ && target.$$.offsetTop || 0,
      dataset: target.dataset,
    }
  }

  Object.keys(event).forEach(key => {
    const {
      name, isCapture, isMutated, isCatch, handler
    } = event[key]

    if (!handler) return

    event[key].id = exparser.addListenerToElement(exparserNode, name, function (evt) {
      const shadowRoot = exparserNode.ownerShadowRoot

      const mutatedMarked = evt.mutatedMarked()
      if (isMutated && evt.mutatedMarked()) return // 已经被标记为互斥的事件，不再触发 mut- 绑定的事件回调
      if (isMutated) evt.markMutated()

      if (shadowRoot) {
        const host = shadowRoot.getHostNode()
        const writeOnly = exparser.Component.getComponentOptions(host).writeOnly

        if (!writeOnly) {
          const caller = exparser.Element.getMethodCaller(host)

          if (typeof caller[handler] === 'function') {
            caller[handler]({
              type: evt.type,
              timeStamp: evt.timeStamp,
              target: convertEventTarget(evt.target, this),
              currentTarget: convertEventTarget(this, null),
              detail: evt.detail,
              touches: evt.touches,
              changedTouches: evt.changedTouches,
              mut: mutatedMarked,
            })
          }
        }
      }

      if (isCatch) return false
    }, {capture: isCapture})
  })
}

/**
 * 渲染成 exparser 节点
 */
function renderExparserNode(options, shadowRootHost, shadowRoot) {
  const type = options.type
  const tagName = options.tagName
  const componentId = options.componentId
  let exparserNode

  if (type === CONSTANT.TYPE_TEXT) {
    exparserNode = shadowRoot.createTextNode(options.content) // save exparser node
  } else {
    if (type === CONSTANT.TYPE_ROOT) {
      shadowRoot = exparser.ShadowRoot.create(shadowRootHost)
      exparserNode = shadowRoot
    } else if (type === CONSTANT.TYPE_SLOT) {
      exparserNode = shadowRoot.createVirtualNode(tagName)
      exparser.Element.setSlotName(exparserNode, options.slotName)
    } else if (type === CONSTANT.TYPE_TEMPLATE || type === CONSTANT.TYPE_IF || type === CONSTANT.TYPE_FOR || type === CONSTANT.TYPE_FORITEM) {
      exparserNode = shadowRoot.createVirtualNode(tagName)
      exparser.Element.setInheritSlots(exparserNode)
    } else {
      const componentTagName = _.getTagName(componentId || tagName) || tagName
      const componentName = componentId || tagName
      exparserNode = shadowRoot.createComponent(componentTagName, componentName, options.generics)
    }

    updateAttrs(exparserNode, options.attrs)
    updateEvent(exparserNode, options.event)

    // children
    options.children.forEach(vt => {
      const childExparserNode = renderExparserNode(vt, null, shadowRoot)
      exparserNode.appendChild(childExparserNode)
    })
  }

  options.exparserNode = exparserNode // 保存 exparser node
  exparserNode._vt = options

  return exparserNode
}

module.exports = {
  updateAttrs,
  updateEvent,
  renderExparserNode,
}
