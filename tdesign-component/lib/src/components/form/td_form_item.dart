import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'td_form_inherited.dart';
import '../../../tdesign_flutter.dart';

/// 表格单元选用组件类型的枚举
enum TDFormItemType { input, radios, dateTimePicker, cascader, stepper, rate, textarea, upLoadImg }

class TDFormItem extends StatefulWidget {
  TDFormItem({
    required this.type,
    this.child,
    this.formItemNotifier,
    this.label,
    this.labelWidget,
    this.help,
    this.name,
    this.labelAlign,
    this.contentAlign,
    this.labelWidth,
    this.tipAlign,
    this.requiredMark= true,
    this.formRules,
    this.itemRule,
    this.showErrorMessage = true,
    this.indicator,
    this.radioGroupSpacing,
    this.additionInfo,
    this.select = '',
    this.selectFn,
    Map<String, String>? radios,
    Key? key,
  }) : super(key: key);

  /// 表单项标签左侧展示的内容
  final String? label;

  /// 自定义标签
  final Widget? labelWidget;

  /// 表格单元需要使用的组件类型
  final TDFormItemType type;

  /// 表单字段名称
  final String? name;

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

  /// 组件提示内容对齐方式
  final TextAlign? tipAlign;

  /// 表单子组件
  final Widget? child;

  final FormItemNotifier? formItemNotifier;

  /// 选择器 适用于日期选择器等
  String select;

  /// 选择器方法 适用于日期选择器等
  final Function? selectFn;

  /// 是否显示必填标记（*）
  final bool? requiredMark;

  /// 整个表单的校验规则
  final List<TDFormValidation>? formRules;

  /// 表单项验证规则
  final List? itemRule;

  /// 是否显示错误信息
  final bool showErrorMessage;

  /// TDTextarea 的属性，指示器
  final bool? indicator;

  /// TDRadioGroup 属性，文字与单选框的间距
  final double? radioGroupSpacing;

  @override
  _TDFormItemState createState() => _TDFormItemState();
}

