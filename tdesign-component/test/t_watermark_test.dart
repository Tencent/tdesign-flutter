import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TWatermark', () {
    testWidgets('水印组件基本渲染测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TWatermark(
              text: '测试水印',
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
    });

    testWidgets('水印组件带子组件测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TWatermark(
              text: '测试水印',
              child: const Text('子组件内容'),
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
      expect(find.text('子组件内容'), findsOneWidget);
    });

    testWidgets('水印组件单行类型测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TWatermark(
              text: '单行水印',
              type: TWatermarkType.singleLine,
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
    });

    testWidgets('水印组件多行类型测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TWatermark(
              text: '多行\n水印',
              type: TWatermarkType.multiLine,
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
    });

    testWidgets('水印组件水平布局测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: TWatermark(
                text: '水平',
                layout: TWatermarkLayout.horizontal,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
    });

    testWidgets('水印组件垂直布局测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: TWatermark(
                text: '垂直',
                layout: TWatermarkLayout.vertical,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
    });

    testWidgets('水印组件网格布局测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: TWatermark(
                text: '网格',
                layout: TWatermarkLayout.grid,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
    });

    testWidgets('水印组件自定义样式测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TWatermark(
              text: '自定义',
              textColor: Colors.red,
              textSize: 20,
              opacity: 0.5,
              rotate: -45,
              gapX: 100,
              gapY: 80,
            ),
          ),
        ),
      );

      expect(find.byType(TWatermark), findsOneWidget);
    });

    testWidgets('水印组件忽略指针测试', (WidgetTester tester) async {
      var buttonClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TWatermark(
              text: '测试',
              child: ElevatedButton(
                onPressed: () {
                  buttonClicked = true;
                },
                child: const Text('点击我'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('点击我'));
      await tester.pump();

      expect(buttonClicked, true);
    });
  });
}
