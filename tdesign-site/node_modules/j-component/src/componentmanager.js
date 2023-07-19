const exparser = require('miniprogram-exparser')
const compile = require('./template/compile')
const transform = require('./template/transform')
const diff = require('./render/diff')
const render = require('./render/render')
const _ = require('./tool/utils')
const SelectorQuery = require('./tool/selectorquery')
const IntersectionObserver = require('./tool/intersectionobserver')

const PATH_TO_ID_MAP = []

class ComponentManager {
  constructor(definition) {
    this.id = definition.id || _.getId(true)
    this.path = _.normalizeAbsolute(definition.path)
    this.definition = definition

    if (definition.tagName) _.setTagName(this.id, definition.tagName) // 保存标签名
    if (this.path) PATH_TO_ID_MAP[this.path] = this.id // 保存 path 到 id 的映射

    const template = definition.template

    this.data = {}
    this.generateFunc = typeof template === 'function' ? transform(template, definition.usingComponents || {}) : compile(template, this.data, definition.usingComponents || {}) // 解析编译模板
    this.exparserDef = this.registerToExparser()

    _.cache(this.id, this)
  }

  /**
   * 注册 exparser 组件
   */
  registerToExparser() {
    const definition = this.definition
    const options = definition.options || {}
    const usingComponents = definition.usingComponents || {}
    const using = Object.keys(usingComponents).map(key => usingComponents[key])
    let methods = {}

    definition.behaviors = definition.behaviors || []
    definition.behaviors = definition.behaviors.map((item) => {
      // 支持内置 behavior
      if (item === 'wx://component-export') {
        return global.wxComponentExport
      } else if (item === 'wx://form-field') {
        return global.wxFormField
      } else if (item === 'wx://form-field-group') {
        return global.wxFormFieldGroup
      } else if (item === 'wx://form-field-button') {
        return global.wxFormFieldButton
      }

      return item
    })

    _.adjustExparserDefinition(definition)

    const path = this.path
    const definitionFilter = exparser.Behavior.callDefinitionFilter(definition)
    const exparserDef = {
      is: this.id,
      using,
      generics: [], // TODO
      template: {
        func: this.generateFunc,
        data: this.data,
      },
      properties: definition.properties,
      data: definition.data,
      methods: definition.methods,
      behaviors: definition.behaviors,
      created: definition.created,
      attached: definition.attached,
      ready: definition.ready,
      moved: definition.moved,
      detached: definition.detached,
      saved: definition.saved,
      restored: definition.restored,
      relations: definition.relations,
      externalClasses: definition.externalClasses,
      options: {
        domain: `${options.writeOnly ? 'wo://' : ''}/`,
        writeOnly: options.writeOnly || false,
        allowInWriteOnly: false,
        lazyRegistration: true,
        classPrefix: options.classPrefix || '',
        addGlobalClass: false,
        templateEngine: TemplateEngine,
        renderingMode: 'full',
        multipleSlots: options.multipleSlots || false,
        publicProperties: true,
        reflectToAttributes: false,
        writeFieldsToNode: false,
        writeIdToDOM: false,
        virtualHost: options.virtualHost || undefined,
      },
      lifetimes: definition.lifetimes,
      pageLifetimes: definition.pageLifetimes,
      observers: definition.observers,
      definitionFilter,
      initiator() {
        // 更新方法调用者，即自定义组件中的 this
        const caller = Object.create(this, {
          data: {
            get: () => this.data,
            set: newData => this.data = newData,
            configurable: true
          },
        })
        const originalSetData = caller.setData
        const getSelectComponentResult = selected => {
          const selectedFilter = exparser.Component.getMethod(selected, '__export__')
          const defaultResult = exparser.Element.getMethodCaller(selected)
          if (selectedFilter) {
            const res = selectedFilter.call(exparser.Element.getMethodCaller(selected), caller)
            return res === undefined ? defaultResult : res
          }
          return defaultResult
        }

        caller._exparserNode = this // 存入原本对应的 exparserNode 实例
        caller.properties = caller.data
        caller.selectComponent = selector => {
          const exparserNode = this.shadowRoot.querySelector(selector)
          return getSelectComponentResult(exparserNode)
        }
        caller.selectAllComponents = selector => {
          const exparserNodes = this.shadowRoot.querySelectorAll(selector)
          return exparserNodes.map(item => getSelectComponentResult(item))
        }
        caller.selectOwnerComponent = () => {
          const ownerShadowRoot = this.ownerShadowRoot
          if (!(ownerShadowRoot instanceof exparser.ShadowRoot)) return null

          const exparserNode = ownerShadowRoot.getHostNode()
          if (!exparserNode) return null

          return getSelectComponentResult(exparserNode)
        } 
        caller.createSelectorQuery = () => new SelectorQuery(caller)
        caller.createIntersectionObserver = options => new IntersectionObserver(caller, options)
        caller.setData = (data, callback) => {
          if (!originalSetData || typeof originalSetData !== 'function') return

          originalSetData.call(this, data)

          if (typeof callback === 'function') {
            // 模拟异步情况
            Promise.resolve().then(callback).catch(console.error)
          }
        }
        caller.getRelationNodes = relationKey => {
          if (!path || !relationKey) return null

          const id = PATH_TO_ID_MAP[_.relativeToAbsolute(path, relationKey)]
          if (!id) return null

          const res = this.getRelationNodes(id)
          if (!res) return null
          return res.map(exparserNode => exparser.Element.getMethodCaller(exparserNode))
        }

        Object.keys(methods).forEach(name => caller[name] = methods[name])
        exparser.Element.setMethodCaller(this, caller)
      },
    }

    const exparserReg = exparser.registerElement(exparserDef)
    exparser.Behavior.prepare(exparserReg.behavior)
    methods = exparserReg.behavior.methods

    return exparserReg
  }
}

