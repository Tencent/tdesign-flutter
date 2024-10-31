import 'package:flutter/material.dart';
import 'td_form_inherited.dart';
import '../../../tdesign_flutter.dart';

/// 表格单元选用组件类型的枚举
enum TDFormItemType {
  input,
  password,
  radios,
  dateTimePicker,
  cascader,
  stepper,
  rate,
  textarea,
}

class TDFormItem extends StatefulWidget {
  TDFormItem({
    required this.type,
    this.label,
    this.help,
    this.labelAlign,
    this.contentAlign,
    this.labelWidth,
    this.requiredMark,
    this.formRules,
    this.itemRule,
    this.onChange,
    this.showErrorMessage = true,
    this.maxLength,
    this.indicator,
    this.radioGroupSpacing,
    this.allowHalf = false,
    this.rateValue = 3,
    this.rateCount = 5,
    this.rateGap,
    this.additionInfo,
    this.controller,
    this.select = '',
    List<Map>? localData,
    Map<String, String>? radios,
    Key? key,
  })  : localData = localData ?? const [],
        radios = radios ?? const {},
        super(key: key);

  /// 表单项标签左侧展示的内容
  final String? label;

  /// 表格单元需要使用的组件类型
  final TDFormItemType type;

  /// TDInput的辅助信息
  final String? additionInfo;

  /// TDInput 默认显示文字
  final String? help;

  /// TODO: item 标签对齐方式
  /// 可选: left、right、top
  final TextAlign? labelAlign;

  /// 表单显示内容对齐方式：
  /// left、right、top
  /// TODO: TDStepper TDRate 等组件没用实现通用性
  final TextAlign? contentAlign;

  /// 标签宽度，如果提供则覆盖Form的labelWidth
  final double? labelWidth;

  /// TODO: 竖直状态的左侧对齐 padding 需要目前部分组件的更新支持
  /// 左侧 起始的 padding 位置不同

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

  /// 整个表单的校验规则
  final List<TDFormValidation>? formRules;

  /// 表单项验证规则
  final List? itemRule;

  /// 表单 item 的回调函数
  final ValueChanged? onChange;

  /// 是否显示错误信息
  final bool showErrorMessage;

  /// TDTextarea 的属性，最大长度
  final int? maxLength;

  /// TDTextarea 的属性，指示器
  final bool? indicator;

  /// TDRadioGroup 属性，文字与单选框的间距
  final double? radioGroupSpacing;

  /// TDRate 属性，是否开启可选半个等级
  final bool allowHalf;

  /// TDRate 属性，评分的满分数
  final int rateCount;

  /// TDRate 属性，初始时的 value
  final double rateValue;

  /// TDRate 属性
  /// 评分图标的间距，默认：TDTheme.of(context).spacer8
  final double? rateGap;

  @override
  _TDFormItemState createState() => _TDFormItemState();
}

class _TDFormItemState extends State<TDFormItem> {
  /// 从 TDForm 继承获取整个表单的参数
  /// 获取真正的 LabelWidth
  double get LabelWidth {
    final inherited = TDFormInherited.of(context);
    final defaultLabelWidth = 8.0;

    /// 如果 item 传入定制的 labelWidth 则使用
    if (widget.labelWidth != null) {
      return widget.labelWidth as double;
    }

    /// 使用 form 整体传入的 labelWidth
    if (inherited?.labelWidth != null) {
      return inherited!.labelWidth as double;
    }

    return defaultLabelWidth;
  }

  /// 获取 form 是否被禁用的状态
  bool get FormState {
    final inherited = TDFormInherited.of(context);
    if (inherited?.disabled != null) {
      return inherited!.disabled;
    }
    return false;
  }

  /// 获取 form 以及 formItem 的内容排列方式
  TextAlign get FormContentAlign {
    final inherited = TDFormInherited.of(context);
    if (widget.contentAlign != null) {
      /// 断言 widget.contentAlign 不会为空
      return widget.contentAlign!;
    }

    /// 如果 没用为 item 定制内容排列方式 则全部使用总表单的内容排列方式
    return inherited!.formContentAlign;
  }

  /// 获取 form 是否为水平排列的状态
  bool get FormIsHorizontal {
    final inherited = TDFormInherited.of(context);
    if (inherited?.isHorizontal != null) {
      return inherited!.isHorizontal;
    }
    return false;
  }

  /// 获取 form 整体是否校验的信号状态
  bool get FormValidate {
    final inherited = TDFormInherited.of(context);
    return inherited!.isValidate;
  }

  /// 获取整个表格是否需要展示错误提示
  bool? get ShowErrorMessage {
    final inherited = TDFormInherited.of(context);
    if (widget.showErrorMessage != null) {
      return widget.showErrorMessage;
    } else {
      return inherited!.formShowErrorMessage;
    }
  }

