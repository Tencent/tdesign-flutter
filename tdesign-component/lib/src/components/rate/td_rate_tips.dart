import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 评分提示组件
class TDRateTips extends StatelessWidget {
  const TDRateTips({
    Key? key,
    this.allowHalf = false,
    required this.activeValue,
    required this.icon,
    this.size,
    required this.getIconColor,
    required this.sizeCall,
    required this.isClick,
    required this.tipClick,
  }) : super(key: key);

  final bool? allowHalf;
  final double activeValue;
  final IconData icon;
  final double? size;
  final Color Function({double? value, bool? isActive}) getIconColor;
  final void Function(Size size) sizeCall;
  final bool isClick;
  final void Function(double value) tipClick;

  int get index => (activeValue - 0.5).floor();

  @override
  Widget build(BuildContext context) {
    final _tipKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _tipKey.currentContext?.findRenderObject() as RenderBox?;
      sizeCall(renderBox?.size ?? Size.zero);
    });
    return Container(
      key: _tipKey,
      decoration: BoxDecoration(
        color: TDTheme.of(context).whiteColor1,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(TDTheme.of(context).radiusDefault),
      ),
      padding: EdgeInsets.all(TDTheme.of(context).spacer4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (allowHalf == true && isClick) {
                tipClick(index + 0.5);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: allowHalf == true && index + 0.5 == activeValue && isClick
                    ? TDTheme.of(context).grayColor3
                    : TDTheme.of(context).whiteColor1,
                borderRadius: BorderRadius.circular(TDTheme.of(context).radiusSmall),
              ),
              padding: EdgeInsets.only(left: TDTheme.of(context).spacer4, right: TDTheme.of(context).spacer4),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.5,
                          child: Icon(
                            icon,
                            size: size ?? 24,
                            color: getIconColor(isActive: true),
                          ),
                        ),
                      ),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.5,
                          child: Icon(
                            icon,
                            size: size ?? 24,
                            color: allowHalf == true
                                ? (isClick ? getIconColor(isActive: false) : getIconColor(value: index + 1))
                                : getIconColor(isActive: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: TDText(
                      allowHalf == true ? (isClick ? '${index + 0.5}' : '${activeValue}') : '${index + 1}',
                      font: TDTheme.of(context).fontBodySmall,
                      textColor: TDTheme.of(context).fontGyColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (allowHalf == true && isClick) SizedBox(width: TDTheme.of(context).spacer4),
          if (allowHalf == true && isClick)
            GestureDetector(
              onTap: () {
                if (allowHalf == true && isClick) {
                  tipClick(index + 1.0);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: index + 1 != activeValue ? TDTheme.of(context).whiteColor1 : TDTheme.of(context).grayColor3,
                  borderRadius: BorderRadius.circular(TDTheme.of(context).radiusSmall),
                ),
                padding: EdgeInsets.only(left: TDTheme.of(context).spacer4, right: TDTheme.of(context).spacer4),
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: size ?? 24,
                      color: getIconColor(isActive: true),
                    ),
                    Center(
                      child: TDText(
                        '${index + 1}',
                        font: TDTheme.of(context).fontBodySmall,
                        textColor: TDTheme.of(context).fontGyColor1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
