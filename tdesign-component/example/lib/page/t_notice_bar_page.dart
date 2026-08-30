import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TNoticeBarPage extends StatelessWidget {
  const TNoticeBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'noticeBar',
      desc: '在导航栏下方，用于给用户显示提示消息。',
      showTestModule: false,
      children: const [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '纯文字的公告栏', builder: _textNoticeBar),
            ExampleItem(desc: '带图标的公告栏', builder: _iconNoticeBar),
            ExampleItem(desc: '带关闭的公告栏', builder: _closeNoticeBar),
            ExampleItem(desc: '带入口的公告栏', builder: _entranceNoticeBar),
            ExampleItem(desc: '自定义样式的公告栏', builder: _customNoticeBar),
            ExampleItem(desc: '自定义内容的公告栏', builder: _customContentNoticeBar),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '公告栏类型有普通（info）、警示（warning）、成功（success）、错误（error）',
              builder: _themeNoticeBars,
            ),
          ],
        ),
        ExampleModule(
          title: '可滚动公告栏',
          children: [
            ExampleItem(
              desc: '可滚动公告栏有水平（horizontal）和垂直（vertical）',
              builder: _scrollingNoticeBars,
            ),
          ],
        ),
      ],
    );
  }
}

@ExampleCode(group: 'noticeBar')
Widget _textNoticeBar(BuildContext context) {
  return const TNoticeBar(content: '这是一条普通的通知信息', prefix: SizedBox.shrink());
}

@ExampleCode(group: 'noticeBar')
Widget _iconNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '提示文字描述提示文字描述提示文字描述',
    prefix: Icon(TIcons.error_circle_filled),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _closeNoticeBar(BuildContext context) {
  return TNoticeBar(
    content: '这是一条普通的通知信息',
    suffixIcon: TIcons.close,
    onPressed: (target) {
      if (target == TNoticeBarTapTarget.suffix) {
        TToast.showText('点击了关闭按钮', context: context);
      }
    },
  );
}

@ExampleCode(group: 'noticeBar')
Widget _entranceNoticeBar(BuildContext context) {
  return Column(
    children: [
      TNoticeBar(
        content: '这是一条普通的通知信息',
        operation: TLink(
          child: const Text('详情'),
          colorScheme: TLinkColorScheme.primary,
          onPressed: () => TToast.showText('点击了详情', context: context),
        ),
        suffixIcon: TIcons.chevron_right,
      ),
      const SizedBox(height: 16),
      TNoticeBar(
        content: '这是一条普通的通知信息',
        suffixIcon: TIcons.chevron_right,
        onPressed: (target) {
          if (target == TNoticeBarTapTarget.suffix) {
            TToast.showText('点击了入口图标', context: context);
          }
        },
      ),
    ],
  );
}

@ExampleCode(group: 'noticeBar')
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
      prefix: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(TIcons.sound),
      ),
      suffixIcon: TIcons.chevron_right,
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _themeNoticeBars(BuildContext context) {
  return const Column(
    children: [
      TNoticeBar(content: '默认状态公告栏默认状态公告栏'),
      SizedBox(height: 16),
      TNoticeBar(status: TNoticeBarStatus.success, content: '成功状态公告栏成功状态公告栏'),
      SizedBox(height: 16),
      TNoticeBar(status: TNoticeBarStatus.warning, content: '警示状态公告栏警示状态公告栏'),
      SizedBox(height: 16),
      TNoticeBar(status: TNoticeBarStatus.error, content: '错误状态公告栏错误状态公告栏'),
    ],
  );
}

@ExampleCode(group: 'noticeBar')
Widget _customContentNoticeBar(BuildContext context) {
  return TNoticeBar(
    content: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字描述提示文字描述',
    operation: TLink(
      child: const Text('详情'),
      colorScheme: TLinkColorScheme.primary,
      onPressed: () => TToast.showText('点击了详情', context: context),
    ),
    suffixIcon: TIcons.close,
  );
}

@ExampleCode(group: 'noticeBar')
Widget _scrollingNoticeBars(BuildContext context) {
  return const Column(
    children: [
      TNoticeBar(
        content: '提示文字描述提示文字描述提示文字描述提示文字描述文',
        prefix: SizedBox.shrink(),
        marquee: true,
        speed: 80,
      ),
      SizedBox(height: 16),
      TNoticeBar(
        content: '提示文字描述提示文字描述提示文字描述提示文字描述文',
        marquee: true,
        speed: 60,
      ),
      SizedBox(height: 16),
      TNoticeBar(
        prefix: Icon(TIcons.sound),
        items: ['君不见', '高堂明镜悲白发', '朝如青丝暮成雪', '人生得意须尽欢', '莫使金樽空对月'],
        direction: Axis.vertical,
        interval: Duration(seconds: 3),
      ),
    ],
  );
}
