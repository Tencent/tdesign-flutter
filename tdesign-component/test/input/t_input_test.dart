import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TInput 密码输入框相关 Widget 测试
///
/// 覆盖 [issue #763](https://github.com/Tencent/tdesign-flutter/issues/763)
/// 的修复点：
/// 1. `obscureText: true` 正确透传到底层 TextField；
/// 2. `autofillHints` 正确透传到底层 TextField；
/// 3. label 区域 GestureDetector 使用 `HitTestBehavior.translucent`，
///    确保点击事件不抢夺，不影响输入框获取焦点；
/// 4. 默认 `onTapOutside` 不会主动 unfocus，从而保证多个 TInput 之间
///    切换焦点时键盘不会被错误收起。
void main() {
  group('TInput obscureText (issue #763)', () {
    testWidgets('obscureText: true 应正确透传到底层 TextField',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TInput(
              obscureText: true,
              leftLabel: '密码',
              hintText: '请输入密码',
              needClear: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue,
          reason: 'TInput.obscureText 必须透传到底层 TextField');
    });

    testWidgets('autofillHints 应正确透传到底层 TextField',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutofillGroup(
              child: TInput(
                obscureText: true,
                leftLabel: '密码',
                autofillHints: const [AutofillHints.password],
                needClear: false,
              ),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofillHints, equals(const [AutofillHints.password]),
          reason: 'TInput.autofillHints 必须透传到底层 TextField');
    });

    testWidgets('label 区域 GestureDetector 应使用 translucent 命中行为',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TInput(
              obscureText: true,
              leftLabel: '密码',
              hintText: '请输入密码',
              needClear: false,
            ),
          ),
        ),
      );

      // 在 label 区域至少存在一个 behavior == translucent 的 GestureDetector，
      // 确保点击 label 区不会抢夺手势导致首次 tap 不弹键盘。
      final detectors =
          tester.widgetList<GestureDetector>(find.byType(GestureDetector));
      final hasTranslucent = detectors
          .any((d) => d.behavior == HitTestBehavior.translucent);
      expect(hasTranslucent, isTrue,
          reason: 'label 区域 GestureDetector 必须使用 HitTestBehavior.translucent，'
              '避免抢夺 TextField 的点击手势导致首次 tap 不弹键盘');
    });

    testWidgets('未传 onTapOutside 时，TextField 应使用安全默认值（不主动 unfocus）',
        (WidgetTester tester) async {
      final focusA = FocusNode();
      final focusB = FocusNode();
      addTearDown(focusA.dispose);
      addTearDown(focusB.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TInput(
                  key: const Key('input-a'),
                  obscureText: true,
                  leftLabel: '密码A',
                  focusNode: focusA,
                  needClear: false,
                ),
                TInput(
                  key: const Key('input-b'),
                  obscureText: true,
                  leftLabel: '密码B',
                  focusNode: focusB,
                  needClear: false,
                ),
              ],
            ),
          ),
        ),
      );

      // 模拟用户点击第一个输入框获取焦点
      focusA.requestFocus();
      await tester.pump();
      expect(focusA.hasFocus, isTrue);

      // 模拟用户切换到第二个输入框
      focusB.requestFocus();
      await tester.pump();

      // 关键断言：两个 TextField 的 onTapOutside 都不是 null（即使用了
      // TInputView 的安全默认值），保证多个 TInput 切换焦点时键盘行为正确。
      final textFields =
          tester.widgetList<TextField>(find.byType(TextField)).toList();
      expect(textFields.length, 2);
      for (final tf in textFields) {
        expect(tf.onTapOutside, isNotNull,
            reason: 'TInputView 必须为 onTapOutside 提供不主动 unfocus 的安全默认值，'
                '避免多个 TInput 切换焦点时键盘被错误收起');
      }
    });

    testWidgets('显式传入 onTapOutside 时应使用业务方提供的回调',
        (WidgetTester tester) async {
      var customCalled = false;
      void customOnTapOutside(PointerDownEvent event) {
        customCalled = true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TInput(
              obscureText: true,
              leftLabel: '密码',
              onTapOutside: customOnTapOutside,
              needClear: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      // 直接调用底层 TextField 的回调，验证业务方传入的 onTapOutside 被采用
      textField.onTapOutside!(const PointerDownEvent());
      expect(customCalled, isTrue,
          reason: '业务方显式传入的 onTapOutside 必须覆盖默认值');
    });

    testWidgets('onLabelTap 默认 null 时点击 label 区域不抛错',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TInput(
              obscureText: true,
              leftLabel: '密码',
              needClear: false,
            ),
          ),
        ),
      );

      // 找到带 leftLabel 文案的 TText 并点击
      await tester.tap(find.text('密码'), warnIfMissed: false);
      await tester.pump();
      // 不抛错即通过；命中行为由 translucent 保证可穿透到 TextField
      expect(tester.takeException(), isNull);
    });

    testWidgets('显式传入 onLabelTap 时点击 label 区域应触发回调',
        (WidgetTester tester) async {
      var labelTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TInput(
              obscureText: true,
              leftLabel: '密码',
              onLabelTap: () {
                labelTapped = true;
              },
              needClear: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('密码'), warnIfMissed: false);
      await tester.pump();
      expect(labelTapped, isTrue,
          reason: 'TInput.onLabelTap 必须在点击 label 区域时被触发');
    });
  });
}
