const exparser = require('miniprogram-exparser')

class NodesRef {
  constructor(selectorQuery, exparserNode, selector, isSelectSingle) {
    this._selectorQuery = selectorQuery
    this._exparserNode = exparserNode
    this._selector = selector
    this._isSelectSingle = isSelectSingle
  }

  boundingClientRect(callback) {
    return this._selectorQuery._push(this._selector, this._exparserNode, this._isSelectSingle, {
      id: true,
      dataset: true,
      rect: true,
      size: true,
    }, callback)
  }

  scrollOffset(callback) {
    return this._selectorQuery._push(this._selector, this._exparserNode, this._isSelectSingle, {
      id: true,
      dataset: true,
      scrollOffset: true,
    }, callback)
  }

  context(callback) {
    return this._selectorQuery._push(this._selector, this._exparserNode, this._isSelectSingle, {
      context: true,
    }, callback)
  }

  fields(fields, callback) {
    return this._selectorQuery._push(this._selector, this._exparserNode, this._isSelectSingle, fields, callback)
  }
}

class SelectorQuery {
  constructor(compInst) {
    this._exparserNode = compInst && compInst._exparserNode || null
    this._queue = []
    this._queueCallback = []
  }

  _push(selector, exparserNode, isSelectSingle, fields, callback) {
    this._queue.push({
      selector,
      exparserNode,
      isSelectSingle,
      fields,
    })
    this._queueCallback.push(callback || null)

    return this
  }

  in(compInst) {
    if (!compInst || typeof compInst !== 'object') {
      throw new Error('invalid params')
    }

    this._exparserNode = compInst._exparserNode

    return this
  }

  select(selector) {
    return new NodesRef(this, this._exparserNode, selector, true)
  }

  selectAll(selector) {
    return new NodesRef(this, this._exparserNode, selector, false)
  }

  selectViewport() {
    return new NodesRef(this, 0, '', false)
  }

  exec(callback) {
    Promise.resolve().then(() => {
      const res = []

      this._queue.forEach((item, index) => {
        const {
          selector, exparserNode, isSelectSingle, fields
        } = item

        if (exparserNode === 0) {
          const itemRes = {}

          if (fields.id) {
            itemRes.id = ''
          }
          if (fields.dataset) {
            itemRes.dataset = {}
          }
          if (fields.rect) {
            itemRes.left = 0
            itemRes.right = 0
            itemRes.top = 0
            itemRes.bottom = 0
          }
          if (fields.size) {
            itemRes.width = document.documentElement.clientWidth
            itemRes.height = document.documentElement.clientHeight
          }
          if (fields.scrollOffset) {
            itemRes.scrollLeft = document.documentElement.scrollLeft || document.body.scrollLeft || 0
            itemRes.scrollTop = document.documentElement.scrollTop || document.body.scrollTop || 0
          }

          res.push(itemRes)
        } else {
          const shadowRoot = exparserNode.shadowRoot
          const nodes = isSelectSingle ? [shadowRoot.querySelector(selector)] : shadowRoot.querySelectorAll(selector)
          const itemResList = []

          for (const node of nodes) {
            if (!node) continue
            const itemRes = {}

            if (fields.id) {
              itemRes.id = node.id || ''
            }
            if (fields.dataset) {
              itemRes.dataset = Object.assign({}, node.dataset || {})
            }
            if (fields.rect || fields.size) {
              const rect = node.$$.getBoundingClientRect()

              if (fields.rect) {
                itemRes.left = rect.left
                itemRes.right = rect.right
                itemRes.top = rect.top
                itemRes.bottom = rect.bottom
              }
              if (fields.size) {
                itemRes.width = rect.width
                itemRes.height = rect.height
              }
            }
            if (fields.properties) {
              fields.properties.forEach(name => {
                name = name.replace(/-([a-z])/g, (all, $1) => $1.toUpperCase())

                if (exparser.Component.hasPublicProperty(node, name)) {
                  itemRes[name] = node.data[name]
                }
              })
            }
            if (fields.scrollOffset) {
              itemRes.scrollLeft = node.$$.scrollLeft || 0
              itemRes.scrollTop = node.$$.scrollTop || 0
            }
            if (fields.computedStyle && fields.computedStyle.length) {
              const style = window.getComputedStyle(node.$$)

              fields.computedStyle.forEach(key => {
                if (key && style[key] !== undefined) itemRes[key] = style[key]
              })
            }
            if (fields.context) {
              itemRes.context = {} // TODO
            }

            itemResList.push(itemRes)
          }

          res.push(isSelectSingle ? (itemResList[0] || null) : itemResList)
        }

        if (typeof this._queueCallback[index] === 'function') this._queueCallback[index].call(this, res[index])
      })

      if (typeof callback === 'function') callback.call(this, res)

      // reset
      this._queue = []
      this._queueCallback = []
    }).catch(console.error)
  }
}

module.exports = SelectorQuery
