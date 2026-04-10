/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * t_image_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 't_dialog_widget.dart';

enum TDialogImagePosition {
  top,
  middle,
}

/// 带有图片的弹窗控件
class TImageDialog extends StatelessWidget {
  const TImageDialog({
    Key? key,
    required this.image,
    this.imagePosition = TDialogImagePosition.top,
    this.backgroundColor,
    this.radius = 12.0,
    this.title,
    this.titleColor,
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
    this.showCloseButton,
    this.padding,
    this.buttonWidget,
  }) : super(key: key);

  /// 背景颜色
  final Color? backgroundColor;

  /// 圆角
  final double radius;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color? titleColor;

  /// 标题对齐模式
  final AlignmentGeometry? titleAlignment;

  /// 内容Widget
  final Widget? contentWidget;

  /// 内容
  final String? content;

  /// 内容颜色
  final Color? contentColor;

  /// 左侧按钮配置
  final TDialogButtonOptions? leftBtn;

  /// 右侧按钮配置
  final TDialogButtonOptions? rightBtn;

  /// 图片
  final Image image;

  /// 图片位置
  final TDialogImagePosition? imagePosition;

  /// 显示右上角关闭按钮
  final bool? showCloseButton;

  /// 内容内边距
  final EdgeInsets? padding;

  /// 自定义按钮
  final Widget? buttonWidget;

  Widget _buildImage(BuildContext context) {
    return SizedBox(
      width: 311,
      height: 160,
      child: FittedBox(
        fit: BoxFit.cover,
        child: image,
      ),
    );
  }

  Widget _buildTopImage(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
        child: _buildImage(context),
      ),
      TDialogInfoWidget(
        title: title,
        padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
        titleColor: titleColor,
        titleAlignment: titleAlignment,
        contentWidget: contentWidget,
        content: content,
        contentColor: contentColor,
      ),
      const TDivider(height: 24, color: Colors.transparent),
      _horizontalButtons(context),
    ]);
  }

  Widget _buildMiddleImage(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TDialogInfoWidget(
        padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
        title: title,
        titleColor: titleColor,
        titleAlignment: titleAlignment,
        contentWidget: contentWidget,
        content: content,
        contentColor: contentColor,
      ),
      Container(
        padding: const EdgeInsets.only(top: 24),
        child: ClipRRect(
          child: _buildImage(context),
        ),
      ),
      const TDivider(height: 24, color: Colors.transparent),
      _horizontalButtons(context),
    ]);
  }

  Widget _buildOnlyImage(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
        child: _buildImage(context),
      ),
      const TDivider(height: 24, color: Colors.transparent),
      _horizontalButtons(context),
    ]);
  }

  Widget _buildBody(BuildContext context) {
    if (title == null && content == null) {
      return _buildOnlyImage(context);
    } else if (imagePosition == TDialogImagePosition.middle) {
      return _buildMiddleImage(context);
    } else {
      return _buildTopImage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TDialogScaffold(
        showCloseButton: showCloseButton,
        backgroundColor: backgroundColor,
        radius: radius,
        body: _buildBody(context));
  }

  Widget _horizontalButtons(BuildContext context) {
    if (buttonWidget != null) {
      return buttonWidget!;
    }
    final left = leftBtn ??
        TDialogButtonOptions(
            title: context.resource.cancel,
            theme: TButtonTheme.light,
            action: null);
    final right = rightBtn ??
        TDialogButtonOptions(
            title: context.resource.confirm,
            theme: TButtonTheme.primary,
            action: null);
    return HorizontalNormalButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }
}
