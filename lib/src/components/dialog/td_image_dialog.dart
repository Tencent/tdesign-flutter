/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_image_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import '../../util/auto_size.dart';
import 'td_dialog_widget.dart';

/// 弹窗控件
class TDImageDialog extends StatelessWidget {
  const TDImageDialog({
    Key? key,
    required this.image,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title = '对话框标题',
    this.titleColor = Colors.black,
    this.content,
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
  })  : assert((title != null || content != null)),
        super(key: key);

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

  final TDDialogButton? leftBtn;
  final TDDialogButton? rightBtn;

  final Image image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 320.scale,
          decoration: BoxDecoration(
            color: backgroundColor, // 底色
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              child: SizedBox(
                width: 320.scale,
                height: 140.scale,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: image,
                ),
              ),
            ),
            TDInfoWidget(
              title: title,
              titleColor: titleColor,
              content: content,
              contentColor: contentColor,
            ),
            const TDDivider(
              height: 1,
            ),
            _horizontalButtons(context),
          ])),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    final left = leftBtn ?? TDDialogButton(title: '取消', action: () {});
    final right =
        rightBtn ?? TDDialogButton(title: '好的', action: () {});
    return HorizontalButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }
}
