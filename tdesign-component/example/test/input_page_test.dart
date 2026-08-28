import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_input_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  testWidgets('price keeps editing state and formats only after blur', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const TInputViewPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final priceInput = find.byWidgetPredicate(
      (widget) => widget is TInput && widget.hintText == '0.00',
    );
    await tester.scrollUntilVisible(
      priceInput,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final textField = find.descendant(
      of: priceInput,
      matching: find.byType(TextField),
    );
    await tester.ensureVisible(textField);
    await tester.pumpAndSettle();

    await tester.tap(textField);
    await tester.enterText(textField, '1.00');
    await tester.enterText(textField, '1.0');
    await tester.pump();
    expect(tester.widget<TextField>(textField).controller?.text, '1.0');

    tester.binding.focusManager.primaryFocus?.unfocus();
    await tester.pump();
    expect(tester.widget<TextField>(textField).controller?.text, '1.00');
  });
}
