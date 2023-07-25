# miniprogram-compiler

## 介绍

这是 wcc、wcsc 官方编译器的 node 封装版，用于编译 wxml、wxss 文件。

## 快速上手

### 安装

```
npm install miniprogram-compiler
```

### 使用

编译 wxml：

```js
const {wxmlToJs} = require('miniprogram-compiler')

const compilerString = wxmlToJs(miniprogramProjectRoot)
const compiler = new Function('global', compilerString)
const $gwx = compiler({})

// 假设项目里有 wxml/index.wxml 文件
const generateFunc = $gwx('wxml/index.wxml')
const compilerRes = generateFunc({
    // 数据
})

console.log(compilerRes)
```

编译 wxss：

```js
const {wxssToJs} = require('miniprogram-compiler')

const compilerString = wxssToJs(miniprogramProjectRoot)
const compiler = new Function('global', compilerString)
const $gwx = compiler({})

// 假设项目里有 wxss/index.wxss 文件
const generateFunc = $gwx('wxss/index.wxss')
generateFunc('前缀') // 会插入到 style 中
```
