import 'log.dart';

// 通过条件导入实现平台差异化：原生平台读取 dart:io 的真实版本，Web 平台使用可注入的实现。
import 'version_util_io.dart'
    if (dart.library.js_interop) 'version_util_web.dart';

/// 版本号比较工具，用于判断当前 Dart/Flutter SDK 版本是否达到目标版本。
class VersionUtil {
  /// 获取当前 Dart/Flutter SDK 版本号。
  ///
  /// - 原生（Android/iOS/macOS/Windows/Linux 等）平台：从 `dart:io` 的 `Platform.version` 读取真实版本。
  /// - Web 平台：`dart:io` 不可用，默认返回空字符串（视为未知版本），
  ///   可通过 [setCurrentVersion] 在业务启动阶段注入真实版本，实现可靠的版本判断。
  static String getCurrentVersion() => getPlatformVersion();

  /// 设置当前 Dart/Flutter SDK 版本号（主要用于 Web 平台）。
  ///
  /// - 原生平台会自动从 `Platform.version` 读取，本方法为 no-op。
  /// - Web 平台默认无法读取运行时版本，调用本方法即可注入版本号（例如编译期常量或服务端下发），
  ///   此后 [isAfterThen] 便能基于该版本号做出正确判断。
  static void setCurrentVersion(String version) =>
      setPlatformVersion(version);

  /// 当前版本号是否大于等于目标版本号。
  ///
  /// 版本号按 `.` 分段逐段比较（如 `2.19.6`）。当分段数量不一致、版本号无法解析、
  /// 或当前版本未知（Web 平台未注入版本号）时，统一返回 `false`，
  /// 即按"尚未达到目标版本"的保守语义处理，并在日志中给出提示。
  static bool isAfterThen(String target) {
    return isAfter(getCurrentVersion(), target);
  }

  /// 判断 [current] 版本号是否大于等于 [target] 版本号（纯逻辑，与平台无关）。
  ///
  /// 版本号按 `.` 分段逐段比较（如 `2.19.6`）。当版本号为空、无法解析，
  /// 或 [current] 为空（未知版本）时，统一返回 `false`，即按"尚未达到目标版本"处理。
  ///
  /// 注意：当分段数量不一致（如 `2.20` vs `2.19.6`）时同样返回 `false`（保守语义）。
  /// 即使其中一方分段数更少但数值上更大（例如 `2.20 > 2.19.6`），也会被判定为"未达到目标版本"。
  /// 这是因为我们要求调用方提供语义一致、分段数相同的版本号，以避免跨位数比较带来的歧义。
  ///
  /// 该方法是纯函数，便于跨平台单测；[isAfterThen] 内部调用它。
  static bool isAfter(String current, String target) {
    try {
      // 空字符串在 split('.') 后返回 [""] 而非空列表，因此这里需要在分割前先判空，
      // 保证空版本号能被直观地识别为"未知版本"并返回 false。
      if (current.isEmpty || target.isEmpty) {
        Log.w('VersionUtil',
            'target or current version is empty, current: $current, target: $target');
        return false;
      }
      var targets = target.split('.');
      var currents = current.split('.');
      if (targets.length != currents.length) {
        Log.w('VersionUtil', 'targets.length != currents.length');
        return false;
      }
      for (var i = 0; i < targets.length; i++) {
        var targetVersion = int.parse(targets[i]);
        var currentVersion = int.parse(currents[i]);
        if (targetVersion == currentVersion) {
          continue;
        }
        return currentVersion > targetVersion;
      }
      return true;
    } catch (e) {
      Log.e('VersionUtil',
          'isAfter current: $current, target: $target, error: $e');
    }
    return false;
  }
}
