import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../input/td_input.dart';

class TDFormItem extends StatefulWidget {
  TDFormItem({
    this.controller,
    this.select = '',
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

  /// 表格的 controller
  var controller;

  /// 日期选择需要展示的内容
  String select;

  /// 是否显示必填符号 (*)
  /// 优先级高于 Form.requiredMark
  final bool? requiredMark;

  /// 表单字段校验规则
  final List? rules;

  /// 校验不通过时，是否显示错误提示信息
  /// 优先级高于 Form.showErrowMessage
  final bool? showErrowMessage;

  @override
  _TDFormItemState createState() => _TDFormItemState();
}

Widget buildSelectRow(BuildContext context, String output, String title) {
  return Container(
    color: TDTheme.of(context).whiteColor1,
    height: 56,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: TDText(title, font: TDTheme.of(context).fontBodyLarge,),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  TDText(
                    output,
                    font: TDTheme.of(context).fontBodyLarge,
                    textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      TDIcons.chevron_right,
                      color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                  ),
                ],
              ),
            ),
          ],
        ),
        const TDDivider(margin: EdgeInsets.only(left: 16, ),)
      ],
    ),
  );
}

class _TDFormItemState extends State<TDFormItem> {
  /// 实现密码右侧的可见按钮
  bool browseOn = false;

  @override
  Widget build(BuildContext context) {
    if (widget.name == 'name') {
      return Column(
        children: [
          TDInput(
            leftLabel: widget.label,
            required: true,
            controller: widget.controller,
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
            controller: widget.controller,
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
    } else if(widget.name == 'date'){
        return GestureDetector(
          onTap: (){
            TDPicker.showDatePicker(context, title: '选择时间',
                onConfirm: (selected) {
                  setState(() {
                    widget.select = '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
                  });
                  Navigator.of(context).pop();
                },
                dateStart: [1999, 01, 01],
                dateEnd: [2023, 12, 31],
                initialDate: [2012, 1, 1]);
          },
          child: buildSelectRow(context, widget.select, '选择时间'),
        );
    }else if(widget.name == 'age'){
      final theme = TDTheme.of(context);

      return Container(
        decoration: BoxDecoration(
          color: theme.whiteColor1,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右分布
            children: [
              TDText(
                widget.label, // 左侧的文本
                style: TextStyle(fontSize: 16), // 可根据需要设置样式
              ),
              TDStepper(
                theme: TDStepperTheme.filled, // 右侧的步进器
              ),
            ],
          ),
        ),
      );
    }


    return Column();
  }
}
