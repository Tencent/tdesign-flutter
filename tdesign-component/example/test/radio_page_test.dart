import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/l10n/app_localizations.dart';
import 'package:tdesign_flutter_example/page/t_radio_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'golden_test_utils.dart';

const _goldenCjkFontFamily = 'Radio Golden CJK';

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
    final cjkFont = FontLoader(_goldenCjkFontFamily)
      ..addFont(
        File(
          'test/fonts/RadioGoldenCJK-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([iconFont.load(), robotoFont.load(), cjkFont.load()]);
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
          debugShowCheckedModeBanner: false,
          locale: const Locale('zh', 'CN'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          ),
          theme: _withGoldenFontFallback(
            TThemeBuilder.light(TThemeData.defaultData()),
          ),
          darkTheme: _withGoldenFontFallback(
            TThemeBuilder.dark(TThemeData.defaultData()),
          ),
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
          debugShowCheckedModeBanner: false,
          theme: _withGoldenFontFallback(
            TThemeBuilder.light(TThemeData.defaultData()),
          ),
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
    expect(find.text('用于在预设的一组选项中执行单项选择，并呈现选择结果。'), findsOneWidget);

    final verticalGroup = tester.widget<TRadioGroup<int>>(
      find.byWidgetPredicate(
        (widget) => widget is TRadioGroup<int> && widget.options.length == 4,
      ),
    );
    expect(verticalGroup.value, 1);
    expect(verticalGroup.iconType, TRadioIconType.fill);
    expect(verticalGroup.titleMaxLines, 3);
    expect(verticalGroup.subTitleMaxLines, 5);
    expect(verticalGroup.options[2].label, '单选单选单选单选单选单选单选单选单选单选单选单选单选单选');
    verticalGroup.onChanged?.call(1);
    await tester.pump();
    expect(
      tester
          .widget<TRadioGroup<int>>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is TRadioGroup<int> && widget.options.length == 4,
            ),
          )
          .value,
      isNull,
    );

    final scrollState = tester.state<ScrollableState>(
      find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      ),
    );
    final expectedText = <String>{
      '01 组件类型',
      '纵向单选框',
      '横向单选框',
      '02 组件状态',
      '单选框状态',
      '03 组件样式',
      '勾选样式',
      '勾选显示位置',
      '非通栏单选样式',
      '04 特殊样式',
      '纵向卡片单选框',
      '横向卡片单选框',
    };
    final foundText = <String>{};
    for (
      var offset = 0.0;
      offset <= scrollState.position.maxScrollExtent;
      offset += 300
    ) {
      scrollState.position.jumpTo(offset);
      await tester.pump();
      await tester.pump();
      for (final text in expectedText) {
        if (find.text(text).evaluate().isNotEmpty) {
          foundText.add(text);
        }
      }
    }
    expect(foundText, expectedText);

    scrollState.position.jumpTo(scrollState.position.maxScrollExtent);
    await tester.pump();
    await tester.pump();
    final specialGroups = find
        .byWidgetPredicate(
          (widget) => widget is TRadioGroup<int> && widget.cardMode,
        )
        .evaluate()
        .map((element) => element.widget as TRadioGroup<int>)
        .toList();
    expect(specialGroups, hasLength(2));
    expect(specialGroups.first.direction, Axis.vertical);
    expect(specialGroups.last.direction, Axis.horizontal);
    expect(specialGroups.last.columns, 3);
    expect(
      specialGroups.first.options.every(
        (item) => item.subTitle == '描述信息描述信息描述信息描述信息描述信息',
      ),
      isTrue,
    );
    expect(
      specialGroups.last.options.every((item) => item.subTitle == null),
      isTrue,
    );

    specialGroups.first.onChanged?.call(2);
    await tester.pump();
    final updatedGroups = find
        .byWidgetPredicate(
          (widget) => widget is TRadioGroup<int> && widget.cardMode,
        )
        .evaluate()
        .map((element) => element.widget as TRadioGroup<int>)
        .toList();
    expect(updatedGroups.map((group) => group.value), [2, 0]);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('Radio Demo ${mode.name} 整页视觉快照', (tester) async {
      tester.view.physicalSize = const Size(375, 2600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildPage(mode));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final description = tester.widget<Text>(
        find.text('描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息'),
      );
      final token = mode == ThemeMode.light
          ? TThemeData.defaultData()
          : TThemeData.defaultData().dark!;
      expect(description.style?.color, token.textColorSecondary);

      await expectLater(
        find.byKey(const Key('radio-page-golden')),
        matchesGoldenFile('goldens/radio_page_${mode.name}.png'),
      );
    });
  }
}

ThemeData _withGoldenFontFallback(ThemeData theme) {
  const fallback = [_goldenCjkFontFamily];
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamilyFallback: fallback),
    primaryTextTheme: theme.primaryTextTheme.apply(
      fontFamilyFallback: fallback,
    ),
  );
}
