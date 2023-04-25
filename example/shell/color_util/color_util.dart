
import 'dart:convert';
import 'dart:io';

/// 用来批处理主题颜色变更的工具类
void main(){
  var path = '/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-flutter/example/shell/color_util/color.txt';
  var dartPath = '/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-flutter/lib/src/theme/td_colors.dart';
  var file = File(path);
  if(!file.existsSync()){
    print('dir not exist， exit');
    return;
  }

  var lines = file.readAsLinesSync();
  print('file  exist, lines:${lines.length}');

  var colorMap = <String,String>{};
  var keys = <String>{};
  var color = '';
  var invalid = false;
  var record = false;
  lines.forEach((element) {
    if(element.startsWith('/* Example */')){
      invalid = true;
    }
    if(!invalid){
      return;
    }
    if(record){
      color = element.replaceFirst('background: ', '')
          .replaceAll(';', '');
      if (color.isNotEmpty && color.startsWith('#')) {
        keys.forEach((element) {
          colorMap[element] = color;
        });
        keys.clear();
      }
      record = false;
    }
    if(element.startsWith('/* Brand')
        || element.startsWith('/* Error')
        || element.startsWith('/* Warning')
        || element.startsWith('/* Success')
    ){
      element = element.replaceAll('/* ', '').replaceAll(' */', '');
      var strings = element.split('/');
      if(strings.length > 1){
        var validKey = strings[1];
        // var aliasKey;
        if(validKey.contains('-')){
          var vks = validKey.split('-');
          validKey = vks[0];
          // aliasKey = vks[1];
        }
        var numLength = validKey.endsWith('0') ? 2 : 1;
        var number = validKey.substring(validKey.length - numLength,validKey.length);
        var key = validKey.substring(0,validKey.length - numLength);
        var finalKey = '${key.toLowerCase()}Color${number}';
        // print('finalKey ${finalKey}, element:$element');
        keys.add(finalKey);
        // TODO:特殊标识的可能和之前的不一样，需要修改
        // if(aliasKey != null){
        //   finalKey = '${key.toLowerCase()}${aliasKey}Color';
        //   // print('finalKey2 ${finalKey}, element:$element');
        //   keys.add(finalKey);
        // }
      }
      record = true;
    } else if(
     // element.startsWith('/* Text&Icon') ||
    element.startsWith('/* Gray')){

      element = element.replaceAll('/* ', '').replaceAll(' */', '');
      var strings = element.split('/');
      if(strings.length > 1){
        var validKey = strings[1];
        if (validKey.startsWith('Gray')) {
          var numLength = validKey.length == 6 ? 2 : 1;
          var number = validKey.substring(validKey.length - numLength,validKey.length);
          var key = validKey.substring(0,validKey.length - numLength);
          var finalKey = '${key.toLowerCase()}Color${number}';
          // print('finalKey ${finalKey}, element:$element');
          keys.add(finalKey);
          record = true;
        }
      }
    }

  });

  print('parse Map size:${colorMap.length}, map:${colorMap}');

  Map jsonMap = jsonDecode(oldColor);

  print('parse jsonMap size:${jsonMap.length}');

  var dartFile = File(dartPath);
  if(dartFile.existsSync()){

    var dartContentLines = dartFile.readAsLinesSync();
    var tempLines = List<String?>.filled(dartContentLines.length, null, growable: false);
    colorMap.forEach((key, value) {
      String oldColor = jsonMap[key];
      oldColor = oldColor.substring(1, oldColor.length);
      value = value.substring(1, value.length);
      if(value != oldColor){
        print('key $key, old:$oldColor, new:$value');
        // 前后颜色不一致
        // dartContent = dartContent.replaceAll(oldColor, value);
        for(var i = 0; i < dartContentLines.length; i++){
          var line = dartContentLines[i];
          if(line.contains(oldColor)){
            // if(tempLines[i] == null){
            //   tempLines[i] = line.replaceAll(oldColor, value);
            // }
            tempLines[i] = line.replaceAll(oldColor, value);
            print('count : $i, line:$line, tempLines:${tempLines[i]}');
          }
        }
      }
    });

    var sb = StringBuffer();
    for(var i = 0; i < dartContentLines.length; i++){
      if(tempLines[i] == null){
        sb.writeln(dartContentLines[i]);
      } else {
        sb.writeln(tempLines[i]);
      }
    }
    dartFile.writeAsStringSync(sb.toString());
    print('update dart file success');
  }




  // print('parse jsonMap after size:${jsonMap.length}, jsonMap:${jsonEncode(jsonMap)}');
  // print('${jsonEncode(jsonMap)}');
}

