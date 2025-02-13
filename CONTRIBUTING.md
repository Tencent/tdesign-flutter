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

- 组件命名规范：以`TD`为前缀，组件名称、`API`名称参考`TDesign`现有组件和`API`命名，可以根据`flutter`原生`Widget`的特点进行修改。组件`API`以满足设计要求和使用为准，可根据`flutter`特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯`Dart`代码规范。
- 对于系统原有组件，如`Text`,`Image`等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃`TDesign`控件。
- 示例页面尽量使用`ExamplePage+ExampleModule+ExampleItem`组合，按照示例稿的布局实现；页面写完后，在`main.dart`中修改`exampleMap`对应组件的`isTodo`属性即可。
- 组件`API`和演示代码，请参考[demo_tool](tdesign-component/demo_tool/README.md)文件。
- 组件内部的固定文案,都应该抽离到`TDResourceDelegate`中统一管理,方便业务进行国际化适配