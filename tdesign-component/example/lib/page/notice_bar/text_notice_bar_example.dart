import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'noticeBar')
class TextNoticeBarExample extends StatelessWidget {
  const TextNoticeBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _textNoticeBar(context);
  }
}

Widget _textNoticeBar(BuildContext context) {
  return const TNoticeBar(content: '这是一条普通的通知信息', prefix: SizedBox.shrink());
}
