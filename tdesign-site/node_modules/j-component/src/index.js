const exparser = require('miniprogram-exparser')
const ComponentManager = require('./componentmanager')
const RootComponent = require('./render/component')
const _ = require('./tool/utils')

module.exports = {
  /**
   * 注册组件
   */
  register(definition = {}) {
    const componentManager = new ComponentManager(definition)

    return componentManager.id
  },

  /**
   * 注册 behavior
   */
  behavior(definition) {
    definition.is = _.getId(true)
    definition.options = {
      lazyRegistration: true,
      publicProperties: true,
    }

    _.adjustExparserDefinition(definition)
    definition.definitionFilter = exparser.Behavior.callDefinitionFilter(definition)
    exparser.registerBehavior(definition)

    return definition.is
  },

  /**
   * 创建组件实例
   */
  create(id, properties) {
    const componentManager = _.cache(id)

    if (!componentManager) return

    return new RootComponent(componentManager, properties)
  },
}

global.wxFormField = module.exports.behavior({
  id: 'wx://form-field',
  properties: {
    name: {
      type: String
    },
    value: {
      type: null
    }
  }
})

global.wxFormFieldGroup = module.exports.behavior({
  is: 'wx://form-field-group',
})

global.wxFormFieldButton = module.exports.behavior({
  is: 'wx://form-field-button',
  listeners: {
    formSubmit(data) {
      this.triggerEvent('formSubmit', data, {bubbles: true})
    },
    formReset(data) {
      this.triggerEvent('formReset', data, {bubbles: true})
    },
  }
})

global.wxComponentExport = module.exports.behavior({
  is: 'wx://component-export',
  definitionFilter(def) {
    if (typeof def.export === 'function') {
      if (typeof def.methods === 'object') {
        def.methods.__export__ = def.export
      } else {
        def.methods = {
          __export__: def.export,
        }
      }
    }
  }
})
