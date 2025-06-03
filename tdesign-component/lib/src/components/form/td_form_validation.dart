import '../../../tdesign_flutter.dart';

/// 实现普通表单项的校验
/// 校验规则 和 错误提醒
class TDFormValidation {
  /// 校验方法
  final String? Function(dynamic) validate;
  final String errorMessage;
  /// 验证字段名称
  final String name;
  /// 校验对象的类型
  final TDFormItemType type;

  TDFormValidation({
    required this.validate,
    required this.errorMessage,
    required this.type,
    required this.name,
  });

  /// 执行校验逻辑
  String? check(String? name,String? value) {
    if (validate(value) != null&&this.name==name) {
      return errorMessage;
    }

    /// 校验通过时返回 null
    return null;
  }
}
