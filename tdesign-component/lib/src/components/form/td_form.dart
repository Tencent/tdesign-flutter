import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/form/td_form_validation.dart';
import 'td_form_inherited.dart';
import '../../../tdesign_flutter.dart';

class TDForm extends StatefulWidget {
  const TDForm({
    Key? key,
    required this.items,
    required this.rules,
    this.colon = false,
    this.formContentAlign = TextAlign.left,
    this.data,
    this.isHorizontal = true,
    this.disabled = false,
    this.errorMessage,
    this.formLabelAlign = TextAlign.left,
    this.labelWidth = 20.0,
    this.preventSubmitDefault = true,
    this.requiredMark = true, // 此处必填项有小问题
    this.isValidate = false,
    this.scrollToFirstError,
    this.formShowErrorMessage = true,
    this.submitWithWarningMessage = false,
  }) : super(key: key);

  /// 表单内容 items
  final List<TDFormItem> items;

  /// 是否在表单标签字段右侧显示冒号
  final bool? colon;

  /// 表单内容对齐方式: 左对齐、右对齐、居中对齐
  /// 可选项: left/right/center
  /// 默认为左对齐
  /// 优先级低于 TDFormItem 的对齐 API
  /// TODO: TDStepper TDRate 等组件没用实现通用性
  final TextAlign formContentAlign;

  /// TODO: 整个表单数据 是否需要将所有 items 的数据整合输出？
  final List<String>? data;

  /// 表单排列方式是否为 水平方向
  final bool isHorizontal;

  /// 是否禁用整个表单
  final bool disabled;

  /// 表单信息错误信息配置
  final Object? errorMessage;

  /// 表单字段标签的对齐方式：
  /// 左对齐、右对齐、顶部对齐
  /// 可选项: left/right/top
  /// TODO: 表单总体标签对齐方式
  final TextAlign? formLabelAlign;

  /// 可以整体设置 label 标签宽度
  final double? labelWidth;

  /// 是否阻止表单提交默认事件（表单提交默认事件会刷新页面）
  /// 设置为 true 可以避免刷新
  final bool? preventSubmitDefault;

  /// 是否显示必填符号（*），默认显示
  final bool? requiredMark;

  /// 整个表单字段校验规则
  final List<TDFormValidation> rules;

  /// 是否对整个 form 进行校验
  /// TODO: 无法重复点击提交按钮的校验进行重复校验
  final bool isValidate;

  /// 表单校验不通过时，是否自动滚动到第一个校验不通过的字段，平滑滚动或是瞬间直达。
  /// 值为空则表示不滚动。可选项：''/smooth/auto
  final String? scrollToFirstError;

  /// 校验不通过时，是否显示错误提示信息，统一控制全部表单项
  /// 如果希望控制单个表单项，请给 FormItem 设置该属性
  final bool? formShowErrorMessage;

  /// 【讨论中】当校验结果只有告警信息时，是否触发 submit 提交事件
  final bool? submitWithWarningMessage;

  @override
  State<TDForm> createState() => _TDFormState();
}

class _TDFormState extends State<TDForm> {
  late final List<Widget> _formItems;

  @override
  void initState() {
    super.initState();
    _formItems =
        widget.items.expand((item) => [item, SizedBox(height: 1)]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TDFormInherited(
      disabled: widget.disabled,
      labelWidth: widget.labelWidth,
      isHorizontal: widget.isHorizontal,
      isValidate: widget.isValidate,
      rules: widget.rules,
      formContentAlign: widget.formContentAlign,
      formShowErrorMessage: widget.formShowErrorMessage,
      child: ListView.builder(
        itemCount: _formItems.length,
        itemBuilder: (context, index) => _formItems[index],
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        cacheExtent: 500,
      ),
    );
  }
}
