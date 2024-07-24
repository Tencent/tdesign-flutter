---
title: Avatar 头像
description: 用于告知用户，该区域的状态变化或者待处理任务的数量。
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
  Widget _buildImageAvatar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: const [
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',),
          SizedBox(width: 32,),
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.normal,
            shape: TDAvatarShape.square,
            defaultUrl: 'assets/img/td_avatar_1.png',),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

字符头像
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextAvatar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: const [
          TDAvatar(
              size: TDAvatarSize.medium,
              type: TDAvatarType.customText,
              text: 'A'),
          SizedBox(width: 32,),
          TDAvatar(
              size: TDAvatarSize.medium,
              type: TDAvatarType.customText,
              shape: TDAvatarShape.square,
              text: 'A'),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

图标头像
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconAvatar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: const [
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.icon,),
          SizedBox(width: 32,),
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.icon,
            shape: TDAvatarShape.square,
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

带徽标头像
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBadgeAvatar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            height: 51,
            width: 51,
            child: Stack(
              alignment:Alignment.bottomLeft,
              children: const [
                TDAvatar(
                  size: TDAvatarSize.medium,
                  type: TDAvatarType.normal,
                  defaultUrl: 'assets/img/td_avatar_1.png',),
                Positioned(child: TDBadge(TDBadgeType.redPoint), right: 0, top: 0)
              ],
            ),
          ),
          const SizedBox(width: 32,),
          SizedBox(
            height: 51,
            width: 51,
            child: Stack(
              alignment:Alignment.bottomLeft,
              children: const [
                TDAvatar(
                    size: TDAvatarSize.medium,
                    type: TDAvatarType.customText,
                    text: 'A'),
                Positioned(child: TDBadge(TDBadgeType.message,count: '8',), right: 0, top: 0)
              ],
            ),
          ),
          const SizedBox(width: 32,),
          SizedBox(
            width: 51,
            height: 51,
            child: Stack(
              alignment:Alignment.bottomLeft,
              children: const [
                TDAvatar(
                  size: TDAvatarSize.medium,
                  type: TDAvatarType.icon,),
                Positioned(child: TDBadge(TDBadgeType.message,count: '12',), right: 0, top: 0,)
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 特殊类型

纯展示的头像组
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDisplayAvatar(BuildContext context){
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: TDAvatar(
        size: TDAvatarSize.medium,
        type: TDAvatarType.display,
        displayText: '+5',
        avatarDisplayListAsset: avatarList,),
    );
  }</pre>

</td-code-block>
                                  

带操作的头像组
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOperationAvatar(BuildContext context){
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.operation,
          avatarDisplayListAsset: avatarList,
          onTap: () {
            TDToast.showText('点击了操作', context: context);
          }),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件尺寸

大尺寸 :64px
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLargeAvatar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: const [
          TDAvatar(
            size: TDAvatarSize.large,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',),
          SizedBox(width: 32,),
          TDAvatar(
              size: TDAvatarSize.large,
              type: TDAvatarType.customText,
              text: 'A'),
          SizedBox(width: 32,),
          TDAvatar(
            size: TDAvatarSize.large,
            type: TDAvatarType.icon,),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

中尺寸 :48px
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMediumAvatar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: const [
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',),
          SizedBox(width: 48,),
          TDAvatar(
              size: TDAvatarSize.medium,
              type: TDAvatarType.customText,
              text: 'A'),
          SizedBox(width: 48,),
          TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.icon,),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

小尺寸 :40px
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSmallAvatar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: const [
          TDAvatar(
            size: TDAvatarSize.small,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/img/td_avatar_1.png',),
          SizedBox(width: 56,),
          TDAvatar(
              size: TDAvatarSize.small,
              type: TDAvatarType.customText,
              text: 'A'),
          SizedBox(width: 56,),
          TDAvatar(
            size: TDAvatarSize.small,
            type: TDAvatarType.icon,),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDAvatar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| size | TDAvatarSize | TDAvatarSize.medium | 头像尺寸 |
| type | TDAvatarType | TDAvatarType.normal | 头像类型 |
| shape | TDAvatarShape | TDAvatarShape.circle | 头像形状 |
| text | String? | - | 自定义文字 |
| radius | double? | - | 自定义圆角 |
| icon | IconData? | - | 自定义图标 |
| avatarUrl | String? | - | 头像地址 |
| avatarSize | double? | - | 自定义头像大小 |
| avatarDisplayList | List<String>? | - | 带操作\展示的头像列表 |
| displayText | String? | - | 纯展示类型末尾文字 |
| onTap |  Function()? | - | 操作点击事件 |
| defaultUrl | String | '' | 默认图片（本地） |
| avatarDisplayWidget | Widget? | - | 带操作头像自定义操作Widget |
| avatarDisplayBorder | double | 2 | 带操作\展示的头像描边宽度 |
| avatarDisplayListAsset | List<String>? | - | 带操作\展示的头像列表 (本地资源) |
| backgroundColor | Color? | - | 自定义文案时背景色 |


  