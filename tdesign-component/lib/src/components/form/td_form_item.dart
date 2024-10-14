import 'package:flutter/material.dart';
import 'td_form_inherited.dart';
import '../../../tdesign_flutter.dart';

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
    this.maxLength,
    this.indicator,
    this.additionInfo,
    this.controller,
    this.select = '',
    List<Map>? localData,
    Map<String, String>? radios,
    Key? key,
  })  : localData = localData ?? const [],
        radios = radios ?? const {},
        super(key: key);

  /// 表单项标签内容
  final String? label;

  /// 表单内容对齐方式：'left' 或 'right'
  final String? contentAlign;

  /// 是否显示右侧箭头
  final bool? arrow;

  /// TDInput的辅助信息
  final String? additionInfo;

  /// TDInput 默认显示文字
  final String? help;

  /// 标签对齐方式：'left', 'right', 或 'top'
  final String? labelAlign;

  /// 标签宽度，如果提供则覆盖Form的labelWidth
  final double? labelWidth;

  /// 表单项标识符
  final String? name;

  /// Input 控制器
  var controller;

  /// 选择器 适用于日期选择器等
  String select;

  /// 传入数据 适用于级联选择器等
  final List<Map> localData;

  /// 单选按钮数据
  /// < 序号 , 名称 >
  final Map<String, String> radios;

  /// 是否显示必填标记（*）
  final bool? requiredMark;

  /// 表单项验证规则
  final List? rules;

  /// 是否显示错误信息
  final bool? showErrowMessage;

  /// TDTextarea的属性，最大长度
  final int? maxLength;

  /// TDTextarea的属性，指示器
  final bool? indicator;

  @override
  _TDFormItemState createState() => _TDFormItemState();
}

class _TDFormItemState extends State<TDFormItem> {
  double get LabelWidth {
    final inherited = TDFormInherited.of(context);
    final double defaultLabelWidth = 8.0; // Default label width

    // 优先使用 widget.labelWidth，如果不为空直接返回
    if (widget.labelWidth != null) {
      return widget.labelWidth as double;
    }

    // 如果 widget.labelWidth 为空，使用 inherited.labelWidth
    if (inherited?.labelWidth != null) {
      return inherited!.labelWidth as double;
    }

    // 如果两者都为空，返回默认值
    return defaultLabelWidth;
  }

  bool get FormState {
    final inherited = TDFormInherited.of(context);
    if (inherited?.disabled != null) {
      return inherited!.disabled;
    }
    return false;
  }

  bool get FormIsHorizontal {
    final inherited = TDFormInherited.of(context);
    if (inherited?.isHorizontal != null) {
      return inherited!.isHorizontal;
    }
    return false;
  }

  bool browseOn = false;

  String? _initData;
  String _selected_1 = '';

  @override
  Widget build(BuildContext context) {
    if (FormIsHorizontal) {
      if (widget.name == 'name') {
        return TDInput(
          inputDecoration: InputDecoration(
            hintText: widget.help,
            contentPadding: EdgeInsets.only(left: LabelWidth),
            border: InputBorder.none,
          ),
          leftLabel: widget.label,
          controller: widget.controller,
          backgroundColor: Colors.white,
          additionInfo: widget.additionInfo,
          readOnly: FormState,
        );
      } else if (widget.name == 'password') {
        return TDInput(
          inputDecoration: InputDecoration(
            hintText: widget.help,
            contentPadding: EdgeInsets.only(left: LabelWidth),
            border: InputBorder.none,
          ),
          type: TDInputType.normal,
          controller: widget.controller,
          obscureText: !browseOn,
          leftLabel: widget.label,
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
          readOnly: FormState,
        );
      } else if (widget.name == 'radios') {
        final theme = TDTheme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.whiteColor1,
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TDText(
                  widget.label ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
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
                        enable: !FormState,
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
      } else if (widget.name == 'radios') {
        final theme = TDTheme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.whiteColor1,
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TDText(
                  widget.label ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
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
                        enable: !FormState,
                      );
                    }).toList(),
                  ),
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
      } else if (widget.name == 'stepper') {
        final theme = TDTheme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.whiteColor1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TDText(
                  widget.label,
                  style: const TextStyle(fontSize: 16),
                ),
                TDStepper(
                  theme: TDStepperTheme.filled,
                  disabled: FormState,
                ),
              ],
            ),
          ),
        );
      } else if (widget.name == 'textarea') {
        return TDTextarea(
          backgroundColor: Colors.red,
          controller: widget.controller,
          label: widget.label,
          hintText: widget.help,
          maxLength: widget.maxLength,
          indicator: widget.indicator,
          readOnly: FormState,
          onChanged: (value) {
            setState(() {});
          },
        );
      }
    } else {
      if (widget.name == 'name') {
        return TDInput(
          type: TDInputType.twoLine,
          inputDecoration: InputDecoration(
            hintText: widget.help,
            border: InputBorder.none,
          ),
          leftLabel: widget.label,
          controller: widget.controller,
          backgroundColor: Colors.white,

          /// 竖直态的 TDInput 没用 additionInfo?
          additionInfo: widget.additionInfo,
          readOnly: FormState,
        );
      } else if (widget.name == 'password') {
        return Column(
          children: [
            TDInput(
              inputDecoration: InputDecoration(
                hintText: widget.help,
                // contentPadding: EdgeInsets.only(left: LabelWidth),
                border: InputBorder.none,
              ),
              type: TDInputType.twoLine,
              controller: widget.controller,
              obscureText: !browseOn,
              leftLabel: widget.label,
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
              readOnly: FormState,
            ),
          ],
        );
      } else if (widget.name == 'radios') {
        final theme = TDTheme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.whiteColor1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TDText(
                  widget.label ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                TDRadioGroup(
                  selectId: 'index:1',
                  direction: Axis.horizontal,
                  directionalTdRadios: widget.radios.entries.map((entry) {
                    return TDRadio(
                      id: entry.key,
                      title: entry.value,
                      radioStyle: TDRadioStyle.circle,
                      showDivider: false,
                      enable: !FormState,
                    );
                  }).toList(),
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
      } else if (widget.name == 'stepper') {
        final theme = TDTheme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.whiteColor1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 使内容左对齐
              children: [
                TDText(
                  widget.label,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                TDStepper(
                  theme: TDStepperTheme.filled,
                  disabled: FormState,
                ),
              ],
            ),
          ),
        );
      } else if (widget.name == 'textarea') {
        return TDTextarea(
          backgroundColor: Colors.red,
          controller: widget.controller,
          label: widget.label,
          hintText: widget.help,
          maxLength: widget.maxLength,
          indicator: widget.indicator,
          readOnly: FormState,
          layout: TDTextareaLayout.vertical,
          onChanged: (value) {
            setState(() {});
          },
        );
      }
    }

    /// TODO: 构建错误的提示页面
    return const Column();
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
                        color:
                            TDTheme.of(context).fontGyColor3.withOpacity(0.4),
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

  Widget _buildSelectRow(BuildContext context, String output, String title) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
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
}
