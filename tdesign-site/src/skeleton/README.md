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

[td_skeleton_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_skeleton_page.dart)

### 1 类型

头像骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAvatarSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.avatar);
  }</pre>

</td-code-block>


图片骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.image);
  }</pre>

</td-code-block>


文本骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.text);
  }</pre>

</td-code-block>


段落骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildParagraphSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.paragraph);
  }</pre>

</td-code-block>


单元格骨架屏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCellSkeleton(BuildContext context) {
    var rowColsAvatar = TDSkeleton(theme: TDSkeletonTheme.avatar);
    var rowColsImage = TDSkeleton.fromRowCol(
      rowCol: TDSkeletonRowCol(objects: const [
        [TDSkeletonRowColObj.rect(width: 48, height: 48, flex: null)]
      ]),
    );
    var rowColsContent = TDSkeleton.fromRowCol(
      rowCol: TDSkeletonRowCol(
        objects: const [
          [TDSkeletonRowColObj(), TDSkeletonRowColObj.spacer(flex: 1)],
          [TDSkeletonRowColObj()]
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
          TDSkeleton.fromRowCol(
            rowCol: TDSkeletonRowCol(objects: const [
              [TDSkeletonRowColObj.rect(width: 48, height: 48, flex: null)],
              [TDSkeletonRowColObj.text(width: 48, flex: null)],
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
                  TDSkeleton.fromRowCol(
                    rowCol: TDSkeletonRowCol(
                      objects: [
                        [
                          TDSkeletonRowColObj(
                              width: constraints.maxWidth*0.96,
                              height: constraints.maxWidth,
                              flex: null,
                              style: TDSkeletonRowColObjStyle(
                                  borderRadius: (context) =>
                                      TDTheme.of(context).radiusExtraLarge))
                        ],
                        [TDSkeletonRowColObj.text(
                          width: constraints.maxWidth*0.96,
                        )],
                        const [
                          TDSkeletonRowColObj.text(),
                          TDSkeletonRowColObj.spacer(flex: 1),
                        ],
                      ],
                    ),
                  )
                ])));

    return Row(
      children: [
        rowCols,
        SizedBox(width: TDTheme.of(context).spacer4),
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
    return TDSkeleton(
      animation: TDSkeletonAnimation.gradient,
      theme: TDSkeletonTheme.paragraph,
    );
  }</pre>

</td-code-block>


闪烁加载效果

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFlashedSkeleton(BuildContext context) {
    return TDSkeleton(
      animation: TDSkeletonAnimation.flashed,
      theme: TDSkeletonTheme.paragraph,
    );
  }</pre>

</td-code-block>



## API
### TDSkeleton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| animation | TDSkeletonAnimation? | null | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| theme | TDSkeletonTheme | TDSkeletonTheme.text | 风格 |


#### 命名构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| animation | TDSkeletonAnimation? | null | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| rowCol | TDSkeletonRowCol | - | 自定义行列数量、宽度高度、间距等 |

```
```
### TDSkeletonRowColStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowSpacing | double Function(BuildContext) | (context) => TDTheme.of(context).spacer16 | 行间距 |

```
```
### TDSkeletonRowCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| objects | List<List<TDSkeletonRowColObj>> | - | 行列对象 |
| style | TDSkeletonRowColStyle | TDSkeletonRowColStyle() | 样式 |

```
```
### TDSkeletonRowColObjStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | double Function(BuildContext) | (context) => TDTheme.of(context).grayColor1 | 背景颜色 |
| borderRadius | double Function(BuildContext) | (context) => TDTheme.of(context).radiusSmall | 圆角 |


#### 工厂构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | double Function(BuildContext) | (context) => TDTheme.of(context).grayColor1 | 背景颜色 |

```
```
### TDSkeletonRowColObj
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | null | 宽度 |
| height | double? | 16 | 高度 |
| flex | int? | 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TDSkeletonRowColObjStyle | TDSkeletonRowColObjStyle() | 样式 |


#### 工厂构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | 48 / null | 宽度 |
| height | double? | 48 / 16 / null | 高度 |
| flex | int? | null / 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TDSkeletonRowColObjStyle | TDSkeletonRowColObjStyle.circle() / TDSkeletonRowColObjStyle.rect() / TDSkeletonRowColObjStyle.text() / TDSkeletonRowColObjStyle.spacer() | 样式 |

  
