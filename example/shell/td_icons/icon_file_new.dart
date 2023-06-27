
import 'dart:convert';
import 'dart:io';

/// 用来批处理主题颜色变更的工具类
void main(){
  var path = '/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-flutter/example/shell/td_icons/index.json';
  // var dartPath = '/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-flutter/lib/src/components/icon/td_icons_new.dart';
  var file = File(path);
  if(!file.existsSync()){
    print('file not exist， exit');
    return;
  }

  var config = file.readAsStringSync();
  var json = jsonDecode(config);
  List list = json['icons'];

  print('list lenght: ${list.length}');
  list.forEach((element) {
    String code = element['codepoint'];
    String name = element['name'];
    // name = name.replaceAll('.', '_');
    // _TDIconsData(0xf101, 'add_circle')
    name = name.replaceAll('-', '_');
    // print('  static const ${name.replaceAll('-', '_')} = IconData(0x${code.replaceFirst('\\', '')}, fontFamily: _kFontFam, fontPackage: _kFontPkg);');
    print('  static const ${name} = _TDIconsData(0x${code.replaceFirst('\\', '')}, \'$name\');');
  });

  list.forEach((element) {
    var name = element['name'].replaceAll('-', '_');
    print('\'$name\': $name,');
  });



  // print('parse jsonMap after size:${jsonMap.length}, jsonMap:${jsonEncode(jsonMap)}');
  // print('${jsonEncode(jsonMap)}');
}
