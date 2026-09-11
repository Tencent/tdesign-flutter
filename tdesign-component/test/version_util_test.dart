import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/util/version_util.dart';

/// VersionUtil 版本比较逻辑测试
///
/// - [VersionUtil.isAfter] 为纯函数，与平台无关，可稳定验证各段位版本比较逻辑
///   （等价于 Web 与非 Web 场景下共用同一套比较语义）。
/// - [VersionUtil.isAfterThen] 在原生测试环境会读取真实 Dart 版本，做冒烟验证。
void main() {
  group('VersionUtil.isAfter（纯逻辑版本比较，Web/原生共用）', () {
    test('当前版本大于目标版本', () {
      expect(VersionUtil.isAfter('2.20.5', '2.19.6'), isTrue);
      expect(VersionUtil.isAfter('2.19.7', '2.19.6'), isTrue);
      expect(VersionUtil.isAfter('3.0.0', '2.19.6'), isTrue);
    });

    test('当前版本小于目标版本', () {
      expect(VersionUtil.isAfter('2.19.5', '2.19.6'), isFalse);
      expect(VersionUtil.isAfter('2.18.7', '2.19.6'), isFalse);
      expect(VersionUtil.isAfter('2.19.6', '2.20.5'), isFalse);
    });

    test('当前版本等于目标版本', () {
      expect(VersionUtil.isAfter('2.19.6', '2.19.6'), isTrue);
      expect(VersionUtil.isAfter('2.20.9.1', '2.20.9.1'), isTrue);
    });

    test('按数字分段比较而非按字典序（跨位数比较）', () {
      // 9 < 10，逐段数字比较应正确返回 false
      expect(VersionUtil.isAfter('2.19.9', '2.19.10'), isFalse);
      expect(VersionUtil.isAfter('2.19.10', '2.19.9'), isTrue);
    });

    test('分段数量不一致时返回 false', () {
      expect(VersionUtil.isAfter('2.19', '2.19.6'), isFalse);
      expect(VersionUtil.isAfter('2.20.9.1', '2.20.9'), isFalse);
    });

    test('版本号无法解析或为空时返回 false 而不抛异常', () {
      expect(VersionUtil.isAfter('2.19.6', 'abc'), isFalse);
      expect(VersionUtil.isAfter('2.19.6', ''), isFalse);
      expect(VersionUtil.isAfter('', '2.19.6'), isFalse);
      expect(VersionUtil.isAfter('2.a.6', '2.19.6'), isFalse);
    });
  });

  group('VersionUtil.isAfterThen（集成冒烟）', () {
    test('原生环境能读取真实版本并完成比较而不抛异常', () {
      final current = VersionUtil.getCurrentVersion();
      expect(current, isNotEmpty);
      // 与自身比较恒为 true
      expect(VersionUtil.isAfterThen(current), isTrue);
    });
  });
}
