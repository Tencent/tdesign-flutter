---
title: Avatar 头像
description: 用于展示用户头像信息，除了纯展示也可点击进入个人详情等操作。
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

[td_avatar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_avatar_page.dart)

### 1 组件类型

图片头像
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.normal,
          shape: TAvatarShape.square,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

字符头像
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.customText,
          shape: TAvatarShape.square,
          text: 'A',
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

图标头像
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.icon,
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.icon,
          shape: TAvatarShape.square,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

带徽标头像
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBadgeAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        SizedBox(
          height: 51,
          width: 51,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(
                size: TAvatarSize.medium,
                type: TAvatarType.normal,
                defaultUrl: 'assets/img/t_avatar_1.png',
              ),
              Positioned(child: TBadge(TBadgeType.redPoint), right: 0, top: 0)
            ],
          ),
        ),
        SizedBox(width: 32),
        SizedBox(
          height: 51,
          width: 51,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(
                size: TAvatarSize.medium,
                type: TAvatarType.customText,
                text: 'A',
              ),
              Positioned(
                child: TBadge(TBadgeType.message, count: '8'),
                right: 0,
                top: 0,
              )
            ],
          ),
        ),
        SizedBox(width: 32),
        SizedBox(
          width: 51,
          height: 51,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(size: TAvatarSize.medium, type: TAvatarType.icon),
              Positioned(
                child: TBadge(TBadgeType.message, count: '12'),
                right: 0,
                top: 0,
              )
            ],
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 特殊类型

纯展示的头像组
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDisplayAvatar(BuildContext context) {
    var assetUrl = 'assets/img/t_avatar_1.png';
    var assetUrl2 = 'assets/img/t_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return TAvatar(
      size: TAvatarSize.medium,
      type: TAvatarType.display,
      displayText: '+5',
      avatarDisplayListAsset: avatarList,
    );
  }</pre>

</td-code-block>
                                  

带操作的头像组
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOperationAvatar(BuildContext context) {
    var assetUrl = 'assets/img/t_avatar_1.png';
    var assetUrl2 = 'assets/img/t_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return TAvatar(
      size: TAvatarSize.medium,
      type: TAvatarType.operation,
      avatarDisplayListAsset: avatarList,
      onTap: () {
        TToast.showText('点击了操作', context: context);
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件尺寸

大尺寸：64px
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLargeAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.large,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.large,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.large,
          type: TAvatarType.icon,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

中尺寸：48px
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMediumAvatar(BuildContext context) {
    return const Row(
      // spacing: 48,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 48),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 48),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.icon,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

小尺寸：40px
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSmallAvatar(BuildContext context) {
    return const Row(
      // spacing: 56,
      children: [
        TAvatar(
          size: TAvatarSize.small,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 56),
        TAvatar(
          size: TAvatarSize.small,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 56),
        TAvatar(
          size: TAvatarSize.small,
          type: TAvatarType.icon,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TAvatar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| avatarDisplayBorder | double | 2 | 带操作展示的头像描边宽度 |
| avatarDisplayList | List<String>? | - | 带操作展示的头像列表 |
| avatarDisplayListAsset | List<String>? | - | 带操作展示的头像列表（本地资源） |
| avatarDisplayWidget | Widget? | - | 带操作头像自定义操作Widget |
| avatarSize | double? | - | 自定义头像大小 |
| avatarUrl | String? | - | 头像地址 |
| backgroundColor | Color? | - | 自定义文案时背景色 |
| defaultUrl | String | '' | 默认图片（本地） |
| displayText | String? | - | 纯展示类型末尾文字 |
| fit | BoxFit? | - | 自定义图片对齐方式 |
| icon | IconData? | - | 自定义图标 |
| key |  | - |  |
| onTap |  Function()? | - | 操作点击事件 |
| radius | double? | - | 自定义圆角 |
| shape | TAvatarShape | TAvatarShape.circle | 头像形状 |
| size | TAvatarSize | TAvatarSize.medium | 头像尺寸 |
| text | String? | - | 自定义文字 |
| type | TAvatarType | TAvatarType.normal | 头像类型 |


  