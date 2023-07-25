/**
 * 感谢 John Resig
 * 源码：https://johnresig.com/files/htmlparser.js
 */

const startTagReg = /^<([-A-Za-z0-9_]+)((?:\s+[\w\-:]+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/
const endTagReg = /^<\/([-A-Za-z0-9_]+)[^>]*>/
const attrReg = /([-A-Za-z0-9_:]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?/g

module.exports = function (content, handler = {}) {
  const stack = []
  let last = content

  stack.last = function () {
    return this[this.length - 1]
  }

  while (content) {
    let isText = true

    if (!stack.last() || stack.last() !== 'wxs') {
      if (content.indexOf('<!--') === 0) {
        // 注释
        const index = content.indexOf('-->')

        if (index >= 0) {
          content = content.substring(index + 3)
          isText = false
        }
      } else if (content.indexOf('</') === 0) {
        // 结束标签
        const match = content.match(endTagReg)

        if (match) {
          content = content.substring(match[0].length)
          match[0].replace(endTagReg, parseEndTag)
          isText = false
        }
      } else if (content.indexOf('<') === 0) {
        // 开始标签
        const match = content.match(startTagReg)

        if (match) {
          content = content.substring(match[0].length)
          match[0].replace(startTagReg, parseStartTag)
          isText = false
        }
      }

      if (isText) {
        const index = content.indexOf('<')

        const text = index < 0 ? content : content.substring(0, index)
        content = index < 0 ? '' : content.substring(index)

        if (handler.text) handler.text(text)
      }
    } else {
      const execRes = (new RegExp(`</${stack.last()}[^>]*>`)).exec(content)

      if (execRes) {
        let text = content.substring(0, execRes.index)
        content = content.substring(execRes.index + execRes[0].length)

        text = text.replace(/<!--(.*?)-->/g, '')
        if (text && handler.text) handler.text(text)
      }

      parseEndTag('', stack.last())
    }


    if (content === last) throw new Error(`parse error: ${content}`)
    last = content
  }

  // 清空保留的标签
  parseEndTag()

  function parseStartTag(tag, tagName, rest, unary) {
    unary = !!unary

    if (!unary) stack.push(tagName)

    if (handler.start) {
      const attrs = []

      rest.replace(attrReg, (all, $1, $2, $3, $4) => {
        attrs.push({
          name: $1,
          value: $2 !== undefined ? $2 : $3 !== undefined ? $3 : $4 !== undefined ? $4 : true,
        })
      })

      if (handler.start) handler.start(tagName, attrs, unary)
    }
  }

  function parseEndTag(tag, tagName) {
    let pos

    if (!tagName) {
      pos = 0
    } else {
      // 找到最近的同类型开始标签
      for (pos = stack.length - 1; pos >= 0; pos--) {
        if (stack[pos] === tagName) break
      }
    }

    if (pos >= 0) {
      // 关闭所有的开始标签，并让其出栈
      for (let i = stack.length - 1; i >= pos; i--) {
        if (handler.end) handler.end(stack[i])
      }

      stack.length = pos
    }
  }
}
