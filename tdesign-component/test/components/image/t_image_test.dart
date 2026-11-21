import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

part 't_image_cache_mode_part.dart';

void main() {
  Widget app(Widget child, {TImageThemeData? imageTheme}) => MaterialApp(
    theme: ThemeData(
      extensions: [
        TThemeData.defaultData(),
        if (imageTheme != null) imageTheme,
      ],
    ),
    home: Scaffold(body: Center(child: child)),
  );

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

  ImageCacheStatus statusOf(String url) =>
      PaintingBinding.instance.imageCache.statusForKey(NetworkImage(url));

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

  testWidgets('network source resolves standard Image builders', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const TImage(
          src: 'https://example.com/image.png',
          width: 100,
          height: 80,
          semanticLabel: 'preview',
        ),
        imageTheme: const TImageThemeData(),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<NetworkImage>());
    expect(image.width, 100);
    expect(image.height, 80);
    expect(image.semanticLabel, 'preview');
    expect(image.loadingBuilder, isNotNull);
    expect(image.errorBuilder, isNotNull);
  });

  testWidgets('default loading and error builders render placeholders', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const TImage(
          src: 'https://example.com/image.png',
          loadingWidget: Text('loading'),
          errorWidget: Text('error'),
        ),
      ),
    );
    final image = tester.widget<Image>(find.byType(Image));
    final context = tester.element(find.byType(Image));

    final loading = image.loadingBuilder!(
      context,
      const Text('child'),
      const ImageChunkEvent(cumulativeBytesLoaded: 1, expectedTotalBytes: 2),
    );
    final failed = image.errorBuilder!(context, StateError('failed'), null);
    await tester.pumpWidget(app(loading));
    expect(find.text('loading'), findsOneWidget);
    expect(tester.getSize(find.text('loading')), isNot(Size.zero));
    expect(
      tester.getSize(
        find
            .ancestor(of: find.text('loading'), matching: find.byType(SizedBox))
            .first,
      ),
      const Size(72, 72),
    );

    await tester.pumpWidget(app(failed));
    expect(find.text('error'), findsOneWidget);
    expect(
      tester.getSize(
        find
            .ancestor(of: find.text('error'), matching: find.byType(SizedBox))
            .first,
      ),
      const Size(72, 72),
    );
  });

  testWidgets('missing source loads while empty source fails', (tester) async {
    await tester.pumpWidget(app(const TImage()));
    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(TIcons.ellipsis), findsOneWidget);
    expect(tester.getSize(find.byType(TImage)), const Size(72, 72));

    await tester.pumpWidget(
      app(
        const TImage(
          width: 96,
          height: 64,
          loadingWidget: Text('custom loading'),
        ),
      ),
    );
    expect(find.text('custom loading'), findsOneWidget);
    expect(tester.getSize(find.byType(TImage)), const Size(96, 64));

    await tester.pumpWidget(app(const TImage(src: '')));
    expect(find.byIcon(TIcons.close), findsOneWidget);

    await tester.pumpWidget(
      app(const TImage(src: '', errorWidget: Text('custom error'))),
    );
    expect(find.text('custom error'), findsOneWidget);
  });

  testWidgets('failed rounded image keeps resolved bounds and clipping', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const TImage(
          src: 'missing-asset.png',
          width: 96,
          height: 64,
          shape: TImageShape.roundedSquare,
          errorWidget: Text('failed'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('failed'), findsOneWidget);
    expect(find.byType(ClipRRect), findsOneWidget);
    expect(tester.getSize(find.byType(TImage)), const Size(96, 64));
    expect(tester.getSize(find.byType(ClipRRect)), const Size(96, 64));
  });

  testWidgets('placeholder uses TDesign token instead of Material surface', (
    tester,
  ) async {
    final token = TThemeData.defaultData();
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
      ).copyWith(surfaceContainerHighest: Colors.red),
      extensions: [token],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: TImage(
            src: 'https://example.com/image.png',
            loadingWidget: Text('loading'),
          ),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    final loading = image.loadingBuilder!(
      tester.element(find.byType(Image)),
      const Text('child'),
      const ImageChunkEvent(cumulativeBytesLoaded: 1, expectedTotalBytes: 2),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: loading),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox && widget.color == token.bgColorComponent,
      ),
      findsOneWidget,
    );
  });

  testWidgets('completed loading returns decoded child', (tester) async {
    await tester.pumpWidget(
      app(const TImage(src: 'https://example.com/image.png')),
    );
    final image = tester.widget<Image>(find.byType(Image));
    final child = image.loadingBuilder!(
      tester.element(find.byType(Image)),
      const Text('decoded'),
      null,
    );
    expect(child, isA<Text>());
  });

  testWidgets('asset and file sources use their matching providers', (
    tester,
  ) async {
    await tester.pumpWidget(app(const TImage(src: 'assets/image.png')));
    expect(tester.widget<Image>(find.byType(Image)).image, isA<AssetImage>());

    await tester.pumpWidget(
      app(
        TImage(
          imageFile: File('/tmp/not-found.png'),
          fit: BoxFit.fill,
          excludeFromSemantics: true,
          cacheWidth: 20,
          cacheHeight: 20,
        ),
        imageTheme: const TImageThemeData(
          color: Colors.red,
          colorBlendMode: BlendMode.srcIn,
          centerSlice: Rect.fromLTWH(1, 1, 2, 2),
          matchTextDirection: true,
          gaplessPlayback: true,
          isAntiAlias: true,
        ),
      ),
    );
    final fileProvider =
        tester.widget<Image>(find.byType(Image)).image as ResizeImage;
    expect(fileProvider.imageProvider, isA<FileImage>());
    expect(fileProvider.width, 20);
    expect(fileProvider.height, 20);
  });

  testWidgets('shape and fit are independent', (tester) async {
    for (final shape in TImageShape.values) {
      await tester.pumpWidget(
        app(
          TImage(key: ValueKey(shape), src: 'assets/image.png', shape: shape),
        ),
      );
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.fill);
    }

    await tester.pumpWidget(
      app(
        const TImage(
          src: 'assets/image.png',
          shape: TImageShape.circle,
          fit: BoxFit.contain,
        ),
      ),
    );
    expect(find.byType(ClipOval), findsOneWidget);

    await tester.pumpWidget(
      app(
        const TImage(
          src: 'assets/image.png',
          shape: TImageShape.roundedSquare,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('实例解码与语义参数、Theme 视觉参数传递到 Image', (tester) async {
    const theme = TImageThemeData(
      color: Colors.red,
      colorBlendMode: BlendMode.srcIn,
      matchTextDirection: true,
      gaplessPlayback: true,
      isAntiAlias: true,
    );
    await tester.pumpWidget(
      app(
        const TImage(
          src: 'assets/image.png',
          fit: BoxFit.contain,
          excludeFromSemantics: true,
          cacheWidth: 100,
          cacheHeight: 80,
        ),
        imageTheme: theme,
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.fit, BoxFit.contain);
    expect(image.color, Colors.red);
    expect(image.colorBlendMode, BlendMode.srcIn);
    expect(image.excludeFromSemantics, isTrue);
    expect(image.isAntiAlias, isTrue);
    final provider = image.image as ResizeImage;
    expect(provider.width, 100);
    expect(provider.height, 80);
  });

  testWidgets('onTap owns interaction for loading, failed, and image states', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(app(TImage(onTap: () => taps++)));
    await tester.tap(find.byType(TImage));

    await tester.pumpWidget(app(TImage(src: '', onTap: () => taps++)));
    await tester.tap(find.byType(TImage));

    await tester.pumpWidget(
      app(TImage(src: 'assets/image.png', onTap: () => taps++)),
    );
    await tester.tap(find.byType(TImage));
    expect(taps, 3);

    await tester.pumpWidget(app(const TImage(src: 'assets/image.png')));
    expect(
      find.descendant(
        of: find.byType(TImage),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets('onLoad fires once on the first image frame', (tester) async {
    var loads = 0;
    var frameBuilds = 0;

    Widget image(String src) => TImage(
      src: src,
      onLoad: () => loads++,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        frameBuilds++;
        return child;
      },
    );

    await tester.pumpWidget(app(image('first.png')));
    final rawImage = tester.widget<Image>(find.byType(Image));
    rawImage.frameBuilder!(
      tester.element(find.byType(Image)),
      const Text('image'),
      0,
      true,
    );
    await tester.pump();

    expect(loads, 1);
    expect(frameBuilds, greaterThan(0));

    await tester.pump();
    expect(loads, 1);
  });

  testWidgets('onError notifies once and errorBuilder only renders UI', (
    tester,
  ) async {
    var errors = 0;
    var errorBuilds = 0;
    Object? lastError;

    Widget failedImage() => TImage(
      src: '',
      onError: (error, stackTrace) {
        errors++;
        lastError = error;
      },
      errorBuilder: (context, error, stackTrace) {
        errorBuilds++;
        return const Text('failed');
      },
    );

    await tester.pumpWidget(app(failedImage()));
    expect(find.text('failed'), findsOneWidget);
    expect(errors, 1);
    expect(errorBuilds, 1);
    expect(lastError, isA<ArgumentError>());

    await tester.pumpWidget(app(failedImage()));
    expect(errors, 1);
    expect(errorBuilds, 2);

    await tester.pumpWidget(
      app(
        TImage(
          onLoad: () => fail('missing source must not load'),
          onError: (error, stackTrace) => fail('missing source must not fail'),
        ),
      ),
    );
    expect(errors, 1);

    await tester.pumpWidget(app(failedImage()));
    expect(errors, 2);
    expect(errorBuilds, 3);
  });

  test(
    'source contract allows loading state and rejects conflicting sources',
    () {
      expect(TImage.new, returnsNormally);
      expect(
        () => TImage(src: 'asset.png', imageFile: File('file.png')),
        throwsAssertionError,
      );
    },
  );

  test('theme data copyWith and lerp cover all value categories', () {
    const a = TImageThemeData(
      color: Colors.red,
      colorBlendMode: BlendMode.srcIn,
      centerSlice: Rect.fromLTWH(0, 0, 10, 10),
      matchTextDirection: false,
      gaplessPlayback: false,
      isAntiAlias: false,
    );
    const b = TImageThemeData(
      color: Colors.blue,
      colorBlendMode: BlendMode.dstIn,
      centerSlice: Rect.fromLTWH(10, 10, 20, 20),
      matchTextDirection: true,
      gaplessPlayback: true,
      isAntiAlias: true,
    );

    expect(a.copyWith().color, Colors.red);
    expect(a.lerp(b, 0.25).colorBlendMode, BlendMode.srcIn);
    expect(a.lerp(b, 0.75).matchTextDirection, isTrue);
    expect(a.lerp(b, 0.75).isAntiAlias, isTrue);
    expect(a.lerp(null, 0.5), same(a));
  });

  // ─── cacheMode 相关测试 ────────────────────────────────────────────────

  networkTest('default cache mode keeps Flutter cache behavior', (
    tester,
  ) async {
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
    expect(fresh.keepAlive, isFalse, reason: '挂载时既有缓存条目应被清除');
    expect(fresh.tracked, isTrue, reason: '清除后组件重新拉取，新条目进入缓存追踪');

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

  networkTest('disabled mode with cacheWidth/Height evicts cached entry', (
    tester,
  ) async {
    const url = 'https://example.com/resized-cache.png';
    await tester.pumpWidget(
      app(
        const TImage(
          src: url,
          cacheMode: TImageCacheMode.disabled,
          cacheWidth: 40,
          cacheHeight: 30,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 卸载后缓存条目被清除。
    await tester.pumpWidget(app(const SizedBox.shrink()));
    await tester.pump();
    expect(statusOf(url), untrackedStatus());
  });
}
