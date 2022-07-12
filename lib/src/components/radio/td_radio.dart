import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

enum TdRadioStyle {
  circle, // 圆形
  square, // 方形
  check, // 对号样式
}

///
/// 单选框按钮
///
class TdRadio extends TdCheckbox {
  final TdRadioStyle radioStyle;

  const TdRadio({
    String? id,
    Key? key,
    String? title,
    bool enable = true,
    int titleMaxLine = 1,
    Color? checkedColor,
    ContentBuilder? customContentBuilder,
    double? spacing,
    this.radioStyle = TdRadioStyle.circle,
    TdContentDirection contentDirection = TdContentDirection.right,
    IconBuilder? customIconBuilder,
  }) : super(
          id: id,
          key: key,
          title: title,
          enable: enable,
          titleMaxLine: titleMaxLine,
          customContentBuilder: customContentBuilder,
          contentDirection: contentDirection,
          spacing: spacing,
          customIconBuilder: customIconBuilder,
        );

  @override
  Widget buildDefaultIcon(
      BuildContext context, TdCheckboxGroupState? groupState, bool isSelected) {

    TdRadioStyle? style ;
    if (groupState is TdRadioGroupState) {
      style = (groupState.widget as TdRadioGroup).radioStyle;
    }

    style = style ?? radioStyle;

    var size = 24.0;
    final theme = TDTheme.of(context);
    IconData? iconData;
    switch (style) {
      case TdRadioStyle.check:
        iconData = isSelected ? TDIcons.check : null;
        break;
      case TdRadioStyle.square:
        iconData = isSelected
            ? TDIcons.check_rectangle_filled
            : TDIcons.check_rectangle;
        break;
      default:
        iconData = isSelected
            ? TDIcons.check_circle_filled
            : TDIcons.check_circle;
        break;
    }
    if (iconData != null) {
      return Icon(
          iconData,
          size: size,
          color: isSelected ? theme.brandColor8 : theme.grayColor4);
    } else {
      return SizedBox.square(dimension: size,);
    }

  }

  @override
  State<StatefulWidget> createState() {
    return TdRadioState();
  }
}

class TdRadioState extends TdCheckboxState {
  @override
  Widget build(BuildContext context) {
    // 检查是否包含在FuiCheckBoxGroup内，如果是的话，状态由Group管理
    final groupState = TdCheckBoxGroupInherited.of(context)?.state;
    if (groupState is TdRadioGroupState) {
      final strictMode = (groupState.widget as TdRadioGroup).strictMode;
      // 严格模式下不能取消选项，只能切换
      if (strictMode == true) {
        canNotCancel = true;
      }
    }
    return super.build(context);
  }
}

///
/// RadioGroup分组对象
///
/// RadioGroup应该嵌套在RadioGroup内，所有在RadioGroup的RadioButton只能有一个被选中
///
///
///
class TdRadioGroup extends TdCheckboxGroup {
  ///
  /// 严格模式下，用户不能取消勾选，只能切换选择项，
  ///
  final bool strictMode;
  final TdRadioStyle? radioStyle;

  TdRadioGroup(
      {required Widget child,
      Key? key,
      String? selectId, // 默认选择项的id
      this.strictMode = true,
      this.radioStyle,
      int? titleMaxLine, // item的行数
      IconBuilder? customIconBuilder,
      ContentBuilder? customContentBuilder,
      double? spacing, // icon和文字距离
      TdContentDirection? contentDirection,
      OnRadioGroupChange? onRadioGroupChange}) // 切换监听
      : super(
          child: child,
          key: key,
          onChangeGroup: (ids) {
            onRadioGroupChange?.call(ids.isNotEmpty ? ids[0] : null);
          },
          controller: null,
          checkedIds: selectId != null ? [selectId] : null,
          maxChecked: 1,
          titleMaxLine: titleMaxLine,
          contentDirection: contentDirection,
          customIconBuilder: customIconBuilder,
          customContentBuilder: customContentBuilder,
          style: null,
          spacing: spacing,
        );

  @override
  State<StatefulWidget> createState() {
    return TdRadioGroupState();
  }
}

class TdRadioGroupState extends TdCheckboxGroupState {
  @override
  bool toggle(String id, bool check, [bool notify = false]) {
    checkBoxStates.forEach((key, value) {
      checkBoxStates[key] = false;
    });
    return super.toggle(id, check, true);
  }
}

typedef OnRadioGroupChange = void Function(String? selectedId);
