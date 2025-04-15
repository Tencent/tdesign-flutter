# CONTRIBUTING

## 目录结构

```text
tdesign-component/
├── demo_tool       // API和演示代码
├── examples        // 组件使用示例
├── lib             // 组件库
└── tests           // 组件测试

tdesign-site/       // tdesign flutter站点
```

## 开发规范

- 组件命名规范：以TD为前缀，组件名称、API名称参考TDesign现有组件和API命名，可以根据flutter原生Widget的特点进行修改。组件API以满足设计要求和使用为准，可根据flutter特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯Dart代码规范。
- 对于系统原有组件，如Text,Image等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃TDesign控件。
- 示例页面尽量使用ExamplePage+ExampleModule+ExampleItem组合，按照示例稿的布局实现；页面写完后，在main.dart中修改exampleMap对应组件的isTodo属性即可。
- 组件API和演示代码，请参考demo_tool/README.md文件。
- 组件内部的固定文案,都应该抽离到TDResourceDelegate中统一管理,方便业务进行国际化适配
- 如果使用的组件TD有封装，尽量使用TD已有组件，而非直接使用系统组件

## 更多
更多内容请参考:[贡献指南](https://tdesign.tencent.com/flutter/develop)