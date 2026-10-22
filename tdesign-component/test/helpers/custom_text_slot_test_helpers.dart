import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// Shared fixtures and assertions keep custom-slot typography checks consistent.
RenderParagraph slotParagraph(WidgetTester tester, String label) =>
    tester.renderObject<RenderParagraph>(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText() == label,
      ),
    );

Widget slotContent(String label, String variant, String wrapper) {
  Widget child = variant == 'native'
      ? Text(label)
      : TText(
          label,
          style: variant == 'partial'
              ? const TextStyle(color: Colors.orange)
              : variant == 'explicit'
              ? const TextStyle(
                  fontSize: 19,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: Colors.pink,
                  letterSpacing: 1,
                  wordSpacing: 0,
                )
              : null,
          maxLines: variant == 'paragraph' ? 2 : null,
          overflow: variant == 'paragraph' ? TextOverflow.fade : null,
          softWrap: variant == 'paragraph' ? false : null,
        );
  if (variant == 'nativeExplicit') {
    child = Text(
      label,
      style: const TextStyle(
        fontSize: 19,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Colors.pink,
        letterSpacing: 1,
        wordSpacing: 0,
      ),
    );
  }
  if (variant == 'nativeLocal') {
    child = DefaultTextStyle.merge(
      style: const TextStyle(
        fontSize: 21,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: Colors.purple,
      ),
      child: Text(label),
    );
  }
  if (variant == 'local') {
    final labelWidget = child;
    child = Builder(
      builder: (context) => Theme(
        data: Theme.of(context).mergeExtension(
          const TTextThemeData(
            textStyle: TextStyle(
              fontSize: 21,
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            ),
          ),
        ),
        child: labelWidget,
      ),
    );
  }
  return switch (wrapper) {
    'row' => Row(
      mainAxisSize: MainAxisSize.min,
      children: [Flexible(child: child)],
    ),
    'padding' => Padding(padding: const EdgeInsets.all(2), child: child),
    'builder' => Builder(builder: (_) => child),
    _ => child,
  };
}

void expectSlotStyle(
  WidgetTester tester,
  String subject,
  String reference,
  String variant,
) {
  final paragraph = slotParagraph(tester, subject);
  final actual = paragraph.text.style!;
  final base = slotParagraph(tester, reference).text.style!;
  final override = switch (variant) {
    'partial' => const TextStyle(color: Colors.orange),
    'explicit' || 'nativeExplicit' => const TextStyle(
      fontSize: 19,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: Colors.pink,
      letterSpacing: 1,
      wordSpacing: 0,
    ),
    'local' || 'nativeLocal' => const TextStyle(
      fontSize: 21,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: Colors.purple,
    ),
    _ => const TextStyle(),
  };
  expect(actual.fontSize, override.fontSize ?? base.fontSize, reason: subject);
  expect(actual.height, override.height ?? base.height, reason: subject);
  expect(
    actual.fontWeight,
    override.fontWeight ?? base.fontWeight,
    reason: subject,
  );
  expect(actual.color, override.color ?? base.color, reason: subject);
  expect(
    actual.letterSpacing,
    override.letterSpacing ?? base.letterSpacing,
    reason: subject,
  );
  if (variant == 'paragraph') {
    expect(paragraph.maxLines, 2);
    expect(paragraph.overflow, TextOverflow.fade);
    expect(paragraph.softWrap, isFalse);
  }
}

Widget slotHost(
  Widget child,
  bool dark,
  double scale, {
  TextStyle? outerStyle,
}) {
  final token = TThemeData.defaultData();
  var theme = dark ? TThemeBuilder.dark(token) : TThemeBuilder.light(token);
  if (outerStyle != null) {
    theme = theme.mergeExtension(TTextThemeData(textStyle: outerStyle));
  }
  return MaterialApp(
    theme: theme,
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 32, color: Colors.red),
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
}
