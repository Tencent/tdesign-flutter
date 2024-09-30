import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../input/td_input.dart';

class TDFormItem extends StatefulWidget {
  TDFormItem({
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
    Key? key,
  }) : super(key: key);

  /// 表格内标签 内容填充
  final String? label;

  /// 表单内容对齐方式：
  /// 左对齐、右对齐
  /// 可选项：left/right
  final String? contentAlign;

  /// 是否显示右箭头
  final bool? arrow;

  /// 表单说明内容
  /// 表单的默认输入字符
  final String? help;

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
  _TDFormItemState createState() => _TDFormItemState();
}

class _TDFormItemState extends State<TDFormItem> {
  /// 实现密码右侧的可见按钮
  bool browseOn = false;

  /// 实现输入框的 controller
  var controller = [];

  @override
  void initState() {
    for (var i = 0; i < 10; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.name == 'name') {
      return Column(
        children: [
          TDInput(
            leftLabel: widget.label,
            required: true,
            controller: controller[0],
            backgroundColor: Colors.white,
            hintText: widget.help,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    } else if (widget.name == 'password') {
      return Column(
        children: [
          TDInput(
            type: TDInputType.normal,
            controller: controller[1],
            obscureText: !browseOn,
            leftLabel: widget.label,
            hintText: widget.help,
            backgroundColor: Colors.white,
            rightBtn: browseOn
                ? Icon(
              TDIcons.browse,
              color: TDTheme.of(context).fontGyColor3,
            )
                : Icon(
              TDIcons.browse_off,
              color: TDTheme.of(context).fontGyColor3,
            ),
            onBtnTap: () {
              setState(() {
                browseOn = !browseOn;
              });
            },
            needClear: false,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    } else if(widget.name == 'gender'){
      return TDRadioGroup(
        selectId: 'index:1',
        direction: Axis.horizontal,
        directionalTdRadios: const [
          TDRadio(
            id: '0',
            title: '男',
            radioStyle: TDRadioStyle.circle,
            showDivider: false,
          ),
          TDRadio(
            id: '1',
            title: '女',
            radioStyle: TDRadioStyle.circle,
            showDivider: false,
          ),
          TDRadio(
            id: '2',
            title: '保密',
            radioStyle: TDRadioStyle.circle,
            showDivider: false,
          ),
        ],
      );
    }
    return Column();
  }
}
