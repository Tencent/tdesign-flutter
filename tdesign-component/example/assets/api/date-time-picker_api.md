## API
### TDDatePicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| header | bool | true | 是否显示头部内容 |
| isTimeUnit | bool? | - | 是否时间显示 |
| itemBuilder | ItemBuilderType? | - | 自定义item构建 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 根据距离计算字体颜色、透明度、粗细 |
| key |  | - |  |
| leftPadding | double? | - | 左边填充 |
| leftText | String? | - | 左侧按钮文案 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| model | DatePickerModel | - | 数据模型 |
| onCancel | DatePickerCallback? | - | 选择器取消按钮回调 |
| onChange | DatePickerCallback? | - | 选择器值改变回调 |
| onConfirm | DatePickerCallback? | - | 选择器确认按钮回调 |
| onSelectedItemChanged | void Function(int wheelIndex, int index)? | - | 选择器选中项改变回调 |
| padding | EdgeInsets? | - | 适配padding |
| pickerHeight | double | 200 | 选择器List的视窗高度，默认200 |
| pickerItemCount | int | 5 | 选择器List视窗中item个数，pickerHeight / pickerItemCount，即item高度 |
| rightPadding | double? | - | 右边填充 |
| rightText | String? | - | 右侧按钮文案 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| title | String? | - | 选择器标题 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| titleHeight | double? | - | 标题高度 |
| topPadding | double? | - | 顶部填充 |
| topRadius | double? | - | 顶部圆角 |

```
```
 ### TDPicker

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showDatePicker |  |   required null context,  String? title,  double? titleHeight,  Color? titleDividerColor,  required DatePickerCallback? onConfirm,  DatePickerCallback? onCancel,  DatePickerCallback? onChange,   Function(int wheelIndex, int index)? onSelectedItemChanged,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  String? rightText,  TextStyle? rightTextStyle,  EdgeInsets? padding,  double? leftPadding,  double? topPadding,  double? rightPadding,  double? topRadius,  Color? backgroundColor,  Widget? customSelectWidget,  bool useYear,  bool useMonth,  bool useDay,  bool useHour,  bool useMinute,  bool useSecond,  bool useWeekDay,  List<int> dateStart,  List<int>? dateEnd,  List<int>? initialDate,  List<int> Function(DateTypeKey key, List<int> nums)? filterItems,  double pickerHeight,  int pickerItemCount,  bool isTimeUnit,  ItemBuilderType? itemBuilder,  Color? barrierColor,  Duration duration, | 显示时间选择器 |
| showMultiLinkedPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List initialData,  required Map data,  required int columnNum,  double pickerHeight,  int pickerItemCount,  Widget? customSelectWidget,  String? rightText,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  TextStyle? rightTextStyle,  double? titleHeight,  double? topPadding,  double? leftPadding,  double? rightPadding,  Color? titleDividerColor,  Color? backgroundColor,  double? topRadius,  EdgeInsets? padding,  ItemBuilderType? itemBuilder,  bool keepSameSelection,  Color? barrierColor,  Duration duration, | 显示多级联动选择器 |
| showMultiPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List<List<String>> data,  double pickerHeight,  int pickerItemCount,  List<int>? initialIndexes,  String? rightText,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  TextStyle? rightTextStyle,  double? titleHeight,  double? topPadding,  double? leftPadding,  double? rightPadding,  Color? titleDividerColor,  Color? backgroundColor,  double? topRadius,  EdgeInsets? padding,  Widget? customSelectWidget,  ItemBuilderType? itemBuilder,  Duration duration,  Color? barrierColor, | 显示多级选择器 |
