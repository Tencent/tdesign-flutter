---
title: 贡献指南
description: TDesign Flutter 贡献指南
spline: explain
---


## 1. 项目地址

<https://github.com/Tencent/tdesign-flutter>

### 目录结构

```txt
tdesign-component/
├── demo_tool       // API 和演示代码工具
├── examples        // 组件使用示例
├── lib             // 组件库
└── tests           // 组件测试

tdesign-site/       // TDesign Flutter 站点

tdesign-adaptation/ // TDesign Flutter 版本适配仓库
```

## 2. 如何运行

### 2.1 Flutter 基础知识

- Flutter 基础介绍：[https://book.flutterchina.club/chapter1/flutter_intro.html](https://book.flutterchina.club/chapter1/flutter_intro.html)
- Dart 语言介绍：[https://book.flutterchina.club/chapter1/dart.html](https://book.flutterchina.club/chapter1/dart.html)
- 搭建 Flutter 开发环境：[https://book.flutterchina.club/chapter1/install_flutter.html](https://book.flutterchina.club/chapter1/install_flutter.html)
- 计数器应用示例：[https://book.flutterchina.club/chapter2/first_flutter_app.html](https://book.flutterchina.club/chapter2/first_flutter_app.html)

### 2.2 开发环境要求

Flutter SDK 版本： >= 3.16.9

**注意：** TD 需要支持 3.16.9 ~ 最新稳定版本，因此最好在 3.16.9 版本开发完成后，使用最新稳定版本确认能否正常运行。如果版本无法兼容，请将不兼容文件移至 `tdesign-adaptation`，做兼容处理。

### 2.3 克隆项目

```bash
# 克隆项目
git clone <https://github.com/Tencent/tdesign-flutter.git>
```

### 2.4 运行 Flutter 项目

下面是命令行运行方法，正常也可以不使用命令行，而在 IDE 直接运行，推荐使用 Android Studio 进行开发。运行时请选择 Android 设备和 iOS 模拟器，不要直接在浏览器运行。

**注意：** 首次开发请先运行 `tdesign-flutter/tdesign-component/init.sh` 脚本，它会根据当前 Flutter 版本，选择适合的 `tdesign-adaptation` 依赖。

```bash
# 运行 Flutter 组件项目
cd tdesign-flutter/tdesign-component/

# 拉取依赖
flutter pub get

# 进入示例项目，需要把 AOPMarket|enable 改为 false，禁用 AOP 才行
cd example/

# 运行项目，最好在运行前先确认设备已连接
flutter run
```

### 2.5 Flutter 多版本兼容

在 Flutter 3.32 版本，SDK 代码变更较大，同一代码可能无法同时支持跨版本运行，因此抽离了 `tdesign-adaptation` 库，用于进行不同 Flutter 版本之间的代码适配。

#### 2.5.1 版本切换

首次运行，可以先将 Flutter SDK 切到 3.16.9 版本，执行 `tdesign-component/init.sh` 脚本，配置对应依赖。

开发完成，切换至最新稳定版尝试运行，如果有不兼容代码，需要在 `tdesign-adaptation` 库进行适配。

其中，高于 3.32 版本的代码，请在 `feature/3.32_adaptation` 分支开发，低于 3.32 版本的代码，请在 `feature/3.16_adaptation` 分支开发。

本地开发 `tdesign-adaptation`，可以修改 `tdesign-component/pubspec_overrides.yaml` 和 `tdesign-component/example/pubspec_overrides.yaml` 文件，使用本地依赖，内容如下：

```yaml
dependency_overrides:
  tdesign_adaptation:
    path: ../tdesign-adaptation  # 本地相对路径
```

但是，提交 Git 时，请不要将 `pubspec_overrides.yaml` 提交到仓库！！！

#### 2.5.2 国际化适配

由于 3.32 版本的国际化功能与 3.16 版本差异比较大，代码生成位置发生变更，无法跨版本兼容。因此，国际化资源代码改为手动依赖方式。如果需要修改字段内容，需要把生成的 `app_localizations(_en、_zh).dart` 文件拷贝到 `example/lib/localizations` 目录。

### 2.6 运行前端官网项目

```bash
# 进入官网前端项目
cd tdesign-flutter/tdesign-site/site/

# 安装依赖
npm install

# 回到 tdesign-site 目录
cd ..

# 运行项目
npm run site:dev
```

**注意：** 本地运行项目，右侧 example 未展示对应组件示例，是正常现象，该示例正式部署才会展示。

![贡献示例](https://tdesign.tencent.com/flutter/assets/contributing_example.png)

## 3. 如何领取 Issue

### 3.1 一个 Issue 的完整流程

- 用户发现功能不满足，查看 API 文档确认不支持，然后提 Issue。[常见问题](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-site/FAQ.md)
- 提了 Issue 后，在群里发出 Issue 链接，方便后续直接沟通，确认详细需求。然后将最终确认结果贴到 GitHub 的 Issue 上。
- 负责人评估开发工作量，打 `help want` 和 `issueShoot` 标签。
- 贡献者确认要领取，在 Issue 下评论领取，并通知负责人。负责人打上 `Received` 标签，讨论确认实现方案。
- 贡献者参考开发规范开发完功能，按照文档自检，然后提 PR，并同步负责人验收。
- PR 自动构建测试包。【自动构建流水线】
- 负责人拉设计一起视觉走查（如果需要的话），走查完成后，合并 PR。Issue 打上下一个版本的标签。
- 版本发布后，Issue 关闭。

### 3.2 标签管理

- 无标签：未评估
- `issueShoot`：已评工作量，可领取
- `Received`：已领取
- `pre_x.x.x`：预计某个版本发布
- `x.x.x`：某个版本已发布

## 4. 开发规范

- 组件命名规范：以 `TD` 为前缀，组件名称、API 名称参考 TDesign 现有组件和 API 命名，可以根据 Flutter 原生 Widget 的特点进行修改。组件 API 以满足设计要求和使用为准，可根据 Flutter 特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯 Dart 代码规范。
- 对于系统原有组件，如 `Text`、`Image` 等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃 TDesign 控件。
- 示例页面尽量使用 `ExamplePage` + `ExampleModule` + `ExampleItem` 组合，按照示例稿的布局实现；页面写完后，在 `main.dart` 中修改 `exampleMap` 对应组件的 `isTodo` 属性即可。
- 组件 API 和演示代码，请参考 `demo_tool/README.md` 文件。
- 组件内部的固定文案，都应该抽离到 `TDResourceDelegate` 中统一管理，方便业务进行国际化适配。
- 如果使用的组件 TD 有封装，尽量使用 TD 已有组件，而非直接使用系统组件。

## 5. 验收标准

### 5.1 PR 规则

- PR 目标分支为 `develop` 分支，请勿直接往 `main` 分支合并。
- 标题格式：`组件类名`: 修改描述（示例：`TDUpload`: 新增 Upload 组件；`TDBottomTabBar`: 修复 iconText 模式，底部溢出 2.5 像素）。
- 勾选规则：
  > 1. 只要有新增参数，就勾选"新特性提交"。
  >
  > 2. 只修改内部 bug，未新增参数，才勾选"日常 bug 修复"。
  >
  > 3. 其他选项视具体改动判断。
- "相关 Issue" 处带上修复的 Issue 链接。
- 其他内容视情况可选填。

### 5.2 代码 Review 自检【欢迎大家补充】

- 尽量使用 TD 已有组件，而非系统组件。比如有直接使用 `Text` 组件的，请换成 `TDText` 组件。
- 检测边界条件，比如参数为 `null` 是否会导致代码异常？
- 是否提供验收用例？用例是否 `ExamplePage` 放在 `test` 字段里？
- 是否提供完善文档？

### 5.3 文档自检

#### 5.3.1 API 文档

- `tdesign-component/demo_tool/all_build.sh` 文件中是否包含对应组件 API 的脚本，若未包含，请参考 `tdesign-component/demo_tool/README.md` 及其他组件示例添加脚本。请确保提交的 `all_build.sh` 中触发的是 `./bin/api_tool_linux`，因为 GitHub 自动打包的环境是 Linux 系统。
- 检测组件属性的注释是否完善。
- 如果组件有对应的系统组件，检测是否有系统组件支持的参数 TD 组件不支持。
- 检测组件与 [https://tdesign.tencent.com/mobile-vue/overview](https://tdesign.tencent.com/mobile-vue/overview) 是否有含义相同但命名不同的组件，如果有，尽量保持命名一致。
- `tdesign-component/demo_tool/all_build.sh` 中的名字与 `tdesign-component/example/lib/config.dart` 的名字需保持一致。

![API 名称示例](https://tdesign.tencent.com/flutter/assets/contributing_api_name.png)

#### 5.3.2 新增组件

- `tdesign-site/site/site.config.mjs`
  > 菜单栏是否放开了注释？如果没有被注释组件，则参考其他组件添加。
  > `name` 与 `tdesign-component/example/lib/config.dart` 的 `ExamplePageModel` 的 `name` 参数是否一致。

![组件名称示例](https://tdesign.tencent.com/flutter/assets/contributing_component_name.png)

- `tdesign-site/site/docs/overview.md`：检查组件预览是否已添加、分组组件数量是否正确。

![概览示例](https://tdesign.tencent.com/flutter/assets/contributing_overview.png)

### 5.4 Demo 自测

提交 PR 后，会触发流水线自动打包。打包完成会添加评论如下：

![APK 示例](https://tdesign.tencent.com/flutter/assets/contributing_apk.png)

点击"体验 apk" 后面链接，即可跳转打包完成的 apk 下载地址，可以安装自测。

**注意：** 该 demo 是基于 Flutter 3.16.9 打包的。请留意最新 Flutter 版本的包是否打包成功；如果评论打包失败，请检测失败原因。

#### 自测内容

- 组件改动后，整体是否有明显的布局溢出等展示异常。
- 新增功能是否在"单元测试"栏目下？（需把示例放在 `ExamplePage` 的 `test` 字段里）。
- 验证功能是否符合预期。
- 点击右上角"i"图标，查看 API 文档是否正确。（若不正确，检测 `all_build.sh` 是否配置了对应组件的脚本）。
- 点击右上角"</>"图标，检测示例代码是否生成。（若未生成，参考其他有生成的模块修改）。
- 如涉及视觉改动，请联系负责人拉取设计同学进行视觉走查。
- 英文环境、切换主题后是否展示正常。

### 5.5 视觉走查

PR 打包完成后，通知负责人拉设计同学进群，将 PR 链接发到群里。设计同学根据"设计走查流水线地址"的链接，替换内网域名后，下载 ipa 包进行走查。

## 6. 合并 PR

Issue 验收完成后，由负责人合并 PR，并将 Issue 的标签改为 `pre_x.x.x`。
