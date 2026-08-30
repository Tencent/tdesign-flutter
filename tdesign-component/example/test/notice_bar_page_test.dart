import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';

import 'demo_page_test_utils.dart';
import 'notice_bar_demo_test_spec.dart';

void main() {
  testWidgets('公开 Demo 按小程序页面边界组合', (tester) async {
    await pumpFullDemoPage(tester, noticeBarDemoPageTestSpec, ThemeMode.light);

    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.showTestModule, isFalse);
    expect(page.children.map((module) => module.title), [
      '组件类型',
      '组件状态',
      '可滚动公告栏',
    ]);
    expect(page.children[0].children.map((item) => item.desc), [
      '纯文字的公告栏',
      '带图标的公告栏',
      '带关闭的公告栏',
      '带入口的公告栏',
      '自定义样式的公告栏',
      '自定义内容的公告栏',
    ]);
    expect(
      page.children[1].children.single.desc,
      '公告栏类型有普通（info）、警示（warning）、成功（success）、错误（error）',
    );
    expect(
      page.children[2].children.single.desc,
      '可滚动公告栏有水平（horizontal）和垂直（vertical）',
    );
    expect(find.textContaining('单元测试'), findsNothing);
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  });

  testWidgets('公开实例的数量、顺序与关键参数一致', (tester) async {
    await pumpFullDemoPage(tester, noticeBarDemoPageTestSpec, ThemeMode.light);

    final notices = tester
        .widgetList<TNoticeBar>(find.byType(TNoticeBar))
        .toList();
    expect(notices, hasLength(14));

    expect(notices[0].content, '这是一条普通的通知信息');
    expect(notices[0].prefixIcon, isNull);
    expect(notices[1].content, '提示文字描述提示文字描述提示文字描述');
    expect(notices[1].prefixIcon, TIcons.error_circle_filled);
    expect(notices[2].prefixIcon, TIcons.error_circle_filled);
    expect(notices[2].suffixIcon, TIcons.close);

    expect(notices[3].prefixIcon, TIcons.error_circle_filled);
    expect(notices[3].right, isA<Row>());
    expect(notices[4].prefixIcon, TIcons.error_circle_filled);
    expect(notices[4].suffixIcon, TIcons.chevron_right);
    expect(notices[5].prefixIcon, TIcons.sound);
    expect(notices[5].suffixIcon, TIcons.chevron_right);
    expect(notices[6].prefixIcon, TIcons.error_circle_filled);
    expect(notices[6].right, isA<Row>());

    expect(notices.sublist(7, 11).map((notice) => notice.content), [
      '默认状态公告栏默认状态公告栏',
      '成功状态公告栏成功状态公告栏',
      '警示状态公告栏警示状态公告栏',
      '错误状态公告栏错误状态公告栏',
    ]);
    expect(notices[7].prefixIcon, TIcons.error_circle_filled);
    expect(notices[8].prefixIcon, TIcons.check_circle_filled);
    expect(notices[9].prefixIcon, TIcons.error_circle_filled);
    expect(notices[10].prefixIcon, TIcons.error_circle_filled);

    expect(notices[11].marquee, isTrue);
    expect(notices[11].speed, 80);
    expect(notices[11].prefixIcon, isNull);
    expect(notices[12].marquee, isTrue);
    expect(notices[12].speed, 60);
    expect(notices[12].prefixIcon, TIcons.error_circle_filled);
    expect(notices[13].direction, Axis.vertical);
    expect(notices[13].prefixIcon, TIcons.error_circle_filled);
    expect(notices[13].items, [
      '君不见',
      '高堂明镜悲白发',
      '朝如青丝暮成雪',
      '人生得意须尽欢',
      '莫使金樽空对月',
    ]);

    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  });
}
