// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:tdesign_flutter_example/main_run.dart';

void main() {
  testWidgets('Counter increments smoke testeee', (WidgetTester tester) async {
    examplePageList.forEach((element) async {
      testWidgets('Counter increments smoke teseeet', (WidgetTester tester) async {

        await _testComponent(tester, element.name);

      });
    });

  });


}

Future<void> _testComponent(WidgetTester tester, String name) async {
  print('当前组件：$name');
  // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

  var button = find.text(name);

  expect(button, findsOneWidget);
  await tester.tap(button);

  // try {
  //   await tester.pumpAndSettle(
  //           const Duration(milliseconds: 100),
  //         EnginePhase.sendSemanticsUpdate,
  //         const Duration(minutes: 100),
  //       );
  // } catch (e) {
  //   print(e);
  // }
  await tester.pump();
  await tester.pump();
  await tester.pump();
  var page = find.text('WebGenTag');
  expect(page, findsOneWidget);

  await tester.pump();

  await tester.fling(page, const Offset(0, -20000), 2);
  await tester.pumpAndSettle();
  var genBtn = find.text('生成Web使用md');
  expect(genBtn, findsOneWidget);
  // // await _flingUtilFind(genBtn,page, tester);
  await tester.tap(genBtn);
}

Future<void> _genMd(String name) async {

}

Future<void> _flingUtilFind(Finder genBtn, Finder page, WidgetTester tester) async {
  // await tester.scrollUntilVisible(genBtn, 100);
  var offset =100.0;
  var sum = offset;
  var found = false;
  while(sum < 5000 && !found){
    found = true;
    sum += offset;
    await tester.fling(page, Offset(0, -offset), 2);
    await tester.pump(const Duration(milliseconds: 50));
    try {
      expect(genBtn, findsOneWidget);
    } catch (e) {
      found = false;
      print('下滑距离：$sum, 未找到Widget，继续下滑');
    }
  }
  return ;
}
