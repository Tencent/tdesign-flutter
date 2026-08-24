import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/page/t_switch_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'golden_test_utils.dart';

void main() {
  final originalGoldenComparator = useGoldenDiffTolerance();
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });
  tearDownAll(() {
    goldenFileComparator = originalGoldenComparator;
  });

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TSwitchPage(),
      ),
    );
  }

  Widget buildGoldenPage(ThemeMode mode) {
    return RepaintBoundary(
      key: const Key('switch-page-golden'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          darkTheme: TThemeBuilder.dark(TThemeData.defaultData()),
          themeMode: mode,
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Switch 开关',
              name: 'switch',
              pageBuilder: (_, __) => const TSwitchPage(),
            ),
            child: const TSwitchPage(),
          ),
        ),
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

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('Switch Demo ${mode.name} 手机视口视觉快照', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildGoldenPage(mode));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byKey(const Key('switch-page-golden')),
        matchesGoldenFile('goldens/switch_page_${mode.name}.png'),
      );
    });
  }
}
