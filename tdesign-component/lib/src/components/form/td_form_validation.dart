import '../../../tdesign_flutter.dart';

/// 实现普通表单项的校验
/// 校验规则 和 错误提醒
class TDFormValidation {

  TDFormValidation({
    required this.validate,
    required this.errorMessage,
    required this.type,
  });

  /// 校验方法
  final String? Function(dynamic) validate;

  /// 错误提示信息
  final String errorMessage;

  /// 校验对象的类型
  final TDFormItemType type;

  /// 执行校验逻辑
  String? check(String? value) {
    if (validate(value) != null) {
      return errorMessage;
    }

    /// 校验通过时返回 null
    return null;
  }
}
