import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_activity_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCupertinoActivityIndicator 组件测试
/// animating=true 时 repeat() 无限循环，不能用 pumpAndSettle
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Scaffold(body: child),
    );
  }

  group('TCupertinoActivityIndicator', () {
    testWidgets('animating=false 不启动动画', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCupertinoActivityIndicator(animating: false),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('animating=true 默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCupertinoActivityIndicator(),
      ));
      await tester.pump();
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TCupertinoActivityIndicator), findsNothing);
    });

    testWidgets('didUpdateWidget animating true→false', (tester) async {
      var animating = true;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(builder: (context, setter) {
          setState = setter;
          return TCupertinoActivityIndicator(animating: animating);
        }),
      ));
      await tester.pump();
      setState(() => animating = false);
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('didUpdateWidget animating false→true', (tester) async {
      var animating = false;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(builder: (context, setter) {
          setState = setter;
          return TCupertinoActivityIndicator(animating: animating);
        }),
      ));
      await tester.pumpAndSettle();
      setState(() => animating = true);
      await tester.pump();
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
    });

    testWidgets('自定义 radius 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCupertinoActivityIndicator(animating: false, radius: 20),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoActivityIndicator), findsOneWidget);
      expect(
        tester.getSize(find.byType(TCupertinoActivityIndicator)),
        const Size(40, 40),
      );
    });

    testWidgets('activeColor 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCupertinoActivityIndicator(
            animating: false, activeColor: Colors.red),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoActivityIndicator), findsOneWidget);
      expect(
        tester
            .widget<TCupertinoActivityIndicator>(
              find.byType(TCupertinoActivityIndicator),
            )
            .activeColor,
        Colors.red,
      );
    });

    testWidgets('duration 变化', (tester) async {
      var duration = 1000;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(builder: (context, setter) {
          setState = setter;
          return TCupertinoActivityIndicator(
              animating: false, duration: duration);
        }),
      ));
      await tester.pumpAndSettle();
      setState(() => duration = 2000);
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoActivityIndicator), findsOneWidget);
    });
  });
}
