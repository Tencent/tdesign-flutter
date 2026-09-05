import 'dart:io' show Platform;

// 原生平台实现：通过 dart:io 读取当前 Dart SDK 版本号。
//
// Web 平台不使用本文件（通过条件导入切换到 version_util_web.dart）。

String _version = '';

/// 原生平台：返回当前 Dart SDK 版本号（`Platform.version` 的首段）。
///
/// 例如 `3.8.0 (stable) ...` 会被解析为 `3.8.0`。
String getPlatformVersion() {
  if (_version.isEmpty) {
    _version = Platform.version.split(' ').first;
  }
  return _version;
}

/// 原生平台会自动读取真实版本，因此本方法为 no-op，仅用于保持跨平台 API 一致。
void setPlatformVersion(String version) {
  // 原生平台无需（也不应）覆盖真实版本，忽略传入值。
}