class _TDFormItemState extends State<TDFormItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.formItemNotifier?.addListener(() {
      updateFormData(widget.formItemNotifier?.formVal);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (widget.formItemNotifier != null) {
      widget.formItemNotifier?.dispose();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (FormValidate) {
      startValidation();
    }
  }
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

  Map<String, dynamic> get FormData {
    return TDFormInherited.of(context)!.formData;
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
  bool get FormRequiredMark{
    return TDFormInherited.of(context)!.requiredMark??false;
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

  /// 表单 item 的校验错误提示信息
  String? errorMessage;


  /// 调用校验方法
  void startValidation() {
    setState(() {
      errorMessage = validate();
    });
  }

  /// 遍历校验规则并执行
  String? validate() {
    String? value = widget.formItemNotifier?.formVal;
    for (var rule in FormRules!) {
      /// 只对类型匹配的项进行校验
      if (rule.type == widget.type) {
        final result = rule.check(widget.name!, value);
        if (result != null) {
          /// 返回第一个不通过的错误信息
          return result;
        }
      }
    }
    return null;
  }

  void updateFormData(value) {
    if (widget.name != null) {
      String name = widget.name!;
      Map<String, dynamic> _formData = FormData;
      _formData[name] = value;
      TDFormInherited.of(context)!.onFormDataChange(_formData);
      startValidation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);
    Widget labelContent=  Visibility(
        visible: widget.label != null ? true : false,
        child: SizedBox(
          width: LabelWidth,
          child: widget.labelWidget ??
              Row(
                 children: [
                   if(FormRequiredMark&&(widget.requiredMark!=null&&widget.requiredMark==true))
                   TDText('*', style: const TextStyle(fontSize: 12),textColor: Colors.red, textAlign: widget.labelAlign),
                   TDText(widget.label, style: const TextStyle(fontSize: 16), textAlign: widget.labelAlign),
                 ],
              )
        ));
    List<Widget> itemContent = [
      labelContent,
      Visibility(
        visible: FormIsHorizontal,
        child: Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: widget.child ?? SizedBox(),
        )),
        replacement: widget.child ?? SizedBox(),
      )
    ];
    switch (widget.type) {
      case TDFormItemType.input:
      case TDFormItemType.radios:
      case TDFormItemType.rate:
        return Container(
            decoration: BoxDecoration(
              color: TDTheme.of(context).whiteColor1,
            ),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: FormIsHorizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: itemContent,
                      ),
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: itemContent,
                      ),
                    ),
                    _buildTipRow()
                  ],
                )));
      case TDFormItemType.dateTimePicker:
      case TDFormItemType.cascader:
        return _buildSelectRow(context, widget.select, widget.label ?? '', widget.selectFn);
      case TDFormItemType.stepper:
        return Container(
          decoration: BoxDecoration(
            color: theme.whiteColor1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Visibility(
                visible: FormIsHorizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      labelContent,
                      widget.child ?? SizedBox()
                    ]),
                replacement: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: itemContent,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              _buildTipRow(right: 20)
            ]),
          ),
        );
      case TDFormItemType.textarea:
        return Container(
            decoration: BoxDecoration(
              color: TDTheme.of(context).whiteColor1,
            ),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: FormIsHorizontal,
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Visibility(
                            visible: widget.label != null ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child:labelContent,
                            )),
                        Expanded(child: widget.child ?? SizedBox()),
                      ]),
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: widget.label != null ? true : false,
                            child: SizedBox(
                              width: LabelWidth,
                              child: widget.labelWidget ??
                                  TDText(widget.label,
                                      style: const TextStyle(fontSize: 16), textAlign: widget.labelAlign),
                            ),
                          ),
                          widget.child ?? SizedBox()
                        ],
                      ),
                    ),
                    _buildTipRow(left: 12)
                  ],
                )));
      case TDFormItemType.upLoadImg:
        return Container(
          decoration: BoxDecoration(color: theme.whiteColor1),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Visibility(
                    visible: FormIsHorizontal,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: itemContent),
                    replacement: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: widget.label != null ? true : false,
                            child: SizedBox(
                              width: LabelWidth,
                              child: widget.labelWidget ??
                                  TDText(widget.label,
                                      style: const TextStyle(fontSize: 16), textAlign: widget.labelAlign),
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        widget.child ?? SizedBox()
                      ],
                    ),
                  ),
                  _buildTipRow()
                ],
              )),
        );
    }
  }

  Widget _buildSelectRow(BuildContext context, String output, String title, Function? selectFn) {
    Widget labelContent = SizedBox(
      width: LabelWidth,
      child: widget.labelWidget ??
          Padding(
            padding: EdgeInsets.only(left: FormIsHorizontal ? 0 : 2),
            child:  Row(
              children: [
                if(FormRequiredMark&&(widget.requiredMark!=null&&widget.requiredMark==true))
                  TDText('*', style: const TextStyle(fontSize: 12),textColor: Colors.red, textAlign: widget.labelAlign),
                TDText(widget.label, style: const TextStyle(fontSize: 16), textAlign: widget.labelAlign),
              ],
            ),
          ),
    );
    Widget content = Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: Row(
        children: [
          Expanded(
              child: TDText(
            textAlign: FormContentAlign,
            output,
            font: TDTheme.of(context).fontBodyLarge,
            textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Icon(
              TDIcons.chevron_right,
              color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (selectFn != null) {
          selectFn(context);
        }
      },
      child: Container(
        color: TDTheme.of(context).whiteColor1,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: FormIsHorizontal,
              child: Row(
                children: [
                  labelContent,
                  Expanded(
                    child: content,
                  ),
                ],
              ),
              replacement: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelContent,
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 2),
                        child: TDText(
                          textAlign: FormContentAlign,
                          output,
                          font: TDTheme.of(context).fontBodyLarge,
                          textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )),
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
            _buildTipRow(right: 44)
          ],
        ),
      ),
    );
  }

  ///文案提示 如帮助信息，错误信息
  Widget _buildTipRow({double left = 4, double right = 20}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.help != null)
          Row(
            children: [
              if (widget.label != null && FormIsHorizontal) SizedBox(width: LabelWidth),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: left, right: right),
                    child: TDText(
                      widget.help,
                      style: const TextStyle(fontSize: 12),
                      textAlign: widget.tipAlign ?? TextAlign.left,
                      textColor: const Color.fromRGBO(0, 0, 0, 0.4),
                    )),
              )
            ],
          ),
        if (ShowErrorMessage != null && ShowErrorMessage! && errorMessage != null && errorMessage != '')
          Row(
            children: [
              if (widget.label != null) SizedBox(width: LabelWidth),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: left, right: right),
                      child: TDText(
                        errorMessage,
                        style: const TextStyle(fontSize: 12),
                        textAlign: widget.tipAlign ?? TextAlign.left,
                        textColor: Color.fromRGBO(213, 73, 65, 1),
                      )))
            ],
          ),
      ],
    );
  }
}

class FormItemNotifier with ChangeNotifier {
  String _formVal = '';
  String get formVal => _formVal;
  upDataForm(val) {
    _formVal = val;
    notifyListeners();
  }

  submit() {
    notifyListeners();
  }
}
