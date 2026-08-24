import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_radio_page.dart';
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

  Widget buildPage(ThemeMode mode) {
    return RepaintBoundary(
      key: const Key('radio-page-golden'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          darkTheme: TThemeBuilder.dark(TThemeData.defaultData()),
          themeMode: mode,
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Radio 单选框',
              name: 'radio',
              pageBuilder: (_, __) => const TRadioPage(),
            ),
            child: const TRadioPage(),
          ),
        ),
      ),
    );
  }

  testWidgets('Radio Demo follows the official groups', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Radio 单选框',
              name: 'radio',
              pageBuilder: (_, __) => const TRadioPage(),
            ),
            child: const TRadioPage(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('纵向单选框'), findsOneWidget);

    final scrollState = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    var foundStatus = false;
    var foundStyle = false;
    var foundSpecial = false;
    for (
      var offset = 0.0;
      offset <= scrollState.position.maxScrollExtent;
      offset += 300
    ) {
      scrollState.position.jumpTo(offset);
      await tester.pump();
      foundStatus |= find.text('02 组件状态').evaluate().isNotEmpty;
      foundStyle |= find.text('03 组件样式').evaluate().isNotEmpty;
      foundSpecial |= find.text('04 特殊样式').evaluate().isNotEmpty;
    }
    expect(foundStatus, isTrue);
    expect(foundStyle, isTrue);
    expect(foundSpecial, isTrue);

    final verticalCardGroups = find
        .byWidgetPredicate(
          (widget) =>
              widget is TRadioGroup<String> &&
              widget.cardMode &&
              widget.direction == Axis.vertical,
        )
        .evaluate()
        .map((element) => element.widget as TRadioGroup<String>)
        .toList();
    expect(verticalCardGroups, hasLength(2));
    expect(verticalCardGroups.first.itemBuilder, isNull);
    expect(verticalCardGroups.last.itemBuilder, isNotNull);
    expect(
      verticalCardGroups.first.options.every((item) => item.subTitle == null),
      isTrue,
    );
    expect(
      verticalCardGroups.last.options.every((item) => item.subTitle == '描述信息'),
      isTrue,
    );

    verticalCardGroups.first.onChanged?.call('b');
    await tester.pump();
    var updatedGroups = find
        .byWidgetPredicate(
          (widget) =>
              widget is TRadioGroup<String> &&
              widget.cardMode &&
              widget.direction == Axis.vertical,
        )
        .evaluate()
        .map((element) => element.widget as TRadioGroup<String>)
        .toList();
    expect(updatedGroups.map((group) => group.value), ['b', 'a']);

    updatedGroups.last.onChanged?.call('c');
    await tester.pump();
    updatedGroups = find
        .byWidgetPredicate(
          (widget) =>
              widget is TRadioGroup<String> &&
              widget.cardMode &&
              widget.direction == Axis.vertical,
        )
        .evaluate()
        .map((element) => element.widget as TRadioGroup<String>)
        .toList();
    expect(updatedGroups.map((group) => group.value), ['b', 'c']);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('Radio Demo ${mode.name} 手机视口视觉快照', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildPage(mode));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byKey(const Key('radio-page-golden')),
        matchesGoldenFile('goldens/radio_page_${mode.name}.png'),
      );
    });
  }
}
