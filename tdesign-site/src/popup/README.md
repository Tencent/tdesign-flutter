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
    return TButton(
      text: '顶部弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.top,
          height: 240,
          onOpen: () => print('open'),
          onOpened: () => print('opened'),
          child: Container(
            color: TTheme.of(context).bgColorContainer,
            height: 240,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromLeft(BuildContext context) {
    return TButton(
      text: '左侧弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.left,
          width: 280,
          child: Container(
            color: TTheme.of(context).bgColorContainer,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenter(BuildContext context) {
    return TButton(
      text: '中间弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.center,
          closeBtn: false,
          child: Container(
            decoration: BoxDecoration(
              color: TTheme.of(context).bgColorContainer,
              borderRadius:
                  BorderRadius.circular(TTheme.of(context).radiusLarge),
            ),
            width: 240,
            height: 240,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottom(BuildContext context) {
    return TButton(
      text: '底部弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.bottom,
          height: 240,
          child: Container(
            color: TTheme.of(context).bgColorContainer,
            height: 240,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromRight(BuildContext context) {
    return TButton(
      text: '右侧弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.right,
          width: 280,
          child: Container(
            color: TTheme.of(context).bgColorContainer,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件示例


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithOperationAndTitle(BuildContext context) {
    return TButton(
      text: '底部弹出层-带标题及操作',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.bottom,
          height: 280,
          title: '标题文字',
          onCancel: () => TPopup.close(context),
          onConfirm: () {
            TToast.showText('确定', context: context);
            TPopup.close(context);
          },
          child: Container(height: 200),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithCloseAndTitle(BuildContext context) {
    return TButton(
      text: '底部弹出层-带标题及关闭',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.bottom,
          height: 280,
          cancel: TText(
            '关闭',
            textColor: TTheme.of(context).textColorSecondary,
            font: TTheme.of(context).fontBodyLarge,
          ),
          titleWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(TIcons.info_circle,
                  color: TTheme.of(context).brandNormalColor, size: 18),
              const SizedBox(width: 4),
              TText(
                '自定义标题',
                textColor: TTheme.of(context).brandNormalColor,
                font: TTheme.of(context).fontTitleMedium,
              ),
            ],
          ),
          confirm: TText(
            '完成',
            textColor: TTheme.of(context).brandNormalColor,
            font: TTheme.of(context).fontTitleMedium,
            fontWeight: FontWeight.w600,
          ),
          onCancel: () => TPopup.close(context),
          onConfirm: () => TPopup.close(context),
          child: Container(height: 200),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenterWithClose(BuildContext context) {
    return TButton(
      text: '居中弹出层-带关闭',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.center,
          closeOnOverlayClick: false,
          width: 240,
          height: 240,
          close: IconButton(
            icon: Icon(
              TIcons.close_circle,
              color: TTheme.of(context).fontWhColor1,
              size: 32,
            ),
            onPressed: () => TPopup.close(context),
          ),
          child: const SizedBox(width: 240, height: 240),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenterWithUnderClose(BuildContext context) {
    return TButton(
      text: '居中弹出层-自定义下方按钮',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.center,
          closeOnOverlayClick: true,
          width: 240,
          height: 200,
          close: IconButton(
            icon: Icon(
              TIcons.poweroff,
              color: TTheme.of(context).fontWhColor1,
              size: 36,
            ),
            onPressed: () => TPopup.close(context),
          ),
          child: Container(
            width: 240,
            height: 200,
            color: TTheme.of(context).bgColorContainer,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 更多 API


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiMarginTop(BuildContext context) {
    return TButton(
      text: 'bottom margin.top',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.bottom,
          height: 320,
          margin: const EdgeInsets.only(top: 120, left: 16, right: 16),
          title: '日历式留白',
          onCancel: () => TPopup.close(context),
          onConfirm: () => TPopup.close(context),
          child: Container(
            height: 240,
            color: TTheme.of(context).bgColorContainer,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiShowOverlayFalse(BuildContext context) {
    return TButton(
      text: 'showOverlay: false（无蒙层）',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.bottom,
          height: 280,
          showOverlay: false,
          // 无蒙层时无法点遮罩关闭，须保留操作栏取消（或其它关闭入口）
          title: '无蒙层',
          onCancel: () => TPopup.close(context),
          onConfirm: () => TPopup.close(context),
          child: Container(
            height: 200,
            color: TTheme.of(context).bgColorContainer,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiOnOverlayClick(BuildContext context) {
    return TButton(
      text: 'onOverlayClick',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.bottom,
          height: 260,
          onOverlayClick: () =>
              TToast.showText('点击蒙层', context: context),
          child: Container(
            height: 200,
            color: TTheme.of(context).bgColorContainer,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiDuration(BuildContext context) {
    return TButton(
      text: 'duration: 600ms',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context: context,
          placement: TPopupPlacement.bottom,
          height: 240,
          duration: const Duration(milliseconds: 600),
          child: Container(
            height: 200,
            color: TTheme.of(context).bgColorContainer,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


## API

  