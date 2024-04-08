import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

enum TDRadioStyle {
  circle, // 圆形
  square, // 方形
  check, // 对号样式
  hollowCircle, // 镂空圆点样式
}

/// 单选框按钮,继承自TDCheckbox，字段含义与父类一致
class TDRadio extends TDCheckbox {
  /// 单选框按钮样式
  final TDRadioStyle radioStyle;

  const TDRadio({
    String? id,
    Key? key,
    String? title,
    Font? titleFont,
    String? subTitle,
    Font? subTitleFont,
    bool enable = true,
    int subTitleMaxLine = 1,
    int titleMaxLine = 1,
    Color? selectColor,
    Color? disableColor,
    ContentBuilder? customContentBuilder,
    double? spacing,
    bool? cardMode,
    bool? showDivider,
    TDCheckBoxSize size = TDCheckBoxSize.small,
    this.radioStyle = TDRadioStyle.circle,
    TDContentDirection contentDirection = TDContentDirection.right,
    IconBuilder? customIconBuilder,
  }) : super(
          id: id,
          key: key,
          title: title,
          subTitle: subTitle,
          titleFont: titleFont,
          subTitleFont: subTitleFont,
          subTitleMaxLine: subTitleMaxLine,
          enable: enable,
          size: size,
          cardMode: cardMode ?? false,
          showDivider: showDivider ?? true,
          titleMaxLine: titleMaxLine,
          customContentBuilder: customContentBuilder,
          contentDirection: contentDirection,
          spacing: spacing,
          customIconBuilder: customIconBuilder,
          selectColor: selectColor,
          disableColor: disableColor,
        );

