const parse = require('./parse')
const VirtualNode = require('./virtualnode')
const expr = require('./expr')
const _ = require('../tool/utils')
const CONSTANT = require('../tool/constant')

/**
 * 过滤属性
 */
function filterAttrs(attrs) {
  const statement = {}
  const event = {}
  const normalAttrs = []

  for (const attr of attrs) {
    const name = attr.name
    const value = attr.value || ''

    if (name === 'wx:if') {
      statement.if = expr.getExpression(value)
    } else if (name === 'wx:elif') {
      statement.elif = expr.getExpression(value)
    } else if (name === 'wx:else') {
      statement.else = true
    } else if (name === 'wx:for') {
      statement.for = expr.getExpression(value)
    } else if (name === 'wx:for-item') {
      statement.forItem = value
    } else if (name === 'wx:for-index') {
      statement.forIndex = value
    } else if (name === 'wx:key') {
      statement.forKey = value
    } else {
      const eventObj = _.parseEvent(name, value)

      if (eventObj) {
        // 事件绑定
        event[eventObj.name] = eventObj
      } else {
        // 普通属性
        normalAttrs.push(attr)
      }
    }
  }

  return {
    statement,
    event,
    normalAttrs,
  }
}

module.exports = function (template, data, usingComponents) {
  if (!template || typeof template !== 'string' || !template.trim()) throw new Error('invalid template')
  template = template.trim()

  // 根节点
  const rootNode = new VirtualNode({
    type: CONSTANT.TYPE_ROOT,
    componentManager: this,
    data,
  })
  const stack = [rootNode]

  stack.last = function () {
    return this[this.length - 1]
  }

  parse(template, {
    start: (tagName, attrs, unary) => {
      let type
      let componentManager
      let id = ''

      if (tagName === 'slot') {
        type = CONSTANT.TYPE_SLOT
      } else if (tagName === 'template') {
        type = CONSTANT.TYPE_TEMPLATE
        tagName = 'virtual'
      } else if (tagName === 'block') {
        type = CONSTANT.TYPE_BLOCK
      } else if (tagName === 'import') {
        type = CONSTANT.TYPE_IMPORT
      } else if (tagName === 'include') {
        type = CONSTANT.TYPE_INCLUDE
      } else if (tagName === 'wxs') {
        type = CONSTANT.TYPE_WXS
      } else if (_.isHtmlTag(tagName)) {
        type = CONSTANT.TYPE_NATIVE
        id = tagName
      } else {
        type = CONSTANT.TYPE_COMPONENT
        id = usingComponents[tagName]
        componentManager = id ? _.cache(id) : _.cache(tagName)

        if (!componentManager) throw new Error(`component ${tagName} not found`)
        else id = componentManager.id
      }

      const {statement, event, normalAttrs} = filterAttrs(attrs)

      const parent = stack.last()
      const node = new VirtualNode({
        type,
        tagName,
        componentId: id,
        attrs: normalAttrs,
        event,
        generics: {}, // TODO
        componentManager,
        root: rootNode,
      })
      let appendNode = node

      // for 语句
      if (statement.for) {
        const itemNode = new VirtualNode({
          type: CONSTANT.TYPE_FORITEM,
          tagName: 'virtual',
          statement: {
            forItem: statement.forItem || 'item',
            forIndex: statement.forIndex || 'index',
            forKey: statement.forKey,
          },
          children: [node],
          root: rootNode,
        })
        node.setParent(itemNode, 0) // 更新父节点

        const forNode = new VirtualNode({
          type: CONSTANT.TYPE_FOR,
          tagName: 'wx:for',
          statement: {
            for: statement.for,
          },
          children: [itemNode],
          root: rootNode,
        })
        itemNode.setParent(forNode, 0) // 更新父节点

        appendNode = forNode
      }

      // 条件语句
      if (statement.if || statement.elif || statement.else) {
        const ifNode = new VirtualNode({
          type: CONSTANT.TYPE_IF,
          tagName: 'wx:if',
          statement: {
            if: statement.if,
            elif: statement.elif,
            else: statement.else,
          },
          children: [node],
          root: rootNode,
        })
        node.setParent(ifNode, 0) // 更新父节点

        appendNode = ifNode
      }

      if (!unary) {
        stack.push(node)
      }

      appendNode.setParent(parent, parent.children.length) // 更新父节点
      parent.appendChild(appendNode)
    },
    // eslint-disable-next-line no-unused-vars
    end: tagName => {
      stack.pop()
    },
    text: content => {
      content = content.trim()
      if (!content) return

      const parent = stack.last()
      if (parent.type === CONSTANT.TYPE_WXS) {
        // wxs 节点
        parent.setWxsContent(content)
      } else {
        // 文本节点
        parent.appendChild(new VirtualNode({
          type: CONSTANT.TYPE_TEXT,
          content: content.replace(/[\n\r\t\s]+/g, ' '),
          parent,
          index: parent.children.length,
          componentManager: this,
          root: rootNode,
        }))
      }
    },
  })

  if (stack.length !== 1) throw new Error(`build ast error: ${template}`)

  return rootNode.generate.bind(rootNode)
}
