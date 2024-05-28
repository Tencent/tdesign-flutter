import 'dart:io' show Platform;

import 'log.dart';
import 'platform_util.dart';

/// flutter web 是否在Dart 3.2.0版本之后
bool kIsFlutterWebAfter320 = false;

class VersionUtil {
  static String getDartVersion(){
    return  Platform.version.split(' ').first;
  }

  /// 当前版本号是否大于等于目标版本号
  static bool isAfterThen(String target){
    try {
      if(PlatformUtil.isWeb){
        // TODO: 需要适配flutter web的具体逻辑
        return kIsFlutterWebAfter320;
      }
      var targets = target.split('.');
      var currents = getDartVersion().split('.');
      if(targets.length != currents.length){
            Log.w('VersionUtil', 'targets.length != currents.length');
            return false;
          }
      for(var i = 0; i < targets.length; i++){
            var targetVersion = int.parse(targets[i]);
            var currentVersion = int.parse(currents[i]);
            if(targetVersion == currentVersion){
              continue;
            }
            return currentVersion > targetVersion;
          }
      return true;
    } catch (e) {
      Log.e('VersionUtil', 'isAfterThen target: $target, error: $e');
    }
    return false;
  }
}

// void main(){
//   print(VersionUtil.isAfterThen('2.19.6'));
//   print(VersionUtil.isAfterThen('2.19.5'));
//   print(VersionUtil.isAfterThen('2.19.7'));
//   print(VersionUtil.isAfterThen('2.18.7'));
//   print(VersionUtil.isAfterThen('2.20.5'));
//   print(VersionUtil.isAfterThen('2.19'));
//   print(VersionUtil.isAfterThen('2.20.9.1'));
// }