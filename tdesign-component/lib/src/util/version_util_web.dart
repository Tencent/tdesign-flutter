// Web 平台实现：dart:io 在 Web 上不可用，无法直接读取 Dart SDK 版本号。
//
// 这里提供一个可注入的版本号，默认返回空字符串（视为"未知版本"）。
// 业务方可在启动阶段通过 VersionUtil.setCurrentVersion 注入真实版本号
// （例如编译期常量或服务端下发），从而让 isAfterThen 在 Web 上也能可靠判断。

String _version = '';

/// Web 平台：返回当前 Dart/Flutter SDK 版本号。
///
/// 默认返回空字符串，表示"未知版本"；此时 [isAfterThen] 按"未达到目标版本"（false）处理。
/// 通过 [setPlatformVersion] 注入版本号后返回注入值。
String getPlatformVersion() => _version;

/// 设置 Web 平台当前的 Dart/Flutter SDK 版本号。
void setPlatformVersion(String version) {
  _version = version;
}
