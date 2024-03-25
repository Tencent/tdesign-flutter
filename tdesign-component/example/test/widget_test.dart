// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/web_md_tool.dart';
import 'package:tdesign_flutter_example/config.dart';

import 'package:tdesign_flutter_example/home.dart';
import 'package:tdesign_flutter_example/main.dart';

void main() async {

    testWidgets('Counter increments smoke testeee', (WidgetTester tester) async {

      WebMdTool.needGenerateWebMd = true;

      await tester.pumpWidget(const MyApp());
      exampleMap.forEach((key, value) {
        value.forEach((model) {
          if (!model.isTodo) {
            examplePageList.add(model);
          }
        });
      });
      for(var element in examplePageList){
        // Build our app and trigger a frame.
        if(element.text == '颜色'){
          // 测试结束
          break;
        }
        await _testComponent(tester, element.text);
      }
      // throw Exception('<===============执行完成!!!!=================>');

    });


}

var changeList = ['Tabs 选项卡','Picker 选择器','Switch 开关','Swiper 轮播图','Popup 弹出层',];
Finder? lastFinder;

Future<void> _testComponent(WidgetTester tester, String name) async {
  print('\n\n当前组件==============>：$name');

  if(changeList.contains(name) && lastFinder != null){
    await tester.fling(lastFinder!, const Offset(0, -300), 2);
    try {
      await tester.pumpAndSettle();
    } catch (e) {
      print('pumpAndSettle 1 error:$e');
    }
  }

  var button = find.text(name);

    expect(button, findsOneWidget);
    lastFinder = button;

    await tester.tap(button);
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    var page = find.text('WebGenTag');
  try {
    expect(page, findsOneWidget);

    await tester.pump();

    await tester.fling(page, const Offset(0, -20000), 2);
    try {
        await tester.pumpAndSettle();
      } catch (e) {
        print('pumpAndSettle 2 error:$e');
      }
  } catch (e) {
    print("没有找到'WebGenTag',不用滑动,直接点击");
  }
  var genBtn = find.text('生成Web使用md');
  expect(genBtn, findsOneWidget);
  await tester.tap(genBtn);

  var back = find.text('返回首页');
  expect(back, findsOneWidget);
  await tester.tap(back);
  await tester.pumpAndSettle();
}

