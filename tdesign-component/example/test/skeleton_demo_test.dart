import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'skeleton_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(skeletonDemoPageTestSpec);

  testWidgets('公开 Demo 展示完整预设、自定义组合与动画矩阵', (tester) async {
    await pumpFullDemoPage(tester, skeletonDemoPageTestSpec, ThemeMode.light);

    final skeletons = tester.widgetList<TSkeleton>(find.byType(TSkeleton));
    expect(skeletons, hasLength(17));
    expect(
      skeletons.where((item) => item.variant == TSkeletonVariant.avatar),
      hasLength(2),
    );
    expect(
      skeletons.where((item) => item.variant == TSkeletonVariant.image),
      hasLength(1),
    );
    expect(
      skeletons.where((item) => item.variant == TSkeletonVariant.text),
      hasLength(1),
    );
    expect(
      skeletons.where((item) => item.variant == TSkeletonVariant.paragraph),
      hasLength(3),
    );
    expect(skeletons.where((item) => item.layout != null), hasLength(10));
    expect(
      skeletons.where((item) => item.animation == TSkeletonAnimation.gradient),
      hasLength(1),
    );
    expect(
      skeletons.where((item) => item.animation == TSkeletonAnimation.flashed),
      hasLength(1),
    );
  });

  testWidgets('两种组件动效推进后保持各自绘制路径', (tester) async {
    await pumpFullDemoPage(tester, skeletonDemoPageTestSpec, ThemeMode.light);

    final gradient = find.byType(ShaderMask);
    final flashed = find.byType(Opacity);
    expect(gradient, findsNWidgets(4));
    expect(flashed, findsNWidgets(4));
    final initialOpacity = tester.widget<Opacity>(flashed.first).opacity;

    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(ShaderMask), findsNWidgets(4));
    expect(find.byType(Opacity), findsNWidgets(4));
    expect(
      tester.widget<Opacity>(flashed.first).opacity,
      isNot(initialOpacity),
    );
    expect(tester.takeException(), isNull);
  });
}
