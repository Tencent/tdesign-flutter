# TTreeSelect

## 定位

`TTreeSelect` 是严格受控的多列树形叶子选择面板，支持任意深度。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `options` | `List<TTreeSelectOption>` | 必填 | 不可变根选项 |
| `value` | `List<List<Object?>>` | 必填 | 受控完整叶子路径集合 |
| `onChanged` | `ValueChanged<List<List<Object?>>>?` | `null` | 选择变化；为 `null` 时禁用 |
| `multiple` | `bool` | `false` | 是否允许选择多个叶子 |

`TTreeSelectOption` 只承载 `label`、`value`、`children` 和 `disabled`。布局和样式不进入数据模型。

## Theme

`TTreeSelectThemeData` 控制面板高度、根列/子列宽度、项高、背景色、普通/选中/禁用文案和选中图标颜色。

## 约束

- 每个选中值都是从根到叶子的完整路径。
- 单选和多选使用同一种 value 结构；单选最多一条路径。
- 父组件必须在 `onChanged` 中回灌 `value`。
- State 只维护展开路径，不自动选首项，也不缓存选中业务值。
- 数据项只描述业务树，布局统一由 Theme 控制。
