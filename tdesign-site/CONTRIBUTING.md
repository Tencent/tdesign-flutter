---
title: 贡献指南
# description: 
spline: explain
---

## 项目地址
[TDesign-Flutter](https://github.com/Tencent/tdesign-flutter)

组件项目：tdesign-component

官网项目：tdesign-site

### 开发规范
- 组件命名规范：以TD为前缀，组件名称、API名称参考TDesign现有组件和API命名，可以根据flutter原生Widget的特点进行修改。组件API以满足设计要求和使用为准，可根据flutter特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯Dart代码规范。
- 对于系统原有组件，如Text,Image等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃TDesign控件。
- 示例页面尽量使用ExamplePage+ExampleModule+ExampleItem组合，按照示例稿的布局实现；页面写完后，在main.dart中修改exampleMap对应组件的isTodo属性即可。
- 组件API和演示代码，请参考`demo_tool/README.md`文件。
- 组件内部的固定文案,都应该抽离到TDResourceDelegate中统一管理,方便业务进行国际化适配

### 共建流程
- 拉取开发分支：建议将项目fork到自己github,每个组件从main分支拉取对应开发分支，命名为feature/组件名小写_下划线
- 实现组件：组件中的属性请尽量使用TDTheme提供的公共属性，使用方法参考'主题-颜色'页面
- 编写示例页：示例页请尽量使用ExamplePage+ExampleModule+ExampleItem组合，参考示例稿布局实现。
- 演示代码：每个组件示例，尽量将原子性代码提取成独立方法，并添加@Demo注解，方便生成演示代码。其中，@Demo注解的'group'参数需与ExamplePage的'exampleCodeGroup'参数一致。写法请参考'圆角-基础'页。
- flutter SDK: 如果可以，建议切换到flutter 3.16.9分支开发。
- API文档：API文档由工具统一生成，请尽量添加字段的详细注释，并将构造方法作为类名下的第一个方法，字段放在构造方法之下，具体写法请参考TDText。
- 代码规范：开发完成后，请检查'Dart Analysis'下的提示，尽量符合代码规范。
- 单元测试：添加未在示例稿中体现，但有必要验证的组件样式，请添加到ExamplePage的'test'参数中。
- 合并代码: 上述检查完成后，请发起pr，合并到dev分支，并同步项目组验收。

### 验收标准(暂定)
- 移动端示例页面展示(视觉验收)
- 实际使用展示(功能验收,暂不需处理)
- 代码规范(兼容指定的最低版本SDK)
- API验收

### Flutter基础知识
- Flutter基础介绍：https://book.flutterchina.club/chapter1/flutter_intro.html
- Dart语言介绍：https://book.flutterchina.club/chapter1/dart.html
- 搭建Flutter开发环境：https://book.flutterchina.club/chapter1/install_flutter.html
- 计数器应用示例：https://book.flutterchina.club/chapter2/first_flutter_app.html

## SDK依赖版本

dart: ">=3.2.6 <4.0.0"

flutter: ">=3.16.0"
