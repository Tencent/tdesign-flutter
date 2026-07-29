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
      children: const [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯文字的公告栏', builder: _textNoticeBar),
          ExampleItem(desc: '可滚动的公告栏', builder: _scrollNoticeBar),
          ExampleItem(
              padding: EdgeInsets.only(top: 16), builder: _scrollIconNoticeBar),
          ExampleItem(desc: '带图标的公告栏', builder: _iconNoticeBar),
          ExampleItem(desc: '带可点击后缀图标的公告栏', builder: _closeNoticeBar),
          ExampleItem(desc: '带入口的公告栏', builder: _entranceNoticeBar1),
          ExampleItem(
              padding: EdgeInsets.only(top: 16), builder: _entranceNoticeBar2),
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
      test: const [
        ExampleItem(desc: '带点击事件的公告栏', builder: _tapNoticeBar),
        ExampleItem(desc: '自定义左侧内容的公告栏', builder: _leftNoticeBar),
        ExampleItem(desc: '垂直滚动的公告栏', builder: _stepNoticeBar),
      ],
    );
  }
}

@ExampleCode(group: 'noticeBar')
Widget _textNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条普通的通知信息',
  );
}

@ExampleCode(group: 'noticeBar')
Widget _scrollNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(),
    ),
    child: const TNoticeBar(
      content: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
      marquee: true,
      speed: 50,
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _scrollIconNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        prefixIcon: TIcons.sound,
      ),
    ),
    child: const TNoticeBar(
      content: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
      marquee: true,
      speed: 50,
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _iconNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(prefixIcon: TIcons.error_circle_filled),
    ),
    child: const TNoticeBar(
      content: '这是一条普通的通知信息',
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _closeNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        prefixIcon: TIcons.error_circle_filled,
        suffixIcon: TIcons.close,
      ),
    ),
    child: TNoticeBar(
      content: '这是一条普通的通知信息',
      onPressed: (target) {
        if (target == TNoticeBarTapTarget.suffix) {
          TToast.showText('点击了关闭按钮', context: context);
        }
      },
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _entranceNoticeBar1(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(prefixIcon: TIcons.error_circle_filled),
    ),
    child: TNoticeBar(
      content: '这是一条普通的通知信息',
      right: TButton(
        child: const Text('文字按钮'),
        variant: TButtonVariant.text,
        colorScheme: TButtonColorScheme.primary,
        size: TButtonSize.extraSmall,
        onPressed: () => TToast.showText('点击了文字按钮', context: context),
      ),
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _entranceNoticeBar2(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        prefixIcon: TIcons.error_circle_filled,
        suffixIcon: TIcons.chevron_right,
      ),
    ),
    child: TNoticeBar(
      content: '这是一条普通的通知信息',
      onPressed: (target) {
        if (target == TNoticeBarTapTarget.suffix) {
          TToast.showText('点击了入口图标', context: context);
        }
      },
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _customNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      TNoticeBarThemeData(
        variant: TNoticeBarVariant.info,
        prefixIcon: TIcons.notification,
        suffixIcon: TIcons.chevron_right,
        backgroundColor: context.tTheme.bgColorComponent,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条普通的通知信息',
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _normalNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.info,
        prefixIcon: TIcons.error_circle_filled,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条普通的通知信息',
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _successNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.success,
        prefixIcon: TIcons.check_circle_filled,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条成功的通知信息',
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _warningNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.warning,
        prefixIcon: TIcons.error_circle_filled,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条警示的通知信息',
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _errorNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.error,
        prefixIcon: TIcons.error_circle_filled,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条错误的通知信息',
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _cardNoticeBar(BuildContext context) {
  var size = MediaQuery.of(context).size;
  final resolvedBg = const TNoticeBarThemeData(variant: TNoticeBarVariant.info)
      .resolve(context)
      .backgroundColor;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: resolvedBg,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          child: Theme(
            data: Theme.of(context).mergeExtension(
              const TNoticeBarThemeData(
                prefixIcon: TIcons.error_circle_filled,
                suffixIcon: TIcons.chevron_right,
              ),
            ),
            child: const TNoticeBar(
              content: '这是一条普通的通知信息',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.tTheme.bgColorContainer,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        )
      ],
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _tapNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        prefixIcon: TIcons.error_circle_filled,
        suffixIcon: TIcons.chevron_right,
      ),
    ),
    child: TNoticeBar(
      content: '这是一条普通的通知信息',
      onPressed: (trigger) {
        TToast.showText('tap:$trigger', context: context);
      },
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _leftNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(suffixIcon: TIcons.chevron_right),
    ),
    child: TNoticeBar(
      content: '这是一条普通的通知信息',
      left: TButton(
        child: const Text('文本'),
        variant: TButtonVariant.text,
        colorScheme: TButtonColorScheme.primary,
        size: TButtonSize.extraSmall,
        onPressed: () => TToast.showText('点击了文字按钮', context: context),
      ),
      onPressed: (target) {
        if (target == TNoticeBarTapTarget.suffix) {
          TToast.showText('点击了入口图标', context: context);
        }
      },
    ),
  );
}

@ExampleCode(group: 'noticeBar')
Widget _stepNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        prefixIcon: TIcons.sound,
      ),
    ),
    child: const TNoticeBar(
      items: [
        '君不见黄河之水天上来',
        '奔流到海不复回',
        '君不见',
        '这是一条很长很长的消息提醒内容测试这是一条很长很长的消息提醒内容测试'
      ],
      direction: Axis.vertical,
      marquee: true,
    ),
  );
}
