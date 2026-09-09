import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'progress_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(progressDemoPageTestSpec);

  testWidgets('公开 Demo 展示完整形态与状态矩阵', (tester) async {
    await pumpFullDemoPage(tester, progressDemoPageTestSpec, ThemeMode.light);

    final progress = tester.widgetList<TProgress>(find.byType(TProgress));
    expect(progress, hasLength(20));
    expect(
      progress.where((item) => item.variant == TProgressVariant.linear),
      hasLength(6),
    );
    expect(
      progress.where((item) => item.variant == TProgressVariant.plump),
      hasLength(6),
    );
    expect(
      progress.where((item) => item.variant == TProgressVariant.circular),
      hasLength(5),
    );
    expect(
      progress.where((item) => item.variant == TProgressVariant.microCircular),
      hasLength(1),
    );
    expect(
      progress.where((item) => item.variant == TProgressVariant.button),
      hasLength(1),
    );
    expect(
      progress.where((item) => item.variant == TProgressVariant.microButton),
      hasLength(1),
    );
    expect(progress.where((item) => item.gradient != null), hasLength(2));
    expect(
      progress
          .where((item) => item.status == TProgressStatus.success)
          .map((item) => item.value),
      contains(1),
    );
    for (final status in TProgressStatus.values) {
      expect(
        progress.where((item) => item.status == status),
        isNotEmpty,
        reason: status.name,
      );
    }
  });

  testWidgets('按钮进度点击后从开始推进到 80%', (tester) async {
    await pumpFullDemoPage(tester, progressDemoPageTestSpec, ThemeMode.light);

    final button = find.byKey(const Key('progress-button'));
    expect(
      find.descendant(of: button, matching: find.text('开始')),
      findsOneWidget,
    );
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.descendant(of: button, matching: find.text('80%')),
      findsOneWidget,
    );
  });

  testWidgets('微型按钮点击后切换播放状态并推进圆环', (tester) async {
    await pumpFullDemoPage(tester, progressDemoPageTestSpec, ThemeMode.light);

    final button = find.byKey(const Key('progress-micro-button'));
    expect(
      find.descendant(of: button, matching: find.byIcon(TIcons.play)),
      findsOneWidget,
    );
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.descendant(of: button, matching: find.byIcon(TIcons.pause)),
      findsOneWidget,
    );
  });
}
