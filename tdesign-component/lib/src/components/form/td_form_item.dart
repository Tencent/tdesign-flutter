import 'package:flutter/material.dart';

class TDFormItem extends StatelessWidget {
  const TDFormItem({
    Key? key,
    this.label,
    this.name,
    this.arrow = false,
    this.contentAlign = 'left',
    this.help,
    this.labelAlign,
    this.labelWidth,
    this.requiredMark,
    this.rules,
    this.showErrowMessage,
  }) : super(key: key);

  /// 表单内容对齐方式：
  /// 左对齐、右对齐
  /// 可选项：left/right
  final String? contentAlign;

  /// 是否显示右箭头
  final bool? arrow;

  /// 表单说明内容 ？？？？
  final help;

  /// 表格内标签 内容填充
  final String? label;

  /// 表单字段标签对齐方式：
  /// 左对齐、右对齐、顶部对齐
  /// 默认使用 Form 的对齐方式，其优先级高于 Form.labelAlign
  /// 可选项: left/right.top
  final String? labelAlign;

  /// 可以整体调整标签宽度
  /// 优先级高于 Form.labelWidth
  final String? labelWidth;

  /// 表格标识
  final String? name;

  /// 是否显示必填符号 (*)
  /// 优先级高于 Form.requiredMark
  final bool? requiredMark;

  /// 表单字段校验规则 ???
  final List? rules;

  /// 校验不通过时，是否显示错误提示信息
  /// 优先级高于 Form.showErrowMessage
  final bool? showErrowMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: contentAlign == 'right'
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        // 标签
        Container(
          width: labelWidth != null ? double.parse(labelWidth!) : null,
          alignment: labelAlign == 'right'
              ? Alignment.centerRight
              : labelAlign == 'top'
                  ? Alignment.topLeft
                  : Alignment.centerLeft,
          child: Text(
            label ?? '',
            style: TextStyle(
              fontWeight:
                  requiredMark == true ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 8), // 标签与输入框的间距
        // 输入框
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: help,
              suffixIcon: arrow == true ? Icon(Icons.arrow_forward) : null,
            ),
            // 可添加更多属性，如 validator 等
          ),
        ),
      ],
    );
  }
}
