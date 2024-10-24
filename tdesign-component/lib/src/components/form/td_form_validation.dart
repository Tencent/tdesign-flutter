import '../../../tdesign_flutter.dart';

class TDFormValidation {
  final String? Function(String?) validate; // 校验方法
  final String errorMessage;

  /// 校验对象的类型
  final TDFormItemType type;

  TDFormValidation({
    required this.validate,
    required this.errorMessage,
    required this.type,
  });

  // 执行校验逻辑
  String? check(String? value) {
    if (validate(value) != null) {
      return errorMessage;
    }
    return null; // 校验通过时返回 null
  }
}
