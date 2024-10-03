import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

class TDFormItem extends StatefulWidget {
  TDFormItem({
    /// 需要从 page 外部传入的参数
    this.controller,
    this.select = '',
    List<Map>? localData,
    Map<String, String>? radios,
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
    this.maxLength,
    this.indicator,
    Key? key,
  })  : localData = localData ?? const [],
        radios = radios ?? const {},
        super(key: key);

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

  /// 组相联选择器需要的数据
  final List<Map> localData;

  /// 单选框数据
  final Map<String, String> radios;

  /// 是否显示必填符号 (*)
  /// 优先级高于 Form.requiredMark
  final bool? requiredMark;

  /// 表单字段校验规则
  final List? rules;

  /// 校验不通过时，是否显示错误提示信息
  /// 优先级高于 Form.showErrowMessage
  final bool? showErrowMessage;

  /// TDTextarea 预留API
  final int? maxLength;
  final bool? indicator;

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
              child: TDText(
                title,
                font: TDTheme.of(context).fontBodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  TDText(
                    output,
                    font: TDTheme.of(context).fontBodyLarge,
                    textColor:
                        TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      TDIcons.chevron_right,
                      color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const TDDivider(
          margin: EdgeInsets.only(
            left: 16,
          ),
        )
      ],
    ),
  );
}

class _TDFormItemState extends State<TDFormItem> {
  /// 实现密码右侧的可见按钮
  bool browseOn = false;

  /// 垂直联级选择器
  String? _initData;
  String _selected_1 = '';

  @override
  Widget build(BuildContext context) {
    if (widget.name == 'name') {
      return Column(
        children: [
          TDInput(
            leftLabel: widget.label,
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
    } else if (widget.name == 'radios') {
      final theme = TDTheme.of(context);
      return Container(
        height: 80.0,
        decoration: BoxDecoration(
          color: theme.whiteColor1,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 左侧的文本
              TDText(
                widget.label ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 16), // 间隔
              // 右侧的单选按钮组，使用 Expanded 包裹
              Expanded(
                child: TDRadioGroup(
                  selectId: 'index:1',
                  direction: Axis.horizontal,
                  directionalTdRadios: widget.radios.entries.map((entry) {
                    return TDRadio(
                      id: entry.key,
                      title: entry.value,
                      radioStyle: TDRadioStyle.circle,
                      showDivider: false,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (widget.name == 'date') {
      return GestureDetector(
        onTap: () {
          TDPicker.showDatePicker(context, title: '选择时间',
              onConfirm: (selected) {
            setState(() {
              widget.select =
                  '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
            });
            Navigator.of(context).pop();
          },
              dateStart: [1999, 01, 01],
              dateEnd: [2023, 12, 31],
              initialDate: [2012, 1, 1]);
        },
        child: buildSelectRow(context, widget.select, '选择时间'),
      );
    } else if (widget.name == 'age') {
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
    } else if (widget.name == 'local') {
      return GestureDetector(
        onTap: () {
          TDCascader.showMultiCascader(context,
              title: '选择地址',
              data: widget.localData,
              initialData: _initData,
              theme: 'step',
              onChange: (List<MultiCascaderListModel> selectData) {
            setState(() {
              List result = [];
              int len = selectData.length;
              _initData = selectData[len - 1].value!;
              selectData.forEach((element) {
                result.add(element.label);
              });
              _selected_1 = result.join('/');
            });
          }, onClose: () {
            Navigator.of(context).pop();
          });
        },
        child: _buildSelectRow(context, _selected_1, '选择地区'),
      );
    } else if (widget.name == 'textarea') {
      return TDTextarea(
        /// 背景颜色未完成
        backgroundColor: Colors.white,
        controller: widget.controller,
        label: widget.label,
        hintText: widget.help,
        maxLength: widget.maxLength,
        indicator: widget.indicator,
        onChanged: (value) {
          setState(() {});
        },
      );
    }
    return Column();
  }

  Widget _buildSelectRow(BuildContext context, String output, String title) {
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
                child: TDText(
                  title,
                  font: TDTheme.of(context).fontBodyLarge,
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TDText(
                      output,
                      font: TDTheme.of(context).fontBodyLarge,
                      textColor:
                          TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        TDIcons.chevron_right,
                        color:
                            TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
          const TDDivider(
            margin: EdgeInsets.only(
              left: 16,
            ),
          )
        ],
      ),
    );
  }
}
