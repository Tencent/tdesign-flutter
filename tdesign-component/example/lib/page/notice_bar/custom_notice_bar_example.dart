import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'noticeBar')
class CustomNoticeBarExample extends StatelessWidget {
  const CustomNoticeBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _customNoticeBar(context);
  }
}

Widget _customNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      TNoticeBarThemeData(
        backgroundColor: context.tTheme.bgColorComponent,
        leftIconColor: context.tTheme.textColorPrimary,
      ),
    ),
    child: const TNoticeBar(
      content: '提示文字描述提示文字描述提示文字描述',
      prefix: Icon(TIcons.sound),
      suffixIcon: TIcons.chevron_right,
    ),
  );
}
