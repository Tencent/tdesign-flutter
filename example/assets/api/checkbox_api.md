## API

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| id | String? | - | id |
| key | Key | - |  |
| title | String? | - | 文本 |
| subTitle | String? | - | 辅助文字 |
| enable | bool | true | 不可用 |
| checked | bool | false | 选中状态。默认为`false` |
| titleMaxLine | int? | - | 标题的行数 |
| subTitleMaxLine | int? | 1 | 辅助文字的行数 |
| customIconBuilder | IconBuilder? | - | 自定义Checkbox显示样式 |
| customContentBuilder | ContentBuilder? | - | 完全自定义内容 |
| style | TDCheckboxStyle? | - | 复选框样式：圆形或方形 |
| spacing | double? | - | icon和文字的距离 |
| backgroundColor | Color? | - | 背景颜色 |
| size | TDCheckBoxSize | TDCheckBoxSize.small | 复选框大小 |
| contentDirection | TDContentDirection | TDContentDirection.right | 文字相对icon的方位 |
| onCheckBoxChanged | OnCheckValueChanged? | - | 切换监听 |
