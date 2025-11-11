import 'dart:convert';
import 'dart:io';

void main() {
  final currentDirectory = Directory.current;
  print('当前运行文件所在的路径：${currentDirectory.path}');
  var basePath = '${currentDirectory.path}/shell/theme/';
  final greenFilePath = '${basePath}green.css';
  final redFilePath = '${basePath}red.css';
  // final jsonFilePath = '${basePath}cssTheme.json';
  final themeFilePath = '${currentDirectory.path}/assets/theme.json';

  genThemeJson(items: [
    ThemeItem(name: 'green', cssPath: greenFilePath),
    ThemeItem(name: 'red', cssPath: redFilePath),
  ], output: themeFilePath);
}

class ThemeItem {
  String name;
  String cssPath;

  ThemeItem({required this.name, required this.cssPath});
}

void genThemeJson({required List<ThemeItem> items, required String output}) {
  var outputMap = {};
  final outputFile = File(output);
  for (var item in items) {
    final cssFile = File(item.cssPath);
    // final jsonFile = File(jsonFilePath);
    print('cssFilePath：${item.cssPath}');
    // print('jsonFilePath：${jsonFilePath}');

    if (!cssFile.existsSync()) {
      print('CSS file does not exist.');
      return;
    }

    var cssContents = cssFile.readAsStringSync();

    var cssContentList = cssContents.split('[theme-mode="dark"]');
    // 亮色模式模式的配置
    var cssContentLight = cssContentList[0];
    var themeMap = parseCss(cssContentLight);
    outputMap[item.name] = themeMap;

    // 暗色模式模式的配置
    if (cssContentList.length > 1) {
      var cssContentDark = cssContentList[1];
      var themeMapDark = parseCss(cssContentDark);
      outputMap['${item.name}Dark'] = themeMapDark;
    }
  }

  outputFile.writeAsStringSync(json.encode(outputMap));
}

Map<dynamic, dynamic> parseCss(String cssContentLight) {
  final jsonMap = convertCssToJson(cssContentLight);

  var filterMap = <String,String>{};
  var colorKeys = <String>['brand', 'warning', 'error', 'success', 'gray'];
  jsonMap.forEach((key, value) {
    for (var element in colorKeys) {
      if (key.startsWith('--td-$element-color') ||
          key.startsWith('--td-bg-color') ||
          key.startsWith('--td-text-color') ||
          key.startsWith('--td-component') ||
          key.startsWith('--td-font-white') ||
          key.startsWith('--td-font-gray')
      ) {
        var newKey = convertToCamelCase(key);
        var valueString = value.toString();
        if (valueString.startsWith('#') || valueString.startsWith('var')) {
          // 处理#开头的色值
          var colorString = valueString.replaceAll(';', '');
          if (colorString.length == 4) {
            // 处理 #eee 这类颜色，将#eee扩展为#eeeeee
            var sb = StringBuffer('#');
            sb.write(colorString[1]);
            sb.write(colorString[1]);
            sb.write(colorString[2]);
            sb.write(colorString[2]);
            sb.write(colorString[3]);
            sb.write(colorString[3]);
            colorString = sb.toString();
          } else if (colorString.length == 9) {
            // 把#rrggbbaa格式的颜色字符串，转换为#AARRGGBB格式的颜色字符串
            var sb = StringBuffer('#');
            sb.write(colorString[7]);
            sb.write(colorString[8]);
            sb.write(colorString[1]);
            sb.write(colorString[2]);
            sb.write(colorString[3]);
            sb.write(colorString[4]);
            sb.write(colorString[5]);
            sb.write(colorString[6]);
            colorString = sb.toString();
          }
          filterMap[newKey] = colorString;
        } else if(valueString.startsWith('rgba')){
          // 将 "rgba(255, 255, 255, 0.22);"格式的颜色字符串valueString，转换为#AARRGGBB格式的颜色字符串
          try {
            var colorString = valueString.replaceAll(';', '');
            var color = colorString.replaceAll('rgba(', '').replaceAll(')', '');
            var colorList = color.split(',');
            var r = int.parse(colorList[0].trim());
            var g = int.parse(colorList[1].trim());
            var b = int.parse(colorList[2].trim());
            var a = double.parse(colorList[3].trim());
            
            // 更精确的透明度计算，避免精度损失
            var alphaInt = (a * 255).toInt();
            
            // 生成完整的十六进制颜色值
            var hexColor = '#${alphaInt.toRadixString(16).padLeft(2, '0')}'
                          '${r.toRadixString(16).padLeft(2, '0')}'
                          '${g.toRadixString(16).padLeft(2, '0')}'
                          '${b.toRadixString(16).padLeft(2, '0')}';
            
            filterMap[newKey] = hexColor.toUpperCase();
          } catch (e) {
            print('颜色转换错误: $valueString, 错误: $e');
            filterMap[newKey] = '#FFFFFFFF'; // 默认白色
          }
        }
        break;
      }

    }
  });

  var functionNames = ['Light','Focus','Disabled','Hover','Active'];
  var defaultNames = ['brandColor','warningColor','errorColor','successColor'];
  var refMap = <String, String> {};
  var removeKey = [];
  filterMap.forEach((key, value) {
    // --td-bg-color-container-active
    if (value.contains('var(')) {
      var field = value.replaceAll('var(', '').replaceAll(')', '');
      for (var f in functionNames) {
        if (key.endsWith(f)) {
          // 替换brandColorLight格式命名为brandLightColor
          var reKey = key.replaceAll('Color$f', '${f}Color');
          refMap[reKey] = convertToCamelCase(field);
          removeKey.add(key);
          return;
        }
      }
      for (var d in defaultNames){
        if(key == d){
          // 替换brandColor格式命名为brandNormalColor
          var reKey = key.replaceAll('Color', 'NormalColor');
          refMap[reKey] = convertToCamelCase(field);
          removeKey.add(key);
          return;
        }
      }
      refMap[key] = convertToCamelCase(field);
      removeKey.add(key);
    }
  });
  // 清除已处理的Key
  removeKey.forEach((key){
    filterMap.remove(key);
  });
  var themeMap = {};
  themeMap['ref'] = refMap;
  themeMap['color'] = filterMap;
  return themeMap;
}

