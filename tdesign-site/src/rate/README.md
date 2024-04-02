---
title: 评分
description:
spline: other
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

### 1 组件类型

实心评分

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFilledRate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
              variant: Variant.filled,
              defaultValue: 2,
              onChange: (value) {
                print('value: $value');
              })
        ],
      ),
    );
  }</pre>

</td-code-block>


自定义评分图标

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomRateWithIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
            allowHalf: false,
            onChange: (value) {
              print('value: $value');
            },
            filledIcon: Icons.thumb_up,
            outlineIcon: Icons.thumb_up_off_alt_outlined,
            count: 5,
            size: 20,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>


自定义评分数量

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomRateWithCount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
            allowHalf: false,
            onChange: (value) {
              print('value: $value');
            },
            filledIcon: Icons.star,
            outlineIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            halfOutlineIcon: Icons.star_half,
            count: 3,
            texts: const ['差', '一般', '好'],
            size: 20,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
</pre>

</td-code-block>


带描述评分

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomRateWithText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
            allowHalf: false,
            variant: Variant.filled,
            onChange: (value) {
              print('value: $value');
            },
            showText: true,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>

### 1 组件状态

禁用评分

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
   Widget _buildDisabledRate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('无法点击评分'),
          TDRate(
            allowHalf: false,
            onChange: (value) {
            },
            filledIcon: Icons.star,
            outlineIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            halfOutlineIcon: Icons.star_half,
            count: 5,
            size: 30,
            defaultValue: 3.5,
            color: Colors.orange,
            disabled: true,
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>


评分支持半星

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHalfRateStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('评分带半星'),
          const SizedBox(width: 8),
          TDRate(
            allowHalf: true,
            variant: Variant.filled,
            onChange: (value) {
              print('value: $value');
            },
            size: 20,
            defaultValue: 3.5,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
</pre>

</td-code-block>


评分支持size

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSizeRateStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('评分支持size'),
          const SizedBox(width: 8),
          TDRate(
            allowHalf: false,
            onChange: (value) {
              print('value: $value');
            },
            size: 30,
            defaultValue: 3.5,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
</pre>

</td-code-block>



## API
### rate

<!-- final bool allowHalf;
  final dynamic color;
  final int count;
  final bool disabled;
  final double gap;
  final bool showText;
  final double size;
  final List<String> texts;
  final double defaultValue;
  final Variant variant;
  final OnChange onChange;
  final IconData filledIcon;
  final IconData outlineIcon;
  final IconData halfFilledIcon;
  final IconData halfOutlineIcon; -->

| 参数 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| count | 图标总数 | int | 5 |
| defaultValue | 当前分值 | double | 0 |
| allowHalf | 是否允许半星 | bool | false |
| disabled | 是否禁用 | bool | false |
| showText | 是否显示描述 | bool | false |
| size | 图标大小 | double | 20 |
| color | 图标颜色 | Color | Colors.orange |
| filledIcon | 选中图标 | IconData | Icons.star |
| outlineIcon | 未选中图标 | IconData | Icons.star_border |
| halfFilledIcon | 选中半星图标 | IconData | Icons.star_half |
| halfOutlineIcon | 未选中半星图标 | IconData | Icons.star_half |
| texts | 图标描述 | List<String> | ['极差', '失望', '一般', '满意', '惊喜'] |
| onChange | 评分变化回调 | OnChange | - |





