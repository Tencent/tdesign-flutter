import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

typedef TDTapEvent = void Function();

enum TDEmptyType { plain, operation }

class TDEmpty extends StatelessWidget {
  const TDEmpty(
      {this.type = TDEmptyType.plain,
        this.image,
        this.emptyText,
        this.operationText,
        this.operationTheme,
        this.onTapEvent,
        this.emptyTextColor,
        this.emptyTextFont,
        this.customOperationWidget,
        Key? key})
      : super(key: key);

  /// 点击事件
  final TDTapEvent? onTapEvent;
  /// 展示图片
  final Widget? image;
  /// 描述文字
  final String? emptyText;
  /// 描述文字颜色
  final Color?  emptyTextColor;
  /// 描述文字大小
  final Font?  emptyTextFont;
  /// 操作按钮文案
  final String? operationText;
  /// 操作按钮文案主题色
  final TDButtonTheme? operationTheme;
  /// 类型，为operation有操作按钮，plain无按钮
  final TDEmptyType type;
  /// 自定义操作按钮
  final Widget? customOperationWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image ?? Icon(
            TDIcons.info_circle_filled,
            size: 96,
            color: TDTheme.of(context).fontGyColor3,
          ),
          Padding(padding: EdgeInsets.only(top: image == null ? 22 : 16)),
          TDText(
            emptyText ?? '',
            fontWeight: FontWeight.w400,
            font: emptyTextFont??TDTheme.of(context).fontBodyMedium,
            textColor: emptyTextColor??TDTheme.of(context).fontGyColor2.withOpacity(0.6),
          ),
          (type == TDEmptyType.operation)
              ? customOperationWidget ?? Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: TDButton(
                    text: operationText ?? '',
                    size: TDButtonSize.large,
                    theme: operationTheme??TDButtonTheme.primary,
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
