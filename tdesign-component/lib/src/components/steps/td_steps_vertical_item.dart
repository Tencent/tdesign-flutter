import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条，垂直步骤item
class TDStepsVerticalItem extends StatelessWidget {
  final TDStepsItemData data;
  final int index;
  final int stepsCount;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;

  /// item 标题组件插槽
  final Widget? titleWidget;

  const TDStepsVerticalItem({
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);

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
        TDIcons.check,
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
        fontSize: 14,
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
    if (status == TDStepsStatus.error && activeIndex == index) {
      stepsNumberBgColor = theme.errorLightColor;
      stepsTitleColor = theme.errorNormalColor;

      if (simple) {
        simpleStepsIconColor = theme.errorNormalColor;
      } else {
        shouldSetIconWidgetDecoration = data.errorIcon == null;
        stepsIconWidget = Icon(
          data.errorIcon ?? TDIcons.close,
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

    return Container(
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
                            child: TDText(
                              data.title!,
                              style: TextStyle(
                                fontWeight: (activeIndex == index && !readOnly)
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: stepsTitleColor,
                                fontSize: 14,
                                height: 1.2,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          verticalSelect
                              ? Icon(
                                  TDIcons.chevron_right,
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
              ? TDTheme.of(context).brandNormalColor
              : TDTheme.of(context).componentBorderColor,
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
          TDText(
            data.content!,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: TDTheme.of(context).textColorPlaceholder,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
