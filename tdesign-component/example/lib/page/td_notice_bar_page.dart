/// @Type Flutter
/// @Author lwb
/// @Date 2024/5/28

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDNoticeBarPage extends StatelessWidget {
  const TDNoticeBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      exampleCodeGroup: 'noticeBar',
      desc: '用于警告或提示。',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯文字通知', builder: _textNoticeBar),
          ExampleItem(desc: '滚动通知', builder: _scrollNoticeBar),
          ExampleItem(desc: '步进滚动通知', builder: _stepNoticeBar),
          ExampleItem(desc: '带图标滚动通知', builder: _scrollIconNoticeBar),
          ExampleItem(desc: '带图标步进通知', builder: _stepIconNoticeBar),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '背景色', builder: _setBgColorNoticeBar),
          ExampleItem(desc: '文字大小', builder: _setFontSizeNoticeBar),
        ])
      ],
    );
  }
}

@Demo(group: 'noticeBar')
Widget _textNoticeBar(BuildContext context) {
  return const TDNoticeBar(text: '这是静止的通知内容');
}

@Demo(group: 'noticeBar')
Widget _scrollNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    text: '这是一条滚动通知',
    type: TdNoticeBarType.scroll,
    duration: 2000,
  );
}

@Demo(group: 'noticeBar')
Widget _stepNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    textList: ['这是第一条通知', '这是第二条通知', '这是第三条通知'],
    type: TdNoticeBarType.step,
    stepDuration: 2000,
    duration: 1000,
  );
}

@Demo(group: 'noticeBar')
Widget _scrollIconNoticeBar(BuildContext context) {
  return TDNoticeBar(
    text: '这是一条滚动通知',
    duration: 2000,
    type: TdNoticeBarType.scroll,
    left: Icon(TDIcons.sound, color: TDTheme.of(context).brandNormalColor),
    right: Icon(TDIcons.chevron_right, color: TDTheme.of(context).grayColor8),
  );
}

@Demo(group: 'noticeBar')
Widget _stepIconNoticeBar(BuildContext context) {
  return TDNoticeBar(
    textList: const ['这是第一条通知', '这是第二条通知', '这是第三条通知'],
    type: TdNoticeBarType.step,
    stepDuration: 2000,
    duration: 1000,
    left: Icon(TDIcons.sound, color: TDTheme.of(context).brandNormalColor),
    right: Icon(TDIcons.chevron_right, color: TDTheme.of(context).grayColor8),
  );
}

@Demo(group: 'noticeBar')
Widget _setBgColorNoticeBar(BuildContext context) {
  return TDNoticeBar(
    text: '这是一条滚动通知',
    textStyle: const TextStyle(color: Colors.white),
    duration: 2000,
    type: TdNoticeBarType.scroll,
    backgroundColor: TDTheme.of(context).brandNormalColor,
  );
}

@Demo(group: 'noticeBar')
Widget _setFontSizeNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    text: '这是一条滚动通知',
    textStyle: TextStyle(fontSize: 24),
    duration: 3000,
    type: TdNoticeBarType.scroll,
  );
}
