# gulp-mp-npm

[![npm](https://img.shields.io/npm/v/gulp-mp-npm)](https://www.npmjs.com/package/gulp-mp-npm)
[![download](https://img.shields.io/npm/dt/gulp-mp-npm)](https://www.npmjs.com/package/gulp-mp-npm)
![test](https://github.com/mcc108/gulp-mp-npm/workflows/Test/badge.svg)
[![codecov](https://img.shields.io/codecov/c/github/mcc108/gulp-mp-npm)](https://codecov.io/gh/mcc108/gulp-mp-npm)

> 用以微信小程序提取 npm 依赖包的 gulp 插件

## 安装

```
$ npm i -D gulp-mp-npm
```

## 快速开始

根据实际项目需求在 `gulpfile.js` 中进行如下配置：

### 如果项目以 `wxss` `js` `json` 等文件开发

```js
const gulp = require('gulp');
const mpNpm = require('gulp-mp-npm')

/** `gulp npm`
 * 提取npm
 * */
const ts = () => gulp.src('src/**')
    .pipe(mpNpm())
    .pipe(gulp.dest('dist'));
```

### 如果项目需要编译 `ts` `less` 等文件

```js
const gulp = require('gulp');
const gulpTs = require('gulp-typescript');
const gulpLess = require('gulp-less');
const rename = require('gulp-rename');
const mpNpm = require('gulp-mp-npm');
const tsProject = gulpTs.createProject('tsconfig.json');

/** `gulp ts`
 * 编译ts
 * */
const ts = () => gulp.src('src/**/*.ts')
    .pipe(tsProject()) // 编译ts
    .pipe(mpNpm()) // 分析提取 ts 中用到的依赖
    .pipe(gulp.dest('dist'));

/** `gulp js`
 * 解析js
 * */
const js = () => gulp.src('src/**/*.js')
    .pipe(mpNpm()) // 分析提取 js 中用到的依赖
    .pipe(gulp.dest('dist'));

/** `gulp json`
 * 解析json
 * */
const json = () => gulp.src('src/**/*.json')
    .pipe(mpNpm()) // 分析 usingComponents 字段提取 npm 组件
    .pipe(gulp.dest('dist'));

/** `gulp less`
 * 编译less
 * */
const less = () => gulp.src('src/**/*.less')
    .pipe(gulpLess()) // 编译less
    .pipe(rename({ extname: '.wxss' }))
    .pipe(mpNpm()) // 分析提取 less 中用到的依赖
    .pipe(gulp.dest('dist'));

/** `gulp wxss`
 * 解析wxss
 * */
const wxss = () => gulp.src('src/**/*.wxss')
    .pipe(mpNpm()) // 分析依赖
    .pipe(gulp.dest('dist'));
```

详细用例可见 [test](./test) 文件夹

项目实战配置可参照 [微信小程序 gulpfile 最佳实践](https://github.com/mcc108/mp-gulpfile)

## API

### mpNpm(options)

`Stream` 输入原文件，输出依赖文件与修改后的原文件

#### options.npmDirname

类型: `String`\
默认值: `'miniprogram_npm'`

指定 `npm` 输出文件夹，默认为官方方案。\
小程序基础库版本 `2.2.1` 及以上**推荐使用官方方案**，即不设置该值。如果自定义输出，将会修改所有原文件中引入依赖路径的代码

#### options.fullExtract

类型: `Array`\
默认值: `[]`

默认情况插件只会按需提取的依赖与组件，可通过该属性指定包名对整个包进行完整提取，主要用于提取分析不到的依赖。\
1、支持使用包名，即使未使用到也会被全量提取 ，例如`options.fullExtract = ['weui-miniprogram']`

2、支持使用glob表达式来精准匹配目录或文件，例如`options.fullExtract = ['npm/**/*.wxs']`，参见[node-glob](https://github.com/isaacs/node-glob)

#### options.useGlobalCache

类型: `Boolean`\
默认值: `false`

默认情况下，对于较复杂的项目会根据不同文件类型，创建多个mpNpm实例：

1、x个实例就会重复执行x次fullExtract插件的逻辑

2、gulp.watch时，任何一个文件变更都会触发fullExtract

3、extracted解析标记在实例结束后会清理，watch文件时，每次文件变更会重新解析，耗时较长

例如设置 `options.useGlobalCache = true` 表示多个实例共享初始化和依赖解析缓存，会大幅提高watch时的性能。建议大量页面使用npm包的项目开启。

## 特点

- 依赖分析，仅会提取使用到的依赖与组件
- 支持提取普通 `npm` 包与小程序专用 `npm` 包
- 不会对依赖进行编译与打包（交给微信开发者工具或者其他 `gulp` 插件完成）
- 兼容[官方方案](https://developers.weixin.qq.com/miniprogram/dev/devtools/npm.html)及原理，同时支持自定义 npm 输出文件夹

## 方案

### 官方原理

在小程序[官方方案](https://developers.weixin.qq.com/miniprogram/dev/devtools/npm.html)文档中可以找到了对原理的介绍：

> 1、首先 node_modules 目录不会参与编译、上传和打包中，所以小程序想要使用 npm 包必须走一遍“构建 npm”的过程，在最外层的 node_modules 的同级目录下会生成一个 miniprogram_npm 目录，里面会存放构建打包后的 npm 包，也就是小程序真正使用的 npm 包。
>
> 2、构建打包分为两种：小程序 npm 包会直接拷贝构建文件生成目录下的所有文件到 miniprogram_npm 中；其他 npm 包则会从入口 js 文件开始走一遍依赖分析和打包过程（类似 webpack）。
>
> 3、寻找 npm 包的过程和 npm 的实现类似，从依赖 npm 包的文件所在目录开始逐层往外找，直到找到可用的 npm 包或是小程序根目录为止。

> 使用 npm 包时如果只引入包名，则默认寻找包名下的 index.js 文件或者 index 组件

### 插件方案

![方案](docs/gulp-mp-npm.png)

整个插件是一个 `Stream` 流管道，其中包含了 `4` 个子流：

- `init` 初始化
- `extractComps` 提取小程序组件依赖
- `extractDeps` 提取普通依赖
- `adjust` 调整输出


### License

MIT
