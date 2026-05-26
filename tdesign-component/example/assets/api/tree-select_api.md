## API
### TTreeSelect
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultValue | List<dynamic> | const [] | 初始值，对应options中的value值 |
| height | double | 336 | 高度 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| multiple | bool | false | 支持多选 |
| onChange | TTreeSelectChangeEvent? | - | 选中值发生变化 |
| options | List<TSelectOption> | const [] | 展示的选项列表 |
| outwardCornerRadius | double | 9 | 一级菜单选中项的外弯折圆角半径，默认为 9 |
| style | TTreeSelectStyle | TTreeSelectStyle.normal | 一级菜单样式 |


### TSelectOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSelectOption> | const [] | 子选项 |
| columnWidth | double? | - | 自定义宽度，允许用户指定每个选项的宽度 |
| label | String | - | 标签 |
| maxLines | int | 1 | 最大显示行数 |
| multiple | bool | false | 当前子项支持多选 |
| value | dynamic | - | 值 |


### TTreeSelectStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | - |
| outline | - |


### TTreeSelectChangeEvent
#### 类型定义

```dart
typedef TTreeSelectChangeEvent = void Function(List<dynamic>, int level);
```
