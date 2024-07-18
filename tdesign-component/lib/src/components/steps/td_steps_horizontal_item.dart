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
    /// 步骤条数字背景色
    var stepsNumberBgColor = TDTheme.of(context).brandNormalColor;
    /// 步骤条数字颜色
    var stepsNumberTextColor = TDTheme.of(context).whiteColor1;
    /// 步骤条标题颜色
    var stepsTitleColor = TDTheme.of(context).brandColor7;
    /// 步骤条icon颜色
    var stepsIconColor = TDTheme.of(context).brandColor7;
    /// 简略步骤条icon颜色
    var simpleStepsIconColor = TDTheme.of(context).brandColor7;

    /// 是否要设置步骤图标widget的Decoration
    bool shouldSetIconWidgetDecoration = true;

    Widget? completeIconWidget;
    /// 错误icon图标显示
    Widget errorIconWidget = Icon(TDIcons.close, color: TDTheme.of(context).errorColor6, size: 16,);

    /// 激活索引大于当前索引
    if (activeIndex > index) {
      stepsNumberBgColor = TDTheme.of(context).brandColor1;
      stepsNumberTextColor = TDTheme.of(context).brandColor7;
      stepsTitleColor = TDTheme.of(context).fontGyColor1;
      /// 已完成的用icon图标显示
      completeIconWidget = Icon(TDIcons.check, color: TDTheme.of(context).brandColor7, size: 16,);
    }else if (activeIndex < index) {
      /// 激活索引小于当前索引
      stepsNumberBgColor = TDTheme.of(context).grayColor1;
      stepsNumberTextColor = TDTheme.of(context).fontGyColor3;
      stepsTitleColor = TDTheme.of(context).fontGyColor3;
      stepsIconColor = TDTheme.of(context).fontGyColor3;
      simpleStepsIconColor = TDTheme.of(context).grayColor4;
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
      stepsIconWidget = Icon(data.successIcon, color: stepsIconColor, size: 22,);
      /// 传了图标则不用设置背景色
      shouldSetIconWidgetDecoration = false;
    }

    /// 状态是错误状态，激活索引是当前索引，只有当前激活索引才需要显示
    if (status == TDStepsStatus.error && activeIndex == index) {
      /// 显示错误颜色
      stepsNumberBgColor = TDTheme.of(context).errorColor1;
      stepsTitleColor = TDTheme.of(context).errorColor6;
      /// 显示错误图标
      stepsIconWidget = errorIconWidget;
      if (data.errorIcon != null) {
        stepsIconWidget = Icon(data.errorIcon, color: TDTheme.of(context).errorColor6, size: 22,);
      }
      /// 传了图标则不用设置背景色等Decoration
      shouldSetIconWidgetDecoration = data.errorIcon == null;
      if (simple) {
        simpleStepsIconColor = TDTheme.of(context).errorColor6;
      }
    }

    /// 步骤条icon图标背景和形状
    BoxDecoration? iconWidgetDecoration = shouldSetIconWidgetDecoration ? BoxDecoration(
      color: stepsNumberBgColor,
      shape: BoxShape.circle,
    ): null;


    // icon组件容器大小
    double iconContainerSize = 22;

    /// 简略步骤条
    if (simple || readOnly) {
      /// readOnly纯展示
      if (readOnly) {
        simpleStepsIconColor = TDTheme.of(context).brandColor7;
        stepsTitleColor = TDTheme.of(context).fontGyColor1;
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Opacity(
                opacity: index == 0 ? 0 : 1,
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: (activeIndex >= index || readOnly) ? TDTheme.of(context).brandColor7 : TDTheme.of(context).grayColor4
                ),
              ),
            ),
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 8, right: 8),
              decoration: iconWidgetDecoration,
              child: stepsIconWidget,
            ),
            Expanded(
              flex: 1,
              child: Opacity(
                opacity: index == stepsCount - 1 ? 0 : 1,
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: (activeIndex > index || readOnly) ? TDTheme.of(context).brandColor7 : TDTheme.of(context).grayColor4,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          alignment: Alignment.center,
          child: TDText(
            data.title,
            style: TextStyle(
              fontWeight: (activeIndex == index && !readOnly)  ? FontWeight.w600 : FontWeight.w400,
              color: stepsTitleColor,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          alignment: Alignment.center,
          child: TDText(
            data.content,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: TDTheme.of(context).fontGyColor3,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

}

