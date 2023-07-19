import 'package:kernel/ast.dart';

class NodeUtils {
  static const String kAnnotationClass = 'Demo';
  static String kImportUri =
      'package:tdesign_flutter_example/annotation/demo.dart';

  /// @Demo 目标类
  static ConstructorInvocation checkIfClassEnable(List<Expression> annotations) {
    if (annotations == null) {
      return null;
    }

    for (var annotation in annotations) {
      //注解有ConstantExpression和ConstructorInvocation两种形式
      if (annotation is ConstantExpression) {
        break;
        // final constantExpression = annotation;
        // final constant = constantExpression.constant;
        // if (constant is InstanceConstant) {
        //   final instanceConstant = constant;
        //   final Class instanceClass = instanceConstant.classReference.node;
        //   //@Demo注解
        //   if (instanceClass.name == kAnnotationClass && kImportUri == (instanceClass?.parent as Library)?.importUri.toString()) {
        //     enabled = true;
        //     return instanceClass;
        //     break;
        //   }
        // }
      } else if (annotation is ConstructorInvocation) {
        final constructorInvocation = annotation;
        final Class cls = constructorInvocation.targetReference.node?.parent;
        if (cls == null) {
          continue;
        }
        final Library library = cls?.parent;
        if (cls.name == kAnnotationClass &&
            kImportUri == library.importUri.toString()) {
          return annotation;
        }
      }
    }
    return null;
  }
}
