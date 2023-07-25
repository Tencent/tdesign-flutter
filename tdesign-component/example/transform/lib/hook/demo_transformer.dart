// Transformer/visitor for toString
// If we add any more of these, they really should go into a separate library.

import 'package:kernel/ast.dart';
import 'package:vm/target/flutter.dart';

import 'demo_recursive_visitor.dart';

/// 通过@Demo注解，获取方法源码
class DemoTransformer extends FlutterProgramTransformer {
  static Reference printTypeReference; //存储插入的方法

  DemoTransformer();

  static const _targetLibrary = 'package:tdesign_flutter_example/annotation/demo.dart';
  static const _targetClass = 'Demo';

  @override
  void transform(Component component) {
    prepare(component);
    if (printTypeReference == null) {
      print('TypeTransformer，未找到插入节点：$_targetLibrary $_targetClass');
      return;
    }

    DemoRecursiveVisitor.uriToSource = component.uriToSource;
    ///开始插桩
    component.visitChildren(DemoRecursiveVisitor());
  }

  /// 获取插入的方法节点
  void prepare(Component component) {
    final libraries = component.libraries;
    if (libraries.isEmpty) {
      return;
    }

    // 根据library和方法名定位
    for (var library in libraries) {
      if (library.importUri.toString() == _targetLibrary) {
        for (var clazz in library.classes) {
          if (clazz.name == _targetClass) {
            printTypeReference = clazz.reference;
          }
        }
      }
    }
  }
}
