# 实施计划

1. 在 Picker 组件域增加 `TPickerPopup.show`，使用当前子树的 `TPickerThemeData.height` 计算总高。
2. 保留 `TPopup` 240px 通用默认值，不在 Popup 内判断具体子组件类型。
3. Picker、DateTimePicker、Form Demo 迁移至统一入口，删除调用点手写的高度公式。
4. 补充默认与自定义主题尺寸回归，复用现有 Demo 交互和 Golden 入口。

## API 与兼容性

`TPickerPopup.show` 是新增的可选入口，不删除原有 `TPicker` / `TDateTimePicker` / `TPopup` API，不属于 breaking change。已手动组合 Popup 的调用方可按需迁移。
