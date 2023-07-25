const exparser = require('miniprogram-exparser')
const _ = require('../tool/utils')
const IntersectionObserver = require('../tool/intersectionobserver')
const CONSTANT = require('../tool/constant')
const render = require('./render')

const MOVE_DELTA = 10
const LONGPRESS_TIME = 350
const SCROLL_PROTECTED = 150
const NATIVE_TOUCH_EVENT = ['touchstart', 'touchmove', 'touchend', 'touchcancel']

/**
 * 遍历 exparser 树
 */
function dfsExparserTree(node, callback, fromTopToBottom) {
  if (node instanceof exparser.Component) {
    if (fromTopToBottom) callback(node)
    if (node.shadowRoot instanceof exparser.Element) dfsExparserTree(node.shadowRoot, callback, fromTopToBottom)
    if (!fromTopToBottom) callback(node)
  }
  node.childNodes.forEach(child => {
    if (child instanceof exparser.Element) dfsExparserTree(child, callback, fromTopToBottom)
  })
}

/**
 * 用于 miniprogram-simulate/jest-snapshot-plugin 的识别
 */
const JSONSymbol = typeof Symbol === 'function' && Symbol.for ? Symbol.for('j-component.json') : 0xd846fe

/**
 * 序列化 exparser 树节点上绑定的事件监听
 */
function exparserNodeEventToJSON(node) {
  return node._vt ? node._vt.event : {}
}

/**
 * 序列化 exparser 树节点的属性
 */
function exparserNodeAttrsToJSON(node) {
  const attrs = []
  const vt = node._vt

  if (vt) {
    vt.attrs.forEach(attr => {
      if (!exparser.Component.hasPublicProperty(node, _.dashToCamelCase(attr.name))) {
        attrs.push(attr)
      }
    })
  }
  return attrs
}

/**
 * 将 exparser 树转换为 JSON 对象
 */
function exparserTreeToJSON(node) {
  const _inner = (node, array) => {
    let children = array
    const vt = node._vt

    if (node instanceof exparser.TextNode) {
      array.push(node.textContent)
    } else if (node instanceof exparser.Element) {
      if (!node.__virtual) {
        children = []
        const child = {
          tagName: _.getTagName(vt.componentId || vt.tagName) || vt.tagName,
          event: exparserNodeEventToJSON(node),
          attrs: exparserNodeAttrsToJSON(node),
          children,
        }
        Object.defineProperty(child, '$$typeof', {
          get() {
            return JSONSymbol
          }
        })
        array.push(child)
      }
      ;(node.__wxSlotChildren || []).forEach(child => _inner(child, children))
    }

    return array
  }

  return _inner(node, [])[0]
}

class Component {
  constructor(exparserNode) {
    this._exparserNode = exparserNode
  }

  get dom() {
    return this._exparserNode.$$
  }

  get data() {
    const caller = exparser.Element.getMethodCaller(this._exparserNode)

    return caller && caller.data
  }

  get instance() {
    return exparser.Element.getMethodCaller(this._exparserNode)
  }

  /**
   * 触发事件
   */
  dispatchEvent(eventName, options = {}) {
    const dom = this.dom

    if (NATIVE_TOUCH_EVENT.indexOf(eventName) >= 0) {
      // native touch event
      let touches = options.touches
      let changedTouches = options.changedTouches

      if (eventName === 'touchstart' || eventName === 'touchmove') {
        touches = touches || [{x: 0, y: 0}]
        changedTouches = changedTouches || [{x: 0, y: 0}]
      } else if (eventName === 'touchend' || eventName === 'touchcancel') {
        touches = touches || []
        changedTouches = changedTouches || [{x: 0, y: 0}]
      }

      const touchEvent = new TouchEvent(eventName, {
        cancelable: true,
        bubbles: true,
        touches: touches.map(touch => new Touch({
          identifier: _.getId(),
          target: dom,
          clientX: touch.x,
          clientY: touch.y,
          pageX: touch.x,
          pageY: touch.y,
        })),
        targetTouches: [],
        changedTouches: changedTouches.map(touch => new Touch({
          identifier: _.getId(),
          target: dom,
          clientX: touch.x,
          clientY: touch.y,
          pageX: touch.x,
          pageY: touch.y,
        })),
      })

      // 模拟异步情况
      Promise.resolve().then(() => {
        dom.dispatchEvent(touchEvent)
      }).catch(console.error)
    } else {
      // 自定义事件
      const customEvent = new CustomEvent(eventName, options)

      // 模拟异步情况
      Promise.resolve().then(() => {
        dom.dispatchEvent(customEvent)

        if (customEvent.target.__wxElement) {
          exparser.Event.dispatchEvent(customEvent.target.__wxElement, exparser.Event.create(eventName, options.detail || {}, {
            originalEvent: customEvent,
            bubbles: true,
            capturePhase: true,
            composed: true,
            extraFields: {
              touches: options.touches || {},
              changedTouches: options.changedTouches || {},
            },
          }))
        }
      }).catch(console.error)
    }
  }

