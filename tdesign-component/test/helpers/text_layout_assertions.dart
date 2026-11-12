import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// Checking exceptions alone misses text clipped by a finite-height parent.
RenderParagraph expectTextFits(
  WidgetTester tester,
  String label, {
  required Finder container,
  bool ellipsized = false,
}) {
  final finder = find.descendant(
    of: find.text(label),
    matching: find.byType(RichText),
  );
  final paragraph = tester.renderObject<RenderParagraph>(finder);
  final painter = TextPainter(
    text: paragraph.text,
    textDirection: paragraph.textDirection,
    textScaler: paragraph.textScaler,
    maxLines: paragraph.maxLines,
    ellipsis: paragraph.overflow == TextOverflow.ellipsis ? '…' : null,
  )..layout(maxWidth: paragraph.size.width);
  expect(paragraph.size.height + 0.01, greaterThanOrEqualTo(painter.height));
  expect(paragraph.didExceedMaxLines, ellipsized);
  final bounds = tester.getRect(container);
  final textBounds = tester.getRect(finder);
  expect(textBounds.left, greaterThanOrEqualTo(bounds.left - 0.01));
  expect(textBounds.right, lessThanOrEqualTo(bounds.right + 0.01));
  expect(textBounds.top, greaterThanOrEqualTo(bounds.top - 0.01));
  expect(textBounds.bottom, lessThanOrEqualTo(bounds.bottom + 0.01));
  painter.dispose();
  return paragraph;
}

Widget textLayoutApp(
  Widget child, {
  bool dark = false,
  double scale = 1,
  bool gradient = false,
  Size? viewport,
}) {
  var theme = dark
      ? TThemeBuilder.dark(TThemeData.defaultData())
      : TThemeBuilder.light(TThemeData.defaultData());
  if (gradient) {
    theme = theme.mergeExtension(
      const TButtonThemeData(
        gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
      ),
    );
  }
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      body: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(size: viewport, textScaler: TextScaler.linear(scale)),
          child: Center(child: child),
        ),
      ),
    ),
  );
}
