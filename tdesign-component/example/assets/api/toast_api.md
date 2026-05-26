## API
### TToast

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| dismissAll | void | - | 关闭所有Toast |
| dismissLoading | void | - | 关闭加载Toast（向后兼容） |
| dismissToast | void | required String toastId | 关闭指定的Toast |
| showFail | String | required String? text, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 失败提示Toast |
| showIconText | String | required String? text, IconData? icon, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 带图标的Toast |
| showLoading | String | required BuildContext context, String? text, Duration duration, bool? preventTap, Widget? customWidget, Color? backgroundColor, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 带文案的加载Toast |
| showLoadingWithoutText | String | required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, double? iconSize, Color? iconColor, String? toastId | 不带文案的加载Toast |
| showSuccess | String | required String? text, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 成功提示Toast |
| showText | String | required String? text, required BuildContext context, Duration duration, int? maxLines, BoxConstraints? constraints, bool? preventTap, Widget? customWidget, Color? backgroundColor, TextStyle? textStyle, String? toastId | 普通文本Toast |
| showWarning | String | required String? text, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 警告Toast |


### IconTextDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |
