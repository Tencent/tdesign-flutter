import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_theme.dart';
import '../icon/td_icons.dart';
import 'td_check_box_group.dart';

///
/// 选择框的样式
///
enum TDCheckboxStyle {
  circle, // 圆形
  square, // 方形
}

///
/// 内容相对icon的位置，上、下、左、右，默认内容在icon的右边
///
enum TDContentDirection {
  top, // content在icon的上面
  left, // content在icon的左边
  right, // content在icon的右边
  bottom // content在icon的下边
}

///
/// 自定义Icon
///
typedef IconBuilder = Widget? Function(BuildContext context, bool checked);

///
/// 自定义Content
///
typedef ContentBuilder = Widget Function(BuildContext context, bool checked, String? content);


typedef OnCheckValueChanged = void Function(bool selected);

///
/// 复选框组件。
///
/// FuiCheckbox支持3种内置样式的的复选框，还支持各种自定义样式，除了提供勾选之外还提供了内
/// 容选项，内容包含一个主标题和副标题，并且支持完全自定义内容，支持指定内容的方向等等
///
///
class TDCheckbox extends StatefulWidget {
  /// id
  /// 当FuiCheckBox嵌入到FuiCheckBoxGroup内时，这个值需要赋值，否则不会被纳入Group管理
  final String? id;

  /// 文本
  final String? title;

  /// 不可用
  final bool enable;

  /// 选中状态。默认为`false`
  /// 当FuiCheckBox嵌入到FuiCheckBoxGroup的时候，这个值表示初始状态，后续的状态会由Group管理
  final bool checked;

  /// 标题的行数
  final int? titleMaxLine;

  /// icon和文字的距离
  final double? spacing;

  /// 复选框样式：圆形或方形
  final TDCheckboxStyle? style;

  ///
  /// 文字相对icon的方位
  ///
  final TDContentDirection contentDirection;

  /// 切换监听
  final OnCheckValueChanged? onCheckBoxChanged;

  /// 自定义Checkbox显示样式
  final IconBuilder? customIconBuilder;

  /// 完全自定义内容
  final ContentBuilder? customContentBuilder;

  const TDCheckbox(
      {this.id,
        Key? key,
      this.title,
      this.enable = true,
      this.checked = false,
      this.titleMaxLine,
      this.customIconBuilder,
      this.customContentBuilder,
      this.style,
      this.spacing,
      this.contentDirection = TDContentDirection.right,
      this.onCheckBoxChanged}): super(key: key);

  @override
  State createState() => TDCheckboxState();

  /// 默认的checkBox icon
  Widget buildDefaultIcon(BuildContext context, TDCheckboxGroupState? groupState, bool isChecked) {
    Widget current;
    var size = 24.0;
    final style = this.style ?? groupState?.widget.style ?? TDCheckboxStyle.circle;
    final theme = TDTheme.of(context);
    current = Icon(
      style == TDCheckboxStyle.circle
          ? isChecked  ? TDIcons.check_circle_filled : TDIcons.check_circle
          : isChecked ? TDIcons.check_rectangle_filled :  TDIcons.check_rectangle,
      size: size,
      color: isChecked ? theme.brandColor8 : theme.grayColor4
    );
    return current;
  }
}

class TDCheckboxState extends State<TDCheckbox> {
  bool checked = false;
  bool _pressed = false;

