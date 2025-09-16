---
title: Popover 弹出气泡
description: 用于文字提示的气泡框。
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

[td_popover_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_popover_page.dart)

### 1 组件类型

带箭头的弹出气泡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '带箭头',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(context: _, content: '弹出气泡内容');
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                                  

不带箭头的弹出气泡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNoArrowPopover(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return TDButton(
          size: TDButtonSize.medium,
          text: '不带箭头',
          type: TDButtonType.outline,
          theme: TDButtonTheme.primary,
             
          onTap: () {
            TDPopover.showPopover(
                context: _, content: '弹出气泡内容', showArrow: false);
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

自定义内容弹出气泡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNCustomPopover(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return TDButton(
          text: '自定义内容',
          type: TDButtonType.outline,
          theme: TDButtonTheme.primary,
             
          onTap: () {
            TDPopover.showPopover(
              context: _,
              padding: const EdgeInsets.all(0),
              width: 108,
              height: 148,
              contentWidget: _buildPopoverList(context),
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDarkPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '深色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '浅色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.light,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInfoPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '品牌色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.info,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuccessPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '成功色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.success,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWarningPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '警告色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.warning,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildErrorPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '错误色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.error,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDarkPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '深色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '浅色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.light,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInfoPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '品牌色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.info,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuccessPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '成功色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.success,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWarningPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '警告色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.warning,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildErrorPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '错误色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.error,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

顶部弹出气泡

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部左',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topLeft,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.top,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部右',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topRight,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部左',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topLeft,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.top,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部右',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topRight,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

底部弹出气泡

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部左',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomLeft,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottom,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部右',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomRight,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部左',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomLeft,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottom,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部右',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomRight,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

右侧弹出气泡

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧上',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightTop,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.right,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧下',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightBottom,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧上',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightTop,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.right,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧下',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightBottom,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

左侧弹出气泡

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧上',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftTop,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.left,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧下',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftBottom,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧上',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftTop,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.left,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧下',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftBottom,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                


## API
### TDPopoverWidget
#### 简介

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| context | BuildContext | - | 上下文 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| offset | double | 4 | 偏移 |
| theme | TDPopoverTheme? | - | 弹出气泡主题 |
| placement | TDPopoverPlacement? | - | 浮层出现位置 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| arrowSize | double | 8 | 箭头大小 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| onTap | OnTap? | - | 点击事件 |
| onLongTap | OnLongTap? | - | 长按事件 |
| radius | BorderRadius? | - | 圆角 |

```
```
 ### TDPopover
#### 简介


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showPopover |  |   required BuildContext context,  String? content,  Widget? contentWidget,  double offset,  TDPopoverTheme? theme,  bool closeOnClickOutside,  TDPopoverPlacement? placement,  bool? showArrow,  double arrowSize,  EdgeInsetsGeometry? padding,  double? width,  double? height,  Color? overlayColor,  OnTap? onTap,  OnLongTap? onLongTap,  BorderRadius? radius, |  |


  