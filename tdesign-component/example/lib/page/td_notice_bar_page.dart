/// @Type Flutter
/// @Author lwb
/// @Date 2024/5/28

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      backgroundColor: Colors.white,
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯文字的公告栏', builder: _textNoticeBar),
          ExampleItem(desc: '可滚动的公告栏', builder: _scrollNoticeBar),
          ExampleItem(builder: _scrollIconNoticeBar),
          ExampleItem(desc: '带图标的公告栏', builder: _iconNoticeBar),
          ExampleItem(desc: '带关闭的公告栏', builder: _closeNoticeBar),
          ExampleItem(desc: '带入口的公告栏', builder: _entranceNoticeBar1),
          ExampleItem(builder: _entranceNoticeBar2),
          ExampleItem(desc: '自定义样式的公告栏', builder: _customNoticeBar),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '普通通知', builder: _normalNoticeBar),
          ExampleItem(desc: '成功通知', builder: _successNoticeBar),
          ExampleItem(desc: '警示通知', builder: _warningNoticeBar),
          ExampleItem(desc: '错误通知', builder: _errorNoticeBar),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '卡片顶部', builder: _cardNoticeBar),
        ])
      ],
      test: [
        ExampleItem(desc: '带点击事件的公告栏', builder: _tapNoticeBar),
        ExampleItem(desc: '自定义左侧内容的公告栏', builder: _leftNoticeBar),
        ExampleItem(desc: '垂直滚动的公告栏', builder: _stepNoticeBar),
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
Widget _scrollIconNoticeBar(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: TDNoticeBar(
      context: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
      speed: 50,
      prefixIcon: TDIcons.sound,
      marquee: true,
    ),
  );
}

@Demo(group: 'noticeBar')
Widget _iconNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
  );
}

@Demo(group: 'noticeBar')
Widget _closeNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    suffixIcon: TDIcons.close,
  );
}

@Demo(group: 'noticeBar')
Widget _entranceNoticeBar1(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    right: TDButton(
      text: '文字按钮',
      type: TDButtonType.text,
      theme: TDButtonTheme.primary,
      size: TDButtonSize.extraSmall,
      height: 22,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    ),
  );
}

@Demo(group: 'noticeBar')
Widget _entranceNoticeBar2(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: TDNoticeBar(
      context: '这是一条普通的通知信息',
      prefixIcon: TDIcons.error_circle_filled,
      suffixIcon: TDIcons.chevron_right,
    ),
  );
}

@Demo(group: 'noticeBar')
Widget _customNoticeBar(BuildContext context) {
  return TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.notification,
    suffixIcon: TDIcons.chevron_right,
    style: TDNoticeBarStyle(backgroundColor: TDTheme.of(context).grayColor3),
  );
}

@Demo(group: 'noticeBar')
Widget _normalNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.info,
  );
}

@Demo(group: 'noticeBar')
Widget _successNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.success,
  );
}

@Demo(group: 'noticeBar')
Widget _warningNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.warning,
  );
}

@Demo(group: 'noticeBar')
Widget _errorNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.error,
  );
}

@Demo(group: 'noticeBar')
Widget _cardNoticeBar(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: TDNoticeBarStyle.generateTheme(context).backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(9)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0d000000),
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
        BoxShadow(
          color: Color(0x0f000000),
          blurRadius: 10,
          spreadRadius: 1,
          offset: Offset(0, 8),
        ),
        BoxShadow(
          color: Color(0x1a000000),
          blurRadius: 5,
          spreadRadius: -3,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: size.width - 32,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          clipBehavior: Clip.hardEdge,
          child: const TDNoticeBar(
            context: '这是一条普通的通知信息',
            prefixIcon: TDIcons.error_circle_filled,
            suffixIcon: TDIcons.chevron_right,
          ),
        ),
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        )
      ],
    ),
  );
}

@Demo(group: 'noticeBar')
Widget _tapNoticeBar(BuildContext context) {
  return TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    suffixIcon: TDIcons.chevron_right,
    onTap: (trigger) {
      TDToast.showText('tap:$trigger', context: context);
    },
  );
}

@Demo(group: 'noticeBar')
Widget _leftNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    suffixIcon: TDIcons.chevron_right,
    left: TDButton(
      text: '文本',
      type: TDButtonType.text,
      theme: TDButtonTheme.primary,
      size: TDButtonSize.extraSmall,
      height: 22,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    ),
  );
}

@Demo(group: 'noticeBar')
Widget _stepNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: ['君不见黄河之水天上来', '奔流到海不复回', '君不见'],
    direction: Axis.vertical,
    prefixIcon: TDIcons.sound,
    marquee: true,
  );
}
