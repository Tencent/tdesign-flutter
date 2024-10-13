## API
### TDToast

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showText |  |   required String? text,  required BuildContext context,  Duration duration,  int? maxLines,  BoxConstraints? constraints,  bool? preventTap, | 普通文本Toast |
| showIconText |  |   required String? text,  IconData? icon,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap, | 带图标的Toast |
| showSuccess |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap, | 成功提示Toast |
| showWarning |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap, | 警告Toast |
| showFail |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap, | 失败提示Toast |
| showLoading |  |   required BuildContext context,  String? text,  Duration duration,  bool? preventTap, | 带文案的加载Toast |
| showLoadingWithoutText |  |   required BuildContext context,  String? text,  Duration duration,  bool? preventTap, | 不带文案的加载Toast |
| dismissLoading |  |  | 关闭加载Toast |
