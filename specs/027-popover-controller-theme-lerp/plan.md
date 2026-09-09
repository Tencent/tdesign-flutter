# 实施方案

## 技术方案

设计分层参考 Flutter Material 3 的
[`MenuAnchor`](https://api.flutter.dev/flutter/material/MenuAnchor-class.html) 与
[`MenuController`](https://api.flutter.dev/flutter/widgets/MenuController-class.html)：
Widget 拥有锚点、内容和视觉配置，Controller 只拥有命令与状态查询。

新增 `TPopoverAnchor` 作为声明式配置和锚点生命周期所有者，新增
`TPopoverController` 作为命令与状态查询入口。Controller 公开 `open()`、
`close()` 和 `isOpen`，不承载 content、placement 或 theme 配置。

`TPopover.showPopover` 的公开签名保持不变。两种入口共用私有 Overlay session，
保证外部点击、滚动、系统返回和锚点卸载的清理语义一致。Anchor 通过
builder 提供当前 Controller，并在触发区域与 Overlay 内容子树提供
`TPopoverController.maybeOf(context)` 查找能力。

Theme 插值增加 nullable 字段辅助函数：仅在两侧均显式时调用连续插值器；
任一侧为空时按 `t < 0.5` 离散保留对应值。这样 `null` 始终保持“交还给
运行时 fallback”的语义。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/popover/` | 新增 Controller 并修复 Theme lerp |
| Demo | `example/lib/page/t_popover_page.dart` | 操作菜单选择后主动关闭 |
| 测试 | Popover 组件与 Demo 测试 | 覆盖控制器和插值调用流 |
| 文档 | dartdoc、Spec、生成 API/片段 | 记录新增用法 |

## API 变化

- 新增 `TPopoverAnchor`、`TPopoverAnchorBuilder` 和 `TPopoverController`。
- Controller 提供 `bool get isOpen`、`void open()`、`void close()` 和
  `TPopoverController.maybeOf(context)`。
- `TPopover.showPopover` 签名与返回类型不变。
- 无删除、改名、默认行为变化，不属于 breaking change。

## 风险与取舍

- 受控层会新增一个 Widget 公开契约，但避免在 Controller 中形成第二份
  可变视觉配置。
- Controller 不继承 `ChangeNotifier`；Anchor builder 会在展开状态变化时重建，
  与 Flutter `MenuController` 的非可监听命令模型保持一致。
- nullable 字段采用离散切换会牺牲一侧为空时的连续动画，但能避免无法在
  ThemeExtension 内解析的上下文 token 被错误替换为零值或透明值。

## 验证策略

- Widget 测试：展开、关闭、幂等、内部 Controller、自然关闭、替换与卸载。
- 单元测试：Theme nullable、双 null、双显式及中点切换。
- Demo 测试：选择操作后状态更新且浮层消失。
- 双版本严格 analyze、组件/Demo 回归和生产源码覆盖率。
- Flutter 3.32.0 Linux 现有 Golden 严格复跑，不更新基线。
