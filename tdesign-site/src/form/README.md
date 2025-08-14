---
title: Form 表单
description: 用以收集、校验和提交数据，一般由输入框、单选框、复选框、选择器等控件组成。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_form_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_form_page.dart)

### 1 基础类型

基础表单
      
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">暂无演示代码</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildForm(BuildContext context) {
    final theme = TDTheme.of(context);
    return TDForm(
        formController: _formController,
        disabled: _formDisableState,
        data: _formData,
        isHorizontal: _isFormHorizontal,
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
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['name'],

            /// 控制单个 item 是否展示错误提醒
            showErrorMessage: true,
            requiredMark: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: "请输入用户名",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '密码',
            name: 'password',
            type: TDFormItemType.input,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['password'],
            showErrorMessage: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: '请输入密码',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '性别',
            name: 'gender',
            type: TDFormItemType.radios,
            labelWidth: 82.0,
            showErrorMessage: true,
            formItemNotifier: _formItemNotifier['gender'],
            child: TDRadioGroup(
              spacing: 0,
              direction: Axis.horizontal,
              controller: _genderCheckboxGroupController,
              directionalTdRadios: _radios.entries.map((entry) {
                return TDRadio(
                  id: entry.key,
                  title: entry.value,
                  radioStyle: TDRadioStyle.circle,
                  showDivider: false,
                  spacing: 4,
                  checkBoxLeftSpace: 0,
                  customSpace: EdgeInsets.all(0),
                  enable: !_formDisableState,
                );
              }).toList(),
              onRadioGroupChange: (ids) {
                if (ids == null) {
                  return;
                }
                _formItemNotifier['gender']?.upDataForm(ids);
              },
            ),
          ),
          TDFormItem(
            label: '生日',
            name: 'birth',
            labelWidth: 82.0,
            type: TDFormItemType.dateTimePicker,
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            formItemNotifier: _formItemNotifier['birth'],
            hintText:'请输入内容',
            select: _selected_1,
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            labelWidth: 82.0,
            hintText:'请输入内容',
            select: _selected_2,
            formItemNotifier: _formItemNotifier['place'],
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
              labelWidth: 82.0,
              type: TDFormItemType.stepper,
              formItemNotifier: _formItemNotifier['age'],
              child: Padding(
                padding: EdgeInsets.only( right: 18),
                child: TDStepper(
                  theme: TDStepperTheme.filled,
                  disabled: _formDisableState,
                  eventController: _stepController!,
                  value:int.parse(_formData['age']),
                  onChange: (value) {
                    _formItemNotifier['age']?.upDataForm('${value}');
                  },
                ),
              )),
          TDFormItem(
            label: '自我评价',
            name: 'description',
            tipAlign: TextAlign.left,
            type: TDFormItemType.rate,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['description'],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: TDRate(
                    count: 5,
                    value: double.parse(_formData['description']),
                    allowHalf: false,
                    disabled: _formDisableState,
                    onChange: (value) {
                      setState(() {
                        _formData['description'] = '${value}';
                      });
                      _formItemNotifier['description']?.upDataForm('${value}');
                    },
                  )),
            ),
          ),
          TDFormItem(
              label: '个人简介',
              labelWidth: 82.0,
              name: 'resume',
              type: TDFormItemType.textarea,
              formItemNotifier: _formItemNotifier['resume'],
              child: Padding(
                padding: EdgeInsets.only(top: _isFormHorizontal?0:8,bottom: 4),
                child: TDTextarea(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.all(0),
                  hintText: '请输入个人简介',
                  maxLength: 500,
                  indicator: true,
                  readOnly: _formDisableState,
                  layout: TDTextareaLayout.vertical,
                  controller: _controller[2],
                  showBottomDivider: false,
                  onChanged: (value) {
                    _formItemNotifier['resume']?.upDataForm(value);
                  },
                ),
              )),
          TDFormItem(
              label: '上传图片',
              name: 'photo',
              labelWidth: 82.0,
              type: TDFormItemType.upLoadImg,
              formItemNotifier: _formItemNotifier['photo'],
              child: Padding(
                padding: EdgeInsets.only(top:4,bottom: 4),
                child: TDUpload(
                  files: files,
                  multiple: true,
                  max: 6,
                  onError: print,
                  onValidate: print,
                  disabled: _formDisableState,
                  onChange: ((imgList, type) {
                    if (_formDisableState) {
                      return;
                    }
                    files = _onValueChanged(files ?? [], imgList, type);
                    List imgs = files.map((e) => e.remotePath ?? e.assetPath).toList();
                    setState(() {
                      _formItemNotifier['photo'].upDataForm(imgs.join(','));
                    });
                  }),
                ),
              ))
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
                      text: '重置',
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      theme: TDButtonTheme.light,
                      shape: TDButtonShape.rectangle,
                      disabled: _formDisableState,
                      onTap: () {
                        //用户名称
                        _controller[0].clear();
                        //密码
                        _controller[1].clear();
                        // 性别
                        _genderCheckboxGroupController.toggle('', false);
                        //个人简介
                        _controller[2].clear();
                        //生日
                        _selected_1 = '';
                        //籍贯
                        _selected_2 = '';
                        //年限
                        _stepController.add(TDStepperEventType.cleanValue);
                        //上传图片
                        files.clear();
                        _formData = {
                          "name": '',
                          "password": '',
                          "gender": '',
                          "birth": '',
                          "place": '',
                          "age": "0",
                          "description": "2",
                          "resume": '',
                          "photo": ''
                        };
                        _formData.forEach((key, value) {
                          _formItemNotifier[key].upDataForm(value);
                        });
                        _formController.reset(_formData);
                        setState(() {});
                      },
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TDButton(
                            text: '提交',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            theme: TDButtonTheme.primary,
                            shape: TDButtonShape.rectangle,
                            onTap: _onSubmit,
                            disabled: _formDisableState)),
                  ],
                )),
          )
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildForm(BuildContext context) {
    final theme = TDTheme.of(context);
    return TDForm(
        formController: _formController,
        disabled: _formDisableState,
        data: _formData,
        isHorizontal: _isFormHorizontal,
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
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['name'],

            /// 控制单个 item 是否展示错误提醒
            showErrorMessage: true,
            requiredMark: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: "请输入用户名",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '密码',
            name: 'password',
            type: TDFormItemType.input,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['password'],
            showErrorMessage: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: '请输入密码',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '性别',
            name: 'gender',
            type: TDFormItemType.radios,
            labelWidth: 82.0,
            showErrorMessage: true,
            formItemNotifier: _formItemNotifier['gender'],
            child: TDRadioGroup(
              spacing: 0,
              direction: Axis.horizontal,
              controller: _genderCheckboxGroupController,
              directionalTdRadios: _radios.entries.map((entry) {
                return TDRadio(
                  id: entry.key,
                  title: entry.value,
                  radioStyle: TDRadioStyle.circle,
                  showDivider: false,
                  spacing: 4,
                  checkBoxLeftSpace: 0,
                  customSpace: EdgeInsets.all(0),
                  enable: !_formDisableState,
                );
              }).toList(),
              onRadioGroupChange: (ids) {
                if (ids == null) {
                  return;
                }
                _formItemNotifier['gender']?.upDataForm(ids);
              },
            ),
          ),
          TDFormItem(
            label: '生日',
            name: 'birth',
            labelWidth: 82.0,
            type: TDFormItemType.dateTimePicker,
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            formItemNotifier: _formItemNotifier['birth'],
            hintText:'请输入内容',
            select: _selected_1,
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            labelWidth: 82.0,
            hintText:'请输入内容',
            select: _selected_2,
            formItemNotifier: _formItemNotifier['place'],
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
              labelWidth: 82.0,
              type: TDFormItemType.stepper,
              formItemNotifier: _formItemNotifier['age'],
              child: Padding(
                padding: EdgeInsets.only( right: 18),
                child: TDStepper(
                  theme: TDStepperTheme.filled,
                  disabled: _formDisableState,
                  eventController: _stepController!,
                  value:int.parse(_formData['age']),
                  onChange: (value) {
                    _formItemNotifier['age']?.upDataForm('${value}');
                  },
                ),
              )),
          TDFormItem(
            label: '自我评价',
            name: 'description',
            tipAlign: TextAlign.left,
            type: TDFormItemType.rate,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['description'],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: TDRate(
                    count: 5,
                    value: double.parse(_formData['description']),
                    allowHalf: false,
                    disabled: _formDisableState,
                    onChange: (value) {
                      setState(() {
                        _formData['description'] = '${value}';
                      });
                      _formItemNotifier['description']?.upDataForm('${value}');
                    },
                  )),
            ),
          ),
          TDFormItem(
              label: '个人简介',
              labelWidth: 82.0,
              name: 'resume',
              type: TDFormItemType.textarea,
              formItemNotifier: _formItemNotifier['resume'],
              child: Padding(
                padding: EdgeInsets.only(top: _isFormHorizontal?0:8,bottom: 4),
                child: TDTextarea(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.all(0),
                  hintText: '请输入个人简介',
                  maxLength: 500,
                  indicator: true,
                  readOnly: _formDisableState,
                  layout: TDTextareaLayout.vertical,
                  controller: _controller[2],
                  showBottomDivider: false,
                  onChanged: (value) {
                    _formItemNotifier['resume']?.upDataForm(value);
                  },
                ),
              )),
          TDFormItem(
              label: '上传图片',
              name: 'photo',
              labelWidth: 82.0,
              type: TDFormItemType.upLoadImg,
              formItemNotifier: _formItemNotifier['photo'],
              child: Padding(
                padding: EdgeInsets.only(top:4,bottom: 4),
                child: TDUpload(
                  files: files,
                  multiple: true,
                  max: 6,
                  onError: print,
                  onValidate: print,
                  disabled: _formDisableState,
                  onChange: ((imgList, type) {
                    if (_formDisableState) {
                      return;
                    }
                    files = _onValueChanged(files ?? [], imgList, type);
                    List imgs = files.map((e) => e.remotePath ?? e.assetPath).toList();
                    setState(() {
                      _formItemNotifier['photo'].upDataForm(imgs.join(','));
                    });
                  }),
                ),
              ))
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
                      text: '重置',
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      theme: TDButtonTheme.light,
                      shape: TDButtonShape.rectangle,
                      disabled: _formDisableState,
                      onTap: () {
                        //用户名称
                        _controller[0].clear();
                        //密码
                        _controller[1].clear();
                        // 性别
                        _genderCheckboxGroupController.toggle('', false);
                        //个人简介
                        _controller[2].clear();
                        //生日
                        _selected_1 = '';
                        //籍贯
                        _selected_2 = '';
                        //年限
                        _stepController.add(TDStepperEventType.cleanValue);
                        //上传图片
                        files.clear();
                        _formData = {
                          "name": '',
                          "password": '',
                          "gender": '',
                          "birth": '',
                          "place": '',
                          "age": "0",
                          "description": "2",
                          "resume": '',
                          "photo": ''
                        };
                        _formData.forEach((key, value) {
                          _formItemNotifier[key].upDataForm(value);
                        });
                        _formController.reset(_formData);
                        setState(() {});
                      },
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TDButton(
                            text: '提交',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            theme: TDButtonTheme.primary,
                            shape: TDButtonShape.rectangle,
                            onTap: _onSubmit,
                            disabled: _formDisableState)),
                  ],
                )),
          )
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildForm(BuildContext context) {
    final theme = TDTheme.of(context);
    return TDForm(
        formController: _formController,
        disabled: _formDisableState,
        data: _formData,
        isHorizontal: _isFormHorizontal,
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
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['name'],

            /// 控制单个 item 是否展示错误提醒
            showErrorMessage: true,
            requiredMark: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: "请输入用户名",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '密码',
            name: 'password',
            type: TDFormItemType.input,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['password'],
            showErrorMessage: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: '请输入密码',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '性别',
            name: 'gender',
            type: TDFormItemType.radios,
            labelWidth: 82.0,
            showErrorMessage: true,
            formItemNotifier: _formItemNotifier['gender'],
            child: TDRadioGroup(
              spacing: 0,
              direction: Axis.horizontal,
              controller: _genderCheckboxGroupController,
              directionalTdRadios: _radios.entries.map((entry) {
                return TDRadio(
                  id: entry.key,
                  title: entry.value,
                  radioStyle: TDRadioStyle.circle,
                  showDivider: false,
                  spacing: 4,
                  checkBoxLeftSpace: 0,
                  customSpace: EdgeInsets.all(0),
                  enable: !_formDisableState,
                );
              }).toList(),
              onRadioGroupChange: (ids) {
                if (ids == null) {
                  return;
                }
                _formItemNotifier['gender']?.upDataForm(ids);
              },
            ),
          ),
          TDFormItem(
            label: '生日',
            name: 'birth',
            labelWidth: 82.0,
            type: TDFormItemType.dateTimePicker,
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            formItemNotifier: _formItemNotifier['birth'],
            hintText:'请输入内容',
            select: _selected_1,
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            labelWidth: 82.0,
            hintText:'请输入内容',
            select: _selected_2,
            formItemNotifier: _formItemNotifier['place'],
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
              labelWidth: 82.0,
              type: TDFormItemType.stepper,
              formItemNotifier: _formItemNotifier['age'],
              child: Padding(
                padding: EdgeInsets.only( right: 18),
                child: TDStepper(
                  theme: TDStepperTheme.filled,
                  disabled: _formDisableState,
                  eventController: _stepController!,
                  value:int.parse(_formData['age']),
                  onChange: (value) {
                    _formItemNotifier['age']?.upDataForm('${value}');
                  },
                ),
              )),
          TDFormItem(
            label: '自我评价',
            name: 'description',
            tipAlign: TextAlign.left,
            type: TDFormItemType.rate,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['description'],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: TDRate(
                    count: 5,
                    value: double.parse(_formData['description']),
                    allowHalf: false,
                    disabled: _formDisableState,
                    onChange: (value) {
                      setState(() {
                        _formData['description'] = '${value}';
                      });
                      _formItemNotifier['description']?.upDataForm('${value}');
                    },
                  )),
            ),
          ),
          TDFormItem(
              label: '个人简介',
              labelWidth: 82.0,
              name: 'resume',
              type: TDFormItemType.textarea,
              formItemNotifier: _formItemNotifier['resume'],
              child: Padding(
                padding: EdgeInsets.only(top: _isFormHorizontal?0:8,bottom: 4),
                child: TDTextarea(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.all(0),
                  hintText: '请输入个人简介',
                  maxLength: 500,
                  indicator: true,
                  readOnly: _formDisableState,
                  layout: TDTextareaLayout.vertical,
                  controller: _controller[2],
                  showBottomDivider: false,
                  onChanged: (value) {
                    _formItemNotifier['resume']?.upDataForm(value);
                  },
                ),
              )),
          TDFormItem(
              label: '上传图片',
              name: 'photo',
              labelWidth: 82.0,
              type: TDFormItemType.upLoadImg,
              formItemNotifier: _formItemNotifier['photo'],
              child: Padding(
                padding: EdgeInsets.only(top:4,bottom: 4),
                child: TDUpload(
                  files: files,
                  multiple: true,
                  max: 6,
                  onError: print,
                  onValidate: print,
                  disabled: _formDisableState,
                  onChange: ((imgList, type) {
                    if (_formDisableState) {
                      return;
                    }
                    files = _onValueChanged(files ?? [], imgList, type);
                    List imgs = files.map((e) => e.remotePath ?? e.assetPath).toList();
                    setState(() {
                      _formItemNotifier['photo'].upDataForm(imgs.join(','));
                    });
                  }),
                ),
              ))
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
                      text: '重置',
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      theme: TDButtonTheme.light,
                      shape: TDButtonShape.rectangle,
                      disabled: _formDisableState,
                      onTap: () {
                        //用户名称
                        _controller[0].clear();
                        //密码
                        _controller[1].clear();
                        // 性别
                        _genderCheckboxGroupController.toggle('', false);
                        //个人简介
                        _controller[2].clear();
                        //生日
                        _selected_1 = '';
                        //籍贯
                        _selected_2 = '';
                        //年限
                        _stepController.add(TDStepperEventType.cleanValue);
                        //上传图片
                        files.clear();
                        _formData = {
                          "name": '',
                          "password": '',
                          "gender": '',
                          "birth": '',
                          "place": '',
                          "age": "0",
                          "description": "2",
                          "resume": '',
                          "photo": ''
                        };
                        _formData.forEach((key, value) {
                          _formItemNotifier[key].upDataForm(value);
                        });
                        _formController.reset(_formData);
                        setState(() {});
                      },
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TDButton(
                            text: '提交',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            theme: TDButtonTheme.primary,
                            shape: TDButtonShape.rectangle,
                            onTap: _onSubmit,
                            disabled: _formDisableState)),
                  ],
                )),
          )
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildForm(BuildContext context) {
    final theme = TDTheme.of(context);
    return TDForm(
        formController: _formController,
        disabled: _formDisableState,
        data: _formData,
        isHorizontal: _isFormHorizontal,
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
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['name'],

            /// 控制单个 item 是否展示错误提醒
            showErrorMessage: true,
            requiredMark: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: "请输入用户名",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '密码',
            name: 'password',
            type: TDFormItemType.input,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['password'],
            showErrorMessage: true,
            child: TDInput(
                leftContentSpace: 0,
                inputDecoration: InputDecoration(
                    hintText: '请输入密码',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: TDTheme.of(context).fontGyColor3.withOpacity(0.4))),
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
                }),
          ),
          TDFormItem(
            label: '性别',
            name: 'gender',
            type: TDFormItemType.radios,
            labelWidth: 82.0,
            showErrorMessage: true,
            formItemNotifier: _formItemNotifier['gender'],
            child: TDRadioGroup(
              spacing: 0,
              direction: Axis.horizontal,
              controller: _genderCheckboxGroupController,
              directionalTdRadios: _radios.entries.map((entry) {
                return TDRadio(
                  id: entry.key,
                  title: entry.value,
                  radioStyle: TDRadioStyle.circle,
                  showDivider: false,
                  spacing: 4,
                  checkBoxLeftSpace: 0,
                  customSpace: EdgeInsets.all(0),
                  enable: !_formDisableState,
                );
              }).toList(),
              onRadioGroupChange: (ids) {
                if (ids == null) {
                  return;
                }
                _formItemNotifier['gender']?.upDataForm(ids);
              },
            ),
          ),
          TDFormItem(
            label: '生日',
            name: 'birth',
            labelWidth: 82.0,
            type: TDFormItemType.dateTimePicker,
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            formItemNotifier: _formItemNotifier['birth'],
            hintText:'请输入内容',
            select: _selected_1,
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            labelWidth: 82.0,
            hintText:'请输入内容',
            select: _selected_2,
            formItemNotifier: _formItemNotifier['place'],
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
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
              labelWidth: 82.0,
              type: TDFormItemType.stepper,
              formItemNotifier: _formItemNotifier['age'],
              child: Padding(
                padding: EdgeInsets.only( right: 18),
                child: TDStepper(
                  theme: TDStepperTheme.filled,
                  disabled: _formDisableState,
                  eventController: _stepController!,
                  value:int.parse(_formData['age']),
                  onChange: (value) {
                    _formItemNotifier['age']?.upDataForm('${value}');
                  },
                ),
              )),
          TDFormItem(
            label: '自我评价',
            name: 'description',
            tipAlign: TextAlign.left,
            type: TDFormItemType.rate,
            labelWidth: 82.0,
            formItemNotifier: _formItemNotifier['description'],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: TDRate(
                    count: 5,
                    value: double.parse(_formData['description']),
                    allowHalf: false,
                    disabled: _formDisableState,
                    onChange: (value) {
                      setState(() {
                        _formData['description'] = '${value}';
                      });
                      _formItemNotifier['description']?.upDataForm('${value}');
                    },
                  )),
            ),
          ),
          TDFormItem(
              label: '个人简介',
              labelWidth: 82.0,
              name: 'resume',
              type: TDFormItemType.textarea,
              formItemNotifier: _formItemNotifier['resume'],
              child: Padding(
                padding: EdgeInsets.only(top: _isFormHorizontal?0:8,bottom: 4),
                child: TDTextarea(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.all(0),
                  hintText: '请输入个人简介',
                  maxLength: 500,
                  indicator: true,
                  readOnly: _formDisableState,
                  layout: TDTextareaLayout.vertical,
                  controller: _controller[2],
                  showBottomDivider: false,
                  onChanged: (value) {
                    _formItemNotifier['resume']?.upDataForm(value);
                  },
                ),
              )),
          TDFormItem(
              label: '上传图片',
              name: 'photo',
              labelWidth: 82.0,
              type: TDFormItemType.upLoadImg,
              formItemNotifier: _formItemNotifier['photo'],
              child: Padding(
                padding: EdgeInsets.only(top:4,bottom: 4),
                child: TDUpload(
                  files: files,
                  multiple: true,
                  max: 6,
                  onError: print,
                  onValidate: print,
                  disabled: _formDisableState,
                  onChange: ((imgList, type) {
                    if (_formDisableState) {
                      return;
                    }
                    files = _onValueChanged(files ?? [], imgList, type);
                    List imgs = files.map((e) => e.remotePath ?? e.assetPath).toList();
                    setState(() {
                      _formItemNotifier['photo'].upDataForm(imgs.join(','));
                    });
                  }),
                ),
              ))
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
                      text: '重置',
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      theme: TDButtonTheme.light,
                      shape: TDButtonShape.rectangle,
                      disabled: _formDisableState,
                      onTap: () {
                        //用户名称
                        _controller[0].clear();
                        //密码
                        _controller[1].clear();
                        // 性别
                        _genderCheckboxGroupController.toggle('', false);
                        //个人简介
                        _controller[2].clear();
                        //生日
                        _selected_1 = '';
                        //籍贯
                        _selected_2 = '';
                        //年限
                        _stepController.add(TDStepperEventType.cleanValue);
                        //上传图片
                        files.clear();
                        _formData = {
                          "name": '',
                          "password": '',
                          "gender": '',
                          "birth": '',
                          "place": '',
                          "age": "0",
                          "description": "2",
                          "resume": '',
                          "photo": ''
                        };
                        _formData.forEach((key, value) {
                          _formItemNotifier[key].upDataForm(value);
                        });
                        _formController.reset(_formData);
                        setState(() {});
                      },
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TDButton(
                            text: '提交',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            theme: TDButtonTheme.primary,
                            shape: TDButtonShape.rectangle,
                            onTap: _onSubmit,
                            disabled: _formDisableState)),
                  ],
                )),
          )
        ]);
  }</pre>

