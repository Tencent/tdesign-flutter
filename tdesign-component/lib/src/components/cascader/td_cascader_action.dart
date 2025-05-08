import 'package:flutter/cupertino.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

/// 级联选择器右上角响应
class TDCascaderAction {
  TDCascaderAction({this.builder, this.text, required this.onConfirm});

  /// 自定义builder
  WidgetBuilder? builder;

  /// 自定义文本
  String? text;

  /// 事件响应
  MultiCascaderCallback onConfirm;

  Widget build(BuildContext context){
    return builder?.call(context) ?? TDText(text ?? context.resource.confirm, textColor: TDTheme.of(context).brandNormalColor, font: TDTheme.of(context).fontTitleMedium,);
  }
}