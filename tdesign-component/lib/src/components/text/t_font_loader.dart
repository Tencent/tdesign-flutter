import 'package:flutter/services.dart';

/// Flutter 动态字体注册工具。
///
/// 字体应在构建 Text 前加载完成；组件不会在绘制过程中隐式下载字体。
class TFontLoader {
  TFontLoader._();

  static final Map<String, _FontLoadRecord> _records = {};

  /// 下载并注册字体。
  ///
  /// 同一 [name] 和 [fontFamilyUrl] 的并发调用共享同一个 Future。加载失败会
  /// 清除缓存并允许重试；已经注册或正在注册的字体不能切换 URL。
  static Future<bool> load({
    /// 注册到 Flutter 字体系统中的字体族名称。
    required String name,

    /// 可直接下载的字体资源 URL。
    required String fontFamilyUrl,
  }) {
    final existing = _records[name];
    if (existing != null) {
      return existing.url == fontFamilyUrl
          ? existing.future
          : Future<bool>.value(false);
    }

    final future = _load(name: name, fontFamilyUrl: fontFamilyUrl);
    _records[name] = _FontLoadRecord(url: fontFamilyUrl, future: future);
    future.then((success) {
      if (!success && identical(_records[name]?.future, future)) {
        _records.remove(name);
      }
    });
    return future;
  }

  static Future<bool> _load({
    required String name,
    required String fontFamilyUrl,
  }) async {
    if (name.isEmpty || fontFamilyUrl.isEmpty) {
      return false;
    }
    try {
      final uri = Uri.parse(fontFamilyUrl);
      final bundle = NetworkAssetBundle(uri);
      final loader = FontLoader(name)..addFont(bundle.load(''));
      await loader.load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

class _FontLoadRecord {
  const _FontLoadRecord({required this.url, required this.future});

  final String url;
  final Future<bool> future;
}
