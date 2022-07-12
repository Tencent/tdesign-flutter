/*
 * Created by haozhicao@tencent.com on 6/29/22.
 * td_loading_content.dart
 * 
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../td_export.dart';
import 'td_circle_indicator.dart';
import 'td_point_indicator.dart';

class TDContentLoading extends Dialog {
  const TDContentLoading(
      {Key? key,
      required this.size,
      this.icon,
      required this.iconColor,
      required this.style,
      this.text,
      this.textColor = Colors.black})
      : super(key: key);

  final TDLoadingSize size;
  final TDLoadingIcon? icon;
  final Color iconColor;
  final String? text;
  final Color textColor;
  final TDLoadingStyle style;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Material(
          type: MaterialType.transparency, //透明类型
          child: Center(
            //保证控件居中效果
            child: _contentWidget(),
          ),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  Widget _contentWidget() {
    if (icon == null) {
      return textWidget();
    } else {
      Widget? indicator;
      switch (icon!) {
        case TDLoadingIcon.activity:
          indicator = CupertinoActivityIndicator(
            radius: size == TDLoadingSize.small
                ? 10
                : (size == TDLoadingSize.medium ? 11 : 13),
            color: iconColor,
          );
          break;
        case TDLoadingIcon.circle:
          indicator = TDCircleIndicator(
            color: iconColor,
            size: size == TDLoadingSize.small
                ? 16
                : (size == TDLoadingSize.medium ? 18 : 20),
            lineWidth: size == TDLoadingSize.small
                ? 2.5
                : (size == TDLoadingSize.medium ? 2.5 : 3.0),
          );
          break;
        case TDLoadingIcon.point:
          indicator = TDPointBounceIndicator(
            color: iconColor,
            size: size == TDLoadingSize.small
                ? 12
                : (size == TDLoadingSize.medium ? 16 : 20),
          );
          break;
      }

      if (text == null) {
        return indicator;
      } else if (style == TDLoadingStyle.vertical) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          indicator,
          SizedBox(
            height: size == TDLoadingSize.small
                ? 6
                : (size == TDLoadingSize.medium ? 8 : 10),
          ),
          textWidget(),
        ]);
      } else {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          indicator,
          SizedBox(
            width: size == TDLoadingSize.small
                ? 6
                : (size == TDLoadingSize.medium ? 8 : 10),
          ),
          textWidget()
        ]);
      }
    }
  }

  Font fitFont() {
    return size == TDLoadingSize.small
        ? Font(size: 12, lineHeight: 20)
        : (size == TDLoadingSize.medium
            ? Font(size: 14, lineHeight: 22)
            : Font(size: 16, lineHeight: 24));
  }

  Widget textWidget() {
    return TDText(
      text,
      textColor: textColor,
      fontWeight: FontWeight.w400,
      font: fitFont(),
      textAlign: TextAlign.center,
    );
  }
}
