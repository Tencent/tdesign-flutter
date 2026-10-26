import 'dart:convert';
import 'dart:io';

import 'package:css2token/css2token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_route.dart';
import 'package:tdesign_flutter_example/config.dart';
import 'package:tdesign_flutter_example/l10n/app_localizations.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';
import 'package:tdesign_flutter_example/util/web_theme_message.dart';

import '../demo_page_test_utils.dart';

const _groups = ['color', 'font', 'radius', 'shadow', 'size'];
final _report = <String, Object?>{};
String _normalize(String value) =>
    value.replaceAll(RegExp('[-_]'), '').toLowerCase();

Map<String, String> _cssFor(Map<String, dynamic> baseline, String? group) {
  final css = baseline.map((key, value) => MapEntry(key, value as String));
  if (group == null) {
    return css;
  }
  for (final part in ['light', 'dark', 'extra']) {
    final variables = parseCssVariables(css[part]!);
    final changed = <String>[];
    for (final entry in variables.entries) {
      final name = entry.key;
      final value = entry.value;
      if ((group == 'color' || group == 'all') &&
          normalizeCssColor(value) != null) {
        changed.add('$name: #8137A5;');
      }
      if ((group == 'shadow' || group == 'all') &&
          name.startsWith('--td-shadow-')) {
        changed.add(
          '$name: ${name.contains('inset') ? 'inset ' : ''}0 2px ${name.contains('inset') ? '0' : '9px'} 0 #668137A5;',
        );
      }
      if ((group == 'radius' || group == 'all') &&
          name.startsWith('--td-radius-') &&
          value.endsWith('%')) {
        changed.add('$name: 3px;');
      }
      final metric = RegExp(r'^(\d+(?:\.\d+)?)px$').firstMatch(value);
      if (metric == null) {
        continue;
      }
      final number = double.parse(metric[1]!);
      if (((group == 'font' || group == 'all') &&
              (name.startsWith('--td-font-size-') ||
                  name.startsWith('--td-line-height-'))) ||
          ((group == 'radius' || group == 'all') &&
              name.startsWith('--td-radius-')) ||
          ((group == 'size' || group == 'all') &&
              RegExp(r'^--td-size-\d+$').hasMatch(name))) {
        changed.add(
          '$name: ${number + (RegExp(r'^--td-size-\d+$').hasMatch(name) ? 2 : 1)}px;',
        );
      }
    }
    if ((group == 'font' || group == 'all')) {
      changed.add('--td-font-family: "Courier New", serif;');
      changed.add('--td-font-family-medium: "Courier New", serif;');
    }
    css[part] = '${css[part]}\n:root { ${changed.join(' ')} }';
  }
  return css;
}

TThemeData _theme(Map<String, dynamic> baseline, String? group, bool dark) {
  final theme = parseWebThemeUpdateMessage({
    'type': 'flutter-css-theme-update',
    'themeMode': dark ? 'dark' : 'light',
    'baseline': baseline,
    'css': _cssFor(baseline, group),
  });
  expect(theme, isNotNull);
  return dark ? theme!.dark! : theme!;
}

bool _isRoot(Element element, Set<String> types) =>
    (types.contains('_refresh-header')
        ? element.widget.key == const ValueKey('t-pull-down-refresh-header')
        : types.contains('${element.widget.runtimeType}'.split('<').first)) ||
    element.widget.key == const ValueKey('t-rate-value-indicator');

