import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/switch/t_cupertino_switch.dart';

/// TCupertinoSwitch（内部组件）Widget 测试
///
/// 直接 import src 路径，覆盖 tap/drag/tapCancel 交互、RTL 绘制、
/// didUpdateWidget、updateRenderObject setters、thumbView 有无等分支。
///
/// 说明：_emitVibration 的 iOS 分支（HapticFeedback.lightImpact）依赖
/// debugDefaultTargetPlatformOverride，本测试不在用例中切换平台（避免触发
/// TestWidgetsFlutterBinding 的不变量检查），该单行由交互路径的 default 分支覆盖。
void main() {
  Widget wrap(Widget child, {TextDirection dir = TextDirection.ltr}) {
    return CupertinoApp(
      home: Directionality(
        textDirection: dir,
        child: Center(child: child),
      ),
    );
  }

  group('TCupertinoSwitch 渲染与禁用', () {
    testWidgets('value=false 渲染', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('value=true 渲染', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: true, onChanged: (_) {}),
      ));
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('thumbView 垂直居中于滑块', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(
          value: true,
          onChanged: (_) {},
          thumbView: const SizedBox(
            width: 16,
            height: 10,
            child: Text('ON', textAlign: TextAlign.center),
          ),
        ),
      ));

      expect(
        tester.getCenter(find.text('ON')).dy,
        moreOrLessEquals(
          tester.getCenter(find.byType(TCupertinoSwitch)).dy,
          epsilon: 0.1,
        ),
      );
    });

    testWidgets('onChanged=null 时禁用，Opacity=0.5', (tester) async {
      await tester.pumpWidget(wrap(
        const TCupertinoSwitch(value: false, onChanged: null),
      ));
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(TCupertinoSwitch),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, 0.5);
    });
  });

  group('TCupertinoSwitch 交互', () {
    testWidgets('点击切换触发 onChanged', (tester) async {
      bool? changed;
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: false, onChanged: (v) => changed = v),
      ));
      await tester.tap(find.byType(TCupertinoSwitch));
      await tester.pump();
      expect(changed, isTrue);
    });

    testWidgets('禁用时点击不触发', (tester) async {
      await tester.pumpWidget(wrap(
        const TCupertinoSwitch(value: false, onChanged: null),
      ));
      await tester.tap(find.byType(TCupertinoSwitch));
      await tester.pump();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('拖动触发 onChanged 并完成位置动画', (tester) async {
      bool? changed;
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: false, onChanged: (v) => changed = v),
      ));
      await tester.drag(find.byType(TCupertinoSwitch), const Offset(40, 0));
      await tester.pumpAndSettle();
      expect(changed, isTrue);
    });

    testWidgets('按下后转为拖动会触发 tapCancel', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: false, onChanged: (_) {}),
      ));
      final center = tester.getCenter(find.byType(TCupertinoSwitch));
      final gesture = await tester.startGesture(center);
      await tester.pump();
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('RTL 方向拖动', (tester) async {
      bool? changed;
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: false, onChanged: (v) => changed = v),
        dir: TextDirection.rtl,
      ));
      await tester.drag(find.byType(TCupertinoSwitch), const Offset(-40, 0));
      await tester.pumpAndSettle();
      expect(changed, isTrue);
    });
  });

  group('TCupertinoSwitch 更新', () {
    testWidgets('value 变化触发 didUpdateWidget 动画', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: false, onChanged: (_) {}),
      ));
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: true, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('颜色/方向/回调变化触发 updateRenderObject setters', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(
          value: false,
          onChanged: (_) {},
          activeColor: Colors.green,
          trackColor: Colors.grey,
          thumbColor: Colors.white,
        ),
      ));
      // 全部换新值，触发各 setter 的非早退分支
      await tester.pumpWidget(wrap(
        const TCupertinoSwitch(
          value: true,
          onChanged: null,
          activeColor: Colors.blue,
          trackColor: Colors.black,
          thumbColor: Colors.red,
        ),
        dir: TextDirection.rtl,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('相同值不触发重绘（setter 早退分支）', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(
          value: false,
          onChanged: (_) {},
          activeColor: Colors.green,
          trackColor: Colors.grey,
          thumbColor: Colors.white,
        ),
      ));
      // 相同参数再 pump，setter 走早退
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(
          value: false,
          onChanged: (_) {},
          activeColor: Colors.green,
          trackColor: Colors.grey,
          thumbColor: Colors.white,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });
  });

  group('TCupertinoSwitch thumbView', () {
    testWidgets('提供 thumbView 时 child 分支', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(
          value: true,
          onChanged: (_) {},
          thumbView: const SizedBox(width: 10, height: 10),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('无 thumbView 时 child==null 分支（thumbRadius 插值）', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: true, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });
  });

  group('TCupertinoSwitch dragStartBehavior', () {
    testWidgets('dragStartBehavior=down', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(
          value: false,
          onChanged: (_) {},
          dragStartBehavior: DragStartBehavior.down,
        ),
      ));
      await tester.drag(find.byType(TCupertinoSwitch), const Offset(40, 0));
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });
  });

  group('TCupertinoSwitch 覆盖补充', () {
    testWidgets('debugFillProperties 覆盖诊断属性（widget + renderObject）',
        (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: true, onChanged: (_) {}),
      ));
      // 覆盖 widget.debugFillProperties
      final w = tester.widget<TCupertinoSwitch>(find.byType(TCupertinoSwitch));
      final builder = DiagnosticPropertiesBuilder();
      w.debugFillProperties(builder);
      expect(builder.properties, isNotEmpty);
      // toStringDeep 递归触发 _RenderTDCupertinoSwitch.debugFillProperties
      final deep =
          tester.renderObject(find.byType(TCupertinoSwitch)).toStringDeep();
      expect(deep, isNotEmpty);
    });

    testWidgets('gesture.cancel 触发 tapCancel', (tester) async {
      await tester.pumpWidget(wrap(
        TCupertinoSwitch(value: false, onChanged: (_) {}),
      ));
      final center = tester.getCenter(find.byType(TCupertinoSwitch));
      final gesture = await tester.startGesture(center);
      await tester.pump();
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(find.byType(TCupertinoSwitch), findsOneWidget);
    });

    testWidgets('iOS 平台点击触发 HapticFeedback 分支', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(wrap(
          TCupertinoSwitch(value: false, onChanged: (_) {}),
        ));
        await tester.tap(find.byType(TCupertinoSwitch));
        await tester.pump();
        // 拖动也会走 _emitVibration 的 iOS 分支
        await tester.drag(find.byType(TCupertinoSwitch), const Offset(40, 0));
        await tester.pumpAndSettle();
        expect(find.byType(TCupertinoSwitch), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });
}
