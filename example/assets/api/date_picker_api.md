## API
### TDDatePicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title |  | - |  |
| onConfirm |  | - |  |
| onCancel |  | - |  |
| backgroundColor |  | - |  |
| titleDividerColor |  | - |  |
| topRadius |  | - |  |
| titleHeight |  | - |  |
| padding | EdgeInsets? | - | 适配padding |
| leftPadding |  | - |  |
| rightPadding |  | - |  |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 根据距离计算字体颜色、透明度、粗细 |
| model |  | - |  |
| showTitle | bool | true | 是否展示标题 |
| pickerHeight | double | 200 | 选择器List的视窗高度，默认200 |
| pickerItemCount | int | - | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| key |  | - |  |

```
```
 ### TDPicker

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showDatePicker |  |   required null context,  required String title,  required DatePickerCallback? onConfirm,  DatePickerCallback? onCancel,  bool useYear,  bool useMonth,  bool useDay,  bool useHour,  bool useMinute,  bool useSecond,  bool useWeekDay,  Color? barrierColor,  List<int> dateStart,  List<int>? dateEnd,  List<int>? initialDate,  Duration duration,  double pickerHeight,  int pickerItemCount, | 显示时间选择器 |
| showMultiPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List<List<String>> data,  List<int>? initialIndexes,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级选择器 |
| showMultiLinkedPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required Map data,  required int columnNum,  required List initialData,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级联动选择器 |
