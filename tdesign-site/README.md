
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


[TDesign](https://github.com/Tencent/tdesign) 适配Flutter的组件库。

## 预览

<br/>
Android请扫码下载预览 ↓
<br/>
<img width="260" src="site/public/assets/qrcode/td_apk_qrcode.png" />
<br/>
iOS请运行项目预览 ↓
<br/>
https://github.com/TDesignOteam/tdesign-flutter/tree/main/tdesign-component

## 使用组件

### yaml引入依赖

```yaml
    dependencies:
      tdesign_flutter:
        git: https://github.com/TDesignOteam/tdesign-flutter.git
```
或者：
```yaml
    dependencies:
      tdesign_flutter:
        hosted:
          name: tdesign_flutter
          url: http://pub.xxxx（公司内网pub库）
          version: ^0.0.3
```


### 引入组件代码

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 本地运行官网示例代码

- 进入 `site` 文件夹，安装`npm install` 安装依赖包 
- `cd ..` 回到 `tdesing-site` 目录，运行命令 `npm run site:dev` 

## 基础库版本

最低基础库版本`^0.0.3`

## 开源协议

TDesign 遵循 [MIT 协议](https://github.com/Tencent/tdesign-miniprogram/LICENSE)。
