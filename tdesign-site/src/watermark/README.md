---
title: Watermark 水印
description: 
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

[td_watermark_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_watermark_page.dart)

### 1 基础用法

单行文本水印:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSingleLine(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: 'TDesign Flutter',
        type: TWatermarkType.singleLine,
      ),
    );
  }</pre>

</td-code-block>
                                  

多行文本水印:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMultiLine(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: 'TDesign\nFlutter',
        type: TWatermarkType.multiLine,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 排列方式

水平排列:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHorizontalLayout(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '内部资料',
        layout: TWatermarkLayout.horizontal,
        gapX: 150,
      ),
    );
  }</pre>

</td-code-block>
                                  

垂直排列:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalLayout(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '机密',
        layout: TWatermarkLayout.vertical,
        gapY: 80,
      ),
    );
  }</pre>

</td-code-block>
                                  

网格排列:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildGridLayout(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: 'TDesign',
        layout: TWatermarkLayout.grid,
        gapX: 120,
        gapY: 80,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 自定义样式

自定义颜色和透明度:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomColor(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '保密文档',
        textColor: TTheme.of(context).errorNormalColor,
        opacity: 0.2,
      ),
    );
  }</pre>

</td-code-block>
                                  

自定义字体大小:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomSize(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '大字体水印',
        textSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }</pre>

</td-code-block>
                                  

自定义旋转角度:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomRotate(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '旋转45度',
        rotate: -45,
        gapX: 150,
        gapY: 100,
      ),
    );
  }</pre>

</td-code-block>
                                  

自定义间距:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomGap(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '密集',
        gapX: 60,
        gapY: 40,
        textSize: 12,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 带内容的水印

图片上的水印:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageWatermark(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '仅供查看',
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: TTheme.of(context).brandFocusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              TIcons.image,
              size: 80,
              color: TTheme.of(context).brandNormalColor,
            ),
          ),
        ),
      ),
    );
  }</pre>

</td-code-block>
                                  

列表上的水印:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildListWatermark(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '内部数据',
        opacity: 0.1,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TTheme.of(context).componentStrokeColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: TTheme.of(context).brandLightColor,
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TText(
                          '列表项 ${index + 1}',
                          font: TTheme.of(context).fontBodyMedium,
                        ),
                        const SizedBox(height: 4),
                        TText(
                          '这是第 ${index + 1} 条数据的描述信息',
                          font: TTheme.of(context).fontBodySmall,
                          textColor: TTheme.of(context).textColorSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }</pre>

</td-code-block>
                                  

表单上的水印:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFormWatermark(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '草稿',
        opacity: 0.08,
        textSize: 48,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TInput(
                leftLabel: '姓名',
                hintText: '请输入姓名',
              ),
              const SizedBox(height: 16),
              TInput(
                leftLabel: '邮箱',
                hintText: '请输入邮箱',
              ),
              const SizedBox(height: 16),
              TInput(
                leftLabel: '电话',
                hintText: '请输入电话号码',
              ),
              const SizedBox(height: 16),
              TButton(
                text: '提交',
                theme: TButtonTheme.primary,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }</pre>

</td-code-block>
                                  


## API

暂无对应api


  