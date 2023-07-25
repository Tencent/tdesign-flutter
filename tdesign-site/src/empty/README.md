---
title: Empty 空状态
description: 用于空状态时的占位提示。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/td_export.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/td_export.dart';
```

## 代码演示

### 1 组件类型

图标空状态
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconEmpty(BuildContext context) {
    return const TDEmpty(
      type: TDEmptyType.plain,
      emptyText: '描述文字',
    );
  }</pre>

</td-code-block>
                                        

自定义图片空状态
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _imageEmpty(BuildContext context) {
    return TDEmpty(
      type: TDEmptyType.plain,
      emptyText: '描述文字',
      image: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TDTheme.of(context).radiusDefault),
          image: const DecorationImage(image: AssetImage('assets/img/empty.png'))
        ),
      ),
    );
  }</pre>

</td-code-block>
                                        

带操作空状态
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _operationEmpty(BuildContext context) {
    return const TDEmpty(
      type: TDEmptyType.operation,
      operationText: '操作按钮',
      emptyText: '描述文字',
    );
  }</pre>

</td-code-block>
                                        


## API
### TDEmpty
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TDEmptyType | TDEmptyType.plain | 类型，为operation有操作按钮，plain无按钮 |
| image | Widget? | - | 展示图片 |
| emptyText | String? | - | 描述文字 |
| operationText | String? | - | 操作按钮文案 |
| onTapEvent | TDTapEvent? | - | 点击事件 |
| key |  | - |  |


  