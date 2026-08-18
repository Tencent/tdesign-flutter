import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_cell_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'golden_test_utils.dart';

void main() {
  late GoldenFileComparator originalGoldenComparator;

  setUpAll(() async {
    originalGoldenComparator = useGoldenDiffTolerance();
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
        debugShowCheckedModeBanner: false,
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TCellPage(),
      ),
    );
  }

  void configurePage(WidgetTester tester) {
    tester.view.physicalSize = const Size(750, 4800);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  String textOf(Widget? widget) => (widget! as Text).data!;

  String noteOf(Widget? widget) => switch (widget) {
    null => '-',
    TBadge(:final label) => 'badge:$label',
    TSwitch(:final value) => 'switch:$value',
    Text() => 'text:${textOf(widget)}',
    _ => widget.runtimeType.toString(),
  };

  String prefixOf(Widget? widget) => switch (widget) {
    null => '-',
    Icon(:final icon) => 'icon:${icon?.codePoint}',
    _ => widget.runtimeType.toString(),
  };

  String imageOf(Widget? widget) => switch (widget) {
    null => '-',
    TImage(:final src, :final variant, :final width, :final height) =>
      'image:$src:${variant.name}:${width}x$height',
    _ => widget.runtimeType.toString(),
  };

  String signature(TCell cell) {
    return [
      textOf(cell.title),
      cell.subtitle == null ? '-' : textOf(cell.subtitle),
      prefixOf(cell.prefix),
      imageOf(cell.image),
      noteOf(cell.note),
      'arrow:${cell.arrow}',
      'required:${cell.required}',
      'align:${cell.align?.name ?? '-'}',
      'tap:${cell.onTap != null}',
    ].join('|');
  }

  Future<void> pumpPage(WidgetTester tester) async {
    configurePage(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
  }

  TCellGroup groupOf(WidgetTester tester, String key) {
    return tester.widget<TCellGroup>(
      find.descendant(
        of: find.byKey(Key(key)),
        matching: find.byType(TCellGroup),
      ),
    );
  }

  List<TCell> cellsOf(WidgetTester tester, String key) {
    return tester
        .widgetList<TCell>(
          find.descendant(
            of: find.byKey(Key(key)),
            matching: find.byType(TCell),
          ),
        )
        .toList();
  }

  testWidgets('Cell 公开 Demo 与小程序 6 + 9 + 3 个实例逐项对应', (tester) async {
    await pumpPage(tester);

    final themeData = TThemeData.defaultData();
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      themeData.bgColorPage,
    );
    expect(find.text('用于各个类别行的信息展示。'), findsOneWidget);
    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('单行单元格'), findsOneWidget);
    expect(find.text('多行单元格'), findsOneWidget);
    expect(find.text('02 组件样式'), findsOneWidget);
    expect(find.text('卡片单元格'), findsOneWidget);
    expect(find.text('03 单元测试'), findsNothing);

    final single = cellsOf(tester, 'cell-demo-single-line');
    expect(
      find.descendant(
        of: find.byKey(const Key('cell-demo-single-line')),
        matching: find.byType(TCellGroup),
      ),
      findsNothing,
    );
    expect(single.map(signature), [
      '单行标题|-|-|-|-|arrow:true|required:false|align:-|tap:true',
      '单行标题|-|-|-|-|arrow:true|required:true|align:-|tap:true',
      '单行标题|-|-|-|badge:16|arrow:true|required:false|align:-|tap:true',
      '单行标题|-|-|-|switch:true|arrow:false|required:false|align:-|tap:true',
      '单行标题|-|-|-|text:辅助信息|arrow:true|required:false|align:-|tap:true',
      '单行标题|-|icon:${TIcons.app.codePoint}|-|-|arrow:true|required:false|align:-|tap:true',
    ]);
    expect((single[2].title! as Text).semanticsLabel, '单行标题，有16条消息');

    const description = '一段很长很长的内容文字';
    final multiple = cellsOf(tester, 'cell-demo-multiple-line');
    expect(
      find.descendant(
        of: find.byKey(const Key('cell-demo-multiple-line')),
        matching: find.byType(TCellGroup),
      ),
      findsNothing,
    );
    expect(multiple.map(signature), [
      '单行标题|$description|-|-|-|arrow:true|required:false|align:-|tap:true',
      '单行标题|$description|-|-|-|arrow:true|required:true|align:-|tap:true',
      '单行标题|$description|-|-|badge:16|arrow:true|required:false|align:-|tap:true',
      '单行标题|$description|-|-|switch:true|arrow:false|required:false|align:-|tap:true',
      '单行标题|$description|-|-|text:辅助信息|arrow:true|required:false|align:-|tap:true',
      '单行标题|$description|icon:${TIcons.app.codePoint}|-|-|arrow:true|required:false|align:-|tap:true',
      '单行标题|一段很长很长的内容文字，长文本自动换行，该选项的描述是一段很长的内容|-|-|-|arrow:false|required:false|align:-|tap:true',
      '单行标题|一段很长很长很长的内容文字|-|image:assets/img/t_avatar_1.png:circle:48.0x48.0|-|arrow:true|required:false|align:-|tap:true',
      '单行标题|$description|-|image:assets/img/t_avatar_1.png:circle:48.0x48.0|-|arrow:false|required:false|align:top|tap:true',
    ]);

    final card = groupOf(tester, 'cell-demo-card');
    expect(find.byType(TCellGroup), findsOneWidget);
    expect(card.variant, TCellGroupVariant.card);
    expect(card.cells.map(signature), [
      '单行标题|-|icon:${TIcons.service.codePoint}|-|-|arrow:true|required:false|align:-|tap:true',
      '单行标题|-|icon:${TIcons.internet.codePoint}|-|-|arrow:true|required:false|align:-|tap:true',
      '单行标题|-|icon:${TIcons.lock_on.codePoint}|-|-|arrow:true|required:false|align:-|tap:true',
    ]);
  });

  testWidgets('开关场景保持小程序默认开启并可交互', (tester) async {
    await pumpPage(tester);

    expect(tester.widget<TSwitch>(find.byType(TSwitch).first).value, isTrue);
    await tester.tap(find.byType(TSwitch).first);
    await tester.pump();
    expect(tester.widget<TSwitch>(find.byType(TSwitch).first).value, isFalse);
  });

  for (final golden in const {
    'cell-demo-single-line': 'cell_demo_single_line.png',
    'cell-demo-multiple-line': 'cell_demo_multiple_line.png',
    'cell-demo-card': 'cell_demo_card.png',
  }.entries) {
    testWidgets('${golden.key} 视觉快照', (tester) async {
      await pumpPage(tester);

      final demo = find.byKey(Key(golden.key));
      expect(demo, findsOneWidget);
      final boundary = tester.renderObject<RenderRepaintBoundary>(demo);
      final image = await boundary.toImage(pixelRatio: 2);
      addTearDown(image.dispose);
      await expectLater(image, matchesGoldenFile('goldens/${golden.value}'));
    });
  }
}