</td-code-block>
                


## API
### TDFormValidation
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| validate | String? Function(dynamic) | - | 校验方法 |
| errorMessage | String | - | 错误提示信息 |
| type | TDFormItemType | - | 校验对象的类型 |

```
```
 ### TDForm
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| items | List<TDFormItem> | - | 表单内容 items |
| rules | Map<String, TDFormValidation> | - | 整个表单字段校验规则 |
| onSubmit | Function | - | 表单提交时触发 |
| data | Map<String, dynamic> | - | 表单数据 |
| colon | bool? | false | 是否在表单标签字段右侧显示冒号 |
| formContentAlign | TextAlign | TextAlign.left | 表单内容对齐方式: 左对齐、右对齐、居中对齐 |
| isHorizontal | bool | true | 表单排列方式是否为 水平方向 |
| disabled | bool | false | 是否禁用整个表单 |
| errorMessage | Object? | - | 表单信息错误信息配置 |
| formLabelAlign | TextAlign? | TextAlign.left | 表单字段标签的对齐方式： |
| labelWidth | double? | 20.0 | 可以整体设置 label 标签宽度 |
| preventSubmitDefault | bool? | true | 是否阻止表单提交默认事件（表单提交默认事件会刷新页面） |
| requiredMark | bool? | true | 是否显示必填符号（*），默认显示 |
| scrollToFirstError | String? | - | 表单校验不通过时，是否自动滚动到第一个校验不通过的字段，平滑滚动或是瞬间直达。 |
| formShowErrorMessage | bool? | true | 校验不通过时，是否显示错误提示信息，统一控制全部表单项 |
| submitWithWarningMessage | bool? | false | 【讨论中】当校验结果只有告警信息时，是否触发 submit 提交事件 |
| onReset | Function? | - | 表单重置时触发 |
| formController | FormController? | - | 表单控制器 |
| btnGroup | List<Widget>? | - | 表单按钮组 |

