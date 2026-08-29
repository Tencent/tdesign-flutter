import 'dart:io';

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

  test('成功加载字体后复用结果并拒绝切换 URL', () async {
    final fontBytes = await File(
      'assets/tdesign/TCloudNumberVF.ttf',
    ).readAsBytes();
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    var requestCount = 0;
    server.listen((request) async {
      requestCount += 1;
      request.response
        ..headers.contentType = ContentType('font', 'ttf')
        ..contentLength = fontBytes.length
        ..add(fontBytes);
      await request.response.close();
    });

    final name = 'valid-${DateTime.now().microsecondsSinceEpoch}';
    final url = 'http://${server.address.host}:${server.port}/font.ttf';
    final first = TFontLoader.load(name: name, fontFamilyUrl: url);
    final concurrent = TFontLoader.load(name: name, fontFamilyUrl: url);

    expect(identical(first, concurrent), isTrue);
    expect(await first, isTrue);
    expect(await TFontLoader.load(name: name, fontFamilyUrl: url), isTrue);
    expect(requestCount, 1);
    expect(
      await TFontLoader.load(name: name, fontFamilyUrl: '$url?different'),
      isFalse,
    );
  });
}
