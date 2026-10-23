import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/text/t_text_styled.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    await (FontLoader('Roboto')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    for (final family in [
      'TDesignGoldenCJK',
      'TDesignFeedbackGoldenCJK',
      'TDesignAlignmentCJK',
    ]) {
      await (FontLoader(family)..addFont(
            File(
              'example/test/fonts/$family-Regular.otf',
            ).readAsBytes().then(ByteData.sublistView),
          ))
          .load();
    }
  });

  Widget app(
    Widget child, {
    bool m3 = true,
    double scale = 1,
    List<ThemeExtension<dynamic>> extensions = const [],
  }) => MaterialApp(
    theme: ThemeData(
      useMaterial3: m3,
      extensions: [TThemeData.defaultData(), ...extensions],
    ),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(body: child),
    ),
  );
  testWidgets(
    'mixed fallback fonts retain the TD line box and raw-text measurement',
    (tester) async {
      final token = TThemeData.defaultData().copyWith(
        fontFamilyMap: {
          'fontFamily': FontFamily(
            fontFamily: 'Roboto',
            fallback: [
              'TDesignGoldenCJK',
              'TDesignFeedbackGoldenCJK',
              'TDesignAlignmentCJK',
            ],
          ),
        },
      );
      for (final scale in [1.0, 1.5, 2.0]) {
        await tester.pumpWidget(
          app(
            const TTextStyled(
              '加载中... Ag8',
              key: Key('mixed'),
              maxLines: 1,
              style: TextStyle(fontSize: 14, height: 22 / 14),
            ),
            scale: scale,
            extensions: [token],
          ),
        );
        final owned = find.byKey(const Key('mixed'));
        final native = find.descendant(of: owned, matching: find.byType(Text));
        expect(tester.getSize(native).height, closeTo(22 * scale, 0.01));
        final widget = tester.widget<TTextStyled>(owned);
        final raw = widget.getRawText(context: tester.element(owned));
        expect(raw.key, const Key('mixed'));
        final painter = TextPainter(
          text: TextSpan(text: raw.data, style: raw.style),
          textDirection: TextDirection.ltr,
          textScaler: TextScaler.linear(scale),
          strutStyle: raw.strutStyle,
          maxLines: raw.maxLines,
        )..layout();
        expect(painter.height, tester.getSize(native).height);
        painter.dispose();
      }
    },
  );

  testWidgets('switching from default to explicit strut updates the renderer', (
    tester,
  ) async {
    const label = TTextStyled('Ag8', style: null, maxLines: 1);
    await tester.pumpWidget(app(label));
    final initial = tester.widget<Text>(find.byType(Text).last);
    final explicit = StrutStyle.fromTextStyle(
      initial.style!,
      leadingDistribution: TextLeadingDistribution.proportional,
      forceStrutHeight: true,
    );
    await tester.pumpWidget(
      app(label, extensions: [TTextThemeData(strutStyle: explicit)]),
    );
    await tester.pumpAndSettle();
    final paragraph = tester.renderObject<RenderParagraph>(
      find.byType(RichText).last,
    );
    expect(
      paragraph.strutStyle!.leadingDistribution,
      TextLeadingDistribution.proportional,
    );
  });

  testWidgets(
    'fallback changes update the same paragraph and distinct cached styles',
    (tester) async {
      const label = TTextStyled('Ag8', style: null, maxLines: 1);
      await tester.pumpWidget(app(label));
      final before = tester.widget<Text>(find.byType(Text).last).strutStyle!;
      final paragraph = tester.renderObject<RenderParagraph>(
        find.byType(RichText).last,
      );
      await tester.pumpWidget(
        app(
          label,
          extensions: [
            const TTextThemeData(
              textStyle: TextStyle(fontFamilyFallback: ['NewFallback']),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      final after = tester.widget<Text>(find.byType(Text).last).strutStyle!;
      expect(
        tester.renderObject<RenderParagraph>(find.byType(RichText).last),
        same(paragraph),
      );
      expect(paragraph.strutStyle!.fontFamilyFallback, ['NewFallback']);
      expect({before, after}, hasLength(2));
    },
  );

  for (final m3 in [false, true]) {
    for (final scale in [1.0, 1.5, 2.0]) {
      testWidgets('native line boxes and content m3=$m3 scale=$scale', (
        tester,
      ) async {
        for (final text in [
          '标签',
          'Ag8',
          '99+',
          '很长的标签 mixed Ag8 123456',
          '第一行\n第二行',
        ]) {
          await tester.pumpWidget(
            app(
              Column(
                children: [
                  SizedBox(
                    width: 100,
                    child: TTextStyled(
                      text,
                      key: const Key('owned'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, height: 22 / 14),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TText(
                      text,
                      key: const Key('public'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, height: 22 / 14),
                    ),
                  ),
                ],
              ),
              m3: m3,
              scale: scale,
            ),
          );
          final owned = find.descendant(
            of: find.byKey(const Key('owned')),
            matching: find.byType(Text),
          );
          final public = find.descendant(
            of: find.byKey(const Key('public')),
            matching: find.byType(Text),
          );
          expect(tester.widget<Text>(owned).data, text);
          expect(
            tester.widget<Text>(owned).style!.leadingDistribution,
            TextLeadingDistribution.even,
          );
          expect(
            tester.widget<Text>(public).style!.leadingDistribution,
            isNull,
          );
          expect(tester.getSize(owned), tester.getSize(public));
          final paragraph = tester.renderObject<RenderParagraph>(owned);
          expect(
            paragraph.getBoxesForSelection(
              TextSelection(baseOffset: 0, extentOffset: text.length),
            ),
            isNotEmpty,
          );
          expect(tester.takeException(), isNull);
        }
      });
    }
    testWidgets('real controls and explicit TD typography m3=$m3', (
      tester,
    ) async {
      final controls = <Widget>[
        const TTag('tag'),
        const TRadioGroup<bool>(
          value: true,
          child: TRadio(value: true, title: 'radio', titleMaxLines: 1),
        ),
        const TCheckbox(value: true, title: 'checkbox', titleMaxLines: 1),
        const TFooter(text: 'footer'),
        const SizedBox(
          height: 64,
          child: Stack(
            children: [TMessage(content: 'message', duration: null)],
          ),
        ),
        const SizedBox(height: 48, child: TSwipeCellAction(label: 'action')),
        const TRate(value: 1, texts: ['rate', '2', '3', '4', '5']),
        const TSwitch(
          value: true,
          variant: TSwitchVariant.text,
          openText: 'switch',
        ),
      ];
      for (final explicit in [false, true]) {
        await tester.pumpWidget(
          app(
            Column(children: controls),
            m3: m3,
            extensions: [
              if (explicit)
                const TTextThemeData(
                  textStyle: TextStyle(
                    leadingDistribution: TextLeadingDistribution.proportional,
                    letterSpacing: 1,
                  ),
                ),
            ],
          ),
        );
        await tester.pumpAndSettle();
        for (final label in [
          'tag',
          'radio',
          'checkbox',
          'footer',
          'message',
          'action',
          'rate',
          'switch',
        ]) {
          final text = tester.widget<Text>(find.text(label));
          expect(
            text.style!.leadingDistribution,
            explicit
                ? TextLeadingDistribution.proportional
                : TextLeadingDistribution.even,
            reason: label,
          );
          if (explicit) {
            expect(text.style!.letterSpacing, 1, reason: label);
          }
        }
        expect(tester.takeException(), isNull);
      }
    });
  }
  testWidgets(
    'explicit strut, height behavior and native text properties survive',
    (tester) async {
      const strut = StrutStyle(
        fontSize: 18,
        height: 2,
        forceStrutHeight: false,
      );
      const behavior = TextHeightBehavior(applyHeightToFirstAscent: false);
      await tester.pumpWidget(
        app(
          const TTextStyled(
            'Ag8',
            style: TextStyle(height: 2),
            maxLines: 1,
            strutStyle: strut,
            textHeightBehavior: behavior,
            textDirection: TextDirection.rtl,
            semanticsLabel: 'read label',
            semanticsIdentifier: 'owned-label',
            textAlign: TextAlign.end,
            selectionColor: Colors.orange,
          ),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text).last);
      expect(text.strutStyle, same(strut));
      expect(text.textHeightBehavior, behavior);
      expect(text.textDirection, TextDirection.rtl);
      expect(text.textAlign, TextAlign.end);
      expect(text.semanticsLabel, 'read label');
      expect(text.semanticsIdentifier, 'owned-label');
      expect(text.selectionColor, Colors.orange);
    },
  );

  testWidgets('fixed-label opt-in retains explicit hard line breaks', (
    tester,
  ) async {
    for (final separator in ['\n', '\r', '\u2028', '\u2029']) {
      await tester.pumpWidget(
        app(TTextStyled('A${separator}B', style: null, centerLeading: true)),
      );
      final text = tester.widget<Text>(find.byType(Text).last);
      expect(text.style!.leadingDistribution, isNull);
      expect(text.data, 'A${separator}B');
    }
  });

  testWidgets('multiline wrapping and selection remain identical', (
    tester,
  ) async {
    const text = '第一行 Ag8\n第二行很长，需要正常换行和选择文字';
    await tester.pumpWidget(
      app(
        const Column(
          children: [
            SizedBox(
              width: 70,
              child: TTextStyled(
                text,
                key: Key('owned'),
                style: null,
                maxLines: 4,
              ),
            ),
            SizedBox(
              width: 70,
              child: TText(text, key: Key('public'), maxLines: 4),
            ),
          ],
        ),
      ),
    );
    final owned = find.descendant(
      of: find.byKey(const Key('owned')),
      matching: find.byType(Text),
    );
    final public = find.descendant(
      of: find.byKey(const Key('public')),
      matching: find.byType(Text),
    );
    expect(tester.widget<Text>(owned).style!.leadingDistribution, isNull);
    expect(tester.getSize(owned), tester.getSize(public));
    const selection = TextSelection(baseOffset: 0, extentOffset: text.length);
    expect(
      tester
          .renderObject<RenderParagraph>(owned)
          .getBoxesForSelection(selection)
          .map((box) => box.toRect()),
      tester
          .renderObject<RenderParagraph>(public)
          .getBoxesForSelection(selection)
          .map((box) => box.toRect()),
    );
  });
  testWidgets('editor, placeholder, selection and explicit styles', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const Column(
          children: [
            TInput(hintText: 'placeholder'),
            TSearchBar(hintText: 'search hint'),
          ],
        ),
      ),
    );
    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.style!.leadingDistribution, TextLeadingDistribution.even);
    }
    for (final hint in ['placeholder', 'search hint']) {
      expect(
        tester.widget<Text>(find.text(hint)).style!.leadingDistribution,
        TextLeadingDistribution.even,
      );
    }
    await tester.enterText(find.byType(TextField).first, '输入 Ag8');
    final editable = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    editable.controller.selection = const TextSelection(
      baseOffset: 0,
      extentOffset: 2,
    );
    await tester.pump();
    expect(editable.controller.text, '输入 Ag8');
    expect(editable.controller.selection.extentOffset, 2);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
      app(
        const TInput(
          style: TextStyle(
            height: 2,
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
        ),
      ),
    );
    final explicit = tester.widget<TextField>(find.byType(TextField));
    expect(
      explicit.style!.leadingDistribution,
      TextLeadingDistribution.proportional,
    );
    expect(explicit.style!.height, 2);
  });
  testWidgets('custom content preserves theme and explicit paragraph style', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const DefaultTextStyle(
          style: TextStyle(
            fontSize: 19,
            height: 2,
            leadingDistribution: TextLeadingDistribution.proportional,
            color: Colors.purple,
          ),
          child: Column(
            children: [
              TBadge.custom(badge: Text('custom badge')),
              TButton(
                child: Text(
                  'custom button',
                  style: TextStyle(
                    height: 2,
                    leadingDistribution: TextLeadingDistribution.proportional,
                  ),
                ),
              ),
              TText('public paragraph'),
            ],
          ),
        ),
      ),
    );
    final badge = find.text('custom badge');
    expect(tester.widget<Text>(badge).style, isNull);
    expect(DefaultTextStyle.of(tester.element(badge)).style.fontSize, 19);
    expect(
      DefaultTextStyle.of(tester.element(badge)).style.leadingDistribution,
      TextLeadingDistribution.proportional,
    );
    expect(tester.widget<Text>(find.text('custom button')).style!.height, 2);
    expect(
      tester
          .widget<Text>(find.text('public paragraph'))
          .style!
          .leadingDistribution,
      isNull,
    );
  });
  testWidgets('Switch component explicit height and leading survive', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const TSwitch(
          value: true,
          variant: TSwitchVariant.text,
          openText: 'on',
        ),
        extensions: [
          const TSwitchThemeData(
            thumbContentOnFont: TextStyle(
              height: 1.25,
              leadingDistribution: TextLeadingDistribution.proportional,
            ),
          ),
        ],
      ),
    );
    final style = tester.widget<Text>(find.text('on')).style!;
    expect(style.height, 1.25);
    expect(style.leadingDistribution, TextLeadingDistribution.proportional);
  });
}
