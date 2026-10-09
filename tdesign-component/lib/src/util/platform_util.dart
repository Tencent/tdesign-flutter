import 'dart:io';

import 'package:flutter/foundation.dart';

/// 区分 Flutter Web 与原生宿主平台的工具。
class PlatformUtil {
  /// 当前是否运行于 Android 原生平台；Web 始终返回 false。
  static bool get isAndroid {
    return !kIsWeb && Platform.isAndroid;
  }

  /// 当前是否运行于 IOS 原生平台；Web 始终返回 false。
  static bool get isIOS {
    return !kIsWeb && Platform.isIOS;
  }

  /// 当前是否运行于 Fuchsia 原生平台；Web 始终返回 false。
  static bool get isFuchsia {
    return !kIsWeb && Platform.isFuchsia;
  }

  /// 当前是否运行于 Linux 原生平台；Web 始终返回 false。
  static bool get isLinux {
    return !kIsWeb && Platform.isLinux;
  }

  /// 当前是否运行于 MacOS 原生平台；Web 始终返回 false。
  static bool get isMacOS {
    return !kIsWeb && Platform.isMacOS;
  }

  /// 当前是否运行于 Ohos 原生平台；Web 始终返回 false。
  static bool get isOhos {
    return !kIsWeb && Platform.operatingSystem == 'ohos';
  }

  /// 当前是否运行于 Windows 原生平台；Web 始终返回 false。
  static bool get isWindows {
    return !kIsWeb && Platform.isWindows;
  }

  /// 当前是否编译并运行于 Flutter Web。
  static bool get isWeb {
    return kIsWeb;
  }
}
