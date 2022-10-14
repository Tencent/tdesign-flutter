import 'package:flutter/material.dart';
import '../../../td_export.dart';

enum TDRadioStyle {
  circle, // 圆形
  square, // 方形
  check, // 对号样式
}

///
/// 单选框按钮
///
class TDRadio extends TDCheckbox {
  final TDRadioStyle radioStyle;

  const TDRadio({
    String? id,
    Key? key,
    String? title,
    String? subTitle,
    bool enable = true,
    int subTitleMaxLine = 1,
    int titleMaxLine = 1,
    Color? checkedColor,
    ContentBuilder? customContentBuilder,
    double? spacing,
    TDCheckBoxSize size = TDCheckBoxSize.small,
    this.radioStyle = TDRadioStyle.circle,
    TDContentDirection contentDirection = TDContentDirection.right,
    IconBuilder? customIconBuilder,
  }) : super(
          id: id,
          key: key,
          title: title,
          subTitle: subTitle,
          subTitleMaxLine: subTitleMaxLine,
          enable: enable,
          size: size,
          titleMaxLine: titleMaxLine,
          customContentBuilder: customContentBuilder,
          contentDirection: contentDirection,
          spacing: spacing,
          customIconBuilder: customIconBuilder,
        );

  @override
  Widget buildDefaultIcon(
      BuildContext context, TDCheckboxGroupState? groupState, bool isSelected) {

    TDRadioStyle? style ;
    if (groupState is TDRadioGroupState) {
      style = (groupState.widget as TDRadioGroup).radioStyle;
    }

    style = style ?? radioStyle;

    var size = 24.0;
    final theme = TDTheme.of(context);
    IconData? iconData;
    switch (style) {
      case TDRadioStyle.check:
        iconData = isSelected ? TDIcons.check : null;
        break;
      case TDRadioStyle.square:
        iconData = isSelected
            ? TDIcons.check_rectangle_filled
            : TDIcons.rectangle;
        break;
      default:
        iconData = isSelected
            ? TDIcons.check_circle_filled
            : TDIcons.circle;
        break;
    }
    if (iconData != null) {
      return Icon(
          iconData,
          size: size,
          color: !enable ? theme.grayColor4 : isSelected ? theme.brandColor8 : theme.grayColor4);
    } else {
      return SizedBox(width: size, height: size,);
    }

  }

  @override
  State<StatefulWidget> createState() {
    return TDRadioState();
  }
}

class TDRadioState extends TDCheckboxState {
  @override
  Widget build(BuildContext context) {
    // 检查是否包含在FuiCheckBoxGroup内，如果是的话，状态由Group管理
    final groupState = TDCheckboxGroupInherited.of(context)?.state;
    if (groupState is TDRadioGroupState) {
      final strictMode = (groupState.widget as TDRadioGroup).strictMode;
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
class TDRadioGroup extends TDCheckboxGroup {
  ///
  /// 严格模式下，用户不能取消勾选，只能切换选择项，
  ///
  final bool strictMode;
  final TDRadioStyle? radioStyle;

  TDRadioGroup(
      {required Widget child,
      Key? key,
      String? selectId, // 默认选择项的id
      this.strictMode = true,
      this.radioStyle,
      int? titleMaxLine, // item的行数
      IconBuilder? customIconBuilder,
      ContentBuilder? customContentBuilder,
      double? spacing, // icon和文字距离
      TDContentDirection? contentDirection,
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
    return TDRadioGroupState();
  }
}

class TDRadioGroupState extends TDCheckboxGroupState {
  @override
  bool toggle(String id, bool check, [bool notify = false]) {
    checkBoxStates.forEach((key, value) {
      checkBoxStates[key] = false;
    });
    return super.toggle(id, check, true);
  }
}

typedef OnRadioGroupChange = void Function(String? selectedId);