  /// 不可取消勾选，在radioButton的严格模式下，只能切换不能取消勾选
  bool canNotCancel = false;

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
  }

  @override
  void didUpdateWidget(TDCheckbox oldWidget) {
    checked = widget.checked;
    super.didUpdateWidget(oldWidget);
  }

  double _spacing(TDCheckboxGroupState? groupState) {
    return widget.spacing ?? groupState?.widget.spacing ?? 5;
  }

  @override
  Widget build(BuildContext context) {
    // 检查是否包含在FuiCheckBoxGroup内，如果是的话，状态由Group管理
    final groupState = TDCheckboxGroupInherited.of(context)?.state;
    final id = widget.id;
    //  只有设置了id的CheckBox才会纳入Group管理
    if (groupState != null && id != null) {
      // CheckBox嵌入在CheckBoxGroup的勾选状态的获取优先级：
      // 1.CheckBoxGroup里设置的checkedIds包含当前id
      // 2.没有checkedIds属性，且没有勾选过，使用当前CheckedBox设置的checked属性
      // 3.用户勾选之后的状态
      checked = groupState.getCheckBoxStateById(id, checked);
    }

    // 构建icon
    var icon = _buildCheckboxIcon(context, groupState, checked);

    // 内容
    var content = _buildContent(context, groupState, checked);


    if (icon == null && content == null) {
      throw Exception('Icon and content cannot both be null!');
    }

    Widget? current ;

    if (icon == null) {
      current = content!;
    } else {

      current = icon;

      if (content != null) {
        final spacing = _spacing(groupState);
        var contentDirection = groupState?.widget.contentDirection ?? widget.contentDirection;
        switch (contentDirection) {
          case TDContentDirection.top:
            current = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: content),
                SizedBox(height: spacing,),
                icon,
              ],
            );
            break;
          case TDContentDirection.left:
            current = Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: content),
                SizedBox(width: spacing,),
                icon,
              ],
            );
            break;
          case TDContentDirection.right:
            current = Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: spacing,),
                Expanded(child: content),
              ],
            );
            break;
          case TDContentDirection.bottom:
            current = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(height: spacing,),
                Expanded(child: content),
              ],
            );
            break;
        }
      }
    }

    if (widget.enable == false) {
      current = Opacity(
        opacity: 0.5,
        child: current,
      );
    } else if (!(canNotCancel && checked)) {
      if (_pressed) {
        // 点击效果
        current = Opacity(
          opacity: 0.68,
          child: current,
        );
      }

      // 开关样式的话自己会处理点击事件
      current = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (detail) {
          _pressState(true);
        },
        onTapUp: (detail) {
          _pressState(false);
        },
        onTapCancel: () {
          _pressState(false);
        },
        onTap: () {
          onValueChange(id, !checked, groupState);
        },
        child: current,
      );
    }

    return current;
  }

  /// 点击效果
  void _pressState(bool pressed) {
    _pressed = pressed;
    setState(() {});
  }

  /// 选中状态的变化
  void onValueChange(
    String? id,
    bool value,
    TDCheckboxGroupState? groupState,
  ) {
    setState(() {
      checked = value;
      widget.onCheckBoxChanged?.call(checked);
      if (groupState != null && id != null) {
        groupState.toggle(id, checked);
      }
    });
  }

  ///
  /// 构建选择框边上的文本内容
  ///
  Widget? _buildContent(
      BuildContext context,
      TDCheckboxGroupState? groupState,
      bool checked,
      ) {

    final title = widget.title;
    final customContent =
        widget.customContentBuilder ?? groupState?.widget.customContentBuilder;

    var content = customContent?.call(context, checked, title);
    if (content == null) {
      if (title != null || customContent != null && title != null) {
        content = Text(
            title,
            maxLines:
            widget.titleMaxLine ?? groupState?.widget.titleMaxLine,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: TDTheme.of(context).fontGyColor1,
              fontSize: TDTheme.of(context).fontS?.size,
            ));
      }
    }
    return content;
  }

  /// 构建icon
  Widget? _buildCheckboxIcon(BuildContext context, TDCheckboxGroupState? groupState, bool isCheck) {
    final iconBuilder = widget.customIconBuilder ?? groupState?.widget.customIconBuilder;
    if (iconBuilder != null) {
      return iconBuilder.call(context, isCheck);
    }
    return widget.buildDefaultIcon(context, groupState, isCheck);
  }
}
