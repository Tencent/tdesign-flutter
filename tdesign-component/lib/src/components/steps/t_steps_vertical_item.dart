import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_steps.dart';

/// Steps步骤条，垂直步骤item
class TStepsVerticalItem extends StatelessWidget {
  /// 步骤条数据
  final TStepsItemData data;

  /// 当前步骤索引
  final int index;

  /// 步骤总数
  final int stepsCount;

  /// 当前激活的步骤索引
  final int activeIndex;

  /// 步骤条状态
  final TStepsStatus status;

  /// 是否为简略模式
  final bool simple;

  /// 是否为只读模式（纯展示）
  final bool readOnly;

  /// 垂直模式下是否可点击选择
  final bool verticalSelect;

  /// item 标题组件插槽
  final Widget? titleWidget;

  /// 点击回调。
  final VoidCallback? onTap;

  const TStepsVerticalItem({
    super.key,
    required this.data,
    required this.index,
    required this.stepsCount,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    required this.verticalSelect,
    this.titleWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;

    /// 步骤条数字背景色
    var stepsNumberBgColor = theme.brandNormalColor;

    /// 步骤条数字颜色
    var stepsNumberTextColor = theme.textColorAnti;

    /// 步骤条标题颜色
    var stepsTitleColor = theme.brandNormalColor;

    /// 步骤条 icon 颜色
    var stepsIconColor = theme.brandNormalColor;

    /// 简略步骤条 icon 颜色
    var simpleStepsIconColor = theme.brandNormalColor;

    /// 是否要设置步骤图标 widget 的 Decoration
    var shouldSetIconWidgetDecoration = true;

    Widget? completeIconWidget;

    /// 已完成步骤条
    if (activeIndex > index) {
      stepsNumberBgColor = theme.brandLightColor;
      stepsNumberTextColor = theme.brandNormalColor;
      stepsTitleColor = theme.textColorPrimary;

      completeIconWidget = Icon(
        TIcons.check,
        color: theme.brandNormalColor,
        size: 16,
      );
    } else if (activeIndex < index) {
      /// 未完成步骤条
      stepsNumberBgColor = theme.bgColorComponent;
      stepsNumberTextColor = theme.textColorPlaceholder;
      stepsTitleColor = theme.textColorPlaceholder;
      stepsIconColor = theme.textColorPlaceholder;
      simpleStepsIconColor = theme.componentBorderColor;
    }

    /// 步骤条icon图标组件，默认为索引文字
    Widget? stepsIconWidget = Text(
      (index + 1).toString(),
      style: TextStyle(
        color: stepsNumberTextColor,
        fontWeight: FontWeight.w400,
        fontSize: theme.fontBodyMedium?.size ?? 14,
      ),
    );

    /// 已完成的用 icon 图标显示
    if (completeIconWidget != null) {
      stepsIconWidget = completeIconWidget;
    }

    /// 传递了成功的 icon 图标, 已完成的 step 都需要显示
    if (data.successIcon != null) {
      stepsIconWidget = Icon(
        data.successIcon,
        color: stepsIconColor,
        size: 22,
      );

      /// 传了图标则不用设置背景色
      shouldSetIconWidgetDecoration = false;
    }

    /// 错误状态
    /// 激活索引是当前索引，只有当前激活索引才需要显示
    if (status == TStepsStatus.error && activeIndex == index) {
      stepsNumberBgColor = theme.errorLightColor;
      stepsTitleColor = theme.errorNormalColor;

      if (simple) {
        simpleStepsIconColor = theme.errorNormalColor;
      } else {
        shouldSetIconWidgetDecoration = data.errorIcon == null;
        stepsIconWidget = Icon(
          data.errorIcon ?? TIcons.close,
          color: theme.errorNormalColor,
          size: shouldSetIconWidgetDecoration ? 16 : 22,
        );
      }
    }

    /// 步骤条icon图标背景和形状
    var iconWidgetDecoration = shouldSetIconWidgetDecoration
        ? BoxDecoration(color: stepsNumberBgColor, shape: BoxShape.circle)
        : null;

    /// icon组件容器大小
    double iconContainerSize = 22;

    /// icon组件容器margin
    double iconMarginBottom = 8;

    /// 简略步骤条
    if (simple || readOnly) {
      /// readOnly纯展示
      if (readOnly) {
        simpleStepsIconColor = theme.brandNormalColor;
        stepsTitleColor = theme.textColorPrimary;
      }
      iconContainerSize = 8;
      iconMarginBottom = 4;
      stepsIconWidget = null;

      /// 简略步骤条BoxDecoration
      var simpleDecoration = BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: simpleStepsIconColor,
          width: 1,
        ),
      );
      if (activeIndex == index && !readOnly) {
        simpleDecoration = BoxDecoration(
          color: simpleStepsIconColor,
          shape: BoxShape.circle,
        );
      }
      iconWidgetDecoration = simpleDecoration;
    }

    final content = Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧图标、线条
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 22,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 62),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: iconContainerSize,
                      height: 22,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: iconMarginBottom),
                      decoration: iconWidgetDecoration,
                      child: stepsIconWidget,
                    ),
                    _buildLineWidget(context)
                  ],
                ),
              ),
            ),
            // 右侧 标题、内容等
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.customTitle != null)
                    data.customTitle!
                  else if (data.title != null && data.title!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TText(
                              data.title!,
                              style: TextStyle(
                                fontWeight: (activeIndex == index && !readOnly)
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: stepsTitleColor,
                                fontSize: theme.fontBodyMedium?.size ?? 14,
                                height: 1.2,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          verticalSelect
                              ? Icon(
                                  TIcons.chevron_right,
                                  color: theme.textColorPrimary,
                                  size: 16,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  _buildContentWidget(context)
                ],
              ),
            )
          ],
        ),
      ),
    );
    return onTap == null
        ? content
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: content,
          );
  }

  Widget _buildLineWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Visibility(
        visible: index != stepsCount - 1,
        child: Container(
          width: 1,
          height: double.infinity,
          color: (activeIndex > index || readOnly)
              ? context.tTheme.brandNormalColor
              : context.tTheme.componentBorderColor,
        ),
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.customContent != null)
          data.customContent!
        else if (data.content != null && data.content!.isNotEmpty)
          TText(
            data.content!,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: context.tTheme.textColorPlaceholder,
              fontSize: context.tTheme.fontBodySmall?.size ?? 12,
            ),
          ),
      ],
    );
  }
}
