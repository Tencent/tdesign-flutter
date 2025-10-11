import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条，水平步骤item
class TDStepsHorizontalItem extends StatelessWidget {
  final TDStepsItemData data;
  final int index;
  final int stepsCount;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;

  const TDStepsHorizontalItem({
    super.key,
    required this.data,
    required this.index,
    required this.stepsCount,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
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

    /// 步骤条icon颜色
    var stepsIconColor = theme.brandNormalColor;

    /// 简略步骤条icon颜色
    var simpleStepsIconColor = theme.brandNormalColor;

    /// 是否要设置步骤图标widget的Decoration
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

    /// 已完成的用icon图标显示
    if (completeIconWidget != null) {
      stepsIconWidget = completeIconWidget;
    }

    /// 传递了成功的icon图标, 已完成的step都需要显示
    if (data.successIcon != null) {
      stepsIconWidget = Icon(
        data.successIcon,
        color: stepsIconColor,
        size: 22,
      );

      /// 传了图标则不用设置背景色
      shouldSetIconWidgetDecoration = false;
    }

    /// 错误状态处理
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

    /// 简略步骤条
    if (simple || readOnly) {
      /// readOnly纯展示
      if (readOnly) {
        simpleStepsIconColor = theme.brandNormalColor;
        stepsTitleColor = theme.textColorPrimary;
      }
      iconContainerSize = 8;
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

    var leftLineColor = (activeIndex >= index || readOnly)
        ? theme.brandNormalColor
        : theme.componentBorderColor;
    var rightLineColor = (activeIndex > index || readOnly)
        ? theme.brandNormalColor
        : theme.componentBorderColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLineWidget(context,
                visible: index != 0, color: leftLineColor),
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 8, right: 8),
              decoration: iconWidgetDecoration,
              child: stepsIconWidget,
            ),
            _buildLineWidget(context,
                visible: index != stepsCount - 1, color: rightLineColor),
          ],
        ),
        _buildTitleWidget(context, stepsTitleColor),
        _buildContentWidget(context)
      ],
    );
  }

  /// 构建步骤条横线组件
  Widget _buildLineWidget(
    BuildContext context, {
    required bool visible,
    required Color color,
  }) {
    return Expanded(
      flex: 1,
      child: Visibility(
        visible: visible,
        child: Container(width: double.infinity, height: 1, color: color),
      ),
    );
  }

  /// 构建标题组件
  Widget _buildTitleWidget(BuildContext context, Color stepsTitleColor) {
    if (data.customTitle != null) {
      return data.customTitle!;
    }

    final title = data.title ?? '';
    if (title.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      alignment: Alignment.center,
      child: TDText(
        title,
        style: TextStyle(
          fontWeight: (activeIndex == index && !readOnly)
              ? FontWeight.w600
              : FontWeight.w400,
          color: stepsTitleColor,
          fontSize: 14,
        ),
      ),
    );
  }

  /// 构建内容组件
  Widget _buildContentWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      alignment: Alignment.center,
      child: data.customContent ??
          TDText(
            data.content ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: TDTheme.of(context).textColorPlaceholder,
              fontSize: 12,
            ),
          ),
    );
  }
}
