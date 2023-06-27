import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'example_base.dart';
import 'example_widget.dart';

class WebMdTool {

  WebMdTool._();

  /// 用于生成web端的md,正常使用不要开启
  static const bool needGenerateWebMd = true;

  /// 生成web端的md
  static void generateWebMd({
    required ExamplePageModel? model,
    required String description,
    required String? exampleCodeGroup,
    required List<ExampleModule> exampleModuleList,
    required List<ExampleItem> testList,
}) async {
    if(needGenerateWebMd && model != null && !kIsWeb){

      var exampleCodeSb = StringBuffer();
      var count = 1;
      for(var module in exampleModuleList) {
        exampleCodeSb.writeln('### $count ${module.title}');
        for(var item in module.children){

          exampleCodeSb.writeln('');
          exampleCodeSb.writeln('${item.desc}');

          var hasCodeSuccess = false;
          if(!item.ignoreCode) {
            var assetsPath = _getCodeAssetsPath(item, exampleCodeGroup ?? '');
            if (assetsPath.isNotEmpty) {
              try {
                var codeString = await rootBundle.loadString(assetsPath);
                if (codeString.isNotEmpty) {
                  exampleCodeSb.writeln('''
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">${codeString}</pre>

</td-code-block>
                                        ''');
                  hasCodeSuccess = true;
                }
              } catch (e) {
                print(e);
              }
            }
          } else {
            var list = manualExampleCode[getItemKey(exampleCodeGroup, module.title, item.desc)];
            if(list != null && list.isNotEmpty) {
              list.forEach((element) {
                exampleCodeSb.writeln('');
                exampleCodeSb.writeln('''
                
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">${element}</pre>

</td-code-block>
                      ''');
              });
              hasCodeSuccess = true;
            } else {
              print('error item:${exampleCodeGroup}_${module.title}_${item.desc},已忽略代码，请手动处理');
            }
          }
          if(!hasCodeSuccess){
            exampleCodeSb.writeln('''
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">暂无演示代码</pre>

</td-code-block>
                      ''');
          }

        }
      }

      var api = '''
## API

暂无对应api
''';
      try {
        api =  await rootBundle.loadString('assets/api/${model.name}_api.md');
      } catch (e) {
        print(e);
      }
      var mdContent = _getTemplate(model.text, description, model.spline ?? 'other', exampleCodeSb.toString(), api.toString());
      var file = File('/sdcard/td/web_md/${model.name}/README.md');
      if(!file.existsSync()){
        file.createSync(recursive: true);
      }
      file.writeAsStringSync(mdContent);
    }
  }

  static String _getCodeAssetsPath(ExampleItem exampleItem, String group) {
    var methodName = exampleItem.methodName ?? '';

    var builderString = exampleItem.builder.toString();
    if (methodName.isEmpty) {
      if (builderString.contains('\'')) {
        var strings = builderString.split('\'');
        if (strings.length > 1) {
          methodName = strings[1];
          if (methodName.isNotEmpty && methodName.contains('@')) {
            methodName = methodName.split('@')[0];
          }
        }
      }
    }
    if (methodName.isNotEmpty && group.isNotEmpty) {
      print('example code methodName: $methodName');
      return 'assets/code/${group}.$methodName.txt';
    }
    return '';
  }

  static String getSpline(String key){
    switch(key){
      case '基础':
        return 'base';
      case '导航':
        return 'base';
      case '输入':
        return 'base';
      case '数据展示':
        return 'base';
      case '反馈':
        return 'base';
      default:
        return 'other';
    }
  }

  static String getItemKey(exampleCodeGroup,moduleTitle,itemDesc){
    return '${exampleCodeGroup}_${moduleTitle}_${itemDesc}';
  }

  static  _getTemplate(
    String title,
    String description,
    String spline,
    String exampleCode,
    String api,
      )=> '''
---
title: $title
description: ${description}
spline: ${spline}
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/td_export.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/td_export.dart';
```

## 代码演示

${exampleCode}

${api}

  ''';

  static var manualExampleCode = <String,List<String>>{};
}