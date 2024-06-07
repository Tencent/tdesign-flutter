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
      desc: '在导航栏下方，用于给用户显示提示消息。',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯文字的公告栏', builder: _textNoticeBar),
          ExampleItem(desc: '可滚动的公告栏', builder: _scrollNoticeBar),
          // ExampleItem(builder: _scrollIconNoticeBar),
          // ExampleItem(desc: '步进滚动通知', builder: _stepNoticeBar),
          // ExampleItem(desc: '带图标步进通知', builder: _stepIconNoticeBar),
          // ExampleItem(desc: '带图标垂直步进通知', builder: _stepVerticalIconNoticeBar),
        ]),
        ExampleModule(title: '组件样式', children: [
          // ExampleItem(desc: '背景色', builder: _setBgColorNoticeBar),
          // ExampleItem(desc: '文字大小', builder: _setFontSizeNoticeBar),
        ])
      ],
    );
  }
}

@Demo(group: 'noticeBar')
Widget _textNoticeBar(BuildContext context) {
  return const TDNoticeBar(context: '这是一条普通的通知信息');
}

@Demo(group: 'noticeBar')
Widget _scrollNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
    marquee: true,
    speed: 50,
  );
}

@Demo(group: 'noticeBar')
Widget _stepNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: ['这是第一条通知', '这是第二条通知', '这是第三条通知'],
    interval: 2000,
    speed: 50,
  );
}

@Demo(group: 'noticeBar')
Widget _scrollIconNoticeBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: TDNoticeBar(
      context: '这是一条滚动通知',
      speed: 50,
      left: Icon(TDIcons.sound, color: TDTheme.of(context).brandNormalColor),
    ),
  );
}

@Demo(group: 'noticeBar')
Widget _stepIconNoticeBar(BuildContext context) {
  return TDNoticeBar(
    context: const ['这是第一条通知', '这是第二条通知', '这是第三条通知'],
    interval: 2000,
    speed: 50,
    left: Icon(TDIcons.sound, color: TDTheme.of(context).brandNormalColor),
    right: Icon(TDIcons.chevron_right, color: TDTheme.of(context).grayColor8),
  );
}

@Demo(group: 'noticeBar')
Widget _stepVerticalIconNoticeBar(BuildContext context) {
  return TDNoticeBar(
    context: const ['这是第一条通知', '这是第二条通知', '这是第三条通知'],
    interval: 2000,
    speed: 300,
    direction: Axis.vertical,
    left: Icon(TDIcons.sound, color: TDTheme.of(context).brandNormalColor),
    right: Icon(TDIcons.chevron_right, color: TDTheme.of(context).grayColor8),
  );
}

@Demo(group: 'noticeBar')
Widget _setBgColorNoticeBar(BuildContext context) {
  return TDNoticeBar(
    context: '这是一条滚动通知',
    style: TDNoticeBarStyle(textStyle: const TextStyle(color: Colors.white)),
    speed: 50,
  );
}

@Demo(group: 'noticeBar')
Widget _setFontSizeNoticeBar(BuildContext context) {
  return TDNoticeBar(
    context: '这是一条滚动通知',
    style: TDNoticeBarStyle(textStyle: const TextStyle(fontSize: 24)),
    speed: 50,
  );
}
