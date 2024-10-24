---
title: Button 按钮
description: 用于开启一个闭环的操作任务，如“删除”对象、“购买”商品等。
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
  TDButton _buildPrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildLightFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDefaultFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildPrimaryTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

图标按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildRectangleIconButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildSquareIconButton(BuildContext context) {
    return const TDButton(
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.square,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildLoadingIconButton(BuildContext context) {
    return TDButton(
      text: '加载中',
      iconWidget: TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        iconColor: TDTheme.of(context).whiteColor1,
      ),
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

幽灵按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildPrimaryGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDangerGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDefaultGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

组合按钮

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCombinationButtons(BuildContext context) {
    return Row(
      children: const [
        SizedBox(
          width: 16,
        ),
        Expanded(
            child: TDButton(
          text: '填充按钮',
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.light,
        )),
        SizedBox(
          width: 16,
        ),
        Expanded(
            child: TDButton(
          text: '填充按钮',
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.primary,
        )),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }</pre>

</td-code-block>
                

通栏按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildFilledFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      theme: TDButtonTheme.primary,
      isBlock: true,
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

按钮禁用状态

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDisableLightFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDisableDefaultFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }</pre>

</td-code-block>
                
### 1 组件主题

按钮尺寸

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildLargeButton(BuildContext context) {
    return const TDButton(
      text: '按钮48',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildMediumButton(BuildContext context) {
    return const TDButton(
      text: '按钮40',
      size: TDButtonSize.medium,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildSmallButton(BuildContext context) {
    return const TDButton(
      text: '按钮32',
      size: TDButtonSize.small,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildExtraSmallButton(BuildContext context) {
    return const TDButton(
      text: '按钮28',
      size: TDButtonSize.extraSmall,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

按钮形状

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  @Demo(group: 'button')
  TDButton _buildPrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildSquareIconButton(BuildContext context) {
    return const TDButton(
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.square,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildRoundButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.round,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildCircleButton(BuildContext context) {
    return const TDButton(
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.circle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildFilledButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.filled,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

按钮主题

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDefaultFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDefaultStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDefaultTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  @Demo(group: 'button')
  TDButton _buildPrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildPrimaryTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDangerFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDangerStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildDangerTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildLightFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildLightStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDButton _buildLightTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }</pre>

</td-code-block>
                


## API
### TDButtonStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| frameColor | Color? | - | 边框颜色 |
| textColor | Color? | - | 文字颜色 |
| frameWidth | double? | - | 边框宽度 |
| radius | BorderRadiusGeometry? | - | 自定义圆角 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDButtonStyle.generateFillStyleByTheme  | 生成不同主题的填充按钮样式 |
| TDButtonStyle.generateOutlineStyleByTheme  | 生成不同主题的描边按钮样式 |
| TDButtonStyle.generateTextStyleByTheme  | 生成不同主题的文本按钮样式 |
| TDButtonStyle.generateGhostStyleByTheme  | 生成不同主题的幽灵按钮样式 |

```
```
 ### TDButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| text | String? | - | 文本内容 |
| size | TDButtonSize | TDButtonSize.medium | 尺寸 |
| type | TDButtonType | TDButtonType.fill | 类型：填充，描边，文字 |
| shape | TDButtonShape | TDButtonShape.rectangle | 形状：圆角，胶囊，方形，圆形，填充 |
| theme | TDButtonTheme? | - | 主题 |
| child | Widget? | - | 自控件 |
| disabled | bool | false | 禁止点击 |
| isBlock | bool | false | 是否为通栏按钮 |
| style | TDButtonStyle? | - | 自定义样式，有则优先用它，没有则根据type和theme选取.如果设置了style,则activeStyle和disableStyle也应该设置 |
| activeStyle | TDButtonStyle? | - | 自定义点击样式，有则优先用它，没有则根据type和theme选取 |
| disableStyle | TDButtonStyle? | - | 自定义禁用样式，有则优先用它，没有则根据type和theme选取 |
| textStyle | TextStyle? | - | 自定义可点击状态文本样式 |
| disableTextStyle | TextStyle? | - | 自定义不可点击状态文本样式 |
| width | double? | - | 自定义宽度 |
| height | double? | - | 自定义高度 |
| onTap | TDButtonEvent? | - | 点击事件 |
| icon | IconData? | - | 图标icon |
| iconWidget | Widget? | - | 自定义图标icon控件 |
| iconTextSpacing | double? | - | 自定义图标与文本之间距离 |
| onLongPress | TDButtonEvent? | - | 长按事件 |
| margin | EdgeInsetsGeometry? | - | 自定义margin |
| padding | EdgeInsetsGeometry? | - | 自定义padding |


  