# TPopup API 文档

## 简介

由其他控件触发，从屏幕边缘或中部滑出/弹出一块自定义内容区域。

**对外类：** `TPopup`、`TPopupHandle`  
**类型：** `TPopupPlacement`、`TPopupTrigger`

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

---

## 设计原则（按 placement）

| placement | 内置头部 / 关闭 | 自定义入口 |
|-----------|-----------------|------------|
| **bottom** | 操作栏：**取消 \| 标题 \| 确认**（默认渲染） | `cancel`/`confirm` 传 `null` 隐藏对应侧；`cancelBuilder` / `confirmBuilder`；`headerBuilder` 整块覆盖 |
| **top / left / right** | **无**内置头部 / 按钮区 | **仅 `child`** |
| **center** | **内置**内容面板外下方关闭按钮 | `closeBuilder: null` 隐藏；未传 / 自定义 `closeBuilder` |

**硬性约定：**

- **bottom 不使用** center 关闭参数（`closeBuilder` 等）。
- **center 不使用**底部操作栏（`onCancel` / `onConfirm` 等仅对 bottom 生效）。
- **top / left / right 不使用** `title`、`headerBuilder` 及一切头部参数（面板内需要的标题请做在 `child` 里）。

---

## placement 一览

### bottom（底部）

| 项 | 说明 |
|----|------|
| 动画 | 自下而上滑入 |
| 尺寸 | `height` 生效；`width` 忽略（横向铺满，`margin` 控制左右） |
| margin | `top / left / right / bottom`；`margin.top` 可做日历式距顶留白 |
| 圆角 | 仅上方两角 |

**头部（操作栏）**

`placement == bottom` 且未使用 `headerBuilder` 时 **默认渲染** 三栏（取消 \| 标题 \| 确认）。`onCancel` / `onConfirm` 可选；未传时点击仍默认关闭（`autoCloseOnCancel` / `autoCloseOnConfirm` 默认为 `true`）。

| 区域 | 默认 | 自定义 / 隐藏 |
|------|------|----------------|
| 左 | 文案「取消」 | `cancel` 自定义 Widget；**`cancel: null` 隐藏左侧** |
| 中 | `title` / `titleWidget`（可为空） | — |
| 右 | 文案「确定」 | `confirm` 自定义 Widget；**`confirm: null` 隐藏右侧** |

**无操作栏：** `cancel: null` 且 `confirm: null`（且无 `cancelBuilder` / `confirmBuilder`），例如 ActionSheet、Picker 自带工具栏的场景。

> `cancel` / `confirm` 参数默认值为内部占位 `kPopupActionDefault`（未传即默认文案）；与「未传参」不同，须显式写 `cancel: null` 才能隐藏。

**无头部：** `headerBuilder: null`（与未传 `kPopupDefaultHeader` 不同）。

**整块替换头部：** 自定义 `headerBuilder`（优先级最高，操作栏参数均不生效）。

```dart
TPopup.show(
  context: context,
  placement: TPopupPlacement.bottom,
  height: 320,
  title: '选择日期',
  onCancel: () => TPopup.close(context),
  onConfirm: () {
    TPopup.close(context);
  },
  child: calendarBody,
);
```

---

### top（顶部）

| 项 | 说明 |
|----|------|
| 动画 | 自上而下滑入 |
| 尺寸 | `height` 生效；`width` 忽略 |
| margin | `top / left / right` |
| 头部 | **无**（不使用 `title` / `headerBuilder`） |

---

### left / right（侧栏）

| 项 | left | right |
|----|------|-------|
| 动画 | 自左滑入 | 自右滑入 |
| 尺寸 | `width` 生效（默认 280）；`height` 忽略 | 同左 |
| margin | `left / top / bottom` | `right / top / bottom` |
| 头部 | **无**（仅 `child`） | 同左 |

---

### center（居中）

| 项 | 说明 |
|----|------|
| 动画 | 缩放（非位移） |
| 尺寸 | `width`、`height` 约束**白色内容区**；有关闭区时按钮在面板外下方额外占位 |
| margin | 不参与定位 |

**关闭区（三态 `closeBuilder`）**

| 写法 | 含义 |
|------|------|
| 不传 `closeBuilder` | 默认 `kPopupDefaultClose` → 显示内置圆圈关闭图标 |
| `closeBuilder: null` | **不显示**关闭区 |
| 自定义 `closeBuilder: (ctx, close) => ...` | 自定义关闭控件；应调用 `close` 关闭（会触发 `onCloseBtn`） |

| 参数 | 默认 | 说明 |
|------|------|------|
| `onCloseBtn` | null | 点击关闭控件时回调（在自动关闭前） |

**内置布局（center 且 `closeBuilder` 非 null，无对外开关）：**

```text
[上间距 40]
[白底内容面板  ← width × height]
[间距 24]
[关闭按钮  ← 蒙层上，非面板内]
```

> 不提供「面板右上角 X」；若需要角标关闭，请在 `child` 内自建。

```dart
TPopup.show(
  context: context,
  placement: TPopupPlacement.center,
  width: 280,
  height: 200,
  closeBuilder: (ctx, close) => IconButton(
    icon: Icon(TIcons.close_circle, color: TTheme.of(ctx).fontWhColor1),
    onPressed: close,
  ),
  child: dialogBody,
);

// 无关闭区
TPopup.show(
  context: context,
  placement: TPopupPlacement.center,
  closeBuilder: null,
  child: alertBody,
);
```