  /**
   * 监听组件事件
   */
  addEventListener(eventName, handler, capture = false) {
    if (typeof capture === 'object') capture = !!capture.capture
    this._exparserNode.addListener(eventName, handler, {capture})
  }

  /**
   * 取消监听组件事件
   */
  removeEventListener(eventName, handler, capture = false) {
    if (typeof capture === 'object') capture = !!capture.capture
    this._exparserNode.removeListener(eventName, handler, {capture})
  }

  /**
   * 选取第一个符合的子组件节点
   */
  querySelector(selector) {
    const shadowRoot = this._exparserNode.shadowRoot
    const selExparserNode = shadowRoot && shadowRoot.querySelector(selector)

    if (selExparserNode) {
      return selExparserNode.__componentNode__ ? selExparserNode.__componentNode__ : new Component(selExparserNode)
    }
  }

  /**
   * 选取所有符合的子组件节点
   */
  querySelectorAll(selector) {
    const shadowRoot = this._exparserNode.shadowRoot
    const selExparserNodes = shadowRoot.querySelectorAll(selector) || []

    return selExparserNodes.map(selExparserNode => (selExparserNode.__componentNode__ ? selExparserNode.__componentNode__ : new Component(selExparserNode)))
  }

  /**
   * 小程序自定义组件的 setData 方法
   */
  setData(data, callback) {
    const caller = exparser.Element.getMethodCaller(this._exparserNode)

    if (caller && typeof caller.setData === 'function') caller.setData(data)
    if (typeof callback === 'function') {
      // 模拟异步情况
      Promise.resolve().then(callback).catch(console.error)
    }
  }

  /**
   * 触发生命周期
   */
  triggerLifeTime(lifeTime, ...args) {
    this._exparserNode.triggerLifeTime(lifeTime, args)
  }

  /**
   * 触发页面生命周期
   */
  triggerPageLifeTime(lifeTime, ...args) {
    this._exparserNode.triggerPageLifeTime(lifeTime, args)
  }

  /**
   * 生成JSON
   */
  toJSON() {
    return exparserTreeToJSON(this._exparserNode)
  }
}

class RootComponent extends Component {
  constructor(componentManager, properties) {
    super()

    const id = componentManager.id
    const tagName = _.getTagName(id)
    const exparserDef = componentManager.exparserDef
    this._exparserNode = exparser.createElement(tagName || id, exparserDef) // create exparser node and render
    this._isTapCancel = false
    this._lastScrollTime = 0

    const attrs = Object.keys(properties || {}).map(key => ({name: key, value: properties[key]}))
    if (attrs.length) {
      // 对齐 observer 逻辑，走 updateAttr 来更新 property
      render.updateAttrs(this._exparserNode, attrs)
    }

    this._exparserNode._vt = {
      type: CONSTANT.TYPE_COMPONENT,
      tagName: tagName || 'main',
      attrs,
      event: {},
      children: []
    }

    this.parentNode = null

    this._bindEvent()
  }

  get dom() {
    return _.getDom(this._exparserNode)
  }

