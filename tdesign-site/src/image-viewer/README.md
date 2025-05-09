---
title: ImageViewer 图片预览
description: 用于图片内容的缩略展示与查看。
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

[td_image_viewer_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_image_viewer_page.dart)

### 1 组件类型

基础图片预览
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicImageViewer(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '基础图片预览',
      onTap: () {
        TDImageViewer.showImageViewer(context: context, images: images);
      },
    );
  }</pre>

</td-code-block>
                                  

带操作图片预览
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _actionImageViewer(BuildContext context) {
    var delImages = [
      'https://tdesign.gtimg.com/mobile/demos/swiper1.png',
      'https://tdesign.gtimg.com/mobile/demos/swiper2.png',
    ];
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '带操作图片预览',
      onTap: () {
        TDImageViewer.showImageViewer(
          context: context,
          images: delImages,
          showIndex: true,
          deleteBtn: true,
        );
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDImageViewerWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| closeBtn | bool? | - | 是否展示关闭按钮 |
| deleteBtn | bool? | - | 是否显示删除操作 |
| images | List<dynamic> | - | 图片数组 |
| labels | List<String>? | - | 图片描述 |
| showIndex | bool? | - | 是否显示页码 |
| loop | bool? | - | 图片是否循环 |
| autoplay | bool? | - | 图片轮播是否自动播放 |
| duration | int? | - | 自动播放间隔 |
| bgColor | Color? | - | 背景色 |
| navBarBgColor | Color? | - | 导航栏背景色 |
| iconColor | Color? | - | 图标颜色 |
| labelStyle | TextStyle? | - | label文字样式 |
| indexStyle | TextStyle? | - | 页码样式 |
| defaultIndex | int? | - | 默认预览图片所在的下标 |
| onIndexChange | OnIndexChange? | - | 预览图片切换回调 |
| width | double? | - | 图片宽度 |
| height | double? | - | 图片高度 |
| onClose | OnClose? | - | 关闭点击 |
| onDelete | OnDelete? | - | 删除点击 |
| ignoreDeleteError | bool? | false | 是否忽略单张图片删除错误提示 |
| onTap | OnImageTap? | - | 点击图片 |
| onLongPress | OnLongPress? | - | 长按图片 |
| leftItemBuilder | LeftItemBuilder? | - | 左侧自定义操作 |
| rightItemBuilder | RightItemBuilder? | - | 右侧自定义操作 |

```
```
 ### TDImageViewer

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showImageViewer |  |   required BuildContext context,  required List<dynamic> images,  List<String>? labels,  bool? closeBtn,  bool? deleteBtn,  bool? showIndex,  bool? loop,  bool? autoplay,  int? duration,  Color? bgColor,  Color? navBarBgColor,  Color? iconColor,  TextStyle? labelStyle,  TextStyle? indexStyle,  Color? modalBarrierColor,  bool? barrierDismissible,  int? defaultIndex,  double? width,  double? height,  OnIndexChange? onIndexChange,  OnClose? onClose,  OnDelete? onDelete,  bool? ignoreDeleteError,  OnImageTap? onTap,  OnLongPress? onLongPress,  LeftItemBuilder? leftItemBuilder,  RightItemBuilder? rightItemBuilder, | 显示图片预览 |


  