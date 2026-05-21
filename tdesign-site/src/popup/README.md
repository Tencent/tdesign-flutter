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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.top,
              height: 240,
              onOpen: () => print('open'),
              onOpened: () => print('opened'),
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.left,
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.center,
              closeBuilder: null,
              child: Container(
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius:
                      BorderRadius.circular(TTheme.of(context).radiusLarge),
                ),
                width: 240,
                height: 240,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 240,
              headerBuilder: null,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.right,
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 280,
              title: '标题文字',
              onConfirm: () => TToast.showText('确定', context: context),
              child: Container(height: 200)),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
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
              child: Container(height: 200)),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.center,
              closeOnOverlayClick: false,
              width: 240,
              height: 240,
              closeBuilder: (_, close) => IconButton(
                    icon: Icon(
                      TIcons.close_circle,
                      color: TTheme.of(context).fontWhColor1,
                      size: 32,
                    ),
                    onPressed: close,
                  ),
              child: const SizedBox(width: 240, height: 240)),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.center,
              closeOnOverlayClick: true,
              width: 240,
              height: 200,
              closeBuilder: (_, close) => IconButton(
                    icon: Icon(
                      TIcons.poweroff,
                      color: TTheme.of(context).fontWhColor1,
                      size: 36,
                    ),
                    onPressed: close,
                  ),
              child: Container(
                width: 240,
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNestedPopup(BuildContext context) {
    return TButton(
      text: '内层再弹一层（嵌套叠加）',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopupHandle? outerHandle;
        outerHandle = TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
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
                          text: '打开内层 Popup',
                          isBlock: true,
                          theme: TButtonTheme.primary,
                          size: TButtonSize.large,
                          onTap: () {
                            TPopup(
                              options: TPopupOptions(
                                placement: TPopupPlacement.bottom,
                                height: 280,
                                title: '内层标题',
                                child: Container(
                                  height: 160,
                                  color: TTheme.of(innerContext)
                                      .bgColorSecondaryContainer,
                                ),
                              ),
                            ).show(innerContext);
                          },
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          text: '关闭外层',
                          isBlock: true,
                          type: TButtonType.outline,
                          size: TButtonSize.large,
                          onTap: () => outerHandle?.close(),
                        ),
                      ],
                    ),
                  );
                },
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 320,
              margin: const EdgeInsets.only(top: 120, left: 16, right: 16),
              title: '日历式留白',
              child: Container(
                height: 240,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 280,
              showOverlay: false,
              // 无蒙层时无法点遮罩关闭，须保留操作栏取消（或其它关闭入口）
              title: '无蒙层',
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 260,
              onOverlayClick: () => TToast.showText('点击蒙层', context: context),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 240,
              duration: const Duration(milliseconds: 600),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TPopup
#### 简介
弹出层：五向滑入 / 居中弹出，支持蒙层、bottom 操作栏、center 下方关闭。

 ## 怎么用

 **命令式（推荐）** — 先组配置，再 `show`，用返回的 [TPopupHandle] 关闭：

 ```dart
 final handle = TPopup(
   options: TPopupOptions(
     placement: TPopupPlacement.bottom,
     title: '标题',
     child: MyPanel(),
   ),
 ).show(context);

 // 关闭这一层（须保留 handle，不要用 context 猜栈顶）
 handle.close();
 ```

 **声明式** — 包住子树，`initialVisible: true` 时首帧自动 [show]；[build] 只渲染 [options.child]：

 ```dart
 TPopup(
   options: TPopupOptions(child: body),
   initialVisible: true,
 )
 ```

 字段说明见 [TPopupOptions]；按 [TPopupPlacement] 只有部分参数生效（无效参数会在
 [TPopupOptions.normalized] 中裁掉）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| initialVisible | bool | false | 为 true 时，挂载后首帧自动调用 [show]（仅声明式）。 |
| key |  | - |  |
| navigatorContext | BuildContext? | - | 指定使用哪个 [Navigator]；默认 [show] 传入的 `context` 所在 Navigator。 |
| options | TPopupOptions | - | 浮层内容与行为配置，见 [TPopupOptions]。 |
| useRootNavigator | bool | false | 为 true 时使用根 [Navigator]（嵌套导航场景）。 |

```
```

### TPopupOptions
#### 简介
浮层配置：[TPopup] 构造与 [TPopup.show] 的唯一参数来源。

 ## 按 [placement] 用哪些字段

 | placement | 常用字段 |
 |-----------|----------|
 | [TPopupPlacement.bottom] | `title` / `cancel` / `confirm` / `headerBuilder`、`height`、`margin` |
 | [TPopupPlacement.center] | `closeBuilder`、`width`、`height`（有下方关闭时） |
 | [TPopupPlacement.top] / [left] / [right] | 主要 `child`、`margin`、方向对应 `width` 或 `height` |

 传给其它 placement 的 bottom / center 专用字段会在 [normalized] 里裁掉。

 ## 三态占位（bottom / center）

 - **未传参数**：使用默认 UI（如默认取消/确定文案、默认关闭图标）。
 - **显式 `null`**：隐藏该槽位（如 `cancel: null` 隐藏左侧；`closeBuilder: null` 无关闭按钮）。
 - **自定义 Widget / Builder**：完全自定义该区域。

 [TPopup.show] 内部会先 [normalized] 再绘制。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoCloseOnCancel | bool | true | 点击取消后是否自动关闭，默认 true。 |
| autoCloseOnConfirm | bool | true | 点击确定后是否自动关闭，默认 true。 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 |
| cancel | Widget? | kPopupActionDefault | bottom 左侧按钮；默认 [kPopupActionDefault] 表示默认文案，传 null 隐藏左侧。 |
| cancelBtn | String? | - | bottom 左侧按钮文案，覆盖默认「取消」。 |
| cancelBuilder | WidgetBuilder? | - | bottom 左侧按钮构建器，优先级高于 [cancel]。 |
| child | Widget | - | 浮层主体内容（必填）。 |
| closeBuilder | TPopupCloseBuilder? | kPopupDefaultClose | center 关闭区：`null` 不显示；未传则用 [kPopupDefaultClose]；bottom 与三边忽略。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭（须 [showOverlay] 为 true）。 |
| confirm | Widget? | kPopupActionDefault | bottom 右侧按钮；默认 [kPopupActionDefault]，传 null 隐藏右侧。 |
| confirmBtn | String? | - | bottom 右侧按钮文案，覆盖默认「确定」。 |
| confirmBuilder | WidgetBuilder? | - | bottom 右侧按钮构建器，优先级高于 [confirm]。 |
| destroyOnClose | bool | false | 为 true 时 Popup 路由 maintainState 为 false，关闭后不保留路由内 State。 |
| duration | Duration | const Duration(milliseconds: 240) | 打开与关闭动画时长（一致）。 |
| headerBuilder | TPopupHeaderBuilder? | kPopupDefaultHeader | bottom 头部：`null` 无头部；未传则用 [kPopupDefaultHeader]；自定义见 [TPopupHeaderBuilder]。 |
| height | double? | - | 高度；对 top、bottom 生效；center 且下方关闭时约束内容区高度。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距；center 忽略。bottom 的 top 可用来做日历式距顶留白。 |
| onCancel | VoidCallback? | - | 点击 bottom 左侧按钮回调。 |
| onClose | VoidCallback? | - | 开始关闭时回调。 |
| onCloseBtn | VoidCallback? | - | center 点击关闭控件前的回调。 |
| onClosed | VoidCallback? | - | 关闭动画结束且路由移除后回调。 |
| onConfirm | VoidCallback? | - | 点击 bottom 右侧按钮回调。 |
| onOpen | VoidCallback? | - | 开始打开时回调（路由入栈）。 |
| onOpened | VoidCallback? | - | 打开动画结束后回调。 |
| onOverlayClick | VoidCallback? | - | 点击蒙层时回调（在是否关闭判断之前）。 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化及触发来源。 |
| overlayColor | Color? | - | 蒙层颜色，默认 black54。 |
| overlayOpacity | double? | - | 蒙层透明度系数（0–1），与 [overlayColor] 的 alpha 相乘后用于绘制。 |
| placement | TPopupPlacement | TPopupPlacement.bottom | 出现位置，默认 [TPopupPlacement.bottom]。 |
| preventScrollThrough | bool | true | 是否拦截底层滚动；无蒙层时用透明层吸收滚动。 |
| radius | double? | - | 内容区圆角，默认主题大圆角。 |
| showOverlay | bool | true | 是否绘制半透明蒙层；为 false 时须保留其它关闭入口。 |
| title | String? | - | bottom 操作栏中间标题文案。 |
| titleAlignLeft | bool | false | bottom 仅标题行时是否左对齐，默认居中。 |
| titleWidget | Widget? | - | bottom 操作栏中间标题组件，优先级高于 [title]。 |
| width | double? | - | 宽度；对 left、right、center 生效。 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| isActionDefault |  |   required Widget? action, |  |

```
```

### TPopupHeaderData
#### 简介
传给自定义 [TPopupOptions.headerBuilder] 的标题栏数据（库内已组装好各槽 Widget）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancel | Widget? | - | 左侧区域 Widget（null 表示该侧已隐藏）。 |
| confirm | Widget? | - | 右侧区域 Widget（null 表示该侧已隐藏）。 |
| onCancel | VoidCallback? | - | 点击左侧区域时回调（是否关闭由 [TPopupOptions.autoCloseOnCancel] 决定）。 |
| onConfirm | VoidCallback? | - | 点击右侧区域时回调（是否关闭由 [TPopupOptions.autoCloseOnConfirm] 决定）。 |
| title | Widget? | - | 中间标题（可为 null）。 |


  