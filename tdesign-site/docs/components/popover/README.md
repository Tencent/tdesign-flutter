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

[t_popover_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_popover_page.dart)

### 1 组件类型

带箭头的弹出气泡

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('带箭头'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: theme,
              );
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
      builder: (popoverContext, constrains) {
        return TButton(
          size: TButtonSize.large,
          child: const Text('不带箭头'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopover.showPopover(
              context: popoverContext,
              content: const Text('弹出气泡内容'),
              showArrow: false,
              colorScheme: theme,
            );
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
    final textStyle = TextStyle(
      color: theme == TPopoverColorScheme.light
          ? context.tTheme.fontGyColor1
          : context.tTheme.fontWhColor1,
    );
    final dividerColor = textStyle.color;
    return LayoutBuilder(
      builder: (popoverContext, constrains) {
        return TButton(
          size: TButtonSize.large,
          child: const Text('自定义内容'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopover.showPopover(
              context: popoverContext,
              padding: const EdgeInsets.all(0),
              colorScheme: theme,
              width: 150,
              height: 146,
              content: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: TText('选项1', style: textStyle),
                  ),
                  Container(height: 1, color: dividerColor),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: TText('选项2', style: textStyle),
                  ),
                  Container(height: 1, color: dividerColor),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
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

### 2 组件样式

深色

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDarkPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('深色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

浅色

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('浅色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.light,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

品牌色

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPrimaryPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('品牌色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.primary,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

成功色

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuccessPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('成功色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.success,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

警告色

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWarningPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('警告色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.warning,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

错误色

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDangerPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('错误色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.danger,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

### 3 位置

顶部弹出气泡

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('顶部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.topLeft,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

顶部中

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('顶部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.top,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

顶部右

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('顶部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.topRight,
                colorScheme: theme,
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
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('底部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.bottomLeft,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

底部中

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('底部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.bottom,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }</pre>

</td-code-block>

底部右

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('底部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.bottomRight,
                colorScheme: theme,
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
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('右侧上'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.rightTop,
                  colorScheme: theme,
                );
              },
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

右侧中

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('右侧中'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.right,
                  colorScheme: theme,
                );
              },
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

右侧下

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('右侧下'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.rightBottom,
                  colorScheme: theme,
                );
              },
            ),
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
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('左侧上'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.leftTop,
                  colorScheme: theme,
                );
              },
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

左侧中

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('左侧中'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.left,
                  colorScheme: theme,
                );
              },
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

左侧下

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('左侧下'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.leftBottom,
                  colorScheme: theme,
                );
              },
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

## 从旧版 API 迁移

- 文本内容由 `content: '提示内容'` 改为 `content: const Text('提示内容')`。
- 自定义内容由 `contentWidget: widget` 改为 `content: widget`，不再需要为了首帧定位强制指定 `width` 和 `height`。
- `onTap`、`onLongTap` 改为无参数回调；内容已由调用方持有，无需从回调重复获取。
- `placement` 可省略，默认使用 `TPopoverPlacement.top`。
- `TPopoverWidget` 不再作为公开入口；统一通过 `TPopover.showPopover` 管理 Overlay 和生命周期。

## API
### TPopover
#### 简介
气泡弹层
通过 `showPopover` 静态方法弹出，支持 12 个方向定位和箭头。

#### 静态方法

##### TPopover.showPopover

显示气泡弹层

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 触发元素的上下文，用于计算气泡锚点位置。 |
| content | Widget | - | 气泡内容。直接传入未设置样式的 `Text` 时使用气泡默认文字样式；组合内容应自行定义子组件样式和布局。 |
| offset | double? | - | 弹层与触发元素的间距。 |
| colorScheme | TPopoverColorScheme | TPopoverColorScheme.defaultTheme | 气泡预设配色。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 默认为 true，避免触发元素移动后气泡停留在旧坐标。 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置，默认为 `TPopoverPlacement.top`。 |
| showArrow | bool? | - | 是否显示气泡箭头。 |
| arrowSize | double? | - | 箭头尺寸。 |
| padding | EdgeInsetsGeometry? | - | 内容内边距。 |
| width | double? | - | 内容外框宽度（包含 padding）。未设置时按 `content` 的实际布局宽度确定，并受组件主题尺寸约束。 |
| height | double? | - | 内容外框高度（包含 padding）。未设置时按 `content` 的实际布局高度确定，并受组件主题尺寸约束。 |
| overlayColor | Color? | - | 蒙层颜色。 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 |
| radius | BorderRadius? | - | 气泡圆角。 |

### TPopoverColorScheme
#### 简介
弹出气泡预设配色。
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认深色配色。 |
| light | 浅色。 |
| primary | 品牌主色。 |
| success | 成功。 |
| warning | 警告。 |
| danger | 危险色。 |

### TPopoverPlacement
#### 简介
气泡弹层定位方向
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| topLeft | 上左。 |
| top | 上方。 |
| topRight | 上右。 |
| rightTop | 右上。 |
| right | 右侧。 |
| rightBottom | 右下。 |
| bottomRight | 下右。 |
| bottom | 下方。 |
| bottomLeft | 下左。 |
| leftBottom | 左下。 |
| left | 左侧。 |
| leftTop | 左上。 |
