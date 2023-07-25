# 微信小程序定义文件

> [English version](./README-en.md)

[![已在 DefinitelyTyped 发布](https://img.shields.io/npm/v/@types/wechat-miniprogram?label=%40types)](https://www.npmjs.com/package/@types/wechat-miniprogram)
[![已在 NPM 发布](https://img.shields.io/npm/v/miniprogram-api-typings.svg?style=flat)](https://www.npmjs.com/package/miniprogram-api-typings)
[![MIT 协议](https://img.shields.io/github/license/wechat-miniprogram/api-typings.svg)](https://github.com/wechat-miniprogram/api-typings)
[![GitHub Actions 测试状况](https://github.com/wechat-miniprogram/api-typings/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/wechat-miniprogram/api-typings/actions/workflows/test.yml)

微信小程序 API 的 TypeScript 类型定义文件

## 安装

### 通过 DefinitelyTyped

```bash
npm install @types/wechat-miniprogram
```

或：

### 通过独立 npm 包

```bash
npm install miniprogram-api-typings
```

安装后手动导入：

- `import 'miniprogram-api-typings';`

或者在 ts 配置中指定：

- 在 `tsconfig.json` 中指定 `types: ["miniprogram-api-typings"]`

或者通过 [三斜杠指令](https://www.tslang.cn/docs/handbook/triple-slash-directives.html) 引用：

- `/// <reference path="node_modules/miniprogram-api-typings/index.d.ts" />`

## 更新日志

参考 [CHANGELOG.md](https://github.com/wechat-miniprogram/api-typings/blob/master/CHANGELOG.md)

## 贡献

API 的定义文件（`lib.wx.api.d.ts`）是随 [文档](https://developers.weixin.qq.com/miniprogram/dev/api/) 一起自动生成的，如果发现了 API 接口的定义错误，请提一个 issue 给我们，关于 API 的 PR 将 __不会__ 被接受。

如果有针对页面（`Page`）、自定义组件（`Component`）等接口的 bug 和建议，欢迎 PR 或提一个 issue 给我们。非常感谢！

### 贡献者

- [Baran](https://github.com/baranwang)
- [MinLiang Zeng](https://github.com/zenml/)
- [Garfield Lee](https://github.com/Garfield550)
- [Mr.Hope](https://github.com/Mister-Hope)
- [chs97](https://github.com/chs97)
- [Jelf](https://github.com/okxiaoliang4)
- [xieyuhang](https://github.com/haiya6)

### 测试

本定义文件使用 [`tsd`](https://github.com/SamVerschueren/tsd) 进行测试，所有的测试样例放在 `test` 目录下。

想执行测试的话，克隆本项目并完成 `npm install --save-dev` 后执行 `npm test` 即可。

如果您发现了不能通过自动化测试的测试样例，可以提交 PR 或者提一个 issue。当然，能通过自动化测试的强有力的测试样例也是欢迎的。