Map<String, List<String>> _visuals(WidgetTester tester, Set<String> types) {
  final values = {for (final group in _groups) group: <String>{}};
  void textStyle(TextStyle? style) {
    if (style == null) {
      return;
    }
    if (style.color != null) {
      values['color']!.add('${style.color}');
    }
    values['font']!.add(
      '${style.fontSize}/${style.height}/${style.fontWeight}/${style.fontFamily}/${style.fontFamilyFallback}',
    );
  }

  void shape(ShapeBorder? border) {
    if (border is RoundedRectangleBorder) {
      values['radius']!.add('${border.borderRadius}');
    }
    if (border is OutlinedBorder) {
      values['color']!.add('${border.side.color}');
    }
  }

  void decoration(Decoration? decoration) {
    if (decoration is BoxDecoration) {
      values['color']!.add(
        '${decoration.color}/${decoration.border}/${decoration.gradient}',
      );
      values['radius']!.add('${decoration.borderRadius}');
      values['shadow']!.add('${decoration.boxShadow}');
    } else if (decoration is ShapeDecoration) {
      values['color']!.add('${decoration.color}/${decoration.gradient}');
      shape(decoration.shape);
      values['shadow']!.add('${decoration.shadows}');
    }
  }

  void visit(Element element) {
    final widget = element.widget;
    if (widget is Badge) {
      // Material Badge owns the dot branch; exclude the anchor child so a
      // nested button cannot masquerade as a badge token consumer.
      values['size']!.add(
        'badge:${widget.smallSize}/${widget.largeSize}/${widget.padding}',
      );
      values['color']!.add('${widget.backgroundColor}/${widget.textColor}');
      textStyle(widget.textStyle);
      return;
    }
    if (widget is CustomPaint &&
        '${widget.painter.runtimeType}' == '_OutwardCornerPainter') {
      values['radius']!.add('outward-corner:${widget.size}');
    }
    if (widget is Material) {
      values['color']!.add('${widget.color}');
      values['radius']!.add('${widget.borderRadius}');
      shape(widget.shape);
      if (widget.elevation > 0) {
        values['shadow']!.add('${widget.elevation}/${widget.shadowColor}');
      }
    }
    if (widget is ColoredBox) {
      values['color']!.add('${widget.color}');
    }
    if (widget is DecoratedBox) {
      decoration(widget.decoration);
    }
    if (widget is Container) {
      decoration(widget.decoration);
    }
    if (widget is ClipRRect) {
      values['radius']!.add('${widget.borderRadius}');
    }
    if (widget is Icon) {
      values['color']!.add('${widget.color}');
      values['size']!.add('icon:${widget.size}');
    }
    if (widget is RichText) {
      widget.text.visitChildren((span) {
        textStyle(span.style);
        return true;
      });
      textStyle(widget.text.style);
    }
    if (widget is EditableText) {
      textStyle(widget.style);
    }
    if (widget is ButtonStyleButton) {
      final style = widget.style;
      textStyle(style?.textStyle?.resolve({}));
      values['color']!.add(
        '${style?.backgroundColor?.resolve({})}/${style?.foregroundColor?.resolve({})}',
      );
      values['size']!.add(
        'button:${style?.minimumSize?.resolve({})}/${style?.padding?.resolve({})}',
      );
      shape(style?.shape?.resolve({}));
    }
    if (widget is Padding) {
      values['size']!.add('padding:${widget.padding}');
    }
    final render = element.renderObject;
    if (render is RenderBox && render.hasSize) {
      values['size']!.add(
        '${widget.runtimeType}:${render.size.width.toStringAsFixed(3)}/${render.size.height.toStringAsFixed(3)}',
      );
    }
    element.visitChildren(visit);
  }

  final roots = tester.allElements.where((e) => _isRoot(e, types));
  for (final element in roots) {
    var nested = false;
    element.visitAncestorElements((ancestor) {
      if (_isRoot(ancestor, types)) {
        nested = true;
      }
      return !nested;
    });
    if (!nested) {
      visit(element);
    }
  }
  return {for (final group in _groups) group: values[group]!.toList()..sort()};
}

