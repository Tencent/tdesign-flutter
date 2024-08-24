---
title: Divider 分割线
description: 用于分割、组织、细化有一定逻辑的组织元素内容和页面结构。
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

[td_divider_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_divider_page.dart)

### 1 组件类型

水平分割线
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalDivider(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Container(
        alignment: Alignment.center,
        child: const TDDivider(),
      ),
    );
  }</pre>

</td-code-block>
                                  

带文字水平分割线
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalTextDivider(BuildContext context) {
    return Column(
      children: const [
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.left,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.center,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.right,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

垂直分割
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalTextDivider(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 16,
          ),
          TDText(
            '文字信息',
            textColor: TDTheme.of(context).fontGyColor1.withOpacity(0.9),
          ),
          const TDDivider(
            width: 0.5,
            height: 12,
            margin: EdgeInsets.only(left: 16, right: 16),
          ),
          TDText('文字信息',
              textColor: TDTheme.of(context).fontGyColor1.withOpacity(0.9)),
          const TDDivider(
            width: 0.5,
            height: 12,
            margin: EdgeInsets.only(left: 16, right: 16),
            isDashed: true,
            direction: Axis.vertical,
          ),
          TDText('文字信息',
              textColor: TDTheme.of(context).fontGyColor1.withOpacity(0.9)),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

虚线样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _dashedDivider(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 20,
        ),
        TDDivider(
          isDashed: true,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.left,
          isDashed: true,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.center,
          isDashed: true,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.right,
          isDashed: true,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TDDivider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| color | Color? | - | 线条颜色 |
| margin | EdgeInsetsGeometry? | - | 外部填充 |
| width | double? | - | 宽度，需要竖向线条时使用 |
| height | double? | - | 高度，横向线条使用 |
| text | String? | - | 文本字符串，使用默认样式 |
| textStyle | TextStyle? | - | 自定义文本样式 |
| widget | Widget? | - | 中间控件，可自定义样式 |
| gapPadding | EdgeInsetsGeometry? | - | 线条和中间文本之间的填充 |
| hideLine | bool | false | 隐藏线条，使用纯文本分割 |
| isDashed | bool | false | 是否为虚线 |
| alignment | TextAlignment | TextAlignment.center | 文字位置 |
| direction | Axis | Axis.horizontal | 方向,竖直虚线必须传 |


  