import 'package:flutter/cupertino.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

/// 级联选择器右上角响应
class TCascaderAction {
  TCascaderAction({this.builder, this.text, required this.onConfirm});

  /// 自定义builder
  WidgetBuilder? builder;

  /// 自定义文本
  String? text;

  /// 事件响应
  MultiCascaderCallback onConfirm;

  Widget build(BuildContext context){
    return builder?.call(context) ?? TText(text ?? context.resource.confirm, textColor: TTheme.of(context).brandNormalColor, font: TTheme.of(context).fontTitleMedium,);
  }
}