Future<Map<String, List<String>>> _allVisuals(
  WidgetTester tester,
  Set<String> types,
) async {
  final merged = {for (final group in _groups) group: <String>{}};
  void collect() {
    final current = _visuals(tester, types);
    for (final group in _groups) {
      merged[group]!.addAll(current[group]!);
    }
  }

  collect();
  final views = find.byType(CustomScrollView);
  if (views.evaluate().isNotEmpty) {
    final scroll = find
        .descendant(of: views.first, matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(scroll).position;
    final original = position.pixels;
    for (
      var step = 0;
      step < 30 && position.pixels != position.maxScrollExtent;
      step++
    ) {
      position.jumpTo(
        (position.pixels + position.viewportDimension).clamp(
          0,
          position.maxScrollExtent,
        ),
      );
      await tester.pump();
      collect();
    }
    expect(
      position.pixels,
      position.maxScrollExtent,
      reason: 'long page must reach its true end',
    );
    position.jumpTo(original.clamp(0, position.maxScrollExtent));
    await tester.pump();
  }
  return {for (final group in _groups) group: merged[group]!.toList()..sort()};
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  final manifest =
      (jsonDecode(File('../tool/components.json').readAsStringSync())
              as Map)['components']
          as List;
  final baseline =
      jsonDecode(
            File('test/theme/fixtures/controller-css.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final models = exampleMap.values.expand((group) => group).toList();
  final expected =
      jsonDecode(
            File(
              'test/theme/fixtures/consumer-expectations.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final only = Platform.environment['TDESIGN_THEME_COMPONENT'];
  SharedPreferences.setMockInitialValues({});
  TExampleRoute.init();
  setUpAll(
    () => loadDemoGoldenFonts(
      const DemoPageTestSpec(
        name: 'theme-audit',
        title: '',
        page: SizedBox(),
        expectedTexts: [],
      ),
    ),
  );
  tearDownAll(() {
    final output = Platform.environment['TDESIGN_THEME_REPORT'];
    if (output != null) {
      File(
        output,
      ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(_report));
    }
  });

  test('site and Example inventories contain all 57 components', () {
    expect(manifest, hasLength(57));
    for (final entry in manifest.cast<Map>()) {
      final slug = entry['slug'] as String;
      expect(
        Directory('../../tdesign-site/docs/components/$slug').existsSync(),
        isTrue,
      );
      expect(
        models.where((model) => _normalize(model.name) == _normalize(slug)),
        hasLength(1),
        reason: slug,
      );
    }
  });

  for (final entry in manifest.cast<Map>()) {
    final slug = entry['slug'] as String;
    if (only != null && !only.split(',').contains(slug)) {
      continue;
    }
    final types = ((entry['api'] as Map)['names'] as List)
        .cast<String>()
        .toSet();
    if (slug == 'badge') {
      types.clear();
      types.addAll({'TBadgeLabel', 'Badge'});
    }
    if (slug == 'pull-down-refresh') {
      types.clear();
      types.add('_refresh-header');
    }
    if (slug == 'action-sheet') {
      types.addAll({'TActionSheetList', 'TActionSheetGrid'});
    }
    if (slug == 'popup') {
      types.add('PopupShell');
    }
    if (slug == 'dropdown-menu') {
      types.addAll({'TDropdownSingleSelectPanel', 'TDropdownMultiSelectPanel'});
    }
    if (slug == 'popover') {
      types.add('TPopoverWidget');
    }
    if (slug == 'image-viewer') {
      types.add('_TImageViewerView');
    }
    if (slug == 'theme') {
      types.addAll({
        'ThemeFunctionColorExample',
        'ThemeTextColorExample',
        'ThemeOtherColorExample',
      });
    }
    if (slug == 'toast') {
      types.addAll({'_TTextToast', '_TIconTextToast', '_TToastLoading'});
    }
    final model = models.singleWhere(
      (model) => _normalize(model.name) == _normalize(slug),
    );
    for (final dark in [false, true]) {
      testWidgets('$slug CSS consumer ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        tester.view.physicalSize = Size(600, slug == 'back-top' ? 812 : 12000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final notifier = ValueNotifier<TThemeData>(
          _theme(baseline, null, dark),
        );
        final modeProvider = ThemeModeProvider();
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: modeProvider,
            child: ValueListenableBuilder<TThemeData>(
              valueListenable: notifier,
              builder: (_, token, child) => MaterialApp(
                theme: dark
                    ? TThemeBuilder.dark(token)
                    : TThemeBuilder.light(token),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('zh'),
                home: child,
              ),
              child: Builder(
                builder: (context) => model.pageBuilder(context, model),
              ),
            ),
          ),
        );
        await _settle(tester);
        // Force lazy slivers to visit their true end before collecting all examples.
        final views = find.byType(CustomScrollView);
        if (views.evaluate().isNotEmpty) {
          final scroll = find
              .descendant(of: views.first, matching: find.byType(Scrollable))
              .first;
          final position = tester.state<ScrollableState>(scroll).position;
          for (var step = 0; step < 30; step++) {
            if (position.pixels >= position.maxScrollExtent) {
              break;
            }
            position.jumpTo(position.maxScrollExtent);
            await tester.pump();
          }
          if (slug != 'back-top') {
            position.jumpTo(0);
          }
          await tester.pump();
        }
        const keyTriggers = {
          'cascader': 'cascader-vertical-trigger',
          'picker': 'picker-area-trigger',
          'date-time-picker': 'date-time-picker-date-trigger',
          'popup': 'popup-with-title-trigger',
        };
        const buttonTriggers = {
          'drawer': '基础抽屉',
          'indexes': '胶囊索引',
          'dialog': '反馈类-带标题',
          'message': '带图标的通知',
          'toast': '纯文本',
          'popover': '带箭头',
          'image-viewer': '基础图片预览',
          'action-sheet': '常规列表型',
          'side-bar': '自定义样式',
        };
        Finder? trigger;
        if (keyTriggers.containsKey(slug)) {
          trigger = find.byKey(ValueKey(keyTriggers[slug]!));
        } else if (buttonTriggers.containsKey(slug)) {
          trigger = find.widgetWithText(TButton, buttonTriggers[slug]!);
        }
        if (slug == 'dropdown-menu') {
          trigger = find.text('三列多选').first;
        }
        if (trigger != null) {
          expect(trigger, findsWidgets, reason: '$slug trigger');
          await tester.ensureVisible(trigger.first);
          await tester.tap(trigger.first);
          await _settle(tester);
        }
        TestGesture? heldGesture;
        if (slug == 'rate') {
          heldGesture = await tester.startGesture(
            tester.getCenter(find.byType(TRate).first),
          );
          await tester.pump(const Duration(milliseconds: 600));
        }
        final results = <String, Object?>{};
        for (final group in [..._groups, 'all']) {
          notifier.value = _theme(baseline, null, dark);
          await _settle(tester);
          if (slug == 'pull-down-refresh') {
            await tester.pump(const Duration(seconds: 3));
            await tester.drag(
              find.byType(TPullDownRefresh).first,
              const Offset(0, 350),
            );
            await tester.pump(const Duration(milliseconds: 100));
          }
          if (slug == 'toast') {
            TToast.dismissAll();
            await tester.pump();
            await tester.tap(trigger!.first);
            await _settle(tester);
          }
          final before = await _allVisuals(tester, types);
          notifier.value = _theme(baseline, group, dark);
          await _settle(tester);
          final after = await _allVisuals(tester, types);
          expect(
            tester.allElements.where((e) => _isRoot(e, types)),
            isNotEmpty,
            reason: '$slug must render its real consumer',
          );
          final checks = group == 'all'
              ? (expected[slug] as List).cast<String>()
              : [if ((expected[slug] as List).contains(group)) group];
          for (final check in checks) {
            expect(
              after[check],
              isNot(equals(before[check])),
              reason:
                  '$slug/$check must react to $group CSS without replacing the page',
            );
          }
          results[group] = {
            'changed': group == 'all'
                ? checks.every(
                    (check) =>
                        jsonEncode(before[check]) != jsonEncode(after[check]),
                  )
                : jsonEncode(before[group]) != jsonEncode(after[group]),
            'roots': tester.allElements.where((e) => _isRoot(e, types)).length,
          };
        }
        final errors = <String>[];
        Object? error;
        while ((error = tester.takeException()) != null) {
          errors.add('$error');
        }
        results['errors'] = errors;
        expect(
          errors,
          isEmpty,
          reason: '$slug layout must remain valid after token updates',
        );
        _report['$slug/${dark ? 'dark' : 'light'}'] = results;
        final output = Platform.environment['TDESIGN_THEME_REPORT'];
        if (output != null) {
          File(output).writeAsStringSync(
            const JsonEncoder.withIndent('  ').convert(_report),
          );
        }
        await heldGesture?.up();
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 5));
        notifier.dispose();
        modeProvider.dispose();
      });
    }
  }
}
