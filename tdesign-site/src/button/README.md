---
title: Button 按钮
description: 用于开启一个闭环的操作任务，如“删除”对象、“购买”商品等。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在 `tdesign_flutter/tdesign_flutter.dart` 中有所有组件的路径。

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
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

图标按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildRectangleIconButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildSquareIconButton(BuildContext context) {
    return const TButton(
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.square,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLoadingIconButton(BuildContext context) {
    return TButton(
      text: '加载中',
      iconWidget: TLoading(
        size: TLoadingSize.small,
        icon: TLoadingIcon.circle,
        iconColor: TTheme.of(context).whiteColor1,
      ),
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

幽灵按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryGhostButton(BuildContext context) {
    return const TButton(
      text: '幽灵按钮',
      size: TButtonSize.large,
      type: TButtonType.ghost,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerGhostButton(BuildContext context) {
    return const TButton(
      text: '幽灵按钮',
      size: TButtonSize.large,
      type: TButtonType.ghost,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultGhostButton(BuildContext context) {
    return const TButton(
      text: '幽灵按钮',
      size: TButtonSize.large,
      type: TButtonType.ghost,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
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
          // spacing: 16,
          children: [
            Expanded(
              child: TButton(
                text: '填充按钮',
                size: TButtonSize.large,
                type: TButtonType.fill,
                shape: TButtonShape.rectangle,
                theme: TButtonTheme.light,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TButton(
                text: '填充按钮',
                size: TButtonSize.large,
                type: TButtonType.fill,
                shape: TButtonShape.rectangle,
                theme: TButtonTheme.primary,
              ),
            ),
          ],
        ));
  }</pre>

</td-code-block>
                

通栏按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildFilledFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      theme: TButtonTheme.primary,
      isBlock: true,
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

按钮禁用状态

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisableLightFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisableDefaultFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
      disabled: true,
    );
  }</pre>

</td-code-block>
                
### 1 组件主题

按钮尺寸

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLargeButton(BuildContext context) {
    return const TButton(
      text: '按钮48',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildMediumButton(BuildContext context) {
    return const TButton(
      text: '按钮40',
      size: TButtonSize.medium,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildSmallButton(BuildContext context) {
    return const TButton(
      text: '按钮32',
      size: TButtonSize.small,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildExtraSmallButton(BuildContext context) {
    return const TButton(
      text: '按钮28',
      size: TButtonSize.extraSmall,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

按钮形状

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  @Demo(group: 'button')
  TButton _buildPrimaryFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildSquareIconButton(BuildContext context) {
    return const TButton(
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.square,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildRoundButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.round,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildCircleButton(BuildContext context) {
    return const TButton(
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.circle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildFilledButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.filled,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

按钮主题

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDefaultTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  @Demo(group: 'button')
  TButton _buildPrimaryFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildPrimaryTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildDangerTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TButton _buildLightTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
    );
  }</pre>

</td-code-block>
                


## API
### TButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeStyle | TButtonStyle? | - | 自定义点击样式，有则优先用它，没有则根据 type 和 theme 选取 |
| child | Widget? | - | 自控件 |
| disabled | bool | false | 禁止点击 |
| disableStyle | TButtonStyle? | - | 自定义禁用样式，有则优先用它，没有则根据 type 和 theme 选取 |
| disableTextStyle | TextStyle? | - | 自定义不可点击状态文本样式 |
| gradient | Gradient? | - | 渐变背景色，优先级高于backgroundColor |
| height | double? | - | 自定义高度 |
| icon | IconData? | - | 图标icon |
| iconPosition | TButtonIconPosition? | TButtonIconPosition.left | 图标位置 |
| iconTextSpacing | double? | - | 自定义图标与文本之间距离 |
| iconWidget | Widget? | - | 自定义图标 icon 控件 |
| isBlock | bool | false | 是否为通栏按钮 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| margin | EdgeInsetsGeometry? | - | 自定义 margin |
| onLongPress | TButtonEvent? | - | 长按事件 |
| onTap | TButtonEvent? | - | 点击事件 |
| padding | EdgeInsetsGeometry? | - | 自定义 padding |
| shape | TButtonShape | TButtonShape.rectangle | 形状：圆角，胶囊，方形，圆形，填充 |
| size | TButtonSize | TButtonSize.medium | 尺寸 |
| style | TButtonStyle? | - | 自定义样式，有则优先用它，没有则根据 type 和 theme 选取。如果设置了 style，则 activeStyle 和 disableStyle 也应该设置 |
| text | String? | - | 文本内容 |
| textStyle | TextStyle? | - | 自定义可点击状态文本样式 |
| theme | TButtonTheme? | - | 主题 |
| type | TButtonType | TButtonType.fill | 类型：填充，描边，文字 |
| width | double? | - | 自定义宽度 |


### TButtonStyle

#### 工厂构造方法

##### TButtonStyle.generateFillStyleByTheme

生成不同主题的填充按钮样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| theme | TButtonTheme? | - | - |
| status | TButtonStatus | - | - |


##### TButtonStyle.generateGhostStyleByTheme

生成不同主题的幽灵按钮样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| theme | TButtonTheme? | - | - |
| status | TButtonStatus | - | - |


##### TButtonStyle.generateOutlineStyleByTheme

生成不同主题的描边按钮样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| theme | TButtonTheme? | - | - |
| status | TButtonStatus | - | - |


##### TButtonStyle.generateTextStyleByTheme

生成不同主题的文本按钮样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| theme | TButtonTheme? | - | - |
| status | TButtonStatus | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| frameColor | Color? | - | 边框颜色 |
| frameWidth | double? | - | 边框宽度 |
| gradient | Gradient? | - | 渐变背景色 |
| radius | BorderRadiusGeometry? | - | 自定义圆角 |
| textColor | Color? | - | 文字颜色 |


### TButtonSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| medium | - |
| small | - |
| extraSmall | - |


### TButtonType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| fill | - |
| outline | - |
| text | - |
| ghost | - |


### TButtonShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| rectangle | - |
| round | - |
| square | - |
| circle | - |
| filled | - |


### TButtonTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | - |
| primary | - |
| danger | - |
| light | - |


### TButtonStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultState | - |
| active | - |
| disable | - |


### TButtonIconPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | - |
| right | - |


### TButtonEvent
#### 类型定义

```dart
typedef TButtonEvent = void Function();
```


  