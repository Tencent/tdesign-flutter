# Button / NavBar 文字槽统一

Button.child 与 NavBar.title 通过现有 TTextStyleScope 同时向 Text/TText 提供组件拥有的文字默认样式。不新增配置，不改 TText/Resolve/Scope 全局实现，不改 Button 已有尺寸/配色/状态解析、点击行为或 Material 主题恢复。

Button 使用内容实际上下文中已解析的 DefaultTextStyle（含状态及动画），避免复制状态解析；原生 Text 应保持外观。NavBar 使用已有标题样式与单行省略规则。作用域仅覆盖 child/title，不扩展到 icon、leading/actions、背景/前景装饰构建器。

实例 style/font 字段继续按既有 TText 链优先，更近的内容局部 TD 主题可覆盖。外层 TD 文字主题的重叠字段由组件槽样式覆盖，未重叠字段与段落配置应保留。复合内容子树中的 TText 同享默认，内部可显式分层。

这是默认行为兼容性变化（breaking），不是无感重构：旧无样式/部分样式 TText 的字体、颜色与布局可能改变。迁移可使用现有 TText.style/font 或内部局部 TTextThemeData 明确原外观，不新增兼容开关。源码 dartdoc 与正式生成 API 同步。本分支只包含 Button/NavBar 的默认行为调整、必要回归及文档；不包含此前其他组件文字槽修复或 CI 优化。

验收：Flutter 3.32.0 / 3.47.7 严格分析、两组件完整非视觉回归与95%覆盖率、受影响Demo与文字契约通过；Linux3.32既有Golden只比较并如实记录，固定环境前后截图比较，不更新基线。用户已授权将本增量单独提交、推送并创建PR，不包含其他组件修复或CI优化。

## 用户理解规则

普通位置用正文默认值，组件文字槽用组件默认值，自己明确设置的样式优先。全局 TTextThemeData 是子树默认值，不是强制覆盖；全局字体族、正文/按钮文案/标题的规格分别由 TD 语义 Token 表达。组件覆盖外层默认中重复的字段，未重复字段继续保留；内容内部更近的 TD 文字主题可局部覆盖。

不得把本次仅两组件统一描述为全库所有 Widget 槽位都已统一；完整自定义区域仍由调用方管理。TText.rich 根样式遵循同一默认链，span 继续遵循 Flutter 富文本显式覆盖规则。TextStyle(inherit:false) 保留已有整体替换语义；“显式字段覆盖”描述的是正常合并，不抹去该例外。
