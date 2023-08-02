
<p align="center">
  <a href="https://tdesign.tencent.com/" target="_blank">
    <img alt="TDesign Logo" width="200" src="https://tdesign.gtimg.com/site/TDesign.png">
  </a>
</p>

<p align="center">
  <a href="https://github.com/Tencent/tdesign-miniprogram/blob/develop/LICENSE">
    <img src="https://img.shields.io/npm/l/tdesign-miniprogram.svg?sanitize=true" alt="License">
  </a>
  <a href="https://www.npmjs.com/package/tdesign-miniprogram">
    <img src="https://img.shields.io/npm/v/tdesign-miniprogram.svg?sanitize=true" alt="Version">
  </a>
  <a href="https://www.npmjs.com/package/tdesign-miniprogram">
    <img src="https://img.shields.io/npm/dw/tdesign-miniprogram" alt="Downloads">
  </a>
</p>


[TDesign](https://github.com/Tencent/tdesign) 适配微信小程序的组件库。

## 预览

请下载App预览 ↓
<br/>

<img width="260" src="https://user-images.githubusercontent.com/7017290/146479952-b05298e8-f6ac-44a1-b73c-7abd8b9b3914.jpeg" />

## 使用组件

### yaml引入依赖

小程序已经支持使用 NPM 安装第三方包。

具体使用方式，可以参考小程序官网文档： [《NPM 支持》](https://developers.weixin.qq.com/miniprogram/dev/devtools/npm.html?search-key=npm)

```yaml
tdesign_flutter:
  git: https://github.com/TDesignOteam/tdesign-flutter.git
```

### 引入组件代码

以按钮组件为例，只需要在 `JSON` 文件中引入按钮对应的自定义组件即可

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 本地运行示例代码

- 进入 `site` 文件夹，安装`npm install` 安装依赖包 
- `cd ..` 回到 `tdesing-minprogram` 目录，运行命令 `npm run site:dev` ，本地运行小程序官方文档项目

## 基础库版本

最低基础库版本`^1.0.0`

## 开源协议

TDesign 遵循 [MIT 协议](https://github.com/Tencent/tdesign-miniprogram/LICENSE)。
