import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'noticeBar')
class IconNoticeBarExample extends StatelessWidget {
  const IconNoticeBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _iconNoticeBar(context);
  }
}

Widget _iconNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '提示文字描述提示文字描述提示文字描述',
    prefix: Icon(TIcons.error_circle_filled),
  );
}
