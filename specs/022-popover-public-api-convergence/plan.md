# 实施方案

## 技术方案

公开入口把内容统一为必填 `Widget`，把 placement 统一为带 `top` 默认值的非空参数，并以 Flutter 标准 `VoidCallback` 表达内容区域手势。底层渲染类改为库私有类，由 Overlay 入口唯一创建。

底层内容容器使用约束而非 String 专用 `TextPainter` 计算尺寸；通过布局阶段取得任意 Widget 的实际尺寸，再解析自动翻转、viewport clamp 与箭头补偿。首轮尺寸尚未稳定时隐藏气泡，尺寸确定后再展示，避免错误位置闪烁。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/popover/`、包入口 | 收敛公开 API，私有化渲染实现 |
| 测试 | Popover 组件与 Demo 测试 | 迁移 Widget 内容和稳定查找方式 |
| 示例 | `example/lib/page/t_popover_page.dart` | 字符串内容改为 Widget |
| 文档 | dartdoc、Spec、生成 API/代码片段 | 记录 breaking 迁移 |

## API 变化

- breaking：删除 `String? content` 与 `Widget? contentWidget` 组合，改为 `required Widget content`。
- breaking：`TPopoverPlacement? placement` 改为 `TPopoverPlacement placement = TPopoverPlacement.top`。
- breaking：`onTap`、`onLongTap` 改为 `VoidCallback?`。
- breaking：包入口不再导出 `TPopoverWidget`、`TPopoverTapCallback`、`TPopoverLongPressCallback`。

迁移示例：

```dart
TPopover.showPopover(
  context: context,
  content: const Text('弹出气泡内容'),
);
```

## 风险与取舍

- 任意 Widget 不能在 build 前通过文本测量得到尺寸，因此定位需要以真实布局尺寸为准；需防止首帧错误位置和重复布局。
- 隐藏实现类会影响直接构造它的调用方，但该类依赖锚点 context，无法独立管理 Overlay 生命周期，继续公开会形成第二入口。
- Widget 内容由调用方持有，事件回调不再回传内容，避免冗余数据源。

## 验证策略

- 单元测试：默认 placement、十二方位、尺寸、主题、手势和生命周期。
- 集成或 Widget 测试：公开 Demo 21 个展开态、自定义内容交互和边界场景。
- 静态检查：组件、示例与全仓 analyze；检查包入口导出。
- 视觉验收：Flutter 3.32.0 Linux light/dark Golden 不出现非预期差异。
