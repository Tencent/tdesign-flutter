---
title: Rate 评分
description: 用于对某行为/事物进行打分。
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

[td_rate_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_rate_page.dart)

### 1 组件类型

实心评分
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFilledRate(BuildContext context) {
    return const TDCell(title: '实心评分', noteWidget: TDRate(value: 3));
  }</pre>

</td-code-block>
                                  

自定义评分
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCusRate(BuildContext context) {
    return const TDCell(title: '自定义评分', noteWidget: TDRate(value: 3, icon: [TDIcons.thumb_up]));
  }</pre>

</td-code-block>
                                  

自定义评分数量
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNumRate(BuildContext context) {
    return const TDCell(
        title: '自定义评分数量',
        noteWidget: TDRate(
          value: 2,
          count: 3,
        ));
  }</pre>

</td-code-block>
                                  

带描述评分
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMsgRate(BuildContext context) {
    return Column(children: const [
      TDCell(title: '带描述评分', noteWidget: TDRate(value: 3, showText: true, texts: ['1分', '2分', '3分', '4分', '5分'])),
      SizedBox(height: 16),
      TDCell(title: '带描述评分', noteWidget: TDRate(value: 3, showText: true))
    ]);
  }</pre>

</td-code-block>
                                  

评分弹框位置
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDRate(BuildContext context) {
    return Column(children: const [
      TDCell(title: '顶部显示', noteWidget: TDRate(placement: PlacementEnum.top)),
      SizedBox(height: 16),
      TDCell(title: '不显示', noteWidget: TDRate(placement: PlacementEnum.none)),
      SizedBox(height: 16),
      TDCell(title: '底部显示', noteWidget: TDRate(placement: PlacementEnum.bottom)),
    ]);
  }</pre>

</td-code-block>
                                  
### 1 组件状态

只可选全星时
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFullRate(BuildContext context) {
    return const TDCell(title: '点击活滑动', noteWidget: TDRate(value: 3));
  }</pre>

</td-code-block>
                                  

可选半星时
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHalfRate(BuildContext context) {
    return const TDCell(title: '点击活滑动', noteWidget: TDRate(value: 3, allowHalf: true, onChange: print,));
  }</pre>

</td-code-block>
                                  
### 1 组件样式

评分大小
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSizeRate(BuildContext context) {
    return Column(children: const [
      TDCell(title: '默认尺寸24', noteWidget: TDRate(value: 3)),
      SizedBox(height: 16),
      TDCell(title: '小尺寸20', noteWidget: TDRate(value: 3, size: 20)),
    ]);
  }</pre>

</td-code-block>
                                  

设置评分颜色
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildColorRate(BuildContext context) {
    return Column(children: const [
      TDCell(
          title: '填充评分',
          noteWidget: TDRate(
            value: 2.5,
            allowHalf: true,
            color: [Color(0xFFFFC51C), Color(0xFFE8E8E8)],
          )),
      SizedBox(height: 16),
      TDCell(title: '线描评分', noteWidget: TDRate(value: 2.5, allowHalf: true, color: [Color(0xFF00A870)])),
    ]);
  }</pre>

</td-code-block>
                                  
### 1 特殊样式

竖向带描述评分
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOtherRate(BuildContext context) {
    var texts = ['非常糟糕', '有些糟糕', '可以尝试', '可以前往', '推荐前往'];
    return Container(
      width: double.infinity,
      child: Center(
        child: TDRate(
        value: 2,
        size: 30,
        showText: true,
        // texts: ['非常糟糕', '有些糟糕', '可以尝试', '可以前往', '推荐前往'],
        direction: Axis.vertical,
        // mainAxisAlignment: MainAxisAlignment.center,
        // textWidth: 64,
        builderText: (context, value) {
          return value == 0
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: TDTheme.of(context).spacer8),
                  child: TDText(
                    texts[(value - 1).toInt()],
                    font: TDTheme.of(context).fontTitleMedium,
                    textColor: TDTheme.of(context).warningColor5,
                  ),
                );
        },
      ),
      ),
      
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
    );
  }</pre>

</td-code-block>
                                  


## API
### TDRate
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| allowHalf | bool? | false | 是否允许半选 |
| color | List<Color>? | - | 评分图标的颜色，示例：[选中颜色] / [选中颜色，未选中颜色]，默认：[TDTheme.of(context).warningColor5, TDTheme.of(context).grayColor4] |
| count | int? | 5 | 评分的数量 |
| disabled | bool? | false | 是否禁用评分 |
| gap | double? | - | 评分图标的间距，默认：TDTheme.of(context).spacer8 |
| icon | List<IconData>? | - | 自定义评分图标，[选中和未选中图标] / [选中图标，未选中图标]，默认：[TDIcons.star_filled] |
| placement | PlacementEnum? | PlacementEnum.top | 选择评分弹框的位置，值为[PlacementEnum.none]表示不显示评分弹框。 |
| showText | bool? | false | 是否显示对应的辅助文字 |
| size | double? | 24.0 | 评分图标的大小 |
| texts | List<String>? | const ['极差', '失望', '一般', '满意', '惊喜'] | 评分等级对应的辅助文字， |
| textWidth | double? | 48.0 | 评分等级对应的辅助文字宽度 |
| builderText | Widget Function(BuildContext context, double value)? | - | 评分等级对应的辅助文字自定义构建，优先级高于[texts] |
| value | double? | 0 | 选择评分的值 |
| onChange | void Function(double value)? | - | 评分数改变时触发 |
| direction | Axis? | Axis.horizontal | 评分图标与辅助文字的布局方向 |
| mainAxisAlignment | MainAxisAlignment? | MainAxisAlignment.start | 评分图标与辅助文字的主轴对齐方式 |
| crossAxisAlignment | CrossAxisAlignment? | CrossAxisAlignment.center | 评分图标与辅助文字的交叉轴对齐方式 |
| mainAxisSize | MainAxisSize? | MainAxisSize.min | 评分图标与辅助文字主轴方向上如何占用空间 |
| iconTextGap | double? | - | 评分图标与辅助文字的间距，默认：[TDTheme.of(context).spacer16] |


  