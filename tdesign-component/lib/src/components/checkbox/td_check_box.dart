import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

import '../../util/auto_size.dart';

///
/// 选择框的样式
///
enum TDCheckboxStyle {
  circle, // 圆形
  square, // 方形
  check, // 无背景勾选样式
}

///
/// 内容相对icon的位置，上、下、左、右，默认内容在icon的右边
///
enum TDContentDirection {
  left, // content在icon的左边
  right, // content在icon的右边
}

enum TDCheckBoxSize {
  large, // 大 高度56
  small, // 小 高度48
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
  const TDCheckbox(
      {this.id,
      Key? key,
      this.title,
      this.subTitle,
      this.titleFont,
      this.subTitleFont,
      this.enable = true,
      this.checked = false,
      this.titleMaxLine,
      this.subTitleMaxLine = 1,
      this.customIconBuilder,
      this.customContentBuilder,
      this.insetSpacing = 16,
      this.style,
      this.spacing,
      this.backgroundColor,
      this.selectColor,
      this.disableColor,
      this.size = TDCheckBoxSize.small,
      this.cardMode = false,
      this.showDivider = true,
      this.contentDirection = TDContentDirection.right,
      this.onCheckBoxChanged})
      : super(key: key);

  /// id
  /// 当FuiCheckBox嵌入到FuiCheckBoxGroup内时，这个值需要赋值，否则不会被纳入Group管理
  final String? id;

  /// 文本
  final String? title;

  /// 标题字体大小
  final Font? titleFont;

  /// 辅助文字
  final String? subTitle;

  /// 副标题字体大小
  final Font? subTitleFont;

  /// 不可用
  final bool enable;

  /// 选中状态。默认为`false`
  /// 当FuiCheckBox嵌入到FuiCheckBoxGroup的时候，这个值表示初始状态，后续的状态会由Group管理
  final bool checked;

  /// 标题的行数
  final int? titleMaxLine;

  /// 辅助文字的行数
  final int? subTitleMaxLine;

  /// 文字和非图标侧的距离
  final double? insetSpacing;

  /// icon和文字的距离
  final double? spacing;

  /// 复选框样式：圆形或方形
  final TDCheckboxStyle? style;

  /// 复选框大小
  final TDCheckBoxSize size;

  /// 展示为卡片模式
  final bool cardMode;

  /// 是否展示分割线
  final bool showDivider;

  /// 文字相对icon的方位
  final TDContentDirection contentDirection;

  /// 切换监听
  final OnCheckValueChanged? onCheckBoxChanged;

  /// 自定义Checkbox显示样式
  final IconBuilder? customIconBuilder;

  /// 完全自定义内容
  final ContentBuilder? customContentBuilder;

  /// 背景颜色
  final Color? backgroundColor;

  /// 选择颜色
  final Color? selectColor;

  /// 禁用选择颜色
  final Color? disableColor;

  @override
  State createState() => TDCheckboxState();