  /**
   * 初始化事件
   */
  _bindEvent() {
    const dom = this.dom

    // touch 事件
    dom.addEventListener('touchstart', evt => {
      this._triggerExparserEvent(evt, 'touchstart')

      if (this._touchstartEvt || evt.defaultPrevented) return
      if (evt.touches.length === 1) {
        if (this._longpressTimer) this._longpressTimer = clearTimeout(this._longpressTimer)

        this._touchstartX = evt.touches[0].pageX
        this._touchstartY = evt.touches[0].pageY
        this._touchstartEvt = evt

        if ((+new Date()) - this._lastScrollTime < SCROLL_PROTECTED) {
          // 滚动中
          this._isTapCancel = true
          this._lastScrollTime = 0 // 只检查一次
        } else {
          this._isTapCancel = false
          this._longpressTimer = setTimeout(() => {
            this._isTapCancel = true // 取消后续的 tap
            this._triggerExparserEvent(evt, 'longpress', {x: this._touchstartX, y: this._touchstartY})
          }, LONGPRESS_TIME)
        }
      }
    }, {capture: true, passive: false})

    dom.addEventListener('touchmove', evt => {
      this._triggerExparserEvent(evt, 'touchmove')

      if (!this._touchstartEvt) return
      if (evt.touches.length === 1) {
        if (!(Math.abs(evt.touches[0].pageX - this._touchstartX) < MOVE_DELTA && Math.abs(evt.touches[0].pageY - this._touchstartY) < MOVE_DELTA)) {
          // is moving
          if (this._longpressTimer) this._longpressTimer = clearTimeout(this._longpressTimer)
          this._isTapCancel = true
        }
      }
    }, {capture: true, passive: false})

    dom.addEventListener('touchend', evt => {
      this._triggerExparserEvent(evt, 'touchend')

      if (!this._touchstartEvt) return
      if (evt.touches.length === 0) {
        if (this._longpressTimer) this._longpressTimer = clearTimeout(this._longpressTimer)
        if (!this._isTapCancel) this._triggerExparserEvent(this._touchstartEvt, 'tap', {x: evt.changedTouches[0].pageX, y: evt.changedTouches[0].pageY})
      }

      this._touchstartEvt = null // 重置 touchStart 事件
    }, {capture: true, passive: false})

    dom.addEventListener('touchcancel', evt => {
      this._triggerExparserEvent(evt, 'touchcancel')

      if (!this._touchstartEvt) return
      if (this._longpressTimer) this._longpressTimer = clearTimeout(this._longpressTimer)

      this._touchstartEvt = null // 重置 touchStart 事件
    }, {capture: true, passive: false})

    // 其他事件
    dom.addEventListener('scroll', evt => {
      // 触发 intersectionObserver
      const listenInfoMap = this._exparserNode._listenInfoMap || {}
      Object.keys(listenInfoMap).forEach(key => {
        const listenInfo = listenInfoMap[key]
        IntersectionObserver.updateTargetIntersection(listenInfo)
      })

      this._lastScrollTime = +new Date()
      this._triggerExparserEvent(evt, 'scroll')
    }, {capture: true, passive: false})

    // eslint-disable-next-line no-unused-vars
    dom.addEventListener('blur', evt => {
      if (this._longpressTimer) this._longpressTimer = clearTimeout(this._longpressTimer)
    }, {capture: true, passive: false})
  }

  /**
   * 触发 exparser 节点事件
   */
  _triggerExparserEvent(evt, name, detail = {}) {
    Promise.resolve().then(() => {
      exparser.Event.dispatchEvent(evt.target, exparser.Event.create(name, detail, {
        originalEvent: evt,
        bubbles: true,
        capturePhase: true,
        composed: true,
        extraFields: {
          touches: evt.touches || {},
          changedTouches: evt.changedTouches || {},
        },
      }))
    }).catch(console.error)
  }

  /**
   * 添加
   */
  attach(parent) {
    parent.appendChild(this.dom)
    this.parentNode = parent

    exparser.Element.pretendAttached(this._exparserNode)
    dfsExparserTree(this._exparserNode, node => node.triggerLifeTime('ready'))
  }

  /**
   * 移除
   */
  detach() {
    if (!this.parentNode) return

    this.parentNode.removeChild(this.dom)
    this.parentNode = null

    exparser.Element.pretendDetached(this._exparserNode)
  }
}

module.exports = RootComponent
