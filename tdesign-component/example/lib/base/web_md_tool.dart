import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'example_base.dart';
import 'example_widget.dart';

class WebMdTool {
  WebMdTool._();

  /// 用于生成web端的md,正常使用不要开启
  static bool needGenerateWebMd = false;

  /// 生成web端的md
  static void generateWebMd({
    required ExamplePageModel? model,
    required String description,
    required String? exampleCodeGroup,
    required List<ExampleModule> exampleModuleList,
    required List<ExampleItem> testList,
    required CodeWrapper? singleChild,
  }) async {
    if (needGenerateWebMd && model != null && !kIsWeb) {
      var pageName = 'td_${model.pageName ?? model.name}_page';
      var exampleCodeSb = StringBuffer();
      var count = 1;
      if (singleChild != null) {
        await writeSingleCode(exampleCodeSb, exampleCodeGroup, pageName);
      } else {
        for (var module in exampleModuleList) {
          exampleCodeSb.writeln('### $count ${module.title}');
          for (var item in module.children) {
            await writeCode(exampleCodeSb, item, exampleCodeGroup, module);
          }
        }
      }

      var api = '''
## API

暂无对应api
''';
      try {
        api = await rootBundle.loadString('assets/api/${model.name}_api.md');
      } catch (e) {
        print(e);
      }
      var mdContent = _getTemplate(
          model.text,
          description,
          model.spline ?? 'other',
          exampleCodeSb.toString(),
          api.toString(),
          pageName);
      print('生成演示代码成功：\n${mdContent.substring(0, 50)}...');

      var path = '';
      if (Platform.environment['FLUTTER_TEST'] == 'true') {
        var baseDir =
            Platform.script.toFilePath().split('/tdesign-component')[0];
        path = '$baseDir/tdesign-site/src/${model.name}/README.md';
        // path = '$baseDir/test/src/${model.name}/README.md';
        // File
      } else {
        path = '/sdcard/td/web_md/${model.name}/README.md';
      }
      var file = File(path);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      file.writeAsStringSync(mdContent);
    }
  }

  static Future<void> writeSingleCode(StringBuffer exampleCodeSb,
      String? exampleCodeGroup, String? pageName) async {
    var hasCodeSuccess = false;

    var list = manualExampleCode[exampleCodeGroup];
    if (list != null && list.isNotEmpty) {
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
      print('error item:singleChild_${exampleCodeGroup},已忽略代码，请手动处理');
    }

    if (!hasCodeSuccess) {
      exampleCodeSb.writeln('''
      
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">暂无演示代码</pre>

</td-code-block>
                ''');
    }
  }

  static Future<void> writeCode(StringBuffer exampleCodeSb, ExampleItem item,
      String? exampleCodeGroup, ExampleModule module) async {
    exampleCodeSb.writeln('');
    exampleCodeSb.writeln('${item.desc}');

    var hasCodeSuccess = false;
    if (!item.ignoreCode) {
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
      var list = manualExampleCode[
          getItemKey(exampleCodeGroup, module.title, item.desc)];
      if (list != null && list.isNotEmpty) {
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
        print(
            'error item:${exampleCodeGroup}_${module.title}_${item.desc},已忽略代码，请手动处理');
      }
    }
    if (!hasCodeSuccess) {
      exampleCodeSb.writeln('''
      
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">暂无演示代码</pre>

</td-code-block>
                ''');
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

  static String getSpline(String key) => switch (key) {
        '基础' => 'base',
        '导航' => 'navigation',
        '输入' => 'form',
        '数据展示' => 'data',
        '反馈' => 'message',
        _ => 'other',
      };

  static String getItemKey(exampleCodeGroup, moduleTitle, itemDesc) {
    return '${exampleCodeGroup}_${moduleTitle}_${itemDesc}';
  }

  static String _getTemplate(
    String title,
    String description,
    String spline,
    String exampleCode,
    String api,
    String pageName,
  ) =>
      '''
---
title: $title
description: ${description}
spline: ${spline}
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

${_getImport(title)}

## 代码演示

${_getPageCode(pageName)}

${exampleCode}

${api}

  ''';

  static var manualExampleCode = <String, List<String>>{};

  static _getImport(String title) {
    if (title == 'Icon 图标') {
      return '''
`tdesign_flutter` 中已引入 [`tdesign_icons`](https://pub.dev/packages/tdesign_icons) 图标库，无需额外安装，直接使用即可：

```dart
import 'package:tdesign_icons/tdesign_icons.dart';
```

当然，你也可以在不使用 `tdesign_flutter` 组件库的情况下，单独使用 [`tdesign_icons`](https://pub.dev/packages/tdesign_icons) 图标库。

所有图标详见TDesign官网: https://tdesign.tencent.com/icons

注：需将icon名称改为下划线形式，如：`logo-tdesign` 对应 `TIcons.logo_tdesign`。
      ''';
    }
    return '''
在 `tdesign_flutter/tdesign_flutter.dart` 中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';${_getExtraImport(title)}
```
''';
  }

  static _getExtraImport(String title) {
    if (title == 'Swiper 轮播图') {
      return '''
 
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';''';
    } else if (title == 'PullDownRefresh 下拉刷新') {
      return '''
 
import 'package:easy_refresh/easy_refresh.dart';''';
    }
    return '';
  }

  static _getPageCode(String pageName) {
    if (pageName == 'td_side-bar_page') {
      return '''
[t_sidebar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/t_sidebar_page.dart)

[t_sidebar_page_anchor.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/t_sidebar_page_anchor.dart)

[t_sidebar_page_custom.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/t_sidebar_page_custom.dart)

[t_sidebar_page_icon.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/t_sidebar_page_icon.dart)

[t_sidebar_page_pagination.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/t_sidebar_page_pagination.dart)''';
    }
    return '[$pageName.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/$pageName.dart)';
  }
}
