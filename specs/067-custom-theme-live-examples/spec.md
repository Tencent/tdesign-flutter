# 自定义主题指南运行示例

custom-theme指南的JSON配置、局部样式与明暗模式代码必须有对应Flutter Web效果，不能用Theme色板页替代配置演示。运行示例复用documentation_examples.dart内生成文档的函数，不维护第二份配置。

## 展示契约

站点复用组件页的td-doc-main、DEMO正文容器、td-doc-phone及iframe样式：左文档右手机，正文不另放独立iframe。指南保持现有目录与标题，不增加API/指南标签。右侧custom-theme路由以ExamplePage分组展示JSON配置、组件局部样式、明暗模式，与其他Demo保持相同页面结构。各章节提供独立场景链接。

展示当前品牌色、局部Tag对照及浅/深/系统模式切换。演示直接调用文档函数；固定配置与官网主题工具相互独立。不改变组件公共API、CI、版本与CHANGELOG，仅本地修改，不推送。
