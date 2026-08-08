## API
### TIcon

#### 工厂构造方法

##### TIcon.fromName

通过图标名称构造（查找 `TIcons.allIconsMap`）
如果名称不存在，抛出 `ArgumentError`。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 图标名称，对应 `TIcons.allIconsMap` 中的 key。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| size | double? | - | 图标尺寸（优先于 `TIconThemeData.size` 和 `IconTheme.of`） |
| color | Color? | - | 图标颜色（优先于 `TIconThemeData.color`、`IconTheme.of` 和 token 兜底） |
| semanticLabel | String? | - | 无障碍语义标签 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData | - | 图标数据（位置参数） |
| color | Color? | - | 图标颜色（优先于 `TIconThemeData.color`、`IconTheme.of` 和 token 兜底） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| semanticLabel | String? | - | 无障碍语义标签 |
| size | double? | - | 图标尺寸（优先于 `TIconThemeData.size` 和 `IconTheme.of`） |


### TIconThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | 图标默认颜色（null 时回退 `IconTheme.of`） |
| size | double? | - | 图标默认尺寸（null 时回退 `IconTheme.of`） |
