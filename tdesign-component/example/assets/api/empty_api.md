## API
### TEmpty
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| customOperationWidget | Widget? | - | 自定义操作按钮 |
| emptyText | String? | - | 描述文字 |
| icon | IconData? | TIcons.info_circle_filled | 图标 |
| image | Widget? | - | 展示图片 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击事件 |
| operationText | String? | - | 操作按钮文案 |
| variant | TEmptyVariant | TEmptyVariant.plain | 空态形态 |


### TEmptyVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| plain | 仅展示空态内容。 |
| operation | 展示空态内容和操作入口。 |
