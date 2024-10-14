import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/form/td_form_inherited.dart';
import '../../../tdesign_flutter.dart';

class TDForm extends StatefulWidget {
  const TDForm({
    Key? key,
    required this.items,
    this.colon = false,
    this.contentAlign = 'left',
    this.data,
    this.isHoeizontal = true,
    this.disabled = false,
    this.errorMessage,
    this.labelAlign = 'right',
    this.labelWidth = 20.0,
    this.preventSubmitDefault = true,
    this.requiredMark = true, // 此处必填项有小问题
    this.resetType = 'empty',
    this.rules,
    this.scrollToFirstError,
    this.showErrorMessage = true,
    this.submitWithWarningMessage = false,
  }) : super(key: key);

  /// 表单内容 items
  final List<TDFormItem> items;

  /// 是否在表单标签字段右侧显示冒号
  final bool? colon;

  /// 表单内容对齐方式: 左对齐、右对齐
  /// 可选项: left/right
  final String? contentAlign;

  /// 表单数据
  final Object? data;

  /// 表单排列方式是否为 水平方向
  final bool isHoeizontal;

  /// 是否禁用整个表单
  final bool disabled;

  /// 表单信息错误信息配置
  final Object? errorMessage;

  /// 表单字段标签的对齐方式：
  /// 左对齐、右对齐、顶部对齐
  /// 可选项: left/right/top
  final String? labelAlign;

  /// 可以整体设置 label 标签宽度
  final double? labelWidth;

  /// 是否阻止表单提交默认事件（表单提交默认事件会刷新页面）
  /// 设置为 true 可以避免刷新
  final bool? preventSubmitDefault;

  /// 是否显示必填符号（*），默认显示
  final bool? requiredMark;

  /// 重置表单的方式，值为 empty 表示重置表单为空，值为 initial 表示重置表单数据为初始值
  /// 可选项：empty/initial
  final String? resetType;

  /// 表单字段校验规则
  final Object? rules;

  /// 表单校验不通过时，是否自动滚动到第一个校验不通过的字段，平滑滚动或是瞬间直达。
  /// 值为空则表示不滚动。可选项：''/smooth/auto
  final String? scrollToFirstError;

  /// 校验不通过时，是否显示错误提示信息，统一控制全部表单项
  /// 如果希望控制单个表单项，请给 FormItem 设置该属性
  final bool? showErrorMessage;

  /// 【讨论中】当校验结果只有告警信息时，是否触发 submit 提交事件
  final bool? submitWithWarningMessage;

  @override
  State<TDForm> createState() => _TDFormState();
}

class _TDFormState extends State<TDForm> {
  @override
  Widget build(BuildContext context) {
    return TDFormInherited(
      disabled: widget.disabled,
      labelWidth: widget.labelWidth,
      isHorizontal: widget.isHoeizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.items
            .map((item) => Column(
                  children: [
                    item,
                    SizedBox(height: 1),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
