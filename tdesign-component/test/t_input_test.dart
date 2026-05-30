import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget _buildTestApp(Widget child) {
  return TTheme(
    data: TThemeData.defaultData(),
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('TInput', () {
    testWidgets('透传 minLines 到内部 TextField', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TInput(
            leftLabel: '标签文字',
            hintText: '请输入文字',
            maxLines: 4,
            minLines: 2,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, 4);
      expect(textField.minLines, 2);
    });
  });
}
