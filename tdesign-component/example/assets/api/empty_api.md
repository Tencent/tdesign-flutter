## API
### TEmpty
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| customOperationWidget | Widget? | - | 自定义操作按钮 |
| emptyText | String? | - | 描述文字 |
| emptyTextColor | Color? | - | 描述文字颜色 |
| emptyTextFont | Font? | - | 描述文字大小 |
| icon | IconData? | TIcons.info_circle_filled | 图标 |
| image | Widget? | - | 展示图片 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTapEvent | TTapEvent? | - | 点击事件 |
| operationText | String? | - | 操作按钮文案 |
| operationTheme | TButtonTheme? | - | 操作按钮文案主题色 |
| type | TEmptyType | TEmptyType.plain | 类型，为operation有操作按钮，plain无按钮 |


### TEmptyType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| plain | - |
| operation | - |


### TTapEvent
#### 类型定义

```dart
typedef TTapEvent = void Function();
```
