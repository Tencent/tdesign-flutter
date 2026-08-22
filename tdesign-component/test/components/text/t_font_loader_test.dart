import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('同名字体并发请求复用 Future', () async {
    final name = 'invalid-concurrent-${DateTime.now().microsecondsSinceEpoch}';
    final first = TFontLoader.load(name: name, fontFamilyUrl: '');
    final second = TFontLoader.load(name: name, fontFamilyUrl: '');
    expect(identical(first, second), isTrue);
    expect(await first, isFalse);
  });

  test('加载失败后清除缓存并允许重试', () async {
    final name = 'invalid-retry-${DateTime.now().microsecondsSinceEpoch}';
    final first = TFontLoader.load(name: name, fontFamilyUrl: '');
    expect(await first, isFalse);
    await Future<void>.delayed(Duration.zero);
    final retry = TFontLoader.load(name: name, fontFamilyUrl: '');
    expect(identical(first, retry), isFalse);
    expect(await retry, isFalse);
  });

  test('同名字体加载期间拒绝切换 URL', () async {
    final name = 'invalid-conflict-${DateTime.now().microsecondsSinceEpoch}';
    final first = TFontLoader.load(name: name, fontFamilyUrl: '');
    final conflict = TFontLoader.load(
      name: name,
      fontFamilyUrl: 'https://example.com/other.ttf',
    );
    expect(await conflict, isFalse);
    expect(await first, isFalse);
  });
}
