# 实施方案

## 技术方案

修正已有默认样式值，并让现有 `TDialogAction.variant` 真正表达 Figma 的文字操作区：文字操作保留官方 32dp 顶间距、贴边 56dp Footer 和分隔线，基础操作保留内边距；三个及以上操作按主操作优先展示。Dialog 使用 Flutter 标准模态路由居中承载自适应面板，保持 240ms 缩放动画、遮罩点击和主题捕获语义，不扩展 Popup 公共契约。组件与 Example 的圆角、间距和字体优先复用语义匹配的 TDesign token；311dp 面板宽度、56dp Footer 高度与 0.5dp 分隔线因没有等价语义 token，保留为单一设计常量。Example 层用现有 `Widget` 槽位、`TInput` 和操作区组合能力表达官方场景。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_dialog.dart` | 默认可见间距、文字操作区和多操作顺序 |
| 路由 | Flutter `RawDialogRoute` 私有子类 | 保留居中自适应、主题捕获、SafeArea、遮罩与缩放动画；在标准蒙层的 onDismiss 中用 maybePop 返回调用方指定的值；Popup 不变 |
| 测试 | `test/components/dialog/` | 样式和 ThemeData 契约 |
| 示例 | `example/lib/page/t_dialog_page.dart` | 22 场景公开矩阵 |
| 示例测试 | `example/test/dialog_page_test.dart` | 入口和关键组合交互 |
| 生成文档 | `example/assets/code/dialog.*.txt` | 代码查看器片段 |

## API 变化

- 不新增按钮配色入口；修复 Dialog 的 normal role 默认映射，保留显式变体、配色与样式的覆盖优先级。普通基础操作通过 TButton 既有 `brandLightColor` / `brandNormalColor` token 渲染；不修改共享 TButton 的默认行为。
- `TPopupOptions` 公开 API 无变化。
- `TDialog.show<T>` 增加 `T? barrierResult`；`TDialog` 与便捷层 `TConfirmDialog` 增加 `Object? closeButtonResult`，默认均为 null；保持按钮 result 和 Future 为唯一结果通道，不扩展业务状态或事件模型。

## 风险与取舍

- 默认可见间距发生 8px 变化，需在 PR 更新日志中向用户明确说明。
- Example 图片复用仓库已打包资源，Golden 显式等待图片解码，避免把空白槽位误收为基线。
- 文字操作区只在全部操作都显式使用 `TButtonVariant.text` 时启用，混合或基础按钮不改变既有布局。
- 输入场景复用已经发布的 `TInput` 和局部 `TInputThemeData`，不把 Dialog 专属颜色、间距扩散为新的公开参数。
- 仅将语义匹配的 radius/spacer/font 值 token 化；面板宽度、Footer 高度和细分隔线不借用无关 token。

## 验证策略

- 单元/Widget 测试：Dialog 组件全部聚焦测试。
- Example 测试：22 个入口逐项打开/关闭，以及图片、输入、文字按钮、垂直按钮、多按钮顺序和自定义操作项。
- 静态检查：Flutter 3.32.0 和 latest 严格 analyze。
- 人工验收：Figma/小程序样式与 375px Golden 对照，并在真实 Web Demo 操作关键打开态。
