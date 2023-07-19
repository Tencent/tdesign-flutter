# Wechat Mini Program API Typings

> [中文版本](./README.md)

[![Published on DefinitelyTyped](https://img.shields.io/npm/v/@types/wechat-miniprogram?label=%40types)](https://www.npmjs.com/package/@types/wechat-miniprogram)
[![Published on NPM](https://img.shields.io/npm/v/miniprogram-api-typings.svg?style=flat)](https://www.npmjs.com/package/miniprogram-api-typings)
[![MIT License](https://img.shields.io/github/license/wechat-miniprogram/api-typings.svg)](https://github.com/wechat-miniprogram/api-typings)
[![GitHub Actions Test Status](https://github.com/wechat-miniprogram/api-typings/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/wechat-miniprogram/api-typings/actions/workflows/test.yml)

Type definitions for APIs of Wechat Mini Program in TypeScript

## Install

### By DefinitelyTyped

```bash
npm install @types/wechat-miniprogram
```

or:

### By standalone npm package

```bash
npm install miniprogram-api-typings
```

Manually import it after installed:

- `import 'miniprogram-api-typings';`

Or specify types in typescript config:

- Specify `types: ["miniprogram-api-typings"]` in `tsconfig.json`

Or reference by [Triple-Slash Directives](https://www.typescriptlang.org/docs/handbook/triple-slash-directives.html):

- `/// <reference path="node_modules/miniprogram-api-typings/index.d.ts" />`

## Changelog

See [CHANGELOG.md](https://github.com/wechat-miniprogram/api-typings/blob/master/CHANGELOG.md) (Chinese only)

## Contribution

Definitions of Wechat APIs (`lib.wx.api.d.ts`) are auto-generated together with our [documentations](https://developers.weixin.qq.com/miniprogram/en/dev/api/), therefore PRs including that file will __not__ be merged. If you found some APIs defined wrongly, create an issue instead.

Both PR and issue are welcomed for definitions of pages (`Page`), custom components (`Component`) and other else, since they are written manually. Help us improve this definition if you have any bug reports or suggestions! Thanks for contributing!

### Contributors

- [Baran](https://github.com/baranwang)
- [MinLiang Zeng](https://github.com/zenml/)
- [Garfield Lee](https://github.com/Garfield550)
- [Mr.Hope](https://github.com/Mister-Hope)
- [chs97](https://github.com/chs97)
- [Jelf](https://github.com/okxiaoliang4)
- [xieyuhang](https://github.com/haiya6)

### Automated tests

We use [`tsd`](https://github.com/SamVerschueren/tsd) to check if this definition is working properly. All test cases are under folder `test`.

To perform an automated test, clone this repo, `npm install --save-dev` and `npm test`.

If you have test case that fails the test, an issue or PR will be great. Strong test case that passes are also welcomed.
