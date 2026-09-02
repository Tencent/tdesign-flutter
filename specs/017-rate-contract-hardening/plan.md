# 技术方案

## API 收敛

- 从 `TRateThemeData` 删除行为字段 `showText`。
- 保留 `texts`，以 nullable 语义同时表达“是否显示”和“显示什么”，不新增 `showText` 参数。
- 保留 `textWidth`、`textGap`、`textStyle` 等纯视觉 Theme 字段。

## 实现

- `_resolveText` 接收 `BuildContext`，0 分读取 `context.resource.notRated`。
- 提取统一图标构建方法，供主评分和浮层复用。
- Semantics 暴露 slider、增减后的值及增减回调。
- 命中计算和裁剪根据 `Directionality` 选择方向。
- 浮层可见样式从 `TThemeData` 的 spacer、radius、font、shadow 和 color 派生。
- 辅助文本使用 `TText`，先由完整 `fontBodyLarge` 构造字号、行高、字重和均匀 leading，再合并 `TRateThemeData.textStyle`；颜色未配置时读取显式 `ColorScheme.onSurface`，最后回退 TDesign 文本 token。外层 Row 显式按中心对齐，星色继续使用 Rate Theme 与 warning/component token。
- 移除整星填充和文案解析中的不可达或重复防御分支。
- 通过单一交互生命周期标记合并 tap/drag 识别器的开始事件，指针取消时以当前受控值结束，避免重复开始或提交未确认值。
- Semantics 同时保留数值和辅助文案，确保半星相邻值可区分。
- 使用父约束决定辅助文案布局：有界宽度内可收缩并省略，无界宽度下保持内容宽度。

## 风险

- 删除 `TRateThemeData.showText` 属于公开签名变化，且该字段已包含在 `1.0.0-alpha.1`。继续收敛该冗余状态入口，但按 breaking change 交付，并记录从 Theme 字段迁移到 nullable `TRate.texts` 的方式。
- RTL 与语义动作会新增回调路径，需要验证回调顺序和边界不重复通知。

## 验证

- 运行 Rate 组件测试与覆盖率门禁。
- 运行 Demo 结构测试和 Linux Golden。
- 将 Demo 功能契约与 Golden 拆分，功能测试进入双版本共享回归，Golden 仅进入 Flutter 3.32.0 Linux 视觉回归。
- 运行生成器 check、回归调度器自测与全量 analyze。
- 运行慢速拖拽、指针取消、带文案半星 Semantics、有界与无界文案布局的根因回归测试。
- 记录修复前后的辅助文字行盒高度，并断言默认文字与星标中心一致。