/**
 * exparser 的模板引擎封装
 */
class TemplateEngine {
  static create(behavior, initValues) {
    const templateEngine = new TemplateEngine()
    const data = Object.assign({}, initValues, behavior.template.data)

    templateEngine._data = data
    templateEngine._generateFunc = behavior.template.func

    return templateEngine
  }

  static collectIdMapAndSlots(exparserNode, idMap, slots) {
    const children = exparserNode.childNodes

    for (const child of children) {
      if (child instanceof exparser.TextNode) continue
      if (child.__id) idMap[child.__id] = child
      if (child.__slotName !== undefined) slots[child.__slotName] = child

      TemplateEngine.collectIdMapAndSlots(child, idMap, slots)
    }
  }

  createInstance(exparserNode, properties = {}) {
    this._data = Object.assign(this._data, properties)
    this._vt = this._generateFunc({data: this._data}) // 生成虚拟树

    const instance = new TemplateEngineInstance()
    instance._generateFunc = this._generateFunc
    instance._vt = this._vt

    instance.data = _.copy(this._data)
    instance.idMap = {}
    instance.slots = {}
    instance.shadowRoot = render.renderExparserNode(instance._vt, exparserNode, null) // 渲染成 exparser 树
    instance.shadowRoot._vt = instance._vt
    instance.listeners = []

    TemplateEngine.collectIdMapAndSlots(instance.shadowRoot, instance.idMap, instance.slots)

    return instance
  }
}

/**
 * exparser 的模板引擎实例
 */
class TemplateEngineInstance {
  /**
   * 当遇到组件更新时，会触发此方法
   */
  updateValues(exparserNode, data, changedPaths, changedValues, changes) {
    const newVt = this._generateFunc({data}) // 生成新虚拟树

    // 合并到方法调用者的 data 中
    const callerData = exparser.Element.getMethodCaller(exparserNode).data
    const hasOwnProperty = Object.prototype.hasOwnProperty
    for (const changeInfo of changes) {
      if (!changeInfo) continue

      const path = changeInfo[0]
      const newData = changeInfo[1]
      let currentData = callerData
      let currentPath = path[0]

      // 检查更新路径
      for (let i = 1, len = path.length; i < len; i++) {
        const nextPath = path[i]
        const currentValue = currentData[currentPath]

        if (!hasOwnProperty.call(currentData, currentPath)) {
          // 不存在，则进行初始化
          if (typeof nextPath === 'number' && isFinite(nextPath)) {
            // 数组
            if (!Array.isArray(currentValue)) currentData[currentPath] = []
          } else if (currentValue === null || typeof currentValue !== 'object' || Array.isArray(currentValue)) {
            // 对象
            currentData[currentPath] = {}
          }
        }

        currentData = currentData[currentPath]
        currentPath = nextPath
      }

      const oldData = currentData[currentPath]
      currentData[currentPath] = _.copy(newData)
      changedValues = [currentData[currentPath], oldData]
    }

    // 应用更新
    diff.diffVt(this._vt, newVt)
    this._vt = newVt
  }
}

module.exports = ComponentManager
