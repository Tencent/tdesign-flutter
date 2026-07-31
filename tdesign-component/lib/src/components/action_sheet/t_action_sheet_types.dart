import 't_action_sheet_item.dart';

/// 选择动作面板项目时触发
typedef TActionSheetOnChanged = void Function(
  TActionSheetItem item,
  int index,
);

/// 动作面板内容对齐方式
enum TActionSheetAlign {
  /// 居中对齐
  center,

  /// 左对齐
  left,

  /// 右对齐
  right,
}