int? toColorInt(String colorStr, {double alpha = 1}) {
  try {
    var hexColor = colorStr.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      if (alpha < 0) {
        alpha = 0;
      } else if (alpha > 1) {
        alpha = 1;
      }
      var alphaInt = (0xFF * alpha).toInt();
      var alphaString = alphaInt.toRadixString(16);

      hexColor = '$alphaString$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  } catch (e) {
    // Log.w('toColor', 'error: $e');
  }
  return null;
}

String convertToCamelCase(String input) {
  input = input.replaceAll('--td-', '');
  final parts = input.split('-');
  final result = StringBuffer(parts[0]);

  for (var i = 1; i < parts.length; i++) {
    final part = parts[i];
    if (part.isNotEmpty) {
      final camelCasePart = part[0].toUpperCase() + part.substring(1);
      result.write(camelCasePart);
    }
  }

  var resultString = result.toString();
  // 特殊命名处理
  if(resultString.contains('Secondarycontainer')){
    resultString = resultString.replaceAll('Secondarycontainer', 'SecondaryContainer');
  } else if(resultString.contains('Secondarycomponent')){
    resultString = resultString.replaceAll('Secondarycomponent', 'SecondaryComponent');
  } else if(resultString.contains('Specialcomponent')){
    resultString = resultString.replaceAll('Specialcomponent', 'SpecialComponent');
  } else if(resultString.startsWith('component')){
    resultString = '${resultString}Color';
  } else if(resultString == 'textDisabledColor'){
    resultString = 'textColorDisabled';
  } else if(resultString.startsWith('fontWhite')){
    resultString = resultString.replaceAll('fontWhite', 'fontWhColor');
  } else if(resultString.startsWith('fontGray')){
    resultString = resultString.replaceAll('fontGray', 'fontGyColor');
  }
  return resultString;
}

Map<String, dynamic> convertCssToJson(String cssContent) {
  final jsonMap = <String, dynamic>{};

  final lines = cssContent.split('\n');
  for (final line in lines) {
    final trimmedLine = line.trim();
    if (trimmedLine.isNotEmpty && !trimmedLine.startsWith('//')) {
      final parts = trimmedLine.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
        jsonMap[key] = value;
      }
    }
  }

  return jsonMap;
  // final jsonString = json.encode(jsonMap);
  // return jsonString;
}