  /// 获取整个表单的校验规则
  List<TDFormValidation> get FormRules {
    final inherited = TDFormInherited.of(context);
    return inherited!.rules;
  }

  bool browseOn = false;
  String? _initData;
  String _selected_1 = '';

  /// 表单 item 的校验错误提示信息
  String? errorMessage;

  double rate = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (FormValidate) {
      startValidation();
    }
  }

  /// 调用校验方法
  void startValidation() {
    setState(() {
      errorMessage = validate();
    });
  }

  /// 遍历校验规则并执行
  String? validate() {
    String? value = widget.controller?.text;

    for (var rule in FormRules!) {
      /// 只对类型匹配的项进行校验
      if (rule.type == widget.type) {
        final result = rule.check(value);
        if (result != null) {
          /// 返回第一个不通过的错误信息
          return result;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (FormIsHorizontal) {
      switch (widget.type) {
        case TDFormItemType.input:
          return TDInput(
            inputDecoration: InputDecoration(
              hintText: widget.help,
              contentPadding: EdgeInsets.only(
                  left: FormContentAlign == TextAlign.center ? 0 : LabelWidth),
              border: InputBorder.none,
              errorText: ShowErrorMessage == true ? errorMessage : null,
            ),

            /// TODO: Input 校验失败时的提示 icon
            // rightBtn: widget.showErrowMessage == true
            //     ? Icon(
            //         TDIcons.error_circle_filled,
            //         color: TDTheme.of(context).fontGyColor3,
            //       )
            //     : null,
            contentAlignment: FormContentAlign,
            leftLabel: widget.label,
            controller: widget.controller,
            backgroundColor: Colors.white,
            additionInfoColor: TDTheme.of(context).errorColor6,
            readOnly: FormState,

            /// TODO: requiredMark 会使得间距变大 要适应优化
            // required: widget.requiredMark,
          );
        case TDFormItemType.password:
          return TDInput(
            inputDecoration: InputDecoration(
              hintText: widget.help,
              contentPadding: EdgeInsets.only(left: LabelWidth),
              border: InputBorder.none,
              errorText: ShowErrorMessage == true ? errorMessage : null,
            ),
            contentAlignment: FormContentAlign,
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
            // additionInfo: widget.additionInfo,
            // additionInfoColor: TDTheme.of(context).errorColor6,
          );
        case TDFormItemType.radios:
          final theme = TDTheme.of(context);
          return Container(
            decoration: BoxDecoration(
              color: theme.whiteColor1,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TDText(
                    widget.label ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: LabelWidth),
                  Expanded(
                    child: TDRadioGroup(
                      // spacing: widget.radioGroupSpacing,
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

                      /// TODO: TDRadioGroup 回调函数存在覆盖问题
                      // onRadioGroupChange: (ids) {
                      //   setState(() {
                      //     print(ids);
                      //   });
                      // },
                    ),
                  ),
                ],
              ),
            ),
          );
        case TDFormItemType.dateTimePicker:
          return GestureDetector(
            onTap: () {
              TDPicker.showDatePicker(context, title: '选择时间',
                  onConfirm: (selected) {
                setState(() {
                  widget.select =
                      '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
                  if (widget.onChange != null) {
                    widget.onChange!(widget.select);
                  }
                });
                Navigator.of(context).pop();
              },
                  dateStart: [1999, 01, 01],
                  dateEnd: [2023, 12, 31],
                  initialDate: [2012, 1, 1]);
            },
            child: _buildSelectRow(context, widget.select, '选择时间'),
          );
        case TDFormItemType.cascader:
          return GestureDetector(
            onTap: () {
              TDCascader.showMultiCascader(context,
                  title: '选择地址',
                  data: widget.localData,
                  initialData: _initData,
                  theme: 'step',
                  onChange: (List<MultiCascaderListModel> selectData) {
                setState(() {
                  var result = [];
                  var len = selectData.length;
                  _initData = selectData[len - 1].value!;
                  selectData.forEach((element) {
                    result.add(element.label);
                  });
                  _selected_1 = result.join('/');
                  if (widget.onChange != null) {
                    widget.onChange!(_selected_1);
                  }
                });
              }, onClose: () {
                Navigator.of(context).pop();
              });
            },
            child: _buildSelectRow(context, _selected_1, '选择地区'),
          );
        case TDFormItemType.stepper:
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
                    onChange: (value) {
                      setState(() {
                        if (widget.onChange != null) {
                          widget.onChange!(value);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        case TDFormItemType.rate:
          return TDCell(
              title: widget.label,
              noteWidget: TDRate(
                count: widget.rateCount,
                value: widget.rateValue,
                allowHalf: widget.allowHalf,
                disabled: FormState,
                onChange: (value) {
                  setState(() {
                    if (widget.onChange != null) {
                      widget.onChange!(value);
                    }
                  });

                  /// TODO: Rated 组件的校验
                  // if (rate < 3) {}
                },
              ));
        case TDFormItemType.textarea:
          return TDTextarea(
            backgroundColor: Colors.red,
            controller: widget.controller,
            label: widget.label,
            hintText: widget.help,
            maxLength: widget.maxLength,
            indicator: widget.indicator,
            readOnly: FormState,
            additionInfo: ShowErrorMessage == true ? errorMessage : null,
            additionInfoColor: TDTheme.of(context).errorColor6,
          );
      }
    } else {
      switch (widget.type) {
        case TDFormItemType.input:
          return TDInput(
            spacer: TDInputSpacer(iconLabelSpace: 0),
            type: TDInputType.twoLine,
            inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16),
              hintText: widget.help,
              border: InputBorder.none,
            ),
            leftLabelSpace: 16,
            leftLabel: widget.label,
            controller: widget.controller,
            backgroundColor: Colors.white,

            /// 竖直态的 TDInput 没用 additionInfo?
            // additionInfo: widget.additionInfo,
            readOnly: FormState,
          );
        case TDFormItemType.password:
          return Column(
            children: [
              TDInput(
                inputDecoration: InputDecoration(
                  hintText: widget.help,
                  contentPadding: const EdgeInsets.only(left: 16),
                  border: InputBorder.none,
                ),
                leftLabelSpace: 16,
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
        case TDFormItemType.radios:
          final theme = TDTheme.of(context);
          return Container(
            decoration: BoxDecoration(
              color: theme.whiteColor1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TDText(
                    widget.label ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
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
                  // onRadioGroupChange: (value) {
                  //   setState(() {
                  //   });
                  // },
                ),
              ],
            ),
          );

        case TDFormItemType.dateTimePicker:
          return GestureDetector(
            onTap: () {
              TDPicker.showDatePicker(context, title: '选择时间',
                  onConfirm: (selected) {
                setState(() {
                  widget.select =
                      '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
                  if (widget.onChange != null) {
                    widget.onChange!(widget.select);
                  }
                });
                Navigator.of(context).pop();
              },
                  dateStart: [1999, 01, 01],
                  dateEnd: [2023, 12, 31],
                  initialDate: [2012, 1, 1]);
            },
            child: _buildSelectRow(context, widget.select, '选择时间'),
          );
        case TDFormItemType.cascader:
          return GestureDetector(
            onTap: () {
              TDCascader.showMultiCascader(context,
                  title: '选择地址',
                  data: widget.localData,
                  initialData: _initData,
                  theme: 'step',
                  onChange: (List<MultiCascaderListModel> selectData) {
                setState(() {
                  var result = [];
                  var len = selectData.length;
                  _initData = selectData[len - 1].value!;
                  selectData.forEach((element) {
                    result.add(element.label);
                  });
                  _selected_1 = result.join('/');
                  if (widget.onChange != null) {
                    widget.onChange!(_selected_1);
                  }
                });
              }, onClose: () {
                Navigator.of(context).pop();
              });
            },
            child: _buildSelectRow(context, _selected_1, '选择地区'),
          );
        case TDFormItemType.stepper:
          return Container(
            decoration: BoxDecoration(
              color: TDTheme.of(context).whiteColor1,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TDText(
                    widget.label,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TDStepper(
                    theme: TDStepperTheme.filled,
                    disabled: FormState,
                    onChange: (value) {
                      setState(() {
                        if (widget.onChange != null) {
                          widget.onChange!(value);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        case TDFormItemType.rate:
          return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: TDTheme.of(context).whiteColor1,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TDText(
                      widget.label,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TDRate(
                        count: widget.rateCount,
                        value: widget.rateValue,
                        allowHalf: widget.allowHalf,
                        disabled: FormState,
                        onChange: (value) {
                          setState(() {
                            if (widget.onChange != null) {
                              widget.onChange!(value);
                            }
                          });
                        }),
                  ],
                ),
              ));
        case TDFormItemType.textarea:
          return TDTextarea(
            backgroundColor: Colors.red,
            controller: widget.controller,
            label: widget.label,
            hintText: widget.help,
            maxLength: widget.maxLength,
            indicator: widget.indicator,
            readOnly: FormState,
            layout: TDTextareaLayout.vertical,
            additionInfo: ShowErrorMessage == true ? errorMessage : null,
            additionInfoColor: TDTheme.of(context).errorColor6,
            onChanged: (value) {
              setState(() {});
            },
          );
      }
    }
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
                        textAlign: FormContentAlign,
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
