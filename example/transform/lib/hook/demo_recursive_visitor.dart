import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:kernel/ast.dart';

import 'node_utils.dart';

/// 根据@Demo注解，获取代码方法
class DemoRecursiveVisitor extends RecursiveVisitor {
  /// 文件uri与对于二进制
  static Map<Uri, Source> uriToSource;

  // 遍历所有方法
  @override
  void visitProcedure(Procedure node) {
    //如果方法命中@Demo注解
    var annotation = NodeUtils.checkIfClassEnable(node.annotations);
    if (annotation != null) {
      //需要添加的语句
      var source = uriToSource[node.fileUri]?.source;
      if (source != null) {
        var utf8String = utf8.decode(source);
        var methodString = String.fromCharCodes(
            utf8String.codeUnits,
            node.startFileOffset,
            min(node.fileEndOffset + 1, utf8String.codeUnits.length));
        var groupName = '';
        if (annotation is ConstructorInvocation) {
          annotation.arguments.named.forEach((element) {
            if (element.name == 'group' && element.value is StringLiteral) {
              groupName = (element.value as StringLiteral).value;
            }
          });
        }
        if (groupName.isNotEmpty) {
          try {
            var file = getFile(annotation, groupName, node);

            // 去掉第一行的注解
            methodString = methodString.substring(methodString.indexOf('\n'), methodString.length);

            file.writeAsString(methodString);
            print('generate code file success, path:${file.path}');
          } catch (e) {
            print('generate code file error: $e');
          }
        }
      }
    }
  }

  File getFile(ConstructorInvocation annotation, String groupName, Procedure node) {
    var annotationPath =
        (annotation.targetReference.node as Constructor).fileUri.path;
    var basePath = annotationPath.substring(
        0, annotationPath.lastIndexOf('/example/lib/'));
    var filePath =
        '$basePath/example/assets/code/${groupName}.${node.name.text}.txt';
    var file = File(filePath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }
}
