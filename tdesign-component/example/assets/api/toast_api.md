## API
### TDToast

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| dismissAll |  |  | 关闭所有Toast |
| dismissLoading |  |  | 关闭加载Toast（向后兼容） |
| dismissToast |  |   required String toastId, | 关闭指定的Toast |
| showFail |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines,  TextStyle? textStyle,  double? iconSize,  Color? iconColor,  String? toastId, | 失败提示Toast |
| showIconText |  |   required String? text,  IconData? icon,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines,  TextStyle? textStyle,  double? iconSize,  Color? iconColor,  String? toastId, | 带图标的Toast |
| showLoading |  |   required BuildContext context,  String? text,  Duration duration,  bool? preventTap,  Widget? customWidget,  Color? backgroundColor,  TextStyle? textStyle,  double? iconSize,  Color? iconColor,  String? toastId, | 带文案的加载Toast |
| showLoadingWithoutText |  |   required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  double? iconSize,  Color? iconColor,  String? toastId, | 不带文案的加载Toast |
| showSuccess |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines,  TextStyle? textStyle,  double? iconSize,  Color? iconColor,  String? toastId, | 成功提示Toast |
| showText |  |   required String? text,  required BuildContext context,  Duration duration,  int? maxLines,  BoxConstraints? constraints,  bool? preventTap,  Widget? customWidget,  Color? backgroundColor,  TextStyle? textStyle,  String? toastId, | 普通文本Toast |
| showWarning |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines,  TextStyle? textStyle,  double? iconSize,  Color? iconColor,  String? toastId, | 警告Toast |
