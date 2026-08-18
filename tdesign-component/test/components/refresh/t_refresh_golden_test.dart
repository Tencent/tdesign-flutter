import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 下拉刷新「逐公开 Demo」Golden / 固定视口证据。
///
/// baseline（goldens/*.png）已随仓库提交，CI 会作为视觉回归断言自动运行
/// （与 `t_refresh_test.dart` 一同执行）。若视觉基线需要更新，在支持
/// Flutter 的环境执行一次
/// `flutter test test/components/refresh/t_refresh_golden_test.dart --update-goldens`
/// 后提交新的 baseline 即可。
void main() {
  setUpAll(() async {
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await robotoFont.load();
  });

  testWidgets('基础刷新 demo（固定视口）', (tester) async {
    tester.view.physicalSize = const Size(375, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData())
            .copyWith(textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto')),
        home: Scaffold(body: _buildRefreshDemo()),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byKey(const Key('refresh-demo-base')),
      matchesGoldenFile('goldens/t_refresh_base.png'),
    );
  });

  testWidgets('自定义提示语 demo（固定视口）', (tester) async {
    tester.view.physicalSize = const Size(375, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData())
            .copyWith(textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto')),
        home: Scaffold(body: _buildLoadingTextsDemo()),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byKey(const Key('refresh-demo-loading-texts')),
      matchesGoldenFile('goldens/t_refresh_loading_texts.png'),
    );
  });

  testWidgets('刷新超时 demo（固定视口）', (tester) async {
    tester.view.physicalSize = const Size(375, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData())
            .copyWith(textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto')),
        home: Scaffold(body: _buildTimeoutDemo()),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byKey(const Key('refresh-demo-timeout')),
      matchesGoldenFile('goldens/t_refresh_timeout.png'),
    );
  });
}

/// 与 example 的 _buildRefresh 保持同构的基础用法 demo。
Widget _buildRefreshDemo() {
  return RepaintBoundary(
    key: const Key('refresh-demo-base'),
    child: SizedBox(
      height: 300,
      child: TPullDownRefresh(
        onRefresh: () => Future<void>.delayed(const Duration(milliseconds: 1500)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Center(child: Text('拖拽该区域演示 顶部下拉刷新')),
            SizedBox(height: 16),
            Center(child: Text('下拉刷新次数：0')),
          ],
        ),
      ),
    ),
  );
}

/// 与 example 的 _buildLoadingTexts 保持同构的自定义提示语 demo。
Widget _buildLoadingTextsDemo() {
  return RepaintBoundary(
    key: const Key('refresh-demo-loading-texts'),
    child: SizedBox(
      height: 300,
      child: TPullDownRefresh(
        loadingBarHeight: 70,
        maxBarHeight: 100,
        texts: const TPullDownRefreshTexts(
          pullToRefresh: '下拉即可刷新...',
          releaseToRefresh: '释放即可刷新...',
          refreshing: '加载中...',
          refreshComplete: '刷新成功',
        ),
        onRefresh: () => Future<void>.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Center(child: Text('下拉刷新')),
            SizedBox(height: 16),
            Center(child: Text('自定义提示语刷新次数：0')),
          ],
        ),
      ),
    ),
  );
}

/// 与 example 的 _buildTimeout 保持同构的刷新超时 demo。
Widget _buildTimeoutDemo() {
  return RepaintBoundary(
    key: const Key('refresh-demo-timeout'),
    child: SizedBox(
      height: 300,
      child: TPullDownRefresh(
        refreshTimeout: const Duration(seconds: 1),
        onTimeout: () {},
        onRefresh: () => Completer<void>().future,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Center(child: Text('下拉刷新')),
            SizedBox(height: 16),
            Center(child: Text('超时刷新次数：0')),
          ],
        ),
      ),
    ),
  );
}
