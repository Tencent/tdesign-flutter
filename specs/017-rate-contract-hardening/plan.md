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

## 风险

- 删除 `TRateThemeData.showText` 属于公开签名变化；当前 Rate 尚未合入发布基线，直接收敛，避免发布冗余 API。
- RTL 与语义动作会新增回调路径，需要验证回调顺序和边界不重复通知。

## 验证

- 运行 Rate 组件测试与覆盖率门禁。
- 运行 Demo 结构测试和 Linux Golden。
- 运行生成器 check、回归调度器自测与全量 analyze。
