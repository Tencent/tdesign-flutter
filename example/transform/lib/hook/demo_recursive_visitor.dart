import 'dart:convert';
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
    if (NodeUtils.checkIfClassEnable(node.annotations)) {
      //需要添加的语句
      var source = uriToSource[node.fileUri]?.source;
      if(source != null){
        var utf8String = utf8.decode(source);
        var methodString = String.fromCharCodes(utf8String.codeUnits, node.startFileOffset, min(node.fileEndOffset + 1, utf8String.codeUnits.length));
        print('demoTest : $methodString');
      }

    }
  }
}
