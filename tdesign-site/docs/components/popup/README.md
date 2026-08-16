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

### 1 弹出位置


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromTop(BuildContext context) {
    return TButton(
      text: 'top',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.top(
              height: 240,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromLeft(BuildContext context) {
    return TButton(
      text: 'left',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.left(
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenter(BuildContext context) {
    return TButton(
      text: 'center',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.center(
              width: 240,
              height: 240,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottom(BuildContext context) {
    return TButton(
      text: 'bottom',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
              height: 240,
              headerBuilder: null,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromRight(BuildContext context) {
    return TButton(
      text: 'right',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.right(
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 头部与操作


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBottomBuiltInHeaderDemos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TButton(
          text: '操作槽 默认',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () {
            TPopup.show(
              context,
              options: TPopupOptions.bottom(
                height: 280,
                titleWidget: const TText('标题'),
                child: Container(height: 200),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        TButton(
          text: '操作槽 自定义',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () {
            TPopup.show(
              context,
              options: TPopupOptions.bottom(
                height: 280,
                titleWidget: const TText('标题'),
                cancelBuilder: _bottomCancelSlot,
                confirmBuilder: _bottomConfirmSlot,
                child: Container(height: 200),
              ),
            );
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromBottomWithHeaderClose(BuildContext context) {
    return TButton(
      text: 'headerBuilder',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
            height: 280,
            headerBuilder: _bottomTitleCloseHeader(title: '标题文字'),
            child: Container(height: 200),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPopFromCenterClose(BuildContext context) {
    return TButton(
      text: 'closeBuilder 自定义',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.center(
            width: 240,
            height: 200,
            closeBuilder: _centerCustomCloseSlot,
            child: Container(
              width: 240,
              height: 200,
              color: TTheme.of(context).bgColorContainer,
            ),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNestedPopup(BuildContext context) {
    return TButton(
      text: '嵌套 show',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
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
                          '外层：headerBuilder: null，仅 child',
                          textColor: TTheme.of(innerContext).textColorSecondary,
                        ),
                        const SizedBox(height: 16),
                        TButton(
                          text: '内层 bottom',
                          isBlock: true,
                          theme: TButtonTheme.primary,
                          size: TButtonSize.large,
                          onTap: () {
                            TPopup.show(
                              innerContext,
                              options: TPopupOptions.bottom(
                                height: 280,
                                titleWidget: const TText('内层标题'),
                                child: Container(
                                  height: 160,
                                  color: TTheme.of(innerContext)
                                      .bgColorSecondaryContainer,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          text: 'Handle.close',
                          isBlock: true,
                          type: TButtonType.outline,
                          size: TButtonSize.large,
                          onTap: () => _toastThen(
                            innerContext,
                            '点击：关闭外层',
                            () => outerHandle?.close(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 安全区域


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiUseSafeAreaCompare(BuildContext context) {
    final theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TText(
          'useSafeArea，真机看橙色底边标记',
          textColor: theme.textColorSecondary,
          font: theme.fontBodyMedium,
        ),
        const SizedBox(height: 16),
        TButton(
          text: 'useSafeArea 开',
          isBlock: true,
          theme: TButtonTheme.primary,
          size: TButtonSize.large,
          onTap: () => _showSafeAreaBottomPopup(context, useSafeArea: true),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'useSafeArea 关',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showSafeAreaBottomPopup(context, useSafeArea: false),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 圆角


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiRadiusCompare(BuildContext context) {
    final theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TText(
          'radius + bottom inset',
          textColor: theme.textColorSecondary,
          font: theme.fontBodyMedium,
        ),
        const SizedBox(height: 16),
        TButton(
          text: 'radius 默认',
          isBlock: true,
          theme: TButtonTheme.primary,
          size: TButtonSize.large,
          onTap: () => _showRadiusBottomPopup(context),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'radius 0',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusBottomPopup(context, radius: 0),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'radius 28',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusBottomPopup(context, radius: 28),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'center radius',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusCenterPopup(context),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'center r32',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusCenterPopup(context, radius: 32),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 更多 API


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiLifecycle(BuildContext context) {
    final theme = TTheme.of(context);
    return TButton(
      text: '生命周期',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
            height: 300,
            titleWidget: const TText('生命周期'),
            onOpen: () => _lifecycleToast(context, 'onOpen'),
            onOpened: () => _lifecycleToast(context, 'onOpened'),
            onClose: () => _lifecycleToast(context, 'onClose'),
            onClosed: () => _lifecycleToast(context, 'onClosed'),
            child: ColoredBox(
              color: theme.bgColorContainer,
              child: Center(
                child: TText(
                  '打开：onOpen → onOpened\n关闭：onClose → onClosed',
                  textColor: theme.textColorSecondary,
                  font: theme.fontBodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiCustomPosition(BuildContext context) {
    return TButton(
      text: 'right inset.top',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        final renderBox =
            navBarkey.currentContext!.findRenderObject() as RenderBox;
        TPopup.show(
          context,
          options: TPopupOptions.right(
            width: 280,
            inset: TPopupRightInset(top: renderBox.size.height),
            child: Container(
              color: TTheme.of(context).bgColorContainer,
            ),
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
      text: 'showOverlay false',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
              height: 280,
              overlay: const TPopupOverlayConfig(
                showOverlay: false,
                preventTap: true,
              ),
              // 不显示可见蒙层，但仍阻断背景交互；须保留其它关闭入口。
              titleWidget: const TText('透明模态'),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
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
          context,
          options: TPopupOptions.bottom(
              height: 260,
              onOverlayClick: () =>
                  TToast.showText('点击蒙层', context: context),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildApiDuration(BuildContext context) {
    return TButton(
      text: 'duration 600ms',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
              height: 240,
              animationDuration: const Duration(milliseconds: 600),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TPopup
#### 简介
弹出层入口：五向滑入 / 居中弹出，支持蒙层、bottom 操作区、center 面板外下方关闭区。
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
| `TPopupPlacement.bottom` | `headerBuilder`、`titleWidget`、`cancelBuilder`、`confirmBuilder` | `height`、`inset` |
| `TPopupPlacement.center` | `closeBuilder` | `width`、`height` |
| `TPopupPlacement.top` | — | `height`、`inset` |
| `TPopupPlacement.left`、`TPopupPlacement.right` | — | `width`、`inset` |
## Builder 三态（`headerBuilder`、`cancelBuilder`、`confirmBuilder`、`closeBuilder`）
| 传参方式 | 效果 |
|----------|------|
| 省略（使用默认值） | 渲染内置 UI |
| 显式 `null` | 隐藏该区域 |
| 自定义 `TPopupHeaderBuilder` / `TPopupSlotBuilder` | 完全替换；需自行提供交互与语义，可调用 `close` 关闭浮层 |
`titleWidget` 默认为 `null`，表示无标题内容。
生命周期回调见 `onOpen`、`onOpened`、`onClose`、`onClosed`、`onVisibleChange`；蒙层行为见 `overlay`（`TPopupOverlayConfig`）。

#### 工厂构造方法

##### 通用参数

以下参数由各命名工厂统一透传，含义一致：

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration | const Duration(milliseconds: 240) | 打开/关闭动画时长。 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 |
| child | Widget | - | 浮层主体内容（必填）。 |
| destroyOnClose | bool | false | 为 true 时路由 `maintainState` 为 false，关闭后不保留路由内 State。 |
| onClose | VoidCallback? | - | 开始关闭（与 `onVisibleChange` 的 `visible: false` 同期）。 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 |
| onOpen | VoidCallback? | - | 路由 push 时（打开动画开始前）。 |
| onOpened | VoidCallback? | - | 打开动画结束。 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置（可见遮罩、背景拦截、点击关闭、回调等）；为 null 时使用默认配置（标准模态弹层）。 |
| radius | double? | - | 内容区圆角，默认主题大圆角。 |
| useSafeArea | bool | true | 是否避让系统安全区，默认 true；top/bottom/left/right 贴边弹出时生效，center 使用完整安全区。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； 与 `inset` 在 top/bottom/left/right 上叠加。设为 false 可贴满屏幕边缘。 |


##### TPopupOptions.bottom

创建 `TPopupPlacement.bottom` 配置。
固定 `placement` 为 `TPopupPlacement.bottom`；默认带内置头部。
蒙层、动画、生命周期等字段语义见同名成员文档。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 |
| inset | TPopupBottomInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |
| headerBuilder | TPopupHeaderBuilder? | _kPopupDefaultHeader | bottom 头部；仅 `TPopupPlacement.bottom` 生效。三态见类文档「Builder 三态」。 自定义时忽略 `titleWidget`、`cancelBuilder`、`confirmBuilder`。 |
| titleWidget | Widget? | - | bottom 标题插槽；仅 `headerBuilder` 为内置默认时生效。`null` 表示无标题。 |
| cancelBuilder | TPopupSlotBuilder? | _kPopupDefaultCancel | bottom 左侧操作槽；仅 `headerBuilder` 为内置默认时生效。 内置默认为「取消」，点击触发 `TPopupTrigger.cancel`。 |
| confirmBuilder | TPopupSlotBuilder? | _kPopupDefaultConfirm | bottom 右侧操作槽；仅 `headerBuilder` 为内置默认时生效。 内置默认为「确定」，点击触发 `TPopupTrigger.confirm`。 |


##### TPopupOptions.center

创建 `TPopupPlacement.center` 配置。
固定 `placement` 为 `TPopupPlacement.center`；默认展示面板外下方圆形关闭按钮。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 |
| closeBuilder | TPopupSlotBuilder? | _kPopupDefaultClose | center 面板外下方关闭区；仅 `TPopupPlacement.center` 生效。三态见类文档「Builder 三态」。 内置默认点击触发 `TPopupTrigger.close`。 |


##### TPopupOptions.left

创建 `TPopupPlacement.left` 配置。
固定 `placement` 为 `TPopupPlacement.left`；未传 `width` 时布局默认宽度 280。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 |
| inset | TPopupLeftInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |


##### TPopupOptions.right

创建 `TPopupPlacement.right` 配置。
固定 `placement` 为 `TPopupPlacement.right`；未传 `width` 时布局默认宽度 280。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 |
| inset | TPopupRightInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |


##### TPopupOptions.top

创建 `TPopupPlacement.top` 配置。
固定 `placement` 为 `TPopupPlacement.top`；无内置头部。

其余参数见「通用参数」。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 |
| inset | TPopupTopInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration | const Duration(milliseconds: 240) | 打开/关闭动画时长。 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 |
| cancelBuilder | TPopupSlotBuilder? | _kPopupDefaultCancel | bottom 左侧操作槽；仅 `headerBuilder` 为内置默认时生效。 内置默认为「取消」，点击触发 `TPopupTrigger.cancel`。 |
| child | Widget | - | 浮层主体内容（必填）。 |
| closeBuilder | TPopupSlotBuilder? | _kPopupDefaultClose | center 面板外下方关闭区；仅 `TPopupPlacement.center` 生效。三态见类文档「Builder 三态」。 内置默认点击触发 `TPopupTrigger.close`。 |
| confirmBuilder | TPopupSlotBuilder? | _kPopupDefaultConfirm | bottom 右侧操作槽；仅 `headerBuilder` 为内置默认时生效。 内置默认为「确定」，点击触发 `TPopupTrigger.confirm`。 |
| destroyOnClose | bool | false | 为 true 时路由 `maintainState` 为 false，关闭后不保留路由内 State。 |
| headerBuilder | TPopupHeaderBuilder? | _kPopupDefaultHeader | bottom 头部；仅 `TPopupPlacement.bottom` 生效。三态见类文档「Builder 三态」。 自定义时忽略 `titleWidget`、`cancelBuilder`、`confirmBuilder`。 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 |
| inset | TPopupInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 |
| onClose | VoidCallback? | - | 开始关闭（与 `onVisibleChange` 的 `visible: false` 同期）。 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 |
| onOpen | VoidCallback? | - | 路由 push 时（打开动画开始前）。 |
| onOpened | VoidCallback? | - | 打开动画结束。 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置（可见遮罩、背景拦截、点击关闭、回调等）；为 null 时使用默认配置（标准模态弹层）。 |
| placement | TPopupPlacement | TPopupPlacement.bottom | 出现位置，默认 `TPopupPlacement.bottom`。 |
| radius | double? | - | 内容区圆角，默认主题大圆角。 |
| titleWidget | Widget? | - | bottom 标题插槽；仅 `headerBuilder` 为内置默认时生效。`null` 表示无标题。 |
| useSafeArea | bool | true | 是否避让系统安全区，默认 true；top/bottom/left/right 贴边弹出时生效，center 使用完整安全区。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； 与 `inset` 在 top/bottom/left/right 上叠加。设为 false 可贴满屏幕边缘。 |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 |


### TPopupHandle
#### 简介
`TPopup.show` 的返回值，用于控制同一份 `TPopupOptions` 的多次打开与关闭。
#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| navigatorContext | BuildContext? | - | 与 `TPopup.show` 的 `navigatorContext` 相同。 |
| options | TPopupOptions | - | 创建时传入的配置；每次 `open` 会按 `TPopupOptions.placement` 裁剪无效字段后使用。 |
| useRootNavigator | bool | - | 与 `TPopup.show` 的 `useRootNavigator` 相同。 |


### TPopupPlacement
#### 简介
浮层出现方向；决定 `TPopupOptions` 中哪些字段生效。
与 `TPopupOptions` 类文档中的「字段与 placement」表对应。
方向固定时请用 `TPopupOptions.bottom`、`TPopupOptions.center` 等命名工厂。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 自顶部滑入；使用 `TPopupOptions.height`、`TPopupOptions.inset`（`TPopupTopInset`）。 |
| left | 自左侧滑入；使用 `TPopupOptions.width`、`TPopupOptions.inset`（`TPopupLeftInset`）。 |
| right | 自右侧滑入；使用 `TPopupOptions.width`、`TPopupOptions.inset`（`TPopupRightInset`）。 |
| bottom | 自底部滑入；默认内置头部；使用 `TPopupOptions.height`、`TPopupOptions.inset`（`TPopupBottomInset`）。 |
| center | 屏幕居中；使用 `TPopupOptions.closeBuilder` 控制面板外下方关闭区。 |


### TPopupTrigger
#### 简介
浮层关闭或显隐变化时的触发来源。
作为 `TPopupVisibleChangeCallback` 的第二个参数，以及关闭流程中的语义标记。
内置控件会映射为 `TPopupTrigger.overlay`、`TPopupTrigger.cancel`、
`TPopupTrigger.confirm`、`TPopupTrigger.close`；
`TPopupHandle.close` 为 `TPopupTrigger.api`；系统返回为
`TPopupTrigger.systemBack`；`headerBuilder` 内调用 `close` 等为
`TPopupTrigger.custom`。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| overlay | 点击蒙层，且 `TPopupOverlayConfig.effectiveCloseOnClick` 为 true。 |
| cancel | 点击 bottom 取消语义槽位（含默认与自定义 `TPopupOptions.cancelBuilder`）。 |
| confirm | 点击 bottom 确认语义槽位（含默认与自定义 `TPopupOptions.confirmBuilder`）。 |
| close | 点击 center 关闭语义槽位（含默认与自定义 `TPopupOptions.closeBuilder`）。 |
| api | 外部 API 主动触发的显隐变化，如 `TPopupHandle.close` 或打开事件。 |
| systemBack | 系统返回键或系统路由返回触发的关闭。 |
| custom | 无框架预设动作语义的自定义关闭，如 `headerBuilder` 内调用 `close`。 |


  