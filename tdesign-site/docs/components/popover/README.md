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
          return TButton(
            size: TButtonSize.medium,
            text: '带箭头',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                  context: _, content: '弹出气泡内容', theme: theme);
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
        return TButton(
          size: TButtonSize.medium,
          text: '不带箭头',
          type: TButtonType.outline,
          theme: TButtonTheme.primary,
          onTap: () {
            TPopover.showPopover(
                context: _, content: '弹出气泡内容', showArrow: false, theme: theme);
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
    var textStyle = TextStyle(
        color: theme == TPopoverTheme.light
            ? TTheme.of(context).fontGyColor1
            : TTheme.of(context).fontWhColor1);
    return LayoutBuilder(
      builder: (_, constrains) {
        return TButton(
          text: '自定义内容',
          type: TButtonType.outline,
          theme: TButtonTheme.primary,
          onTap: () {
            TPopover.showPopover(
              context: _,
              padding: const EdgeInsets.all(0),
              theme: theme,
              width: 108,
              height: 152,
              contentWidget: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: TText('选项1', style: textStyle),
                  ),
                  const TDivider(height: 0.5),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: TText('选项2', style: textStyle),
                  ),
                  const TDivider(height: 0.5),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: TText('选项3', style: textStyle),
                  ),
                ],
              ),
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
          return TButton(
            size: TButtonSize.medium,
            text: '深色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
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
          return TButton(
            size: TButtonSize.medium,
            text: '浅色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.light,
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
          return TButton(
            size: TButtonSize.medium,
            text: '品牌色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.info,
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
          return TButton(
            size: TButtonSize.medium,
            text: '成功色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.success,
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
          return TButton(
            size: TButtonSize.medium,
            text: '警告色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.warning,
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
          return TButton(
            size: TButtonSize.medium,
            text: '错误色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.error,
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
          return TButton(
            size: TButtonSize.medium,
            text: '深色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
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
          return TButton(
            size: TButtonSize.medium,
            text: '浅色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.light,
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
          return TButton(
            size: TButtonSize.medium,
            text: '品牌色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.info,
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
          return TButton(
            size: TButtonSize.medium,
            text: '成功色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.success,
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
          return TButton(
            size: TButtonSize.medium,
            text: '警告色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.warning,
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
          return TButton(
            size: TButtonSize.medium,
            text: '错误色',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TPopoverTheme.error,
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
          return TButton(
            size: TButtonSize.medium,
            text: '顶部左',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.topLeft,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '顶部中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.top,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '顶部右',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.topRight,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '顶部左',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.topLeft,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '顶部中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.top,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '顶部右',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.topRight,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '底部左',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottomLeft,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '底部中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottom,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '底部右',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottomRight,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '底部左',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottomLeft,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '底部中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottom,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '底部右',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottomRight,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '右侧上',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.rightTop,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '右侧中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.right,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '右侧下',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.rightBottom,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '右侧上',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.rightTop,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '右侧中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.right,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '右侧下',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.rightBottom,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '左侧上',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.leftTop,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '左侧中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.left,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '左侧下',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.leftBottom,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '左侧上',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.leftTop,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '左侧中',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.left,
                theme: theme,
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
          return TButton(
            size: TButtonSize.medium,
            text: '左侧下',
            type: TButtonType.outline,
            theme: TButtonTheme.primary,
            onTap: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.leftBottom,
                theme: theme,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>
                


## API
### TPopover

#### 静态方法

##### TPopover.showPopover

返回类型：`Future`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| offset | double | 4 | 偏移 |
| theme | TPopoverTheme? | - | 弹出气泡主题 |
| closeOnClickOutside | bool | true | - |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| arrowSize | double | 8 | 箭头大小 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| overlayColor | Color? | Colors.transparent | - |
| onTap | OnTap? | - | 点击事件 |
| onLongTap | OnLongTap? | - | 长按事件 |
| radius | BorderRadius? | - | 圆角 |


### TPopoverWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double | 8 | 箭头大小 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| context | BuildContext | - | 上下文 |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| offset | double | 4 | 偏移 |
| onLongTap | OnLongTap? | - | 长按事件 |
| onTap | OnTap? | - | 点击事件 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| radius | BorderRadius? | - | 圆角 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| theme | TPopoverTheme? | - | 弹出气泡主题 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |


### TPopoverTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| dark | 暗色 |
| light | 亮色 |
| info | 品牌色 |
| success | 成功 |
| warning | 警告 |
| error | 错误 |


### TPopoverPlacement
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| topLeft | 上左 |
| top | 上 |
| topRight | 上右 |
| rightTop | 右上 |
| right | 右 |
| rightBottom | 右下 |
| bottomRight | 下右 |
| bottom | 下 |
| bottomLeft | 下左 |
| leftBottom | 左下 |
| left | 左 |
| leftTop | 左上 |


### OnTap
#### 类型定义

```dart
typedef OnTap =  Function(String? content);
```


### OnLongTap
#### 类型定义

```dart
typedef OnLongTap =  Function(String? content);
```


  