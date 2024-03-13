## API
### TDMultiPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String? | - | 选择器标题 |
| onConfirm | MultiPickerCallback? | - | 选择器确认按钮回调 |
| onCancel | MultiPickerCallback? | - | 选择器取消按钮回调 |
| data | Map | - | 总的数据 |
| pickerHeight | double | - |  |
| pickerItemCount | int | - | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| initialIndexes | List<int>? | - | 若为null表示全部从零开始 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| titleHeight | double? | - | 标题高度 |
| topPadding | double? | - | 顶部填充 |
| leftPadding | double? | - | 左边填充 |
| rightPadding | double? | - | 右边填充 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| topRadius | double? | - | 顶部圆角 |
| padding | EdgeInsets? | - | 适配padding |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 不同距离自选项计算策略 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| key |  | - |  |

```
```
 ### TDMultiLinkedPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String? | - | 选择器标题 |
| onConfirm | MultiPickerCallback? | - | 选择器确认按钮回调 |
| onCancel | MultiPickerCallback? | - | 选择器取消按钮回调 |
| selectedData | List | - | 选中数据 |
| data | Map | - | 总的数据 |
| columnNum | int | - | 总列数 |
| pickerHeight | double | 200 |  |
| pickerItemCount | int | 5 | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| titleHeight | double? | - | 标题高度 |
| topPadding | double? | - | 顶部填充 |
| leftPadding | double? | - | 左边填充 |
| rightPadding | double? | - | 右边填充 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| topRadius | double? | - | 顶部圆角 |
| padding | EdgeInsets? | - | 适配padding |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 不同距离自选项计算策略 |
| key |  | - |  |

```
```
 ### MultiLinkedPickerModel
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | Map | - | 总的数据 |
| columnNum | int | - | 总列数 |
| initialData |  | - |  |

```
```
 ### TDPicker

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showDatePicker |  |   required null context,  required String title,  required DatePickerCallback? onConfirm,  DatePickerCallback? onCancel,  bool useYear,  bool useMonth,  bool useDay,  bool useHour,  bool useMinute,  bool useSecond,  bool useWeekDay,  Color? barrierColor,  List<int> dateStart,  List<int>? dateEnd,  List<int>? initialDate,  String rightText,  String leftText,  Duration duration,  double pickerHeight,  int pickerItemCount, | 显示时间选择器 |
| showMultiPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List<List<String>> data,  List<int>? initialIndexes,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级选择器 |
| showMultiLinkedPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required Map data,  required int columnNum,  required List initialData,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级联动选择器 |