  /// 默认的checkBox icon
  Widget buildDefaultIcon(BuildContext context, TDCheckboxGroupState? groupState, bool isChecked) {
    if (cardMode == true) {
      return Container();
    }
    Widget current;
    var size = 24.0;
    final style = this.style ?? groupState?.widget.style ?? TDCheckboxStyle.circle;
    final theme = TDTheme.of(context);
    final deSelectedColor = style == TDCheckboxStyle.check ? Colors.transparent : theme.grayColor4;
    current = Icon(
      style == TDCheckboxStyle.circle
          ? isChecked
              ? TDIcons.check_circle_filled
              : TDIcons.circle
          : style == TDCheckboxStyle.square
              ? isChecked
                  ? TDIcons.check_rectangle_filled
                  : TDIcons.rectangle
              : isChecked
                  ? TDIcons.check
                  : TDIcons.check,
      size: size,
      color: !enable
          ? (isChecked ? (disableColor ?? theme.brandDisabledColor) : deSelectedColor)
          : isChecked
              ? selectColor ?? theme.brandNormalColor
              : deSelectedColor,
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
    return widget.spacing ?? groupState?.widget.spacing ?? 8;
  }

  EdgeInsets _getPadding(TDCheckBoxSize size) {
    if (widget.cardMode) {
      return const EdgeInsets.only(top: 16);
    }
    switch (size) {
      case TDCheckBoxSize.small:
        return const EdgeInsets.only(top: 12, bottom: 12);
      case TDCheckBoxSize.large:
        return const EdgeInsets.only(top: 16, bottom: 16);
    }
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

    Widget? current;

    if (icon == null) {
      current = content!;
    } else {
      current = icon;

      if (content != null) {
        final spacing = _spacing(groupState);
        var contentDirection = groupState?.widget.contentDirection ?? widget.contentDirection;
        switch (contentDirection) {
          case TDContentDirection.left:
            current = Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: _getPadding(widget.size),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: widget.insetSpacing ?? 16),
                            child: content,
                          )),
                          SizedBox(
                            width: spacing,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: icon,
                          ),
                        ],
                      ),
                      Visibility(
                        visible: widget.subTitle != null && widget.subTitle != '',
                        child: Padding(
                          padding: EdgeInsets.only(left: widget.insetSpacing ?? 16, right: 16),
                          child: TDText(widget.subTitle ?? '',
                              maxLines: widget.subTitleMaxLine,
                              overflow: TextOverflow.ellipsis,
                              textColor:
                                  widget.enable ? TDTheme.of(context).fontGyColor3 : TDTheme.of(context).fontGyColor4,
                              font: TDTheme.of(context).fontBodyMedium),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                    visible: !widget.cardMode && widget.showDivider,
                    child: const TDDivider(
                      margin: EdgeInsets.only(left: 16),
                    ))
              ],
            );
            break;
          case TDContentDirection.right:
            current = Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: _getPadding(widget.size),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: icon,
                          ),
                          SizedBox(
                            width: widget.cardMode ? 0 : spacing,
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(right: widget.insetSpacing ?? 16),
                            child: content,
                          )),
                        ],
                      ),
                      Visibility(
                        visible: widget.subTitle != null && widget.subTitle != '',
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: widget.cardMode ? 4.scale : 0,
                              left: widget.cardMode ? 16 : 48,
                              right: widget.insetSpacing ?? 16),
                          child: TDText(widget.subTitle ?? '',
                              maxLines: widget.subTitleMaxLine,
                              overflow: TextOverflow.ellipsis,
                              textColor:
                                  widget.enable ? TDTheme.of(context).fontGyColor3 : TDTheme.of(context).fontGyColor4,
                              font: widget.subTitleFont ?? TDTheme.of(context).fontBodyMedium),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                    visible: !widget.cardMode && widget.showDivider,
                    child: const TDDivider(
                      margin: EdgeInsets.only(left: 48),
                    ))
              ],
            );
            break;
        }
      }
    }

    if (!(canNotCancel && checked)) {
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

    return Container(
      clipBehavior: widget.cardMode ? Clip.hardEdge : Clip.none,
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
          border: widget.cardMode
              ? checked
                  ? Border.all(width: 1.5, color: widget.selectColor ?? TDTheme.of(context).brandNormalColor)
                  : Border.all(width: 1.5, color: Colors.transparent)
              : null,
          borderRadius: widget.cardMode ? const BorderRadius.all(Radius.circular(6)) : null),
      child: Stack(
        children: [
          current,
          Positioned(
              top: 0,
              left: 0,
              child: Visibility(
                  visible: widget.cardMode && checked,
                  child: RadioCornerIcon(
                    length: 28,
                    radius: 4,
                    selectColor: widget.selectColor,
                  ))),
        ],
      ),
    );
  }

  /// 点击效果
  void _pressState(bool pressed) {
    if (!widget.enable) {
      return;
    }
    _pressed = pressed;
    setState(() {});
  }

  /// 选中状态的变化
  void onValueChange(
    String? id,
    bool value,
    TDCheckboxGroupState? groupState,
  ) {
    if (!widget.enable) {
      return;
    }
    setState(() {
      checked = value;
      if (groupState != null && id != null) {
        groupState.toggle(id, checked);
      }
      widget.onCheckBoxChanged?.call(checked);
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
    final customContent = widget.customContentBuilder ?? groupState?.widget.customContentBuilder;

    var content = customContent?.call(context, checked, title);
    if (content == null) {
      if (title != null || customContent != null && title != null) {
        content = TDText(title,
            maxLines: widget.titleMaxLine ?? groupState?.widget.titleMaxLine,
            overflow: TextOverflow.ellipsis,
            textColor: widget.enable ? TDTheme.of(context).fontGyColor1 : TDTheme.of(context).fontGyColor4,
            font: widget.titleFont ??
                TDTheme.of(context)
                    .fontBodyLarge); // TODO custom fontSize https://github.com/Tencent/tdesign-flutter/issues/66
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

class RadioCornerIcon extends StatelessWidget {
  final double length;
  final double radius;
  final Color? selectColor;

  const RadioCornerIcon({Key? key, required this.length, required this.radius, required this.selectColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: length,
      height: length,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          CustomPaint(
            painter: RadioCorner(
                length: length, radius: radius, fillColor: selectColor ?? TDTheme.of(context).brandNormalColor),
          ),
          const Positioned(
              top: 3,
              left: 2,
              child: Icon(
                TDIcons.check,
                size: 14,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}

class RadioCorner extends CustomPainter {
  final double length;
  final double radius;
  final Color fillColor;

  RadioCorner({required this.length, required this.radius, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = fillColor
      ..style = PaintingStyle.fill;
    var rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);
    var pi = 3.1415;
    var path = Path();
    path.moveTo(0, radius);
    path.addArc(
      rect,
      180 * (pi / 180.0),
      90 * (pi / 180.0),
    );
    path.moveTo(radius, 0);
    path.lineTo(length, 0);
    path.lineTo(0, length);
    path.lineTo(0, radius);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
