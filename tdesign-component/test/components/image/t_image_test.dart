import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

part 't_image_cache_mode_test.dart';

void main() {
  Widget app(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  /// 需要真实走网络加载链路的测试：设置 mock 客户端并在测试体内复位。
  ///
  /// `debugNetworkImageHttpClientProvider` 是 painting debug 变量，框架在
  /// 测试体结束即校验复位，tearDown 时机晚于校验，因此用 try/finally 包裹。
  void networkTest(
    String description,
    Future<void> Function(WidgetTester tester) body,
  ) {
    testWidgets(description, (tester) async {
      debugNetworkImageHttpClientProvider = () => _OkHttpClient(kOnePixelPng);
      PaintingBinding.instance.imageCache.clear();
      try {
        await body(tester);
      } finally {
        debugNetworkImageHttpClientProvider = null;
        PaintingBinding.instance.imageCache.clear();
      }
    });
  }

  /// 把 URL 预置进 ImageCache（模拟已被其他组件加载过的既有缓存）。
  ///
  /// 图片加载是异步的，pending/live 条目已足以验证 disabled 模式的清除行为。
  void precacheNetwork(String url) {
    final stream = NetworkImage(url).resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((_, __) {}));
  }

  ImageCacheStatus statusOf(String url) => PaintingBinding
      .instance
      .imageCache
      .statusForKey(NetworkImage(url));

  Matcher untrackedStatus() => isA<ImageCacheStatus>().having(
    (status) => status.untracked,
    'untracked',
    isTrue,
  );

  Matcher trackedStatus() => isA<ImageCacheStatus>().having(
    (status) => status.tracked,
    'tracked',
    isTrue,
  );

  networkTest('default cache mode keeps Flutter cache behavior', (tester) async {
    const url = 'https://example.com/default.png';
    await tester.pumpWidget(app(const TImage(src: url, width: 72, height: 72)));
    await tester.pumpAndSettle();

    expect(statusOf(url), trackedStatus());

    // 卸载后缓存条目保留，同 URL 再挂载可命中缓存。
    await tester.pumpWidget(app(const SizedBox.shrink()));
    await tester.pump();
    expect(statusOf(url), trackedStatus());
  });

  networkTest('disabled mode evicts pre-existing cache on mount', (
    tester,
  ) async {
    const url = 'https://example.com/disabled.png';

    // 预置既有缓存条目，模拟其他组件已加载过同一 URL。
    precacheNetwork(url);
    await tester.pump();
    expect(
      statusOf(url).pending || statusOf(url).live,
      isTrue,
      reason: '预置后缓存条目应处于 pending/live 状态',
    );

    // disabled 模式挂载时清除既有缓存并重新拉取，保证拿到最新数据。
    await tester.pumpWidget(
      app(
        const TImage(
          src: url,
          width: 72,
          height: 72,
          cacheMode: TImageCacheMode.disabled,
        ),
      ),
    );
    await tester.pump();
    final fresh = statusOf(url);
    expect(
      fresh.keepAlive,
      isFalse,
      reason: '挂载时既有缓存条目应被清除',
    );
    expect(
      fresh.tracked,
      isTrue,
      reason: '清除后组件重新拉取，新条目进入缓存追踪',
    );

    // 卸载后缓存条目被清除，不保留给后续复用。
    await tester.pumpWidget(app(const SizedBox.shrink()));
    await tester.pump();
    expect(statusOf(url), untrackedStatus());
  });

  networkTest('disabled mode clears url cache when instance is recycled', (
    tester,
  ) async {
    const url = 'https://example.com/rebuild.png';
    await tester.pumpWidget(
      app(
        const TImage(
          key: ValueKey(1),
          src: url,
          cacheMode: TImageCacheMode.disabled,
        ),
      ),
    );
    await tester.pump();
    expect(statusOf(url), trackedStatus());

    // 同 key 同源 rebuild：流复用，条目保留。
    await tester.pumpWidget(
      app(
        const TImage(
          key: ValueKey(1),
          src: url,
          cacheMode: TImageCacheMode.disabled,
        ),
      ),
    );
    await tester.pump();
    expect(statusOf(url), trackedStatus());

    // 换 key 重建：旧实例销毁时清除该 URL 缓存（新实例展示不受影响）。
    await tester.pumpWidget(
      app(
        const TImage(
          key: ValueKey(2),
          src: url,
          cacheMode: TImageCacheMode.disabled,
        ),
      ),
    );
    await tester.pump();
    expect(statusOf(url), untrackedStatus());

    await tester.pumpWidget(app(const SizedBox.shrink()));
    await tester.pump();
    expect(statusOf(url), untrackedStatus());
  });

  networkTest('disabled mode evicts the old source when source changes', (
    tester,
  ) async {
    const oldUrl = 'https://example.com/old.png';
    const newUrl = 'https://example.com/new.png';
    await tester.pumpWidget(
      app(const TImage(src: oldUrl, cacheMode: TImageCacheMode.disabled)),
    );
    await tester.pump();
    expect(statusOf(oldUrl), trackedStatus());

    await tester.pumpWidget(
      app(const TImage(src: newUrl, cacheMode: TImageCacheMode.disabled)),
    );
    await tester.pump();

    // 旧源条目已清除，新源条目正常追踪。
    expect(statusOf(oldUrl), untrackedStatus());
    expect(statusOf(newUrl), trackedStatus());
  });

  networkTest('disabled mode evicts on dispose so cache is not reused', (
    tester,
  ) async {
    const url = 'https://example.com/dispose.png';
    await tester.pumpWidget(
      app(const TImage(src: url, cacheMode: TImageCacheMode.disabled)),
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(app(const SizedBox.shrink()));
    await tester.pump();
    expect(statusOf(url), untrackedStatus());
  });

  networkTest('enabled mode keeps the entry cached across dispose', (
    tester,
  ) async {
    const url = 'https://example.com/enabled.png';
    await tester.pumpWidget(app(const TImage(src: url)));
    await tester.pumpAndSettle();
    await tester.pumpWidget(app(const SizedBox.shrink()));
    await tester.pump();

    expect(statusOf(url), trackedStatus());
  });

  testWidgets('cacheMode never affects asset sources', (tester) async {
    await tester.pumpWidget(
      app(
        const TImage(
          src: 'assets/image.png',
          cacheMode: TImageCacheMode.disabled,
        ),
      ),
    );
    await tester.pump();
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<AssetImage>());
  });

  testWidgets('network provider keeps cacheWidth and cacheHeight wrapping', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const TImage(
          src: 'https://example.com/resized.png',
          cacheWidth: 30,
          cacheHeight: 20,
        ),
      ),
    );
    await tester.pump();
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<ResizeImage>());
    final resized = image.image as ResizeImage;
    expect(resized.width, 30);
    expect(resized.height, 20);
    expect(resized.imageProvider, isA<NetworkImage>());
  });

  test('cache mode enum documents both strategies', () {
    expect(TImageCacheMode.values, hasLength(2));
  });
}
