const expr = require('./expr')
const CONSTANT = require('../tool/constant')

class VirtualNode {
  constructor(options = {}) {
    this.type = options.type
    this.tagName = options.tagName || ''
    this.componentId = options.componentId
    this.root = options.root || this // 根节点的 root 是自己
    this.parent = options.parent
    this.index = options.index || 0
    this.content = options.content && expr.getExpression(options.content)
    this.attrs = options.attrs || []
    this.event = options.event || {}
    this.statement = options.statement || {} // if/for 语句
    this.children = options.children || []
    this.generics = options.generics
    this.componentManager = options.componentManager // 所属的 componentManager 实例

    // 根节点用
    this.data = options.data || {}

    // wxs 节点用
    this.wxsModuleName = ''

    // slot 节点用
    this.slotName = ''

    this.checkAttrs()
  }

  /**
   * 检查属性
   */
  checkAttrs() {
    const type = this.type
    const attrs = this.attrs
    const filterAttrs = []

    for (const attr of attrs) {
      const name = attr.name
      const value = attr.value

      if (type === CONSTANT.TYPE_WXS && name === 'module') {
        // wxs 模块
        this.wxsModuleName = value || ''
      } else if (type === CONSTANT.TYPE_SLOT && name === 'name') {
        // slot 名
        this.slotName = value || ''
      } else {
        if (value && typeof value === 'string') attr.value = expr.getExpression(value)
        filterAttrs.push(attr)
      }
    }

    this.attrs = filterAttrs
  }

  /**
   * 设置父节点
   */
  setParent(parent, index = 0) {
    if (!parent) return

    this.parent = parent
    this.index = index
  }

  /**
   * 添加子节点
   */
  appendChild(node) {
    this.children.push(node)
  }

  /**
   * 设置 wxs 内容并转换成函数
   */
  setWxsContent(content) {
    if (!this.wxsModuleName) return

    // eslint-disable-next-line no-new-func
    const func = new Function('require', 'module', content)
    const req = () => {} // require function
    const mod = {exports: {}} // modules

    func.call(null, req, mod)

    this.root.data[this.wxsModuleName] = mod.exports // set in root's data
  }

  /**
   * 获取下一个兄弟节点
   */
  nextSibling() {
    return this.parent && this.parent.children[this.index + 1]
  }

  /**
   * 获取前一个兄弟节点
   */
  previousSibling() {
    return this.parent && this.parent.children[this.index - 1]
  }

  /**
   * 检查 if 语句
   */
  checkIf(data) {
    const statement = this.statement

    if (!statement.if) return true

    return expr.calcExpression(statement.if, data)
  }

  /**
   * 检查 elif 语句
   */
  checkElif(data) {
    const statement = this.statement

    if (!statement.elif) return true

    return this.checkPreviousCondition(data) ? false : expr.calcExpression(statement.elif, data)
  }

  /**
   * 检查 else 语句
   */
  checkElse(data) {
    const statement = this.statement

    if (!statement.else) return true

    return !this.checkPreviousCondition(data)
  }

  /**
   * 检查前一个条件语句
   */
  checkPreviousCondition(data) {
    let previousSibling = this.previousSibling()

    while (previousSibling) {
      const statement = previousSibling.statement

      if (previousSibling.type !== CONSTANT.TYPE_IF) return false // not if node
      if (!statement.if && !statement.elif) return false // not have condition statement
      if (statement.if) return previousSibling.checkIf(data)

      if (statement.elif) {
        if (!previousSibling.checkElif(data)) {
          previousSibling = previousSibling.previousSibling()
        } else {
          return true
        }
      }
    }

    return false
  }

  /**
   * 生成虚拟树
   */
  generate(options = {}) {
    const data = options.data || {}
    const statement = this.statement
    let key = options.key || ''

    options.data = data

    delete options.key // 不能跨组件传递

    // 检查 include 节点
    if (this.type === CONSTANT.TYPE_INCLUDE) {
      return null
    }

    // 检查 import 节点
    if (this.type === CONSTANT.TYPE_IMPORT) {
      return null
    }

    // 检查 template 节点
    if (this.type === CONSTANT.TYPE_TEMPLATE) {
      return null
    }

    // 检查 wxs 节点
    if (this.type === CONSTANT.TYPE_WXS) {
      return null
    }

    // 检查 if / elif / else 语句
    if (this.type === CONSTANT.TYPE_IF && (!this.checkIf(data) || !this.checkElif(data) || !this.checkElse(data))) {
      return null
    }

    let children = []

    // 检查子节点
    if (this.children && this.children.length) {
      if (this.type === CONSTANT.TYPE_FOR) {
        // 检查 for 语句
        const list = expr.calcExpression(statement.for, data) || []
        options.extra = options.extra || {}

        for (let i = 0, len = list.length; i < len; i++) {
          const {forItem: bakItem, forIndex: bakIndex} = options.extra

          options.extra.forItem = list[i]
          options.extra.forIndex = i

          // eslint-disable-next-line no-loop-func
          this.children.forEach(node => {
            const vt = node.generate(options)
            children.push(vt)
          })

          options.extra.forItem = bakItem
          options.extra.forIndex = bakIndex
        }
      } else if (this.type === CONSTANT.TYPE_FORITEM) {
        // 检查 for 子节点
        options.extra = options.extra || {}
        const {forItem, forIndex} = options.extra
        const {forItem: bakItem, forIndex: bakIndex} = data
        data[statement.forItem] = forItem // list item
        data[statement.forIndex] = forIndex // list index
        if (statement.forKey) key = statement.forKey === '*this' ? forItem : forItem[statement.forKey] // list key

        children = this.children.map(node => node.generate(options))

        data[statement.forItem] = bakItem
        data[statement.forIndex] = bakIndex
      } else {
        // 其他节点
        children = this.children.map(node => node.generate(options))
      }
    }

    // 过滤子节点
    const filterChildren = []
    for (const child of children) {
      if (!child) continue

      if (child.type === CONSTANT.TYPE_BLOCK) {
        // block 节点
        const grandChildren = child.children
        for (const grandChild of grandChildren) {
          filterChildren.push(grandChild)
        }
      } else {
        filterChildren.push(child)
      }
    }

    // 检查属性
    const attrs = []
    for (const {name, value} of this.attrs) {
      attrs.push({
        name,
        value: value ? expr.calcExpression(value, data) : value,
      })
    }

    // 计算内容
    let content = expr.calcExpression(this.content, data)
    content = content !== undefined ? String(content) : ''

    return {
      type: this.type,
      tagName: this.tagName,
      componentId: this.componentId,
      content, // 文本节点的内容
      key, // 节点的 key，diff 用
      children: filterChildren,
      generics: this.generics,
      attrs,
      event: this.event,
      slotName: this.slotName, // slot 节点的 name 属性
    }
  }
}

module.exports = VirtualNode
