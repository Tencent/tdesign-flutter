import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../support/token_consumption_evidence.dart';

void main() {
  emptyTokenConsumptionTests();
  Widget app(Widget child, {TEmptyThemeData? theme}) {
    var data = TThemeBuilder.light(TThemeData.defaultData());
    if (theme != null) {
      data = data.mergeExtension(theme);
    }
    return MaterialApp(
      theme: data,
      home: Scaffold(body: child),
    );
  }

  TText tText(WidgetTester tester, String data) => tester.widget<TText>(
    find.byWidgetPredicate((widget) => widget is TText && widget.data == data),
  );

  testWidgets('renders the default icon and description', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(app(const TEmpty(emptyText: '暂无数据')));
    final icon = tester.widget<Icon>(find.byIcon(TIcons.info_circle_filled));
    final text = tText(tester, '暂无数据');
    expect(icon.size, 96);
    expect(icon.color, token.textColorPlaceholder);
    expect(text.style?.color, token.textColorPlaceholder);
    expect(text.font, token.fontBodyMedium);
  });

  testWidgets('image replaces icon and keeps the description', (tester) async {
    await tester.pumpWidget(
      app(
        const TEmpty(
          image: SizedBox(key: ValueKey('image'), width: 80, height: 80),
          emptyText: '自定义图片',
        ),
      ),
    );
    expect(find.byKey(const ValueKey('image')), findsOneWidget);
    expect(find.byIcon(TIcons.info_circle_filled), findsNothing);
    expect(find.text('自定义图片'), findsOneWidget);
  });

  testWidgets('operation is composed directly and receives one tap', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      app(
        TEmpty(
          emptyText: '无数据',
          operation: TButton(
            onPressed: () => taps += 1,
            child: const Text('重试'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('重试'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('omitted operation does not reserve an action widget', (
    tester,
  ) async {
    await tester.pumpWidget(app(const TEmpty()));
    expect(find.byType(TButton), findsNothing);
    expect(find.byType(TEmpty), findsOneWidget);
  });

  testWidgets('theme overrides concrete description visuals', (tester) async {
    final font = Font(size: 14, lineHeight: 20);
    await tester.pumpWidget(
      app(
        const TEmpty(emptyText: '主题文案'),
        theme: TEmptyThemeData(emptyTextColor: Colors.red, emptyTextFont: font),
      ),
    );
    final text = tText(tester, '主题文案');
    expect(text.style?.color, Colors.red);
    expect(text.font, font);
  });

  test('theme copyWith and lerp preserve visual fields', () {
    final font = Font(size: 14, lineHeight: 20);
    final a = TEmptyThemeData(emptyTextColor: Colors.red, emptyTextFont: font);
    final b = TEmptyThemeData(
      emptyTextColor: Colors.blue,
      emptyTextFont: Font(size: 16, lineHeight: 24),
    );
    expect(
      a.copyWith(emptyTextColor: Colors.green).emptyTextColor,
      Colors.green,
    );
    expect(a.copyWith().emptyTextFont, same(font));
    expect(a.lerp(b, 0.25).emptyTextFont, same(font));
    expect(a.lerp(b, 0.75).emptyTextFont, same(b.emptyTextFont));
    expect(a.lerp(null, 0.5), same(a));
  });
}

void emptyTokenConsumptionTests() {
  for (final brightness in Brightness.values) {
    for (final custom in [false, true]) {
      testWidgets('token consumption empty ${brightness.name} custom=$custom', (
        tester,
      ) async {
        final token = evidenceTokens(brightness, custom: custom);
        for (final image in [false, true]) {
          await tester.pumpWidget(
            evidenceHost(
              TEmpty(
                image: image
                    ? const SizedBox(
                        key: ValueKey('token-image'),
                        width: 80,
                        height: 80,
                      )
                    : null,
                emptyText: 'token empty',
                operation: const SizedBox(
                  key: ValueKey('token-operation'),
                  width: 60,
                  height: 20,
                ),
              ),
              brightness: brightness,
              token: token,
            ),
          );
          await tester.pumpAndSettle();
          final scenario = '${brightness.name}/custom=$custom/image=$image';
          final text = tester.widget<Text>(find.text('token empty'));
          tokenObservation(
            'emptyDescriptionColor',
            scenario: scenario,
            actual: text.style?.color,
            expected: token.textColorPlaceholder,
          );
          tokenObservation(
            'emptyDescriptionFont',
            scenario: scenario,
            actual:
                '${text.style?.fontSize}/${text.style!.height! * text.style!.fontSize!}',
            expected: custom ? '19.0/27.0' : '14.0/22.0',
          );
          if (!image) {
            tokenObservation(
              'emptyIconColor',
              scenario: scenario,
              actual: tester
                  .widget<Icon>(find.byIcon(TIcons.info_circle_filled))
                  .color,
              expected: token.textColorPlaceholder,
            );
          }
          final imageRect = tester.getRect(
            image
                ? find.byKey(const ValueKey('token-image'))
                : find.byIcon(TIcons.info_circle_filled),
          );
          final textRect = tester.getRect(find.text('token empty'));
          tokenObservation(
            'emptyDescriptionMarginTop',
            scenario: scenario,
            actual: textRect.top - imageRect.bottom,
            expected: token.spacer2,
            enforce: image && !custom,
          );
          tokenObservation(
            'emptyDescriptionMarginTop',
            scenario: 'contract/$scenario/description-gap',
            actual: textRect.top - imageRect.bottom,
            expected: image ? 16.0 : 22.0,
          );
          tokenObservation(
            'emptyActionMarginTop',
            scenario: scenario,
            actual:
                tester
                    .getRect(find.byKey(const ValueKey('token-operation')))
                    .top -
                textRect.bottom,
            expected: token.spacer4,
            enforce: !custom,
          );
          tokenObservation(
            'emptyActionMarginTop',
            scenario: 'contract/$scenario/action-gap',
            actual:
                tester
                    .getRect(find.byKey(const ValueKey('token-operation')))
                    .top -
                textRect.bottom,
            expected: 32.0,
          );
        }
      });
    }
  }
}
