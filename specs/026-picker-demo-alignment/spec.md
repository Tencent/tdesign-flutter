# Picker 公开 Demo 对齐

## 目标与契约

- 按小程序 `b60cdc8a1dce1f06dd45cb4e41eefd31c674e514` 顺序覆盖城市、时间、地区、带标题和无标题选择器。
- `TPickerColumns` 表达独立列，`TPickerLinked` 表达联动列；不再增加模糊数据入口。
- `value + onChanged` 保持严格受控，`onChanged == null` 禁用；Popup、标题、按钮与确认草稿由 Flutter 组合。
- 不复制小程序 `visible/usePopup/header/title/keys/defaultValue`，typed option 在数据边界完成转换。
- 补齐 Demo、light/dark Golden、组件回归与覆盖率门禁。

## 验收标准

- 两组五个字段实例顺序与小程序公开 Demo 一致。
- 标题/无标题 Popup 与取消/确认有功能断言。
- 组件、Demo、Golden、覆盖率和 Flutter 双版本 analyze 通过。
