---
title: 贡献指南
# description: 
spline: explain
---

## 1.项目地址
https://github.com/Tencent/tdesign-flutter

目录结构:
```text
tdesign-component/
├── demo_tool       // API和演示代码工具
├── examples        // 组件使用示例
├── lib             // 组件库
└── tests           // 组件测试

tdesign-site/       // tdesign flutter站点
```
## 2.如何运行
### 2.1 Flutter基础知识
- Flutter基础介绍：[https://book.flutterchina.club/chapter1/flutter_intro.html](https://book.flutterchina.club/chapter1/flutter_intro.html)
- Dart语言介绍：[https://book.flutterchina.club/chapter1/dart.html](https://book.flutterchina.club/chapter1/dart.html)
- 搭建Flutter开发环境：[https://book.flutterchina.club/chapter1/install_flutter.html](https://book.flutterchina.club/chapter1/install_flutter.html)
- 计数器应用示例：[https://book.flutterchina.club/chapter2/first_flutter_app.html](https://book.flutterchina.club/chapter2/first_flutter_app.html)

### 2.2 开发环境要求
flutter sdk 版本：3.16.9

（注: TD需要支持3.16.9~最新稳定版本，因此最好再3.16.9版本开发完成后，使用最新稳定版本确认能否正常运行）

### 2.3 克隆项目
```
// 克隆项目
git clone https://github.com/Tencent/tdesign-flutter.git
```


### 2.3 运行flutter项目
下面是命令行运行方法，正常也可以不使用命令行，而在IDE直接运行，推荐使用Android Studio进行开发。运行时请选择Android设备和iOS模拟器，不要直接在浏览器运行
```
// 运行flutter组件项目
cd tdesign-flutter/tdesign-component/

// 拉取依赖
flutter pub get

// 进入示例项目 需要把AOPMarket|enable 改为false,禁用aop才行
cd example/

// 运行项目，最好在运行前先确认设备已连接
flutter run
```

### 2.4 运行前端官网项目

```
// 进入官网前端项目
cd tdesign-flutter/tdesign-site/site/

// 安装依赖
npm install

// 回到tdesign-site目录
cd ..

// 运行项目
npm run site:dev
```
注：本地运行项目，右侧example未展示对应组件示例，是正常现象，该示例正式部署才会展示。
<br/>
<img width="260" src="https://tdesign.tencent.com/flutter/assets/contributing_example.png" />
<br/>
## 3.如何领取issue
### 3.1 一个issue的完整流程：
- 用户发现功能不满足，查看API文档确认不支持，然后提issue。[常见问题](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-site/FAQ.md)
- 提了issue后，在群里发出issue链接，方便后续直接沟通，确认详细需求。然后将最终确认结果贴到github的issue上。
- 负责人评估开发工作量，打`help want`和`issueShoot`标签。
- 贡献者确认要领取，在issue下评论领取，并通知负责人。负责人打上Received标签,讨论确认实现方案.
- 贡献者参考开发规范开发完功能，按照文档自检，然后提pr，并同步负责人验收。
- pr自动构建测试包。【自动构建流水线】
- 负责人拉设计一起视觉走查（如果需要的话），走查完成后，合并pr。issue打上下一个版本的标签。
- 版本发布后，issue关闭。


### 3.2 标签管理
- 无标签：未评估
- issueShoot: 已评工作量，可领取
- Received:已领取
- pre_x.x.x：预计某个版本发布
- x.x.x: 某个版本已发布

## 4.开发规范
- 组件命名规范：以TD为前缀，组件名称、API名称参考TDesign现有组件和API命名，可以根据flutter原生Widget的特点进行修改。组件API以满足设计要求和使用为准，可根据flutter特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯Dart代码规范。
- 对于系统原有组件，如Text,Image等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃TDesign控件。
- 示例页面尽量使用ExamplePage+ExampleModule+ExampleItem组合，按照示例稿的布局实现；页面写完后，在main.dart中修改exampleMap对应组件的isTodo属性即可。
- 组件API和演示代码，请参考demo_tool/README.md文件。
- 组件内部的固定文案,都应该抽离到TDResourceDelegate中统一管理,方便业务进行国际化适配
- 如果使用的组件TD有封装，尽量使用TD已有组件，而非直接使用系统组件


## 5.验收标准
### 5.1 pr规则
- pr目标分支为develop分支，请勿直接往main分支合并
- 标题格式：`组件类名`: 修改描述（示例：`TDUpload`: 新增Upload组件；`TDBottomTabBar`: 修复iconText模式，底部溢出2.5像素）
- 勾选规则：
  > 1.只要有新增参数，就勾选”新特性提交“
  > 
  > 2.只修改内部bug，未新增参数，才勾选”日常 bug 修复“
  > 
  > 3.其他选项视具体改动判断
- ”相关issue“处带上修复的issue链接
- 其他内容视情况可选填


### 5.2 代码review自检【欢迎大家补充】
- 尽量使用TD已有组件，而非系统组件。比如有直接使用Text组件的，请换成TDText组件。
- 检测边界条件，比如参数为null是否会导致代码异常？
- 是否提供验收用例？用例是否ExamplePage放在test字段里？
- 是否提供完善文档？

### 5.3 文档自检
#### 5.3.1 API 文档：
- tdesign-component/demo_tool/all_build.sh文件中是否包含对应组件API的脚本，若未包含，请参考tdesign-component/demo_tool/README.md及其他组件示例添加脚本。请确保提交的all_build.sh中触发的是./bin/api_tool_linux，因为github自动打包的环境是linux系统
- 检测组件属性的注释是否完善
- 如果组件有对应的系统组件，检测是否有系统组件支持的参数TD组件不支持
- 检测组件与https://tdesign.tencent.com/mobile-vue/overview 是否有含义相同但命名不同的组件，如果有，尽量保持命名一致。
- tdesign-component/demo_tool/all_build.sh中的名字与tdesign-component/example/lib/config.dart的名字需保持一致
<br/>
<img width="720" src="https://tdesign.tencent.com/flutter/assets/contributing_api_name.png" />
<br/>


#### 5.3.2 新增组件：
- tdesign-site/site/site.config.mjs
  > 菜单栏是否放开了注释？如果没有被注释组件，则参考其他组件添加。
  > 
  > name与tdesign-component/example/lib/config.dart的ExamplePageModel的name参数是否一致

<br/>
<img width="720" src="https://tdesign.tencent.com/flutter/assets/contributing_component_name.png" />
<br/>
- tdesign-site/site/docs/overview.md：检查组件预览是否已添加、分组组件数量是否正确
<br/>
<img width="720" src="https://tdesign.tencent.com/flutter/assets/contributing_overview.png" />
<br/>


### 5.4 demo自测
提交pr后，会触发流水线自动打包。打包完成会添加评论如下：
<br/>
<img width="720" src="https://tdesign.tencent.com/flutter/assets/contributing_apk.png" />
<br/>
点击”体验apk“后面链接，即可跳转打包完成的apk下载地址，可以安装自测。
注：该demo是基于Flutter 3.16.9打包的。请留意最新Flutter版本的包是否打包成功；如果评论打包失败，请检测失败原因。

#### 自测内容：
- 组件改动后，整体是否有明显的布局溢出等展示异常
- 新增功能是否在”单元测试“栏目下？（需把示例放在ExamplePage的test字段里）
- 验证功能是否符合预期
- 点击右上角”i“图标，查看API文档是否正确。（若不正确，检测all_build.sh是否配置了对应组件的脚本）
- 点击右上角"</>"图标，检测示例代码是否生成。（若未生成，参考其他有生成的模块修改）
- 如涉及视觉改动，请联系负责人拉取设计同学进行视觉走查
- 英文环境、切换主题后是否展示正常

### 5.5视觉走查
pr打包完成后，通知负责人拉设计同学进群，将pr链接发到群里。设计同学根据“设计走查流水线地址”的链接，替换内网域名后，下载ipa包进行走查。

## 6.合并pr
issue验收完成后，由负责人合并pr，并将issue的标签改为pre_x.x.x
