---
title: Cascader 级联选择器
description: 用于多层级数据的逐级选择
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

[td_cascader_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_cascader_page.dart)

### 1 组件类型

垂直级联选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择地址', data: _data, initialData: _initData, theme: 'step',
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
  }</pre>

</td-code-block>
                                  

垂直级联选择器-带字母定位
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalLetterCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择地址', data: _data_2, initialData: _initData_2, theme: 'step',
            onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_2 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_2 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_2, '选择地区'),
    );
  }</pre>

</td-code-block>
                                  

水平级联选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHorizontalCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context,
            title: '选择地址',
            subTitles: ['请选择省份', '请选择城市', '请选择区/县'],
            data: _data,
            initialData: _initData,
            theme: 'tab', onChange: (List<MultiCascaderListModel> selectData) {
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
  }</pre>

</td-code-block>
                                  

水平级联选择器-带字母定位
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHorizontalLetterCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context,
            title: '选择地址',
            data: _data_2,
            initialData: _initData_2,
            isLetterSort: true,
            theme: 'tab', onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_2 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_2 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_2, '选择地区'),
    );
  }</pre>

</td-code-block>
                                  

水平级联选择器-部门
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHorizontalCompanyCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择部门人员', data: _data_3,isLetterSort: true, initialData: _initData_3, theme: 'tab',
            onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_3 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_3 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_3, '选择部门人员'),
    );
  }</pre>

</td-code-block>
                                  

垂直级联选择器-部门
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalCompanyCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择部门人员', data: _data_3,isLetterSort: true, initialData: _initData_3, theme: 'step',
            onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_3 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_3 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_3, '选择部门人员'),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDMultiCascader
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| title | String? | - | 选择器标题 |
| titleStyle | TextStyle? | - | 标题样式 |
| theme | String? | - | 展示风格 可选项：step/tab |
| subTitles | List<String>? | - | 每级展示的次标题 |
| data | List<Map> | - | 选择器的数据源 |
| cascaderHeight | double | - | 选择器List的视窗高度，默认200 |
| initialIndexes | List<int>? | - | 若为null表示全部从零开始 |
| initialData | String? | - | 初始化数据 |
| backgroundColor | Color? | - | 背景颜色 |
| topRadius | double? | - | 顶部圆角 |
| closeText | String? | - | 关闭按钮文本 |
| isLetterSort | bool | false | 是否开启字母排序 |
| onClose | Function? | - | 选择器关闭按钮回调 |
| onChange | MultiCascaderCallback | - | 值发生变更时触发 |


  