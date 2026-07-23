---
title: Button 按钮 (V1.0)
description: 用于开启一个闭环的操作任务，如"删除"对象、"购买"商品等。
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

[td_button_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_button_page.dart)

### 1 组件类型

基础按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  @Demo(group: 'button')
  TButton _buildPrimaryFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.light,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TButton(
      child: Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryTextButton(BuildContext context) {
    return const TButton(
      child: Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

图标按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildRectangleIconButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      icon: Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildSquareIconButton(BuildContext context) {
    return const TButton(
      icon: Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLoadingIconButton(BuildContext context) {
    return TButton(
      child: const Text('加载中'),
      icon: TLoading(
        size: TLoadingSize.small,
        icon: TLoadingIcon.circle,
        iconColor: TTheme.of(context).whiteColor1,
      ),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

幽灵按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryGhostButton(BuildContext context) {
    return const TButton(
      child: Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerGhostButton(BuildContext context) {
    return const TButton(
      child: Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.danger,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultGhostButton(BuildContext context) {
    return const TButton(
      child: Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

组合按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCombinationButtons(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TButton(
                child: Text('填充按钮'),
                size: TButtonSize.large,
                variant: TButtonVariant.fill,
                colorScheme: TButtonColorScheme.light,
                onPressed: null,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TButton(
                child: Text('填充按钮'),
                size: TButtonSize.large,
                variant: TButtonVariant.fill,
                colorScheme: TButtonColorScheme.primary,
                onPressed: null,
              ),
            ),
          ],
        ));
  }</pre>

</td-code-block>
                

通栏按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBlockFillButton(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: TButton(
        child: Text('填充按钮'),
        icon: Icon(TIcons.app),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: null,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

按钮禁用状态

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisableLightFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.light,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisableDefaultFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const TButton(
      child: Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const TButton(
      child: Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                
### 1 组件主题

按钮尺寸

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLargeButton(BuildContext context) {
    return const TButton(
      child: Text('按钮48'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildMediumButton(BuildContext context) {
    return const TButton(
      child: Text('按钮40'),
      size: TButtonSize.medium,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildSmallButton(BuildContext context) {
    return const TButton(
      child: Text('按钮32'),
      size: TButtonSize.small,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildExtraSmallButton(BuildContext context) {
    return const TButton(
      child: Text('按钮28'),
      size: TButtonSize.extraSmall,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

按钮形状

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  @Demo(group: 'button')
  TButton _buildPrimaryFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildSquareIconButton(BuildContext context) {
    return const TButton(
      icon: Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildRoundButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildCircleButton(BuildContext context) {
    return const TButton(
      icon: Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildFilledButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

按钮主题

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultStrokeButton(BuildContext context) {
    return const TButton(
      child: Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultTextButton(BuildContext context) {
    return const TButton(
      child: Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  @Demo(group: 'button')
  TButton _buildPrimaryFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TButton(
      child: Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryTextButton(BuildContext context) {
    return const TButton(
      child: Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.danger,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerStrokeButton(BuildContext context) {
    return const TButton(
      child: Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.danger,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerTextButton(BuildContext context) {
    return const TButton(
      child: Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.danger,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.light,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightStrokeButton(BuildContext context) {
    return const TButton(
      child: Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.light,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightTextButton(BuildContext context) {
    return const TButton(
      child: Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.light,
      onPressed: null,
    );
  }</pre>

</td-code-block>
                


## API
### TButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 内容（纯文案用 `Text('...')`） |
| colorScheme | TButtonColorScheme? | - | 配色方案，未传时使用 Theme 默认解析 |
| icon | Widget? | - | 图标（Widget 类型，IconData 需包裹为 `Icon(...)`） |
| iconPosition | TButtonIconPosition | TButtonIconPosition.left | 图标位置 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调，`null` 表示禁用 |
| size | TButtonSize | TButtonSize.medium | 尺寸，未传时使用 Theme `TButtonThemeData.defaultSize` |
| style | ButtonStyle? | - | P0 逃逸舱：`ButtonStyle` 覆盖所有 resolve 结果 |
| variant | TButtonVariant? | - | 变体（fill / outline / text / ghost），未传时使用 Theme `TButtonThemeData.defaultVariant` |


### TButtonThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultSize | TButtonSize | TButtonSize.medium | 未传 `TButton.size` 时的默认尺寸 |
| defaultVariant | TButtonVariant | TButtonVariant.fill | 未传 `TButton.variant` 时的默认变体 |
| filledStyle | ButtonStyle? | - | P2 色板：fill 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| ghostStyle | ButtonStyle? | - | P2 色板：ghost 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| gradient | Gradient? | - | 渐变背景色（装饰层，非 ButtonStyle 字段） |
| iconSpacing | double? | - | 图标与文案之间的间距 |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| outlinedStyle | ButtonStyle? | - | P2 色板：outline 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| padding | EdgeInsetsGeometry? | - | 覆盖默认 padding（null 时由 resolve 按 size/shape 推导） |
| shape | TButtonShape? | - | 外形，会展开进 resolves `ButtonStyle.shape` |
| textButtonStyle | ButtonStyle? | - | P2 色板：text 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| textStyle | TextStyle? | - | 默认文案样式 |


### TButtonResolve

#### 静态方法

##### TButtonResolve.resolve

解析最终的 `ButtonStyle`

返回类型：`ButtonStyle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TButtonVariant | - | - |
| colorScheme | TButtonColorScheme? | - | - |
| size | TButtonSize | - | - |
| icon | Widget? | - | - |
| iconPosition | TButtonIconPosition | - | - |
| theme | TButtonThemeData? | - | - |
| instanceStyle | ButtonStyle? | - | - |
| context | BuildContext | - | - |


### TButtonShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| rectangle | - |
| round | - |
| square | - |
| circle | - |
| filled | - |


### TButtonSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| medium | - |
| small | - |
| extraSmall | - |


### TButtonVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| fill | - |
| outline | - |
| text | - |
| ghost | - |


### TButtonColorScheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | - |
| primary | - |
| danger | - |
| light | - |


### TButtonIconPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | - |
| right | - |


  