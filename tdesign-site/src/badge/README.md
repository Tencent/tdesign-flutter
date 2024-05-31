---
title: Badge 徽标
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

### 1 组件类型

红点徽标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRedPointBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 24,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDText(
                  '消息',
                  font: TDTheme.of(context).fontBodyLarge,
                ),
                const Positioned(
                  child: TDBadge(TDBadgeType.redPoint),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 40,
          ),
          SizedBox(
            width: 27,
            height: 27,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                Icon(TDIcons.notification),
                Positioned(
                  child: TDBadge(TDBadgeType.redPoint),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 40,
          ),
          SizedBox(
            width: 83,
            height: 51,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                TDButton(
                  width: 80,
                  height: 48,
                  text: '按钮',
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                ),
                Positioned(
                  child: TDBadge(TDBadgeType.redPoint),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

数字徽标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNumberBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 32,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDText(
                  '消息',
                  font: TDTheme.of(context).fontBodyLarge,
                ),
                const Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 40,
          ),
          SizedBox(
            width: 34,
            height: 34,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                Icon(TDIcons.notification),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 40,
          ),
          SizedBox(
            width: 86,
            height: 54,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                TDButton(
                  width: 80,
                  height: 48,
                  text: '按钮',
                  size: TDButtonSize.large,
                ),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

自定义徽标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 56,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  child: const Icon(TDIcons.notification),
                  decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor2,
                      borderRadius: BorderRadius.circular(
                          TDTheme.of(context).radiusDefault)),
                  height: 48,
                  width: 48,
                ),
                const Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
          const SizedBox(width: 40),
          SizedBox(
            width: 64,
            height: 56,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  child: const Icon(TDIcons.notification),
                  decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor2,
                      borderRadius: BorderRadius.circular(
                          TDTheme.of(context).radiusDefault)),
                  height: 48,
                  width: 48,
                ),
                const Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '0',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
          const SizedBox(width: 40),
          SizedBox(
            width: 64,
            height: 56,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  child: const Icon(TDIcons.notification),
                  decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor2,
                      borderRadius: BorderRadius.circular(
                          TDTheme.of(context).radiusDefault)),
                  height: 48,
                  width: 48,
                ),
                const Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '0',
                    showZero: false,
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

圆形徽标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                Icon(TDIcons.notification),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

方形徽标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSquareBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                Icon(TDIcons.notification),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.square,
                    border: TDBadgeBorder.small,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

气泡徽标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBubbleBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 67,
            height: 56,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  child: const Icon(TDIcons.shop),
                  decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor2,
                      borderRadius: BorderRadius.circular(
                          TDTheme.of(context).radiusDefault)),
                  height: 48,
                  width: 48,
                ),
                const Positioned(
                  child: TDBadge(
                    TDBadgeType.bubble,
                    count: '领积分',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

角标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSubscriptBadge(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          child: TDText(
            '单行标题',
            textColor: TDTheme.of(context).fontGyColor1,
            font: TDTheme.of(context).fontBodyLarge,
          ),
          color: Colors.white,
          height: 48,
          width: MediaQuery.of(context).size.width,
        ),
        const TDBadge(
          TDBadgeType.subscript,
          message: 'NEW',
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 组件尺寸

Large
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLargeBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 65.5,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                TDAvatar(
                  size: TDAvatarSize.large,
                  type: TDAvatarType.icon,
                ),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    size: TDBadgeSize.large,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

Medium
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMediumBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 51,
            height: 49.5,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: const [
                TDAvatar(
                  size: TDAvatarSize.medium,
                  type: TDAvatarType.icon,
                ),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '8',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDBadge
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TDBadgeType | type | 红点样式 |
| key |  | - |  |
| count | String? | - | 红点数量 |
| border | TDBadgeBorder | TDBadgeBorder.large | 红点圆角大小 |
| size | TDBadgeSize | TDBadgeSize.small | 红点尺寸 |
| color | Color? | - | 红点颜色 |
| textColor | Color? | - | 文字颜色 |
| message | String? | - | 消息内容 |
| widthLarge | double | 32 | 角标大三角形宽 |
| widthSmall | double | 12 | 角标小三角形宽 |
| padding | EdgeInsetsGeometry? | - | 角标自定义padding |
| showZero | bool | true | 值为0是否显示 |


  