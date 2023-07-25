const Expression = require('expr-parser')

module.exports = {
  /**
   * 获取表达式
   */
  getExpression(content) {
    let end = 0
    let start = content.indexOf('{{', end)
    const res = []

    while (start >= 0) {
      let expression

      res.push(content.substring(end, start)) // before
      start += 2
      end = content.indexOf('}}', start)

      if (end >= 0) {
        expression = new Expression(content.substring(start, end))
        end += 2
      } else {
        // without end
        res.push(content.substring(start - 2))
        end = content.length
      }

      if (expression) res.push(expression.parse())
      start = content.indexOf('{{', end)
    }

    res.push(content.substring(end)) // after

    return res.filter(item => !!item)
  },

  /**
   * 计算表达式
   */
  calcExpression(arr, data = {}) {
    if (!arr || typeof arr === 'string' || typeof arr === 'number' || typeof arr === 'boolean') {
      return arr
    } if (arr.length === 1 && typeof arr[0] === 'function') {
      return arr[0](data)
    }

    return arr.map(item => {
      if (typeof item === 'string') return item
      if (typeof item === 'function') return item(data)

      return ''
    }).join('')
  },
}
