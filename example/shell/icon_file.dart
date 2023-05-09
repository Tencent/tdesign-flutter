
import 'dart:convert';
import 'dart:io';

/// 用来批处理主题颜色变更的工具类
void main(){
  var path = '/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-flutter/example/shell/config.json';
  var dartPath = '/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-flutter/lib/src/theme/td_colors.dart';
  var file = File(path);
  if(!file.existsSync()){
    print('dir not exist， exit');
    return;
  }

  var config = file.readAsStringSync();
  var json = jsonDecode(config);
  List list = json['glyphs'];
  list.forEach((element) {
    var code = element['code'];
    String name = element['css'];
    name = name.replaceAll('.', '_');
    print('  static const $name = _TDIconsData($code, \'$name\');');
  });



  // print('parse jsonMap after size:${jsonMap.length}, jsonMap:${jsonEncode(jsonMap)}');
  // print('${jsonEncode(jsonMap)}');
}
