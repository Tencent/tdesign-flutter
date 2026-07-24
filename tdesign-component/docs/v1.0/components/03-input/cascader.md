# TCascader

## 定位

`TCascader` 是严格受控的层级路径选择面板，不包含弹层、工具栏和确认操作。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `options` | `List<TCascaderOption>` | 必填 | 不可变根选项 |
| `value` | `List<Object?>` | 必填 | 受控选中路径 |
| `onChanged` | `ValueChanged<List<Object?>>?` | `null` | 路径变化；为 `null` 时禁用 |
| `variant` | `TCascaderVariant` | `tab` | 横向标签或纵向步骤导航 |
| `placeholder` | `String` | `请选择` | 未选择层级文案 |

`TCascaderOption` 使用 `label`、`value`、`children` 和 `disabled` 描述任意深度的树。

## Theme

`TCascaderThemeData` 控制高度、背景、圆角、普通/选中/禁用文案、导航内边距和分隔线颜色。

## 约束

- 父组件必须在 `onChanged` 中回灌 `value`。
- 每次选择返回从根到当前项的完整路径。
- State 只维护当前展示层级，不持有业务选择副本。
- 弹层和页面关闭行为始终由调用方组合。