---

## 生命周期回调顺序

| 阶段 | 回调 | 说明 |
|------|------|------|
| 路由入栈 | `onOpen` | `didPush` 时 |
| 变为可见 | `onVisibleChange(true, programmatic)` | 与打开方式无关，均为 `programmatic` |
| 打开动画结束 | `onOpened` | 动画 `completed` |
| 开始关闭 | `onClose` + `onVisibleChange(false, trigger)` | `trigger` 见 `TPopupTrigger` |
| 关闭动画结束 | `onClosed` | 路由移除且动画 `dismissed` |

关闭触发：`overlay` / `cancelBtn` / `confirmBtn` / `closeBtn` / `programmatic`（含系统返回、`handle.close`、`TPopup.close`）。

---

## Widget 与 Builder 怎么选

| 类型 | 签名 | 何时创建 | 适用 |
|------|------|----------|------|
| **Widget** | `Widget? cancel` | 调用 `show` 时 | 完全静态 |
| **Builder** | `WidgetBuilder? cancelBuilder` | Popup `build` 时 | **推荐**：主题、国际化 |

**优先级（同一槽位）：**

```text
xxxBuilder > xxx (Widget) > 内置默认 UI
```

| 槽位 | Builder（推荐） | Widget |
|------|-----------------|--------|
| 底部取消 | `cancelBuilder` | `cancel` |
| 底部确认 | `confirmBuilder` | `confirm` |
| 居中关闭 | `closeBuilder(ctx, close)` | — |
| 整块头部（仅 bottom） | `headerBuilder` | — |

---

## TPopup.show（命令式）

返回 [TPopupHandle]；优先使用 `handle.close()`，或在 Popup 子树内使用 `TPopup.close(context)`。

`cancel` / `confirm` 默认 `kPopupActionDefault` 表示默认文案；显式 `null` 隐藏对应侧。

### 关闭行为

- **`TPopup.close(context)`**：仅关闭当前 Navigator 上 Tracker **栈顶**且正在展示的 Popup；无 Popup 时**不操作**（不会 `maybePop` 当前页）。
- **嵌套 Popup**：每次 `close` 只关最上层；`navigatorContext` / `useRootNavigator` 须与 `show` 一致。
- **外层重复 `show`**：同一按钮在页面 context 上连点第二次无效（返回同一 handle）；Popup 路由内可再 `show` 嵌套一层。

### 动画

`duration` 同时用于打开与关闭过渡（默认 240ms）。

---

## 参数表（摘要）

### 通用

| 名称 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| child | Widget | - | 浮层主体（必填） |
| placement | TPopupPlacement | bottom | top / left / right / bottom / center |
| width | double? | - | left / right / center |
| height | double? | - | top / bottom；center 有关闭区时约束白底内容区 |
| margin | EdgeInsets? | zero | center 忽略 |
| showOverlay | bool | true | 半透明遮罩 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭 |
| overlayColor | Color? | black54 | 蒙层颜色 |
| overlayOpacity | double? | - | 与 `overlayColor` 的 alpha 相乘 |
| preventScrollThrough | bool | true | 拦截底层滚动 |
| destroyOnClose | bool | false | Popup 路由 `maintainState = false`；不销毁声明式 `TPopup` 的 State |
| duration | Duration | 240ms | 开、关动画时长一致 |
| onOpen / onOpened / onClose / onClosed | VoidCallback? | - | 生命周期 |
| onVisibleChange | (bool, TPopupTrigger)? | - | 显隐及触发来源 |

### bottom 专用

`title`、`cancel`/`confirm`、`cancelBuilder`/`confirmBuilder`、`headerBuilder`（`null` 无头，未传默认操作栏）。

### center 专用

`closeBuilder`（三态）、`onCloseBtn`。

---

## Header / 关闭 优先级

**bottom：**

```text
headerBuilder: null     →  无头部
未传 headerBuilder     →  默认操作栏 / 仅标题行
自定义 headerBuilder   →  整块自定义
```

**center：**

```text
closeBuilder: null           →  仅内容区
未传 closeBuilder            →  默认面板外下方关闭（kPopupDefaultClose）
自定义 closeBuilder          →  自定义控件，仍在面板外下方槽位
```

---

## TPopupHandle

```dart
void close([Object? result]);
bool get isShowing;
```

---

## 声明式 TPopup

```dart
TPopup(
  initialVisible: false,
  placement: TPopupPlacement.bottom,
  child: ...,
  // 参数与 show 一致
)
```

`build` 仅渲染 `child`；弹层在独立路由中。不支持受控 `visible`。

---

## 迁移对照

| 旧 API | 新 API |
|--------|--------|
| TSlidePopupRoute | TPopup.show |
| SlideTransitionFrom | TPopupPlacement |
| TPopupBottomConfirmPanel | onCancel / onConfirm + title |
| TPopupCenterPanel | placement: center + closeBuilder 三态 |
| modalTop | margin.top（bottom） |

---

## 备注

- 不提供键盘避让、`zIndex`、拖拽半屏、受控 `visible`。
- 国际化：操作栏默认文案来自 `context.resource`。
- 无障碍：蒙层语义标签；bottom 操作栏与 center 关闭带 `Semantics(button: true)`。
- API 文档生成：源码 `///` 为唯一真相；运行 `demo_tool/all_build.sh` 中 popup 段生成 `example/assets/api/popup_api.md`。
