import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter_example/main.dart';

void main() {
  testWidgets('example home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('TDesign Flutter 组件库'), findsOneWidget);
    expect(find.text('Button 按钮'), findsOneWidget);
  });
}
