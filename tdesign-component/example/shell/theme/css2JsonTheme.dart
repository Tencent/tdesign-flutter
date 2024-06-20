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

    var cssContent = cssFile.readAsStringSync();

    // 过滤深色模式的配置
    cssContent = cssContent.split("[theme-mode=\"dark\"]")[0];

    final jsonMap = convertCssToJson(cssContent);

    var filterMap = <String,String>{};
    var colorKeys = <String>['brand', 'warning', 'error', 'success', 'gray'];
    jsonMap.forEach((key, value) {
      for (var element in colorKeys) {
        if (key.startsWith('--td-$element-color')) {
          var newKey = convertToCamelCase(key);
          var colorString = value.toString().replaceAll(';', '');
          filterMap[newKey] = colorString;
          break;
        }
      }
    });

    var functionNames = ['Light','Focus','Disabled','Hover','Active'];
    var defaultNames = ['brandColor','warningColor','errorColor','successColor'];
    var refMap = <String, String> {};
    var removeKey = [];
    filterMap.forEach((key, value) {
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

    outputMap[item.name] = themeMap;
  }

  outputFile.writeAsStringSync(json.encode(outputMap));
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

  return result.toString();
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
