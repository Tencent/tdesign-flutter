import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDFormPage extends StatefulWidget {
  const TDFormPage({Key? key}) : super(key: key);

  @override
  _TDFormPageState createState() => _TDFormPageState();
}

class _TDFormPageState extends State<TDFormPage> {
  List<TextEditingController> _controller = [];

  String _selected_1 = '请输入内容';
  String _selected_2 = '请输入内容';

  String? _initLocalData;

  /// form 禁用的状态
  bool _formDisableState = false;

  /// form 排列方式是否为水平
  bool _isFormHorizontal = true;

  /// 控制是否进行表单校验
  bool _validateForm = false;

  /// 设置按钮是否可点击状态
  /// true 表示处于 active 状态
  bool horizontalButton = false;
  bool verticalButton = true;

  Color activeButtonColor = Color(0xFFF0F1FD);
  Color defaultButtonColor = Color(0xFFE5E5E5);

  Color verticalTextColor = Color(0xFF1A1A1A);
  Color horizontalTextColor = Color(0xFF0A58D9);
  Color verticalButtonColor = Color(0xFFE5E5E5);
  Color horizontalButtonColor = Color(0xFFF0F1FD);

  /// radios 传入参数
  final Map<String, String> _radios = {'0': '男', '1': '女', '3': '保密'};

  /// 级联选择器 传入参数
  static const List<Map> _data = [
    {
      'label': '北京市',
      'value': '110000',
      "children": [
        {
          "value": '110100',
          "label": '北京市',
          "children": [
            {"value": '110101', "label": '东城区'},
            {"value": '1101022', "label": '东区'},
            {"value": '110102', "label": '西城区'},
            {"value": '110105', "label": '朝阳区'},
            {"value": '110106', "label": '丰台区'},
            {"value": '110107', "label": '石景山区'},
            {"value": '110108', "label": '海淀区'},
            {"value": '110109', "label": '门头沟区'},
          ],
        },
      ],
    },
    {
      "label": '天津市',
      "value": '120000',
      "children": [
        {
          "value": '120100',
          "label": '天津市',
          "children": [
            {
              "value": '120101',
              "label": '和平区',
            },
            {
              "value": '120102',
              "label": '河东区',
            },
            {
              "value": '120103',
              "label": '河西区',
            },
            {
              "value": '120104',
              "label": '南开区',
            },
            {
              "value": '120105',
              "label": '河北区',
            },
            {
              "value": '120106',
              "label": '红桥区',
            },
            {
              "value": '120110',
              "label": '东丽区',
            },
            {
              "value": '120111',
              "label": '西青区',
            },
            {
              "value": '120112',
              "label": '津南区',
            },
          ],
        },
      ],
    },
  ];
  List<TDUploadFile> files = [
    // TDUploadFile(key: 1, remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
    // TDUploadFile(key: 2, remotePath: 'https://tdesign.gtimg.com/demo/images/example2.png'),
    // TDUploadFile(key: 3, remotePath: 'https://tdesign.gtimg.com/demo/images/example3.png'),
  ];

  ///密码是否浏览
  bool browseOn = false;

  /// 整个表单存放的数据
  Map<String, dynamic> _formData = {
    "name": '',
    "password": '',
    "gender": '',
    "birth": '',
    "place": '',
    "age": "3",
    "description": "2",
    "resume": '',
    "photo": '',
  };
  Map<String, dynamic> _formItemNotifier = {
    "name": '',
    "password": '',
    "gender": '',
    "birth": '',
    "place": '',
    "age": '',
    "description": '',
    "resume": '',
    "photo": "",
  };

  @override
  void initState() {
    /// 三个文本型的表格单元
    for (var i = 0; i < 4; i++) {
      _controller.add(TextEditingController());
    }
    _formData.forEach((key, value) {
      _formItemNotifier[key] = FormItemNotifier();
    });
    super.initState();
  }

  /// 提交按钮钮点击事件：
  /// 改变 _validate 值，从而触发校验
  /// 获取表单的数据
  void _onSubmit() {
    globaTDFormlKey.currentState?.onSubmit();
  }

