import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_tag_page.dart';

import 'demo_page_test_utils.dart';

const _tagSpec = DemoPageTestSpec(
  name: 'tag',
  title: 'Tag 标签',
  page: TTagPage(),
  expectedTexts: [
    '01 组件类型',
    '基础标签',
    '圆弧标签',
    'Mark标签',
    '02 组件状态（主题）',
    '填充型各主题',
    '描边型各主题',
    '03 组件尺寸',
    '04 可选标签',
  ],
  componentType: TTag,
);

void main() {
  registerDemoStructureTests(_tagSpec);
  registerDemoGoldenTests(_tagSpec);

  testWidgets('Tag Demo exposes every color scheme and variant', (tester) async {
    await pumpFullDemoPage(tester, _tagSpec, ThemeMode.light);

    final tags = tester.widgetList<TTag>(find.byType(TTag)).toList();
    expect(
      tags.map((tag) => tag.colorScheme).toSet(),
      containsAll(TTagColorScheme.values),
    );
    expect(
      tags.map((tag) => tag.variant).toSet(),
      containsAll(TTagVariant.values),
    );
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
