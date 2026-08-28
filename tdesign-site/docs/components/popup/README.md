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

[t_popup_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_popup_page.dart)

### 1 组件类型


基础弹出层


底部弹出


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('底部弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              headerBuilder: (_, __) =>
                  const TPopupHeader(title: TText('底部弹出层')),
              child: const Center(child: TText('弹出层内容区域')),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>
顶部弹出


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTopPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('顶部弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.top(
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                alignment: Alignment.center,
                child: const TText('顶部弹出层内容'),
              ),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>
左侧弹出


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLeftPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('左侧弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.left(
              child: Container(
                alignment: Alignment.center,
                child: const TText('左侧弹出层内容'),
              ),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>
右侧弹出


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('右侧弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.right(
              child: Container(
                alignment: Alignment.center,
                child: const TText('右侧弹出层内容'),
              ),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>
中间弹出


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCenterPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('中间弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: TText('中间弹出层内容')),
              ),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>
### 2 组件示例


应用示例


带标题及操作


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWithTitlePopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('带标题及操作'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 258,
              headerBuilder: (_, __) =>
                  const TPopupHeader(title: TText('标题文字')),
              child: const Center(child: TText('内容区域')),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>
自定义关闭按钮


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomClosePopup(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('自定义关闭按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.center(
              width: 240,
              height: 200,
              closeBuilder: (_, close) => IconButton(
                tooltip: '关闭',
                icon: Icon(
                  TIcons.close_circle,
                  color: theme.fontWhColor1,
                  size: 32,
                ),
                onPressed: close,
              ),
              child: Container(
                width: 240,
                height: 200,
                color: theme.bgColorContainer,
                alignment: Alignment.center,
                child: const TText('自定义关闭按钮'),
              ),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>
### 3 嵌套弹窗


多层 Popup 嵌套使用


嵌套弹窗


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNestedPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('嵌套弹窗'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopupHandle? outerHandle;
          outerHandle = TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 360,
              headerBuilder: null,
              child: Builder(
                builder: (innerContext) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TText(
                          '外层：仅 child，无内置头部',
                          textColor: innerContext.tTheme.textColorSecondary,
                        ),
                        const SizedBox(height: 16),
                        TButton(
                          child: const TText('打开内层 Popup'),
                          size: TButtonSize.large,
                          variant: TButtonVariant.outline,
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () {
                            TPopup.show(
                              innerContext,
                              options: TPopupOptions.bottom(
                                height: 240,
                                headerBuilder: (_, __) =>
                                    const TPopupHeader(title: TText('内层标题')),
                                child: const Center(
                                  child: TText('内层内容区域'),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          child: const TText('关闭外层'),
                          size: TButtonSize.large,
                          variant: TButtonVariant.outline,
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () => outerHandle?.close(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

## API
### TPopup
#### 简介
弹出层入口：五向滑入 / 居中弹出，支持蒙层、可选 bottom 头部和
可选 center 面板外下方关闭区。
通过 `show` 命令式打开；返回 `TPopupHandle` 用于关闭与再次打开。
多次调用 `show` 会继续压入新的浮层路由，可用于叠加展示。

配置项见 `TPopupOptions`；方向见 `TPopupPlacement`。

#### 静态方法

##### TPopup.show

打开浮层并压入独立 `PopupRoute`。
返回 `TPopupHandle`，可用 `TPopupHandle.close`、`TPopupHandle.open`、
`TPopupHandle.isShowing` 控制与查询。
重复调用会继续 push 新的浮层；若需互斥请在业务层管理。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 `Navigator` 并展示浮层。 |
| options | TPopupOptions | - | 浮层配置；方向固定时推荐 `TPopupOptions.bottom` 等命名工厂。 |
| navigatorContext | BuildContext? | - | 可选，指定承载浮层的 `Navigator` 的 context，默认 `context`。 |
| useRootNavigator | bool | false | 为 true 时使用根 `Navigator`（嵌套导航场景）。 |


### TPopupHeader
#### 简介
Popup 标准头部布局。
本组件只负责取消按钮、标题和确认按钮的布局，不注入默认内容或业务行为。
需要关闭 Popup 时，在 `TPopupOptions.headerBuilder` 中构建按钮并调用其 `close` 参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancelButton | Widget? | - | 左侧取消操作；为 null 时不显示。 |
| confirmButton | Widget? | - | 右侧确认操作；为 null 时不显示。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| title | Widget? | - | 中间标题；为 null 时不显示。 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| headerHeight | double | - | 标准头部高度。 |


### TPopupOptions
#### 简介
`TPopup.show` 的配置对象。
## 如何创建
| 场景 | 推荐用法 |
|------|----------|
| 弹出方向已知 | `TPopupOptions.bottom`、`TPopupOptions.center`、`TPopupOptions.top`、`TPopupOptions.left`、`TPopupOptions.right` |
| 方向由变量决定 | 默认构造并设置 `placement`；传错字段会在 `TPopup.show` / `TPopupHandle.open` 时抛 `FlutterError` |
命名工厂只暴露当前方向生效的字段（例如 `TPopupOptions.bottom` 无 `width` 参数）。
## 字段与 `TPopupPlacement`
| `TPopupPlacement` | 头部 / 关闭区 | 尺寸 |
|-------------------|-------------|------|
| `TPopupPlacement.bottom` | `headerBuilder` | `height`、`inset` |
| `TPopupPlacement.center` | `closeBuilder` | `width`、`height` |
| `TPopupPlacement.top` | — | `height`、`inset` |
| `TPopupPlacement.left`、`TPopupPlacement.right` | — | `width`、`inset` |
`headerBuilder` 与 `closeBuilder` 默认均为 `null`，基础 Popup 只渲染
`child`。显式提供 builder 时才会渲染相应区域，builder 可调用 `close`
关闭浮层。
生命周期回调见 `onOpen`、`onOpened`、`onClose`、`onClosed`、`onVisibleChange`；
蒙层行为见 `overlay`（`TPopupOverlayConfig`）。

#### 工厂构造方法

##### 通用参数

以下参数由各命名工厂统一透传，含义一致：

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 300ms（与官方及仓库其他浮层组件对齐）。 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 |
| child | Widget | - | 浮层主体内容（必填）。 |
| destroyOnClose | bool | false | 为 true 时路由 `maintainState` 为 false，关闭后不保留路由内 State。 |
| onClose | VoidCallback? | - | 开始关闭（与 `onVisibleChange` 的 `visible: false` 同期）。 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 |
| onOpen | VoidCallback? | - | 路由 push 时（打开动画开始前）。 |
| onOpened | VoidCallback? | - | 打开动画结束。 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 |
| useSafeArea | bool | true | 是否避让系统安全区，默认 true；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。设为 false 可贴满屏幕边缘。 |


##### TPopupOptions.bottom

创建 `TPopupPlacement.bottom` 配置。
固定 `placement` 为 `TPopupPlacement.bottom`；默认不显示头部。
蒙层、动画、生命周期等字段语义见同名成员文档。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 |
| inset | TPopupBottomInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |
| headerBuilder | TPopupHeaderBuilder? | - | bottom 头部；仅 `TPopupPlacement.bottom` 生效，默认不显示。 可返回 `TPopupHeader` 组合取消按钮、标题和确认按钮；builder 的 `close` 参数只负责关闭 Popup，不会自动生成任何按钮。 |


##### TPopupOptions.center

创建 `TPopupPlacement.center` 配置。
固定 `placement` 为 `TPopupPlacement.center`；默认不显示关闭按钮。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 |
| closeBuilder | TPopupSlotBuilder? | - | center 面板外下方关闭区；仅 `TPopupPlacement.center` 生效，默认不显示。 builder 的 `close` 参数只负责关闭 Popup，不会自动生成关闭按钮。 |


##### TPopupOptions.left

创建 `TPopupPlacement.left` 配置。
固定 `placement` 为 `TPopupPlacement.left`；未传 `width` 时布局默认宽度 280。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 |
| inset | TPopupLeftInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |


##### TPopupOptions.right

创建 `TPopupPlacement.right` 配置。
固定 `placement` 为 `TPopupPlacement.right`；未传 `width` 时布局默认宽度 280。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 |
| inset | TPopupRightInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |


##### TPopupOptions.top

创建 `TPopupPlacement.top` 配置。
固定 `placement` 为 `TPopupPlacement.top`；无内置头部。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 |
| inset | TPopupTopInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 300ms（与官方及仓库其他浮层组件对齐）。 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 |
| child | Widget | - | 浮层主体内容（必填）。 |
| closeBuilder | TPopupSlotBuilder? | - | center 面板外下方关闭区；仅 `TPopupPlacement.center` 生效，默认不显示。 builder 的 `close` 参数只负责关闭 Popup，不会自动生成关闭按钮。 |
| destroyOnClose | bool | false | 为 true 时路由 `maintainState` 为 false，关闭后不保留路由内 State。 |
| headerBuilder | TPopupHeaderBuilder? | - | bottom 头部；仅 `TPopupPlacement.bottom` 生效，默认不显示。 可返回 `TPopupHeader` 组合取消按钮、标题和确认按钮；builder 的 `close` 参数只负责关闭 Popup，不会自动生成任何按钮。 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 |
| inset | TPopupInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |
| onClose | VoidCallback? | - | 开始关闭（与 `onVisibleChange` 的 `visible: false` 同期）。 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 |
| onOpen | VoidCallback? | - | 路由 push 时（打开动画开始前）。 |
| onOpened | VoidCallback? | - | 打开动画结束。 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 |
| placement | TPopupPlacement | TPopupPlacement.bottom | 出现位置，默认 `TPopupPlacement.bottom`。 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 |
| useSafeArea | bool | true | 是否避让系统安全区，默认 true；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。设为 false 可贴满屏幕边缘。 |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 |


### TPopupHandle
#### 简介
`TPopup.show` 的返回值，用于控制同一份 `TPopupOptions` 的多次打开与关闭。
#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| navigatorContext | BuildContext? | - | 与 `TPopup.show` 的 `navigatorContext` 相同。 |
| options | TPopupOptions | - | 创建时传入的配置；每次 `open` 会按 `TPopupOptions.placement` 裁剪无效字段后使用。 |
| themeContext | BuildContext | - | 用于捕获调用点局部 Theme 的 context。 |
| useRootNavigator | bool | - | 与 `TPopup.show` 的 `useRootNavigator` 相同。 |


### TPopupOverlayConfig
#### 简介
Popup 蒙层行为配置（可见遮罩、背景拦截、点击行为）。
统一收敛 `TPopupOptions` 上散落的蒙层参数（`showOverlay` / `modal` /
`closeOnOverlayClick` / `overlayColor` / `overlayOpacity` / `onOverlayClick`），
与 Toast 的 `TOverlayConfig` 命名风格一脉相承，作为蒙层行为的单一真源。
`showOverlay` 与 `preventTap` 解耦，可独立配置：
* `showOverlay=true, preventTap=true`（默认）：标准模态弹层（显示蒙层 + 拦截背景）；
* `showOverlay=true, preventTap=false`：显示蒙层但不拦截背景交互；
* `showOverlay=false, preventTap=true`：透明模态弹层（拦截交互但不显示蒙层）；
* `showOverlay=false, preventTap=false`：非模态浮层（不显示蒙层也不拦截交互）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeOnClick | bool? | - | 点击可见蒙层是否关闭；省略时在可点击的可见蒙层上默认为 true。 仅当 `showOverlay` 与 `preventTap` 都为 true 时生效；视觉蒙层允许点击穿透时， 不会接收点击事件，也不会关闭 Popup。 |
| color | Color? | - | 蒙层颜色；为 null 时默认 black54。 |
| onClick | VoidCallback? | - | 可见蒙层点击回调；是否关闭取决于 `effectiveCloseOnClick`。 仅当 `showOverlay` 与 `preventTap` 都为 true 时触发。 |
| opacity | double? | - | 蒙层透明度系数（0–1），与 `color` 的 alpha 相乘后用于绘制；为 null 时不额外调整。 |
| preventTap | bool | true | 是否拦截背景交互（默认 true）；对应原 `modal` 参数。 |
| showOverlay | bool | true | 是否显示可见半透明蒙层（默认 true）。 |


### TPopupPlacement
#### 简介
浮层出现方向；决定 `TPopupOptions` 中哪些字段生效。
与 `TPopupOptions` 类文档中的「字段与 placement」表对应。
方向固定时请用 `TPopupOptions.bottom`、`TPopupOptions.center` 等命名工厂。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 自顶部滑入；默认高 240，使用 `TPopupOptions.height`、`TPopupOptions.inset`（`TPopupTopInset`）覆盖。 |
| left | 自左侧滑入；默认宽 280，使用 `TPopupOptions.width`、`TPopupOptions.inset`（`TPopupLeftInset`）覆盖。 |
| right | 自右侧滑入；默认宽 280，使用 `TPopupOptions.width`、`TPopupOptions.inset`（`TPopupRightInset`）覆盖。 |
| bottom | 自底部滑入；默认高 240；使用 `TPopupOptions.height`、`TPopupOptions.inset`（`TPopupBottomInset`）覆盖。 |
| center | 屏幕居中；默认 240 × 240，使用 `TPopupOptions.width`、`TPopupOptions.height` 覆盖； 使用 `TPopupOptions.closeBuilder` 控制面板外下方关闭区。 |


### TPopupTrigger
#### 简介
浮层关闭或显隐变化时的触发来源。
作为 `TPopupVisibleChangeCallback` 的第二个参数，以及关闭流程中的语义标记。
内置行为会映射为 `TPopupTrigger.overlay`，center 关闭 builder 调用 `close`
映射为 `TPopupTrigger.close`；
`TPopupHandle.close` 为 `TPopupTrigger.api`；系统返回为
`TPopupTrigger.systemBack`；headerBuilder 内调用 `close` 等为
`TPopupTrigger.custom`。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| overlay | 点击蒙层，且 `TPopupOverlayConfig.effectiveCloseOnClick` 为 true。 |
| cancel | 调用头部关闭函数并显式指定取消语义。 |
| confirm | 调用头部关闭函数并显式指定确认语义。 |
| close | 点击 center 关闭槽位。 |
| api | 外部 API 主动触发的显隐变化，如 `TPopupHandle.close` 或打开事件。 |
| systemBack | 系统返回键或系统路由返回触发的关闭。 |
| custom | 无框架预设动作语义的自定义关闭，如 headerBuilder 内调用 `close`。 |


### TPopupHeaderBuilder
#### 简介
bottom 整行头部自定义构建器。
* `context` 构建上下文
* `close` 关闭浮层；省略参数时触发源为 `TPopupTrigger.custom`，也可显式传入
`TPopupTrigger.cancel` 或 `TPopupTrigger.confirm` 标记操作语义
#### 类型定义

```dart
typedef TPopupHeaderBuilder = Widget Function(BuildContext context, TPopupCloseCallback close);
```


### TPopupCloseCallback
#### 简介
Popup 关闭函数；省略 `trigger` 时按 `TPopupTrigger.custom` 上报。
#### 类型定义

```dart
typedef TPopupCloseCallback = void Function([TPopupTrigger trigger]);
```


### TPopupSlotBuilder
#### 简介
center 面板外关闭区构建器。
* `context` 构建上下文
* `close` 关闭浮层，触发源为 `TPopupTrigger.close`
自定义 builder 需自行提供交互与无障碍语义；框架仅为内置默认控件补充默认语义。
#### 类型定义

```dart
typedef TPopupSlotBuilder = Widget Function(BuildContext context, VoidCallback close);
```


### TPopupVisibleChangeCallback
#### 简介
浮层显隐变化回调。
* `visible` 为 true 表示打开，false 表示开始关闭
* `trigger` 关闭来源，见 `TPopupTrigger`；打开时为 `TPopupTrigger.api`
#### 类型定义

```dart
typedef TPopupVisibleChangeCallback = void Function(bool visible, TPopupTrigger trigger);
```
