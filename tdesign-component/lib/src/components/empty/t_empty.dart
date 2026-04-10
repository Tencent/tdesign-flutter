import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

typedef TTapEvent = void Function();

enum TEmptyType { plain, operation }

class TEmpty extends StatelessWidget {
  const TEmpty({
    this.type = TEmptyType.plain,
    this.icon = TIcons.info_circle_filled,
    this.image,
    this.emptyText,
    this.operationText,
    this.operationTheme,
    this.onTapEvent,
    this.emptyTextColor,
    this.emptyTextFont,
    this.customOperationWidget,
    Key? key,
  }) : super(key: key);

  /// 点击事件
  final TTapEvent? onTapEvent;

  /// 图标
  final IconData? icon;

  /// 展示图片
  final Widget? image;

  /// 描述文字
  final String? emptyText;

  /// 描述文字颜色
  final Color? emptyTextColor;

  /// 描述文字大小
  final Font? emptyTextFont;

  /// 操作按钮文案
  final String? operationText;

  /// 操作按钮文案主题色
  final TButtonTheme? operationTheme;

  /// 类型，为operation有操作按钮，plain无按钮
  final TEmptyType type;

  /// 自定义操作按钮
  final Widget? customOperationWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image ??
              Icon(
                icon ?? TIcons.info_circle_filled,
                size: 96,
                color: TTheme.of(context).textColorPlaceholder,
              ),
          Padding(padding: EdgeInsets.only(top: image == null ? 22 : 16)),
          TText(
            emptyText ?? '',
            fontWeight: FontWeight.w400,
            font: emptyTextFont ?? TTheme.of(context).fontBodyMedium,
            textColor:
                emptyTextColor ?? TTheme.of(context).textColorPlaceholder,
          ),
          (type == TEmptyType.operation)
              ? customOperationWidget ??
                  Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: TButton(
                        text: operationText ?? '',
                        size: TButtonSize.large,
                        theme: operationTheme ?? TButtonTheme.primary,
                        width: 179,
                        onTap: () {
                          if (onTapEvent != null) {
                            onTapEvent!();
                          }
                        },
                      ))
              : Container()
        ],
      ),
    );
  }
}
