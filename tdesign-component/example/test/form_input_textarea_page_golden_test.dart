import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/page/t_form_page.dart';
import 'package:tdesign_flutter_example/page/t_input_page.dart';
import 'package:tdesign_flutter_example/page/t_textarea_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'golden_test_utils.dart';

const _pageWidth = 375.0;
// Linux + Flutter 3.32 是唯一权威 Golden 环境，保持 0% 严格比较。
// 其他宿主仅用于本地预检；3% 来自同一页面在 macOS/Linux 间已观测的
// 1.90%～2.58% 字体栅格差异，不是全仓默认容差。
const _nonLinuxPreviewDiffRate = 0.03;
const _geometryEpsilon = 0.000001;

void main() {
  late GoldenFileComparator originalGoldenComparator;

  setUpAll(() async {
    originalGoldenComparator = Platform.isLinux
        ? goldenFileComparator
        : useGoldenDiffTolerance(maxDiffRate: _nonLinuxPreviewDiffRate);
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFont = FontLoader('Roboto')
      ..addFont(
        File(
          '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });
  tearDownAll(() => goldenFileComparator = originalGoldenComparator);

  const pages = <_DemoPage>[
    _DemoPage(
      name: 'input',
      title: 'Input 输入框',
      height: 2994,
      contentHeight: 2946,
      components: [
        _ComponentGeometry(
          type: TInput,
          count: 26,
          first: Rect.fromLTRB(96, 248, 359, 272),
          last: Rect.fromLTRB(96, 2930, 359, 2954),
        ),
        _ComponentGeometry(
          type: TFormItem,
          count: 25,
          first: Rect.fromLTRB(0, 232, 375, 288),
          last: Rect.fromLTRB(0, 2914, 375, 2970),
        ),
      ],
      child: TInputViewPage(),
    ),
    _DemoPage(
      name: 'textarea',
      title: 'Textarea 多行文本框',
      height: 1966,
      contentHeight: 1918,
      components: [
        _ComponentGeometry(
          type: TTextarea,
          count: 8,
          first: Rect.fromLTRB(0, 232, 375, 360),
          last: Rect.fromLTRB(16, 1818, 359, 1942),
        ),
        _ComponentGeometry(
          type: TFormItem,
          count: 1,
          first: Rect.fromLTRB(0, 1774, 375, 1966),
          last: Rect.fromLTRB(0, 1774, 375, 1966),
        ),
      ],
      child: TTextareaPage(),
    ),
    _DemoPage(
      name: 'form',
      title: 'Form 表单',
      height: 1135,
      contentHeight: 1064.3333333333335,
      components: [
        _ComponentGeometry(
          type: TTextarea,
          count: 1,
          first: Rect.fromLTRB(96, 801, 359, 901),
          last: Rect.fromLTRB(96, 801, 359, 901),
        ),
        _ComponentGeometry(
          type: TFormItem,
          count: 9,
          first: Rect.fromLTRB(0, 345, 375, 425),
          last: Rect.fromLTRB(0, 917, 375, 1031.3333333333335),
        ),
        _ComponentGeometry(
          type: TUpload,
          count: 1,
          first: Rect.fromLTRB(96, 933, 359, 1015.3333333333334),
          last: Rect.fromLTRB(96, 933, 359, 1015.3333333333334),
        ),
      ],
      child: TFormPage(),
    ),
  ];

  for (final page in pages) {
    for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
      final brightness = themeMode == ThemeMode.light ? 'light' : 'dark';
      testWidgets('完整 ${page.name} $brightness Demo 快照', (tester) async {
        tester.view.physicalSize = Size(_pageWidth, page.height);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(_buildPage(page, themeMode));
        await tester.pump();

        _expectRect(
          tester.getRect(find.byWidget(page.child)),
          Rect.fromLTWH(0, 0, _pageWidth, page.height),
        );
        final pageScrollView = find.byType(CustomScrollView);
        expect(pageScrollView, findsOneWidget);
        _expectRect(
          tester.getRect(pageScrollView),
          Rect.fromLTRB(0, 48, _pageWidth, page.height),
        );
        final pageScrollable = find
            .descendant(of: pageScrollView, matching: find.byType(Scrollable))
            .first;
        expect(
          tester
              .state<ScrollableState>(pageScrollable)
              .position
              .maxScrollExtent,
          0,
        );
        _expectContentHeight(tester, pageScrollView, page.contentHeight);
        _expectComponentGeometry(tester, page.components);
        if (page.name == 'form') {
          _expectDirectFormInputs(tester);
        }
        _expectKeyBorders(tester, page.name);

        await expectLater(
          find.byWidget(page.child),
          matchesGoldenFile('goldens/${page.name}_demo_$brightness.png'),
        );
      });
    }
  }
}

void _expectContentHeight(
  WidgetTester tester,
  Finder scrollView,
  double expectedHeight,
) {
  final viewportFinder = find.descendant(
    of: scrollView,
    matching: find.byType(Viewport),
  );
  expect(viewportFinder, findsOneWidget);
  final viewport = tester.renderObject<RenderViewport>(viewportFinder);
  var contentHeight = 0.0;
  var sliver = viewport.firstChild;
  while (sliver != null) {
    contentHeight += sliver.geometry!.scrollExtent;
    sliver = viewport.childAfter(sliver);
  }
  expect(contentHeight, closeTo(expectedHeight, _geometryEpsilon));
}

void _expectComponentGeometry(
  WidgetTester tester,
  List<_ComponentGeometry> components,
) {
  for (final component in components) {
    final finder = find.byType(component.type);
    expect(finder, findsNWidgets(component.count));
    _expectRect(tester.getRect(finder.first), component.first);
    _expectRect(tester.getRect(finder.last), component.last);
  }
}

void _expectDirectFormInputs(WidgetTester tester) {
  final inputs = tester
      .widgetList<TFormItem>(find.byType(TFormItem))
      .map((item) => item.child)
      .whereType<TInput>()
      .toList(growable: false);
  expect(inputs, hasLength(2));
  _expectRect(
    tester.getRect(find.byWidget(inputs.first)),
    const Rect.fromLTRB(96, 361, 359, 385),
  );
  _expectRect(
    tester.getRect(find.byWidget(inputs.last)),
    const Rect.fromLTRB(96, 441, 359, 465),
  );
}

void _expectRect(Rect actual, Rect expected) {
  expect(actual.left, closeTo(expected.left, _geometryEpsilon));
  expect(actual.top, closeTo(expected.top, _geometryEpsilon));
  expect(actual.right, closeTo(expected.right, _geometryEpsilon));
  expect(actual.bottom, closeTo(expected.bottom, _geometryEpsilon));
}

void _expectKeyBorders(WidgetTester tester, String pageName) {
  if (pageName == 'input' || pageName == 'form') {
    final formItemBorder = find.descendant(
      of: find.byType(TFormItem).first,
      matching: find.byWidgetPredicate(_hasSolidBottomBorder),
    );
    expect(formItemBorder, findsOneWidget);
  }
  if (pageName == 'textarea') {
    final textareaBorder = find.descendant(
      of: find.byType(TTextarea).last,
      matching: find.byWidgetPredicate(_hasSolidFullBorder),
    );
    expect(textareaBorder, findsOneWidget);
  }
}

bool _hasSolidBottomBorder(Widget widget) {
  final border = _boxBorder(widget);
  return border != null &&
      border.top.style == BorderStyle.none &&
      border.left.style == BorderStyle.none &&
      border.right.style == BorderStyle.none &&
      border.bottom.style == BorderStyle.solid &&
      border.bottom.width == 1;
}

bool _hasSolidFullBorder(Widget widget) {
  final border = _boxBorder(widget);
  if (border == null) {
    return false;
  }
  return [
    border.top,
    border.right,
    border.bottom,
    border.left,
  ].every((side) => side.style == BorderStyle.solid && side.width == 1);
}

Border? _boxBorder(Widget widget) {
  if (widget is! DecoratedBox || widget.decoration is! BoxDecoration) {
    return null;
  }
  final border = (widget.decoration as BoxDecoration).border;
  return border is Border ? border : null;
}

Widget _buildPage(_DemoPage page, ThemeMode themeMode) {
  final model = ExamplePageModel(
    text: page.title,
    name: page.name,
    pageBuilder: (_, __) => page.child,
  );
  return ChangeNotifierProvider(
    create: (_) => ThemeModeProvider(),
    child: MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      darkTheme: TThemeBuilder.dark(TThemeData.defaultData()),
      themeMode: themeMode,
      home: ExamplePageInheritedTheme(model: model, child: page.child),
    ),
  );
}

class _DemoPage {
  const _DemoPage({
    required this.name,
    required this.title,
    required this.height,
    required this.contentHeight,
    required this.components,
    required this.child,
  });

  final String name;
  final String title;
  final double height;
  final double contentHeight;
  final List<_ComponentGeometry> components;
  final Widget child;
}

class _ComponentGeometry {
  const _ComponentGeometry({
    required this.type,
    required this.count,
    required this.first,
    required this.last,
  });

  final Type type;
  final int count;
  final Rect first;
  final Rect last;
}
