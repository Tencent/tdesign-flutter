import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../td_export.dart';

typedef TDTapEvent = void Function();

enum TDEmptyType { plain, operation }

class TDEmpty extends StatelessWidget {
  const TDEmpty(
      {this.type = TDEmptyType.plain,
        this.image,
        this.emptyText,
        this.operationText,
        this.onTapEvent,
        Key? key})
      : super(key: key);

  /// 点击事件
  final TDTapEvent? onTapEvent;
  final Widget? image;
  final String? emptyText;
  final String? operationText;
  final TDEmptyType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image ?? Icon(
            TDIcons.info_circle_filled,
            size: 84,
            color: TDTheme.of(context).fontGyColor3,
          ),
          Padding(padding: EdgeInsets.only(top: image == null ? 22 : 16)),
          TDText(
            emptyText ?? '',
            fontWeight: FontWeight.w400,
            font: TDTheme.of(context).fontBodyMedium,
            textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
          ),
          (type == TDEmptyType.operation)
              ? Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: TDButton(
                    content: operationText ?? '',
                    size: TDButtonSize.large,
                    style: TDButtonStyle.primary(),
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
