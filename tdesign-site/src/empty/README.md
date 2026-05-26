---
title: Empty 空状态
description: 用于空状态时的占位提示。
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

[td_empty_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_empty_page.dart)

### 1 组件类型

图标空状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconEmpty(BuildContext context) {
    return const TEmpty(
      type: TEmptyType.plain,
      emptyText: '描述文字',
    );
  }</pre>

</td-code-block>
                                  

自定义图标空状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconEmptyCustom(BuildContext context) {
    return const TEmpty(
      type: TEmptyType.plain,
      icon: Icons.hourglass_empty_sharp,
      emptyText: '描述文字',
    );
  }</pre>

</td-code-block>
                                  

自定义图片空状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _imageEmpty(BuildContext context) {
    return TEmpty(
      type: TEmptyType.plain,
      emptyText: '描述文字',
      image: Container(
        decoration: BoxDecoration(
          color: TTheme.of(context).bgColorComponent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const TImage(
          width: 120,
          assetUrl: 'assets/img/empty.png',
          type: TImageType.fitWidth,
        ),
      ),
    );
  }</pre>

</td-code-block>
                                  

带操作空状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _operationEmpty(BuildContext context) {
    return const TEmpty(
      type: TEmptyType.operation,
      operationText: '操作按钮',
      emptyText: '描述文字',
    );
  }</pre>

</td-code-block>
                                  

自定义带操作空状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _operationCustomEmpty(BuildContext context) {
    return TEmpty(
      type: TEmptyType.operation,
      emptyText: '描述文字',
      customOperationWidget: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: TButton(
          text: '自定义操作按钮',
          size: TButtonSize.medium,
          theme: TButtonTheme.danger,
          width: 160,
          onTap: () {},
        ),
      ),
    );
  }</pre>

</td-code-block>
                                  


## API
### TEmpty
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| customOperationWidget | Widget? | - | 自定义操作按钮 |
| emptyText | String? | - | 描述文字 |
| emptyTextColor | Color? | - | 描述文字颜色 |
| emptyTextFont | Font? | - | 描述文字大小 |
| icon | IconData? | TIcons.info_circle_filled | 图标 |
| image | Widget? | - | 展示图片 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTapEvent | TTapEvent? | - | 点击事件 |
| operationText | String? | - | 操作按钮文案 |
| operationTheme | TButtonTheme? | - | 操作按钮文案主题色 |
| type | TEmptyType | TEmptyType.plain | 类型，为operation有操作按钮，plain无按钮 |


### TEmptyType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| plain | - |
| operation | - |


### TTapEvent
#### 类型定义

```dart
typedef TTapEvent = void Function();
```


  