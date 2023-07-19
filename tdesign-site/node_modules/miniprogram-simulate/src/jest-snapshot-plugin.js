/**
 * 参考实现 https://github.com/facebook/jest/blob/3f107a3377/packages/pretty-format/src/plugins/ReactTestComponent.ts
 */
// eslint-disable-next-line import/no-extraneous-dependencies
const _markup = require('pretty-format/build/plugins/lib/markup')

/**
 * 用于识别 j-component toJSON 函数生成的 JSON 对象
 */
const testSymbol =
  typeof Symbol === 'function' && Symbol.for
      ? Symbol.for('j-component.json')
      : 0xd846fe

/**
 * @typedef {object} JComponentJSON j-component toJSON 函数生成的 JSON 对象
 * @prop {string} tagName
 * @prop {{ name: string; value: any }[]} attrs
 * @prop {{ [event: string]: { handler: string; isCapture: boolean; isMutated: boolean; isCatch: boolean; name: string } }} event
 * @prop {JComponentJSON[]} children
 */

/**
 * @typedef {import('pretty-format/build/types').NewPlugin} NewPlugin
 * @typedef {import('pretty-format/build/types').Config} Config
 * @typedef {import('pretty-format/build/types').Printer} Printer
 * @typedef {import('pretty-format/build/types').Refs} Refs
 */

/**
 * 暴露给 pretty-format 的检测函数
 * 仅有检测返回 true 的对象才会传入 serialize
 * @param {any} val
 */
const test = function test(val) {
    return val && val.$$typeof === testSymbol
}

/**
 * 打印节点属性
 * @param {JComponentJSON['attrs']} attrs
 * @param {Config} config
 * @param {string} indentation
 * @param {number} depth
 * @param {Refs} refs
 * @param {Printer} printer
 */
const printAttrs = function printAttrs(
    attrs,
    config,
    indentation,
    depth,
    refs,
    printer
) {
    const indentationNext = indentation + config.indent
    const colors = config.colors
    return Array.from(attrs)
        .sort(function(a, b) {
            return a.name.localeCompare(b.name)
        })
        .map(function(attr) {
            const name = attr.name
            const value = attr.value
            let printed = printer(value, config, indentationNext, depth, refs)

            if (typeof value !== 'string') {
                if (printed.indexOf('\n') !== -1) {
                    printed =
                        config.spacingOuter +
                        indentationNext +
                        printed +
                        config.spacingOuter +
                        indentation
                }

                printed = '"{{' + printed + '}}"'
            }

            return (
                config.spacingInner +
                indentation +
                colors.prop.open +
                name +
                colors.prop.close +
                '=' +
                colors.value.open +
                printed +
                colors.value.close
            )
        })
        .join('')
}

/**
 * 打印节点事件绑定
 * @param {JComponentJSON['event']} event
 * @param {Config} config
 * @param {string} indentation
 * @param {number} depth
 * @param {Refs} refs
 * @param {Printer} printer
 */
const printEvent = function printEvent(
    event,
    config,
    indentation,
    depth,
    refs,
    printer
) {
    const indentationNext = indentation + config.indent
    const colors = config.colors
    return Object.keys(event)
        .sort()
        .map(function(eventName) {
            const eventInfo = event[eventName]
            const handler = eventInfo.handler
            const isCapture = eventInfo.isCapture
            const isMutated = eventInfo.isMutated
            const isCatch = eventInfo.isCatch
            const attrName =
                (isCapture ? 'capture-' : '') +
                (isMutated ? 'mut-' : '') +
                (isCatch ? 'catch' : 'bind') +
                ':' +
                eventName

            const printed = printer(handler, config, indentationNext, depth, refs)
            return (
                config.spacingInner +
                indentation +
                colors.prop.open +
                attrName +
                colors.prop.close +
                '=' +
                colors.value.open +
                printed +
                colors.value.close
            )
        })
        .join('')
}

/**
 * 打印节点所有属性
 * @param {JComponentJSON} object
 * @param {Config} config
 * @param {string} indentation
 * @param {number} depth
 * @param {Refs} refs
 * @param {Printer} printer
 */
const printProps = function printProps(
    object,
    config,
    indentation,
    depth,
    refs,
    printer
) {
    return (
        printAttrs(object.attrs, config, indentation, depth, refs, printer) +
        printEvent(object.event, config, indentation, depth, refs, printer)
    )
}

/**
 * 暴露给 pretty-format 的打印函数
 * 仅有通过 test 函数检测返回 true 的对象才会传入 serialize
 * @param {JComponentJSON} object
 * @param {Config} config
 * @param {string} indentation
 * @param {number} depth
 * @param {Refs} refs
 * @param {Printer} printer
 */
const serialize = function serialize(
    object,
    config,
    indentation,
    depth,
    refs,
    printer
) {
    return ++depth > config.maxDepth
        ? _markup.printElementAsLeaf(object.tagName, config)
        : _markup.printElement(
            object.tagName,
            printProps(
                object,
                config,
                indentation + config.indent,
                depth,
                refs,
                printer
            ),
            _markup.printChildren(
                object.children,
                config,
                indentation + config.indent,
                depth,
                refs,
                printer
            ),
            config,
            indentation
        )
}

module.exports = {
    serialize,
    test,
}
