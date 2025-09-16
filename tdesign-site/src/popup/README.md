---
title: Popup 弹出层
description: 由其他控件触发，屏幕滑出或弹出一块自定义内容区域
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

[td_popup_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_popup_page.dart)

### 1 组件类型


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromTop(BuildContext context) {
    return TDButton(
      text: '顶部弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.top,
            open: () {
              print('open');
            },
            opened: () {
              print('opened');
            },
            builder: (context) {
              return Container(
                color: Colors.white,
                height: 240,
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromLeft(BuildContext context) {
    return TDButton(
      text: '左侧弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.left,
            builder: (context) {
              return Container(
                color: Colors.white,
                width: 280,
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenter(BuildContext context) {
    return TDButton(
      text: '中间弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return Container(
                color: Colors.white,
                width: 240,
                height: 240,
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottom(BuildContext context) {
    return TDButton(
      text: '底部弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return Container(
                color: Colors.white,
                height: 240,
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromRight(BuildContext context) {
    return TDButton(
      text: '右侧弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.right,
            builder: (context) {
              return Container(
                color: Colors.white,
                width: 280,
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件示例


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithOperationAndTitle(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带标题及操作',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomConfirmPanel(
                title: '标题文字',
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TDToast.showText('确定', context: context);
                  Navigator.maybePop(context);
                },
                child: Container(
                  height: 200,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithOperation(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带操作',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomConfirmPanel(
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TDToast.showText('确定', context: context);
                  Navigator.maybePop(context);
                },
                child: Container(
                  height: 200,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithCloseAndTitle(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带标题及关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: '标题文字',
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: Container(
                  height: 200,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithCloseAndLeftTitle(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带左边标题及关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: '标题文字',
                titleLeft: true,
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: Container(
                  height: 200,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithClose(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: Container(
                  height: 200,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithTitle(BuildContext context) {
    return TDButton(
      text: '底部弹出层-仅标题',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: '标题文字',
                hideClose: true,
                // closeClick: () {
                //   Navigator.maybePop(context);
                // },
                child: Container(
                  height: 200,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenterWithClose(BuildContext context) {
    return TDButton(
      text: '居中弹出层-带关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            isDismissible: false,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return TDPopupCenterPanel(
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: const SizedBox(
                  width: 240,
                  height: 240,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenterWithUnderClose(BuildContext context) {
    return TDButton(
      text: '居中弹出层-关闭在下方',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            isDismissible: false,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return TDPopupCenterPanel(
                closeUnderBottom: true,
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: const SizedBox(
                  width: 240,
                  height: 240,
                ),
              );
            }));
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDSlidePopupRoute
#### 简介
从屏幕的某个方向滑动弹出的Dialog框的路由，比如从顶部、底部、左、右滑出页面
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builder | WidgetBuilder | - | 控件构建器 |
| barrierLabel |  | - |  |
| modalBarrierColor | Color? | Colors.black54 | 蒙层颜色 |
| isDismissible | bool | true | 点击蒙层能否关闭 |
| modalBarrierFull | bool | false | 是否全屏显示蒙层 |
| slideTransitionFrom | SlideTransitionFrom | SlideTransitionFrom.bottom | 设置从屏幕的哪个方向滑出 |
| modalWidth | double? | - | 弹出框宽度 |
| modalHeight | double? | - | 弹出框高度 |
| modalTop | double? | 0 | 弹出框顶部距离 |
| modalLeft | double? | 0 | 弹出框左侧距离 |
| open | VoidCallback? | - | 打开前事件 |
| opened | VoidCallback? | - | 打开后事件 |
| close | VoidCallback? | - | 关闭前事件 |
| barrierClick | VoidCallback? | - | 蒙层点击事件，仅在[modalBarrierFull]为false时触发 |
| focusMove | bool | false | 是否有输入框获取焦点时整体平移避免输入框被遮挡 |

```
```
 ### TDPopupBottomDisplayPanel
#### 简介
右上角带关闭的底部浮层面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| child |  | - |  |
| title |  | - |  |
| titleColor |  | - |  |
| titleFontSize | double? | - | 标题字体大小 |
| titleLeft | bool | false | 标题是否靠左 |
| hideClose | bool | false | 是否隐藏关闭按钮 |
| closeColor | Color? | - | 关闭按钮颜色 |
| closeSize | double? | - | 关闭按钮图标尺寸 |
| closeClick | PopupClick? | - | 关闭按钮点击回调 |
| backgroundColor |  | - |  |
| radius |  | - |  |
| draggable |  | - |  |
| maxHeightRatio |  | - |  |
| minHeightRatio |  | - |  |

```
```
 ### TDPopupBottomConfirmPanel
#### 简介
带确认的底部浮层面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| child |  | - |  |
| title |  | - |  |
| titleColor |  | - |  |
| leftText | String? | - | 左边文本 |
| leftTextColor | Color? | - | 左边文本颜色 |
| leftClick | PopupClick? | - | 左边文本点击回调 |
| rightText | String? | - | 右边文本 |
| rightTextColor | Color? | - | 右边文本颜色 |
| rightClick | PopupClick? | - | 右边文本点击回调 |
| titleFontSize | double? | - | 标题字体大小 |
| leftTextFontSize | double? | - | 左边文本字体大小 |
| rightTextFontSize | double? | - | 右边文本字体大小 |
| backgroundColor |  | - |  |
| radius |  | - |  |
| draggable |  | - |  |
| maxHeightRatio |  | - |  |
| minHeightRatio |  | - |  |

```
```
 ### TDPopupCenterPanel
#### 简介
居中浮层面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| child | Widget | - | 子控件 |
| closeUnderBottom | bool | false | 关闭按钮是否在视图框下方 |
| closeColor | Color? | - | 关闭按钮颜色 |
| closeClick | PopupClick? | - | 关闭按钮点击回调 |
| backgroundColor | Color? | - | 背景颜色 |
| radius | double? | - | 圆角 |
| closeSize | double? | - | 关闭按钮图标尺寸 |


  