var oldColor = '''
{
			"brandColor1": "#ECF2FE",
			"brandColor2": "#D4E3FC",
			"brandColor3": "#BBD3FB",
			"brandColor4": "#96BBF8",
			"brandColor5": "#699EF5",
			"brandColor6": "#4787F0",
			"brandColor7": "#266FE8",
			"brandColor8": "#0052D9",
			"brandColor9": "#0034B5",
			"brandColor10": "#001F97",
			"brandLightColor": "#ECF2FE",
			"brandFocusColor": "#D4E3FC",
			"brandDisabledColor": "#BBD3FB",
			"brandHoverColor": "#266FE8",
			"brandNormalColor": "#0052D9",
			"brandClickColor": "#0034B5",
			"errorColor1": "#FDECEE",
			"errorColor2": "#F9D7D9",
			"errorColor3": "#F8B9BE",
			"errorColor4": "#F78D94",
			"errorColor5": "#F36D78",
			"errorColor6": "#E34D59",
			"errorColor7": "#C9353F",
			"errorColor8": "#B11F26",
			"errorColor9": "#951114",
			"errorColor10": "#680506",
			"errorLightColor": "#FDECEE",
			"errorFocusColor": "#F9D7D9",
			"errorDisabledColor": "#F8B9BE",
			"errorHoverColor": "#F36D78",
			"errorNormalColor": "#E34D59",
			"errorClickColor": "#C9353F",
			"warningColor1": "#FEF3E6",
			"warningColor2": "#F9E0C7",
			"warningColor3": "#F7C797",
			"warningColor4": "#F2995F",
			"warningColor5": "#ED7B2F",
			"warningColor6": "#D35A21",
			"warningColor7": "#BA431B",
			"warningColor8": "#9E3610",
			"warningColor9": "#842B0B",
			"warningColor10": "#5A1907",
			"warningLightColor": "#FEF3E6",
			"warningFocusColor": "#F9E0C7",
			"warningDisabledColor": "#F7C797",
			"warningHoverColor": "#F2995F",
			"warningNormalColor": "#ED7B2F",
			"warningClickColor": "#D35A21",
			"successColor1": "#E8F8F2",
			"successColor2": "#BCEBDC",
			"successColor3": "#85DBBE",
			"successColor4": "#48C79C",
			"successColor5": "#00A870",
			"successColor6": "#078D5C",
			"successColor7": "#067945",
			"successColor8": "#056334",
			"successColor9": "#044F2A",
			"successColor10": "#033017",
			"successLightColor": "#E8F8F2",
			"successFocusColor": "#BCEBDC",
			"successDisabledColor": "#85DBBE",
			"successHoverColor": "#48C79C",
			"successNormalColor": "#00A870",
			"successClickColor": "#078D5C",
			"fontGyColor1": "#E6000000",
			"fontGyColor2": "#99000000",
			"fontGyColor3": "#66000000",
			"fontGyColor4": "#42000000",
			"fontWhColor1": "#FFFFFFFF",
			"fontWhColor2": "#8CFFFFFF",
			"fontWhColor3": "#59FFFFFF",
			"fontWhColor4": "#38FFFFFF",
			"whiteColor1": "#FFFFFF",
			"grayColor1": "#F3F3F3",
			"grayColor2": "#EEEEEE",
			"grayColor3": "#E7E7E7",
			"grayColor4": "#DCDCDC",
			"grayColor5": "#C5C5C5",
			"grayColor6": "#A6A6A6",
			"grayColor7": "#8B8B8B",
			"grayColor8": "#777777",
			"grayColor9": "#5E5E5E",
			"grayColor10": "#4B4B4B",
			"grayColor11": "#383838",
			"grayColor12": "#2C2C2C",
			"grayColor13": "#242424",
			"grayColor14": "#181818"
		}
''';