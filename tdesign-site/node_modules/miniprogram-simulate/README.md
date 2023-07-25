# miniprogram-simulate

[![](https://img.shields.io/npm/v/miniprogram-simulate.svg?style=flat)](https://www.npmjs.com/package/miniprogram-simulate)
[![](https://github.com/wechat-miniprogram/miniprogram-simulate/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/wechat-miniprogram/miniprogram-simulate/actions/workflows/ci.yml?query=branch%3Amaster+)
[![](https://img.shields.io/github/license/wechat-miniprogram/miniprogram-simulate.svg)](https://github.com/wechat-miniprogram/miniprogram-simulate/blob/master/LICENSE)
[![](https://img.shields.io/codecov/c/github/wechat-miniprogram/miniprogram-simulate.svg)](https://app.codecov.io/gh/wechat-miniprogram/miniprogram-simulate)

## 介绍

小程序自定义组件测试工具集。

目前因为小程序独特的运行环境，所以对于小程序自定义组件的单元测试一直没有比较优雅的解决方案，此工具集就是为了解决此痛点而诞生的。将原本小程序自定义组件双线程分离运行的机制调整成单线程模拟运行，利用 dom 环境进行渲染，借此来完成整个自定义组件树的搭建。

运行此工具集需要依赖 js 运行环境和 dom 环境，因此可以采用 jsdom + nodejs（如 jest），也可以采用真实浏览器环境（如 karma）。文档[使用简介](./docs/tutorial.md)中会提供简单的使用方式介绍。

## 安装

```
npm install --save-dev miniprogram-simulate
```

## 使用

```js
const simulate = require('miniprogram-simulate')

test('test sth', () => {
    const id = simulate.load('/components/comp/index') // 加载自定义组件
    const comp = simulate.render(id) // 渲染自定义组件
    
    // 使用自定义组件封装实例 comp 对象来进行各种单元测试
})
```

以上只是一个简单的例子，实际上这个工具集必须搭配 jest 或 jsdom/mocha 等测试框架来使用，更为详细的使用细节请参阅下述文档：

* [使用简介](./docs/tutorial.md)
* [接口文档](./docs/api.md)
* [细节实现](./docs/detail.md)
* [暂不支持特性](./docs/todo.md)
* [更新日志](./docs/update.md)

## 协议

[MIT](./LICENSE)
