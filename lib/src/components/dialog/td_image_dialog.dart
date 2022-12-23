/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_image_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import '../../util/auto_size.dart';
import 'td_dialog_widget.dart';

enum TDDialogImagePosition {
  top,
  middle,
}

/// 弹窗控件
class TDImageDialog extends StatelessWidget {
  const TDImageDialog({
    Key? key,
    required this.image,
    this.imagePosition = TDDialogImagePosition.top,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title,
    this.titleColor = Colors.black,
    this.content,
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
  }) : super(key: key);

  /// 背景颜色
  final Color backgroundColor;

  /// 圆角
  final double radius;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color titleColor;

  /// 内容
  final String? content;

  /// 内容颜色
  final Color? contentColor;

  final TDDialogButtonOptions? leftBtn;
  final TDDialogButtonOptions? rightBtn;

  final Image image;

  /// 图片位置
  final TDDialogImagePosition? imagePosition;

  Widget _buildImage(BuildContext context) {
    return SizedBox(
      width: 320.scale,
      height: 140.scale,
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
      TDDialogInfoWidget(
        title: title,
        titleColor: titleColor,
        content: content,
        contentColor: contentColor,
      ),
      TDDivider(height: 24.scale, color: Colors.transparent),
      _horizontalButtons(context),
    ]);
  }
  
  Widget _buildMiddleImage(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TDDialogInfoWidget(
        title: title,
        titleColor: titleColor,
        content: content,
        contentColor: contentColor,
      ),
      Container(
        padding: EdgeInsets.only(top: 24.scale),
        child: ClipRRect(
          child: _buildImage(context),
        ),
      ),
      TDDivider(height: 24.scale, color: Colors.transparent),
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
      TDDivider(height: 24.scale, color: Colors.transparent),
      _horizontalButtons(context),
    ]);
  }
  
  Widget _buildBody(BuildContext context) {
    if (title == null && content == null) {
      return _buildOnlyImage(context);
    } else if (imagePosition == TDDialogImagePosition.middle) {
      return _buildMiddleImage(context);
    } else {
      return _buildTopImage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 320.scale,
          decoration: BoxDecoration(
            color: backgroundColor, // 底色
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: _buildBody(context)),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    final left = leftBtn ?? TDDialogButtonOptions(title: '取消', action: () {});
    final right = rightBtn ?? TDDialogButtonOptions(title: '好的', action: () {});
    return HorizontalNormalButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }
}
