# expr-parser

[![](https://img.shields.io/npm/v/expr-parser.svg?style=flat)](https://www.npmjs.org/package/expr-parser)
[![](https://img.shields.io/travis/JuneAndGreen/expr-parser.svg)](https://github.com/JuneAndGreen/expr-parser)
[![](https://img.shields.io/npm/l/expr-parser.svg)](https://github.com/JuneAndGreen/expr-parser)
[![](https://img.shields.io/coveralls/github/JuneAndGreen/expr-parser.svg)](https://github.com/JuneAndGreen/expr-parser)

## 简介

一个方便好用的 js 表达式解析器

## 安装

```bash
npm install --save expr-parser
```

## 使用

```
const Expression = require('expr-parser');

const exprCalc = new Expression('a.value + 12 - (2 * 14 / 4)').parse();

console.log(exprCalc({
    a: {
        value: 3 
    },
})); // 传入数据，输出计算结果 8
```

> 更多用法请参考[测试用例](./test.js)。

## 协议

MIT
