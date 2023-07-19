const exparser = require('miniprogram-exparser')
const _ = require('./utils')

/**
 * 测量相交区域
 */
function measureIntersect(baseRect, newRect) {
  const rect = {
    left: baseRect.left < newRect.left ? newRect.left : baseRect.left,
    top: baseRect.top < newRect.top ? newRect.top : baseRect.top,
    right: baseRect.right > newRect.right ? newRect.right : baseRect.right,
    bottom: baseRect.bottom > newRect.bottom ? newRect.bottom : baseRect.bottom,
    width: 0,
    height: 0,
  }
  if (rect.right > rect.left) rect.width = rect.right - rect.left
  else rect.right = rect.left = rect.bottom = rect.top = 0

  if (rect.bottom > rect.top) rect.height = rect.bottom - rect.top
  else rect.right = rect.left = rect.bottom = rect.top = 0

  return rect
}

/**
 * 测量参照区域
 */
function measureRelativeRect(relatives) {
  const clientWidth = document.documentElement.clientWidth
  const clientHeight = document.documentElement.clientHeight

  let retRect = null
  for (let i = 0; i < relatives.length; i++) {
    const {node, margins} = relatives[i]
    const boundingRect = node ? node.$$.getBoundingClientRect() : {
      left: 0,
      top: 0,
      right: clientWidth,
      bottom: clientHeight,
      width: clientWidth,
      height: clientHeight
    }
    const rect = {
      left: boundingRect.left - margins.left,
      top: boundingRect.top - margins.top,
      right: boundingRect.right + margins.right,
      bottom: boundingRect.bottom + margins.bottom,
    }

    if (retRect) retRect = measureIntersect(retRect, rect)
    else retRect = rect
  }

  return retRect
}

class IntersectionObserver {
  constructor(compInst, options = {}) {
    this._exparserNode = compInst._exparserNode
    this._relativeInfo = []
    this._options = options
    this._disconnected = false
    this._observers = []

    this._exparserNode._listenInfoMap = this._exparserNode._listenInfoMap || {} // 存入监听信息
  }

  /**
     * 检查并更新目标节点的相交情况
     */
  static updateTargetIntersection(listenerInfo) {
    const {
      targetNode, relatives, thresholds, minWidthOrHeight, currentRatio, callback
    } = listenerInfo
    const targetRect = targetNode.$$.getBoundingClientRect()

    if (targetRect.right - targetRect.left < minWidthOrHeight) {
      targetRect.right = targetRect.left + minWidthOrHeight
      targetRect.width = minWidthOrHeight
    }
    if (targetRect.bottom - targetRect.top < minWidthOrHeight) {
      targetRect.bottom = targetRect.top + minWidthOrHeight
      targetRect.height = minWidthOrHeight
    }

    const relativeRect = measureRelativeRect(relatives)
    const intersectRect = measureIntersect(relativeRect, targetRect)
    const targetArea = targetRect.width * targetRect.height
    const intersectRatio = targetArea ? intersectRect.width * intersectRect.height / targetArea : 0

    listenerInfo.currentRatio = intersectRatio

    let isUpdate = currentRatio === undefined
    if (intersectRatio !== currentRatio) {
      thresholds.forEach(threshold => {
        if (isUpdate) return
        if (intersectRatio <= threshold && currentRatio >= threshold) isUpdate = true
        else if (intersectRatio >= threshold && currentRatio <= threshold) isUpdate = true
      })
    }

    if (isUpdate) {
      callback.call(targetNode, {
        id: targetNode.id,
        dataset: targetNode.dataset,
        time: Date.now(),
        boundingClientRect: targetRect,
        intersectionRatio: intersectRatio,
        intersectionRect: intersectRect,
        relativeRect,
      })
    }
  }

  disconnect() {
    this._disconnected = true
    this._observers.forEach(observer => observer.disconnect())
    this._observers = []
  }

  observe(selector, callback) {
    // 获取目标节点
    const shadowRoot = this._exparserNode.shadowRoot
    let targetNodes = this._options.observeAll ? shadowRoot.querySelectorAll(selector) : shadowRoot.querySelector(selector)
    if (!Array.isArray(targetNodes)) targetNodes = targetNodes ? [targetNodes] : []

    // 获取参照区域
    const relatives = []
    this._relativeInfo.forEach(item => {
      const {selector, margins} = item
      const node = selector === null ? null : shadowRoot.querySelector(selector)
      if (selector === null || node) {
        relatives.push({
          node,
          margins: {
            left: margins.left || 0,
            top: margins.top || 0,
            right: margins.right || 0,
            bottom: margins.bottom || 0,
          },
        })
      }
    })

    targetNodes.forEach(targetNode => {
      const id = _.getId()
      const listenerInfo = {
        targetNode,
        relatives,
        thresholds: this._options.thresholds || [0],
        currentRatio: this._options.initialRatio || 0,
        minWidthOrHeight: 0,
        callback,
      }
      const observer = exparser.Observer.create(evt => {
        if (evt.status === 'attached') {
          this._exparserNode._listenInfoMap[id] = listenerInfo
          window.requestAnimationFrame(() => {
            if (!this._disconnected) IntersectionObserver.updateTargetIntersection(listenerInfo)
          })
        } else if (evt.status === 'detached') {
          delete this._exparserNode._listenInfoMap[id]
          observer.disconnect()
        }
      })
      observer.observe(targetNode, {attachStatus: true})
      if (exparser.Element.isAttached(targetNode)) {
        this._exparserNode._listenInfoMap[id] = listenerInfo
        window.requestAnimationFrame(() => {
          if (!this._disconnected) IntersectionObserver.updateTargetIntersection(listenerInfo)
        })
      }

      this._observers.push(observer)
    })
  }

  relativeTo(selector, margins = {}) {
    this._relativeInfo.push({
      selector,
      margins,
    })
    return this
  }

  relativeToViewport(margins = {}) {
    this._relativeInfo.push({
      selector: null,
      margins,
    })
    return this
  }
}

module.exports = IntersectionObserver