  @override
  Widget buildDefaultIcon(BuildContext context, TDCheckboxGroupState? groupState, bool isSelected) {
    if (cardMode == true) {
      return Container();
    }
    TDRadioStyle? style;
    if (groupState is TDRadioGroupState) {
      style = (groupState.widget as TDRadioGroup).radioCheckStyle;
    }

    style = style ?? radioStyle;

    var size = 24.0;
    final theme = TDTheme.of(context);

    // 由于镂空圆没有现成icon，因而自己画一个`
    if (style == TDRadioStyle.hollowCircle) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: HollowCircle(!enable
              ? (isSelected ? theme.brandDisabledColor : theme.grayColor4)
              : isSelected
                  ? selectColor ?? theme.brandNormalColor
                  : theme.grayColor4),
        ),
      );
    }

    IconData? iconData;
    switch (style) {
      case TDRadioStyle.check:
        iconData = isSelected ? TDIcons.check : null;
        break;
      case TDRadioStyle.square:
        iconData = isSelected ? TDIcons.check_rectangle_filled : TDIcons.rectangle;
        break;
      default:
        iconData = isSelected ? TDIcons.check_circle_filled : TDIcons.circle;
        break;
    }
    if (iconData != null) {
      return Icon(iconData,
          size: size,
          color: !enable
              ? (isSelected ? (disableColor ?? theme.brandDisabledColor) : theme.grayColor4)
              : isSelected
                  ? selectColor ??  theme.brandNormalColor
                  : theme.grayColor4);
    } else {
      return SizedBox(
        width: size,
        height: size,
      );
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

class HollowCircle extends CustomPainter {
  HollowCircle(this.color);

  // 绘制颜色
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(10.5, 10.5), 10.5, paint);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(10.5, 10.5), 6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// RadioGroup分组对象，继承自TDCheckboxGroup，字段含义与父类一致
/// RadioGroup应该嵌套在RadioGroup内，所有在RadioGroup的RadioButton只能有一个被选中
///
/// cardMode: 使用卡片样式，需要配合direction 和 directionalTdRadios 使用，
/// 组合为横向、纵向卡片，同时需要在每个TDRadio上设置cardMode参数。
class TDRadioGroup extends TDCheckboxGroup {
  /// 严格模式下，用户不能取消勾选，只能切换选择项，
  final bool strictMode;

  /// 勾选样式
  final TDRadioStyle? radioCheckStyle;

  /// 是否显示下划线
  final bool showDivider;

  /// 自定义下划线
  final Widget? divider;

  TDRadioGroup({
    Key? key,
    Widget? child, // 使用child 则请勿设置direction
    Axis? direction, // direction 对 directionalTdRadios 起作用
    List<TDRadio>? directionalTdRadios,
    String? selectId, // 默认选择项的id
    bool? passThrough, // 非通栏单选样式 用于使用child 或 direction == Axis.vertical 场景
    bool cardMode = false,
    this.strictMode = true,
    this.radioCheckStyle,
    int? titleMaxLine, // item的行数
    IconBuilder? customIconBuilder,
    ContentBuilder? customContentBuilder,
    double? spacing, // icon和文字距离
    TDContentDirection? contentDirection,
    OnRadioGroupChange? onRadioGroupChange, // 切换监听
    this.showDivider = false,
    this.divider,
  })  : assert(() {
          // 使用direction属性则必须配合directionalTdRadios，child字段无效
          if (direction != null && directionalTdRadios == null) {
            throw FlutterError('[TDRadioGroup] direction and directionalTdRadios must set at the same time');
          }
          // 未使用direction则必须设置child
          if (direction == null && child == null) {
            throw FlutterError('[TDRadioGroup] direction means use child as the exact one, but child is null');
          }
          // 横向单选框 每个选项有字数限制
          if (direction == Axis.horizontal && directionalTdRadios != null) {
            directionalTdRadios.forEach((element) {
              if (element.subTitle != null) {
                throw FlutterError('horizontal radios style should not have subTilte, '
                    'because there left no room for it');
              }
            });
            var maxWordCount = 2;
            var tips = '[TDRadioGroup] radio title please not exceed $maxWordCount words.\n'
                '2tabs: 7words maximum\n'
                '3tabs: 4words maximum\n'
                '4tabs: 2words maximum';
            if (directionalTdRadios.length == 2) {
              maxWordCount = 7;
            }
            if (directionalTdRadios.length == 3) {
              maxWordCount = 4;
            }
            if (directionalTdRadios.length == 4) {
              maxWordCount = 2;
            }
            directionalTdRadios.forEach((radio) {
              if ((radio.title?.length ?? 0) > maxWordCount) {
                throw FlutterError(tips);
              }
            });
          }
          // 卡片模式要求每个TDRadio必须设置cardMode属性为true，且不能有子标题（空间不够）
          if (cardMode == true) {
            assert(direction != null && directionalTdRadios != null);
            directionalTdRadios!.forEach((element) {
              // if use cardMode at TDRadioGroup, then every TDRadio should
              // set it's own carMode to true.
              if (element.cardMode == false) {
                throw FlutterError('if use cardMode at TDRadioGroup, then every '
                    'TDRadio should set it\'s own carMode to true.');
              }
              if (element.subTitle != null && direction == Axis.horizontal) {
                throw FlutterError('horizontal card style should not have subTilte, '
                    'because there left no room for it');
              }
            });
          }
          return true;
        }()),
        super(
          child: Container(
            clipBehavior: (passThrough ?? false) && direction != Axis.horizontal ? Clip.hardEdge : Clip.none,
            decoration: (passThrough ?? false) && direction != Axis.horizontal
                ? BoxDecoration(borderRadius: BorderRadius.circular(10))
                : null,
            margin: (passThrough ?? false) && direction != Axis.horizontal
                ? const EdgeInsets.symmetric(horizontal: 16)
                : null,
            child: direction == null
                ? child!
                : (direction == Axis.vertical
                    ? ListView.separated(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: cardMode ? const EdgeInsets.symmetric(horizontal: 16) : null,
                            height: cardMode ? 82 : null,
                            child: directionalTdRadios[index],
                          );
                        },
                        itemCount: directionalTdRadios!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          if (cardMode) {
                            return const SizedBox(
                              height: 12,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      )
                    : Container(
                        margin: cardMode ? const EdgeInsets.symmetric(horizontal: 16) : null,
                        height: cardMode ? 56 : null,
                        alignment: cardMode ? Alignment.topLeft : null,
                        child: cardMode
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: directionalTdRadios!
                                    .expand(horizontalChild)
                                    .toList()
                                    .sublist(0, directionalTdRadios.length * 2 - 1),
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: directionalTdRadios!.map((e) => Expanded(child: e)).toList(),
                                  ),
                                  if (showDivider)
                                    divider ??
                                        const TDDivider(
                                          margin: EdgeInsets.only(left: 16),
                                        )
                                ],
                              ),
                      )),
          ),
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

// 横向卡片单选框，根据设计师要求'间距保持一致，宽度适应'
// 实现方法为在两个单选框中间增加一个宽度固定的SizedBox，同时每个单选框是Expanded的，这样就能
// 平分整个Row。
Iterable<Widget> horizontalChild(Widget child) sync* {
  yield Expanded(child: child);
  yield const SizedBox(
    width: 12,
  );
}