  /// 定义整个校验规则
  final List<TDFormValidation> _validationRules = [
    TDFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '输入不能为空',
      type: TDFormItemType.input,
      name: 'name',
    ),
    TDFormValidation(
      validate: (value) => RegExp(r'^[a-zA-Z]{8}$').hasMatch(value ?? '') ? null : 'invalid',
      errorMessage: '只能输入8个字符英文',
      type: TDFormItemType.input,
      name: 'password',
    ),
    TDFormValidation(
        validate: (value) => value == null || value.isEmpty ? 'empty' : null,
        errorMessage: '不能为空',
        type: TDFormItemType.radios,
        name: 'gender'),
    TDFormValidation(
        validate: (value) => value == null || value.isEmpty ? 'empty' : null,
        errorMessage: '不能为空',
        type: TDFormItemType.dateTimePicker,
        name: 'birth'),
    TDFormValidation(
        validate: (value) => value == null || value.isEmpty ? 'empty' : null,
        errorMessage: '不能为空',
        type: TDFormItemType.cascader,
        name: 'place'),
    TDFormValidation(
        validate: (value) {
          if (value == null || value.isEmpty) {
            return 'empty';
          } else if (int.parse(value) == 0) {
            return 'empty';
          }
          return null;
        },
        errorMessage: '年限需要大于0',
        type: TDFormItemType.stepper,
        name: "age"),
    TDFormValidation(
        validate: (value) => value == null || value.isEmpty ? 'empty' : null,
        errorMessage: '不能为空',
        type: TDFormItemType.textarea,
        name: 'resume'),
    TDFormValidation(
        validate: (value) => value == null || value.isEmpty ? 'empty' : null,
        errorMessage: '不能为空',
        type: TDFormItemType.upLoadImg,
        name: 'photo'),
  ];

  ///表单提交数据
  onSubmit(Map<String, dynamic> formData, isValidateSuc) {
    setState(() {
      _validateForm = !_validateForm;
    });

    /// 其他通过回调获取数据
    print('Form Data: $formData');
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'form',
      desc: '基础表单',
      backgroundColor: const Color(0xfff6f6f6),
      children: [
        ExampleModule(title: '基础类型', children: [
          ExampleItem(desc: '基础表单', builder: _buildArrangementSwitch),
          ExampleItem(desc: '', builder: _buildSwitchWithBase),
          ExampleItem(builder: (BuildContext context) {
            return CodeWrapper(builder: _buildForm);
          }),
          // ExampleItem(ignoreCode: true, desc: '', builder: (_) => CodeWrapper(builder: _buildCombinationButtons)),
        ]),
      ],
    );
  }

  @Demo(group: 'form')
  Widget _buildForm(BuildContext context) {
    final theme = TDTheme.of(context);
    return TDForm(
        key: globaTDFormlKey,
        disabled: _formDisableState,
        data: _formData,
        isHorizontal: _isFormHorizontal,
        isValidate: _validateForm,
        rules: _validationRules,
        formContentAlign: TextAlign.left,
        requiredMark: true,

        /// 确定整个表单是否展示提示信息
        formShowErrorMessage: true,
        onSubmit: onSubmit,
        items: [
          TDFormItem(
              label: '用户名',
              name: 'name',
              type: TDFormItemType.input,
              help: '请输入用户名',
              labelWidth: 60.0,
              formItemNotifier: _formItemNotifier['name'],

              /// 控制单个 item 是否展示错误提醒
              showErrorMessage: true,
              requiredMark: false,
              child: TDInput(
                  inputDecoration: InputDecoration(
                    hintText: "请输入用户名",
                    border: InputBorder.none,
                  ),
                  controller: _controller[0],
                  backgroundColor: Colors.white,
                  additionInfoColor: TDTheme.of(context).errorColor6,
                  showBottomDivider: false,
                  readOnly: _formDisableState,
                  onChanged: (val) {
                    _formItemNotifier['name']?.upDataForm(val);
                  },
                  onClearTap: () {
                    _controller[0].clear();
                    _formItemNotifier['name']?.upDataForm("");
                  })),
          TDFormItem(
            label: '密码',
            name: 'password',
            type: TDFormItemType.input,
            help: '请输入密码',
            labelWidth: 60.0,
            formItemNotifier: _formItemNotifier['password'],
            showErrorMessage: true,
            child: TDInput(
              inputDecoration: InputDecoration(
                hintText: '请输入密码',
                border: InputBorder.none,
              ),
              type: TDInputType.normal,
              controller: _controller[1],
              obscureText: !browseOn,
              backgroundColor: Colors.white,
              needClear: false,
              readOnly: _formDisableState,
              showBottomDivider: false,
              onChanged: (val) {
                _formItemNotifier['password']?.upDataForm(val);
              },
                onClearTap: () {
                  _controller[1].clear();
                  _formItemNotifier['password']?.upDataForm("");
                }
            ),
          ),
          TDFormItem(
            label: '性别',
            name: 'gender',
            type: TDFormItemType.radios,
            labelWidth: 60.0,
            radioGroupSpacing: 0,
            showErrorMessage: true,
            formItemNotifier: _formItemNotifier['gender'],
            child: TDRadioGroup(
              spacing: 0,
              direction: Axis.horizontal,
              directionalTdRadios: _radios.entries.map((entry) {
                return TDRadio(
                  id: entry.key,
                  title: entry.value,
                  radioStyle: TDRadioStyle.circle,
                  showDivider: false,
                  enable: !_formDisableState,
                );
              }).toList(),
              onRadioGroupChange: (ids) {
                _formItemNotifier['gender']?.upDataForm(ids);
              },
            ),
          ),
          TDFormItem(
            label: '生日',
            help: '请输入生日',
            name: 'birth',
            labelWidth: 60.0,
            type: TDFormItemType.dateTimePicker,
            contentAlign: _isFormHorizontal ? TextAlign.right : TextAlign.left,
            tipAlign: _isFormHorizontal ? TextAlign.right : TextAlign.left,
            formItemNotifier: _formItemNotifier['birth'],
            select: _selected_1,
            selectFn: (BuildContext context) {
              TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
                setState(() {
                  _selected_1 =
                      '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
                  _formItemNotifier['birth']?.upDataForm(_selected_1);
                });
                Navigator.of(context).pop();
              }, dateStart: [1999, 01, 01], dateEnd: [2050, 12, 31], initialDate: [2012, 1, 1]);
            },
          ),
          TDFormItem(
            label: '籍贯',
            name: 'place',
            type: TDFormItemType.cascader,
            contentAlign: _isFormHorizontal ? TextAlign.right : TextAlign.left,
            tipAlign: _isFormHorizontal ? TextAlign.right : TextAlign.left,
            labelWidth: 60.0,
            help: '请输入籍贯',
            select: _selected_2,
            formItemNotifier: _formItemNotifier['place'],
            selectFn: (BuildContext context) {
              TDCascader.showMultiCascader(context,
                  title: '选择地址',
                  data: _data,
                  initialData: _initLocalData,
                  theme: 'step', onChange: (List<MultiCascaderListModel> selectData) {
                setState(() {
                  var result = [];
                  var len = selectData.length;
                  _initLocalData = selectData[len - 1].value!;
                  selectData.forEach((element) {
                    result.add(element.label);
                  });
                  _selected_2 = result.join('/');
                  _formItemNotifier['place']?.upDataForm(_selected_2);
                });
              }, onClose: () {
                Navigator.of(context).pop();
              });
            },
          ),
          TDFormItem(
              label: '年限',
              name: 'age',
              help: '请选择年限',
              labelWidth: 60.0,
              type: TDFormItemType.stepper,
              tipAlign: _isFormHorizontal ? TextAlign.right : TextAlign.left,
              formItemNotifier: _formItemNotifier['age'],
              child: Padding(
                padding: EdgeInsets.only(top: _isFormHorizontal ? 0 : 4, right: 18),
                child: TDStepper(
                  theme: TDStepperTheme.filled,
                  disabled: _formDisableState,
                  onChange: (value) {
                    _formItemNotifier['age']?.upDataForm('${value}');
                  },
                ),
              )),
          TDFormItem(
            label: '自我评价',
            name: 'description',
            help: '请选择自我评价',
            tipAlign: _isFormHorizontal ? TextAlign.right : TextAlign.left,
            type: TDFormItemType.rate,
            labelWidth: 78.0,
            formItemNotifier: _formItemNotifier['description'],
            child: Align(
              alignment: _isFormHorizontal ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(top: _isFormHorizontal ? 0 : 5, right: 18, bottom: 5),
                  child: TDRate(
                    count: 5,
                    value: 3,
                    allowHalf: false,
                    disabled: _formDisableState,
                    onChange: (value) {
                      _formItemNotifier['description']?.upDataForm('${value}');
                    },
                  )),
            ),
          ),
          TDFormItem(
            label: '个人简介',
            labelWidth: 78.0,
            name: 'resume',
            type: TDFormItemType.textarea,
            help: '请输入个人简介',
            formItemNotifier: _formItemNotifier['resume'],
            child: TDTextarea(
              backgroundColor: Colors.red,
              hintText: '请输入个人简介',
              maxLength: 500,
              indicator: true,
              readOnly: _formDisableState,
              layout: TDTextareaLayout.vertical,
              showBottomDivider: false,
              onChanged: (value) {
                _formItemNotifier['resume']?.upDataForm(value);
              },
            ),
          ),
          TDFormItem(
            label: '上传图片',
            name: 'photo',
            help: '请上传个人图片',
            labelWidth: 76.0,
            type: TDFormItemType.upLoadImg,
            formItemNotifier: _formItemNotifier['photo'],
            child: TDUpload(
              files: files,
              multiple: true,
              max: 6,
              onError: print,
              onValidate: print,
              onChange: ((imgList, type) {
                files = _onValueChanged(files ?? [], imgList, type);
                List imgs = files.map((e) => e.remotePath ?? e.assetPath).toList();
                setState(() {
                  _formItemNotifier['photo'].upDataForm(imgs.join(','));
                });
              }),
            ),
          )
        ],
        btnGroup: [
          Container(
            decoration: BoxDecoration(
              color: theme.whiteColor1,
            ),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                        child: TDButton(
                            text: '提交',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            theme: TDButtonTheme.primary,
                            shape: TDButtonShape.rectangle,
                            onTap: _onSubmit,
                            disabled: _formDisableState)),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TDButton(
                      text: '重置',
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      theme: TDButtonTheme.light,
                      shape: TDButtonShape.rectangle,
                      disabled: _formDisableState,
                      onTap: () {
                        setState(() {
                          _formData = {
                            "name": '',
                            "password": '',
                            "gender": '',
                            "birth": '',
                            "place": '',
                            "age": 3,
                            "description": 2,
                            "resume": '',
                            "photo": ''
                          };
                        });
                      },
                    )),
                  ],
                )),
          )
        ]);
  }

  List<TDUploadFile> _onValueChanged(List<TDUploadFile> fileList, List<TDUploadFile> value, TDUploadType event) {
    switch (event) {
      case TDUploadType.add:
        fileList.addAll(value);
        break;
      case TDUploadType.remove:
        fileList.removeWhere((element) => element.key == value[0].key);
        break;
      case TDUploadType.replace:
        final firstReplaceFile = value.first;
        final index = fileList.indexWhere((file) => file.key == firstReplaceFile.key);
        if (index != -1) {
          fileList[index] = firstReplaceFile;
        }
        break;
    }
    return fileList;
  }

  /// 横 竖 排版模式切换按钮
  @Demo(group: 'form')
  Widget _buildArrangementSwitch(BuildContext buildContext) {
    final theme = TDTheme.of(context);
    return Container(
        decoration: BoxDecoration(
          color: theme.whiteColor1,
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TDButton(
                    text: '水平排布',
                    shape: TDButtonShape.round,
                    style: TDButtonStyle(backgroundColor: horizontalButtonColor),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: horizontalTextColor,
                    ),
                    onTap: () {
                      setState(() {
                        if (horizontalButton) {
                          /// 置换按钮状态
                          horizontalButton = false;
                          verticalButton = true;

                          /// 置换按钮颜色
                          final currentVerticalColor = verticalButtonColor;
                          verticalButtonColor = horizontalButtonColor;
                          horizontalButtonColor = currentVerticalColor;

                          /// 置换文字颜色
                          final currentTextColor = verticalTextColor;
                          verticalTextColor = horizontalTextColor;
                          horizontalTextColor = currentTextColor;
                          _isFormHorizontal = true;
                          print(_isFormHorizontal);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TDButton(
                    text: '竖直排布',
                    shape: TDButtonShape.round,
                    style: TDButtonStyle(backgroundColor: verticalButtonColor),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: verticalTextColor,
                    ),
                    onTap: () {
                      setState(() {
                        if (verticalButton) {
                          /// 置换按钮状态
                          horizontalButton = true;
                          verticalButton = false;

                          /// 置换按钮颜色
                          final currentVerticalColor = verticalButtonColor;
                          verticalButtonColor = horizontalButtonColor;
                          horizontalButtonColor = currentVerticalColor;

                          /// 置换文字颜色
                          final currentTextColor = verticalTextColor;
                          verticalTextColor = horizontalTextColor;
                          horizontalTextColor = currentTextColor;

                          _isFormHorizontal = false;
                          print(_isFormHorizontal);
                        }
                      });
                    },
                  ),
                ),
              ],
            )));
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithBase(BuildContext context) {
    return _buildItem(
      context,
      TDSwitch(
        isOn: _formDisableState,
        onChanged: (value) {
          setState(() {
            _formDisableState = value;
          });
          return false;
        },
      ),
      title: '禁用态',
    );
  }

  @Demo(group: 'switch')
  Widget _buildItem(BuildContext context, Widget switchItem, {String? title, String? desc}) {
    final theme = TDTheme.of(context);
    Widget current = Row(
      children: [
        Expanded(
            child: TDText(
          title ?? '',
          textColor: theme.fontGyColor1,
        )),
        TDText(
          desc ?? '',
          textColor: theme.grayColor6,
        ),
        SizedBox(child: switchItem)
      ],
    );
    current = Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: SizedBox(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: current,
          ),
          color: Colors.white,
        ),
        height: 56,
      ),
    );
    return Column(mainAxisSize: MainAxisSize.min, children: [current]);
  }
}
