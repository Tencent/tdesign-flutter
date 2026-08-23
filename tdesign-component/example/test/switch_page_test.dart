import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_switch_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TSwitchPage(),
      ),
    );
  }

  Future<void> visitPage(WidgetTester tester, void Function() inspect) async {
    final scrollable = find.byType(Scrollable).first;
    final state = tester.state<ScrollableState>(scrollable);
    for (
      var offset = 0.0;
      offset <= state.position.maxScrollExtent;
      offset += 240
    ) {
      state.position.jumpTo(offset);
      await tester.pump();
      inspect();
    }
    state.position.jumpTo(state.position.maxScrollExtent);
    await tester.pump();
    inspect();
  }

  testWidgets('Switch 示例按小程序分组展示类型、状态和尺寸', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final visibleExamples = <String>{};
    await visitPage(tester, () {
      for (final text in const [
        '01 组件类型',
        '02 组件状态',
        '03 组件样式',
        '基础开关',
        '带描述开关',
        '自定义颜色开关',
        '开关尺寸',
        '大尺寸 32',
        '中尺寸 28',
        '小尺寸 24',
      ]) {
        if (find.text(text).evaluate().isNotEmpty) {
          visibleExamples.add(text);
        }
      }
    });
    expect(
      visibleExamples,
      containsAll(const [
        '01 组件类型',
        '02 组件状态',
        '03 组件样式',
        '基础开关',
        '带描述开关',
        '自定义颜色开关',
        '开关尺寸',
        '大尺寸 32',
        '中尺寸 28',
        '小尺寸 24',
      ]),
    );
  });

  testWidgets('Switch 示例包含文字、图标、加载和禁用状态', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final variants = <TSwitchVariant?>{};
    final loadingValues = <bool>{};
    final disabledValues = <bool>{};
    await visitPage(tester, () {
      for (final widget in tester.widgetList<TSwitch>(find.byType(TSwitch))) {
        variants.add(widget.variant);
        if (widget.variant == TSwitchVariant.loading) {
          loadingValues.add(widget.value);
        }
        if (widget.variant == null && widget.onChanged == null) {
          disabledValues.add(widget.value);
        }
      }
    });

    expect(variants, contains(TSwitchVariant.text));
    expect(variants, contains(TSwitchVariant.icon));
    expect(loadingValues, containsAll(const [false, true]));
    expect(disabledValues, containsAll(const [false, true]));
  });
}