```
```
 ### TDFormItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TDFormItemType | - | 表格单元需要使用的组件类型 |
| child | Widget? | - | 表单子组件 |
| formItemNotifier |  | - |  |
| label | String? | - | 表单项标签左侧展示的内容 |
| labelWidget | Widget? | - | 自定义标签 |
| help | String? | - | TDInput 默认显示文字 |
| name | String? | - | 表单字段名称 |
| labelAlign | TextAlign? | - | TODO: item 标签对齐方式 |
| contentAlign | TextAlign? | - | 表单显示内容对齐方式： |
| labelWidth | double? | - | 标签宽度，如果提供则覆盖Form的labelWidth |
| tipAlign | TextAlign? | - | 组件提示内容对齐方式 |
| requiredMark | bool? | true | 是否显示必填标记（*） |
| formRules | List<TDFormValidation>? | - | 整个表单的校验规则 |
| itemRule | List? | - | 表单项验证规则 |
| showErrorMessage | bool | true | 是否显示错误信息 |
| indicator | bool? | - | TDTextarea 的属性，指示器 |
| additionInfo | String? | - | TDInput的辅助信息 |
| select | String | '' | 选择器 适用于日期选择器等 |
| selectFn | Function? | - | 选择器方法 适用于日期选择器等 |
| hintText | null | '' | 提示内容 |
| radios |  | - |  |
| key |  | - |  |


  