---
title: Skeleton 骨架屏
description: 当网络较慢时，在页面真实数据加载之前，给用户展示出页面的大致结构。
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

[t_skeleton_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_skeleton_page.dart)

### 1 类型

头像骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAvatarSkeleton(BuildContext context) {
    return TSkeleton(theme: TSkeletonTheme.avatar);
  }</pre>

</td-code-block>


图片骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageSkeleton(BuildContext context) {
    return TSkeleton(theme: TSkeletonTheme.image);
  }</pre>

</td-code-block>


文本骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextSkeleton(BuildContext context) {
    return TSkeleton(theme: TSkeletonTheme.text);
  }</pre>

</td-code-block>


段落骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildParagraphSkeleton(BuildContext context) {
    return TSkeleton(theme: TSkeletonTheme.paragraph);
  }</pre>

</td-code-block>


单元格骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCellSkeleton(BuildContext context) {
    var rowColsAvatar = TSkeleton(theme: TSkeletonTheme.avatar);
    var rowColsImage = TSkeleton.fromRowCol(
      rowCol: TSkeletonRowCol(objects: const [
        [TSkeletonRowColObj.rect(width: 48, height: 48, flex: null)]
      ]),
    );
    var rowColsContent = TSkeleton.fromRowCol(
      rowCol: TSkeletonRowCol(
        objects: const [
          [TSkeletonRowColObj(), TSkeletonRowColObj.spacer(flex: 1)],
          [TSkeletonRowColObj()]
        ],
      ),
    );

    return Column(
      children: [
        Row(
          children: [
            rowColsAvatar,
            const SizedBox(width: 12),
            rowColsContent,
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            rowColsImage,
            const SizedBox(width: 12),
            rowColsContent,
          ],
        ),
      ],
    );
  }</pre>

</td-code-block>


宫格骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildGridSkeleton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 5; i++)
          TSkeleton.fromRowCol(
            rowCol: TSkeletonRowCol(objects: const [
              [TSkeletonRowColObj.rect(width: 48, height: 48, flex: null)],
              [TSkeletonRowColObj.text(width: 48, flex: null)],
            ]),
          ),
      ],
    );
  }</pre>

</td-code-block>


图文组合骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCombineSkeleton(BuildContext context) {
    var rowCols = Flexible(
        child: LayoutBuilder(
            builder: (context, constraints) => Row(children: [
                  TSkeleton.fromRowCol(
                    rowCol: TSkeletonRowCol(
                      objects: [
                        [
                          TSkeletonRowColObj(
                              width: constraints.maxWidth*0.96,
                              height: constraints.maxWidth,
                              flex: null,
                              style: TSkeletonRowColObjStyle(
                                  borderRadius: (context) =>
                                      TTheme.of(context).radiusExtraLarge))
                        ],
                        [TSkeletonRowColObj.text(
                          width: constraints.maxWidth*0.96,
                        )],
                        const [
                          TSkeletonRowColObj.text(),
                          TSkeletonRowColObj.spacer(flex: 1),
                        ],
                      ],
                    ),
                  )
                ])));

    return Row(
      children: [
        rowCols,
        SizedBox(width: TTheme.of(context).spacer4),
        rowCols,
      ],
    );
  }</pre>

</td-code-block>

### 1 组件动效

渐变加载效果

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildGradientSkeleton(BuildContext context) {
    return TSkeleton(
      animation: TSkeletonAnimation.gradient,
      theme: TSkeletonTheme.paragraph,
    );
  }</pre>

</td-code-block>


闪烁加载效果

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFlashedSkeleton(BuildContext context) {
    return TSkeleton(
      animation: TSkeletonAnimation.flashed,
      theme: TSkeletonTheme.paragraph,
    );
  }</pre>

</td-code-block>



## API
### TSkeleton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| animation | TSkeletonAnimation? | null | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| theme | TSkeletonTheme | TSkeletonTheme.text | 风格 |


#### 命名构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| animation | TSkeletonAnimation? | null | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| rowCol | TSkeletonRowCol | - | 自定义行列数量、宽度高度、间距等 |

```
```
### TSkeletonRowColStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowSpacing | double Function(BuildContext) | (context) => TTheme.of(context).spacer16 | 行间距 |

```
```
### TSkeletonRowCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| objects | List<List<TSkeletonRowColObj>> | - | 行列对象 |
| style | TSkeletonRowColStyle | TSkeletonRowColStyle() | 样式 |

```
```
### TSkeletonRowColObjStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | double Function(BuildContext) | (context) => TTheme.of(context).grayColor1 | 背景颜色 |
| borderRadius | double Function(BuildContext) | (context) => TTheme.of(context).radiusSmall | 圆角 |


#### 工厂构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | double Function(BuildContext) | (context) => TTheme.of(context).grayColor1 | 背景颜色 |

```
```
### TSkeletonRowColObj
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | null | 宽度 |
| height | double? | 16 | 高度 |
| flex | int? | 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TSkeletonRowColObjStyle | TSkeletonRowColObjStyle() | 样式 |


#### 工厂构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | 48 / null | 宽度 |
| height | double? | 48 / 16 / null | 高度 |
| flex | int? | null / 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TSkeletonRowColObjStyle | TSkeletonRowColObjStyle.circle() / TSkeletonRowColObjStyle.rect() / TSkeletonRowColObjStyle.text() / TSkeletonRowColObjStyle.spacer() | 样式 |

  
