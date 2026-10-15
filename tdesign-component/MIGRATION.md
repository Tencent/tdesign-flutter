<!-- Generated from tdesign-site/site/docs/migration-0.2.7-to-1.0.md; do not edit this copy. -->

# 从 0.2.7 升级到 1.0

本文仅面向 `tdesign_flutter 0.2.7` 使用方。1.0 是不兼容升级，旧参数和旧行为不会通过兼容别名保留；不能对全项目执行一次 `TD` → `T` 替换后就认为迁移结束。

升级时将依赖更新为 `tdesign_flutter: ^1.0.0`。本文仅说明 0.2.7 到 1.0 的迁移；alpha 版本之间的升级不在本文范围。

已有具体组件需要迁移时，可直接跳到[按组件查找迁移方式](#migration-components)；首次升级建议先按下面的顺序处理公共配置。

## 升级顺序

1. 保留当前依赖锁文件、主题 JSON 与关键页面截图；先在业务分支迁移。
2. 升级到 Flutter ≥3.32.0、Dart ≥3.8.0。原生平台要求还受所解析的 Flutter/图片选择器实现包约束，按目标 SDK 构建验证。
3. 先替换公共主题/文字与导入，再迁移基础组件，最后迁移选择器、表单、浮层和异步交互。
4. 修复全部编译错误后，按本文的行为清单验证真实操作。默认视觉和回调行为变化不一定产生编译错误。

统一入口可同时提供 TD 与 Flutter Material 类型：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

仍可显式导入 Material；业务另有同名类型时用 import 前缀或 show/hide 解决。不要从 `package:tdesign_flutter/src/...` 导入旧 State、Painter 或内部适配类型。

## 先判断需要做哪些工作

**先处理公共配置。** 升级依赖和SDK后，先迁移导入、主题和文字，再处理实际使用的组件。

**参数或状态变化，需要改写调用处。** 按钮内容与回调、复选框受控值和输入控制器不能只替换类名。先看具体改法，再核对组件API。

**交互职责变化，需要重组业务流程。** Form、Picker/日期确认、浮层、Upload、页签和轮播，需要检查状态、提交/取消及资源释放，不能仅以编译通过作为完成标准。

尚未逐项确认的业务用法应继续核对API和真实操作，不归为“只改名即可”。下面索引用于查找，具体改法解释主要场景，完整API不在本文重复列出。

### 直接查看主要改法

- [主题、文字与样式](#migration-theme)
- [按钮与禁用语义](#migration-button)
- [受控值、输入与选择](#migration-controlled)
- [表单改为字段树](#migration-form)
- [Picker、日期与浮层确认分离](#migration-picker)
- [Popup、Dialog、Toast](#migration-overlay)
- [Upload 与平台依赖](#migration-upload)
- [两种 TabBar 与 Swiper](#migration-tabs)

<a id="migration-components"></a>
## 按组件查找迁移方式

只需要迁移项目中实际使用的组件。先搜索代码中的旧类名，例如 `TDButton`，再按下面的分类找到它。分组默认收起，展开后查看对应入口和提示。

1. **找对应入口**：每项先列出“0.2.7旧入口 → 1.0入口”，用于定位新组件。
2. **完成用法调整**：阅读“需要调整”，并结合下方具体改法修改参数、数据和回调；箭头不表示只改类名就能完成迁移。
3. **核对当前用法**：点击组件名称进入1.0 API文档，再验证真实操作、主题及布局。

例如，搜索到 `TDButton` 时，先看[按钮与禁用语义](#migration-button)，把文字和点击回调迁到新的内容槽与回调，再查看按钮API。不要仅把它改名为 `TButton` 后就结束。

### 选择你正在迁移的组件

- [主题与全局配置](#migration-group-global)（1项）
- [按钮、文字与基础组件](#migration-group-basic)（6项）
- [页面导航与页签](#migration-group-navigation)（8项）
- [表单、输入与选择](#migration-group-input)（16项）
- [内容与数据展示](#migration-group-display)（15项）
- [浮层、提示与交互反馈](#migration-group-feedback)（11项）

查找旧枚举、Controller、State等辅助类型时，使用文末的[旧类型名称对照](#migration-legacy-types)。该附录用于定位处置方向，组件迁移优先按下面的分组进行。

<a id="migration-group-global"></a>
<details>
<summary>主题与全局配置</summary>


先处理全局主题，再迁移各组件的局部样式。

<a id="migration-component-theme"></a>
- **[Theme 主题](https://tdesign.tencent.com/flutter/components/theme?tab=api)**：`TDTheme / TDThemeData` → `context.tTheme / TThemeData / TThemeBuilder`。

  **需要调整**：`TDTheme.of(context)` → `context.tTheme`；应用用 `TThemeBuilder.light/dark(TThemeData)`。全局 Token、组件 Theme 和实例配置分层，Material 主题不反向改变 TD 内置外观；旧文字全局开关改为局部 Theme/实例/布局。 [查看相关改法](#migration-theme)

</details>

<a id="migration-group-basic"></a>
<details>
<summary>按钮、文字与基础组件</summary>


从页面上常用的按钮、文字、图标等开始，核对内容槽和样式配置。

<a id="migration-component-button"></a>
- **[Button 按钮](https://tdesign.tencent.com/flutter/components/button?tab=api)**：`TDButton` → `TButton`。

  **需要调整**：`text` → `child: Text(...)`，`onTap` → `onPressed`，`type/theme` → `variant/colorPreset`。删除 `disabled` 后用空回调禁用；旧三套状态样式合并为 `ButtonStyle`，图标改传 Widget。 [查看相关改法](#migration-button)

<a id="migration-component-divider"></a>
- **[Divider 分割线](https://tdesign.tencent.com/flutter/components/divider?tab=api)**：`TDDivider` → `TDivider`。

  **需要调整**：`text/widget` 合并为 `child`，`direction` → `layout`，`alignment` → `align`，`isDashed` → `dashed`。线色、粗细、间隔使用 `TDividerThemeData`；旧 `margin` 改由外层 Padding 表达，不能原样搬入构造。

<a id="migration-component-fab"></a>
- **[Fab 悬浮按钮](https://tdesign.tencent.com/flutter/components/fab?tab=api)**：`TDFab` → `TFab`。

  **需要调整**：`onClick` → `onPressed`，`icon` 改传 Widget。旧 `size/shape/theme` 没有对应实例参数；默认动作按当前内置规格展示，完整自定义使用 `child`，拖动边界使用 `xBounds/yBounds`。

<a id="migration-component-icon"></a>
- **[Icon 图标](https://tdesign.tencent.com/flutter/components/icon?tab=api)**：`TDIcons / Icon` → `TIcons / TIcon`。

  **需要调整**：图标数据使用外部包 `tdesign_flutter_icons` 导出的 `TIcons`，展示使用 `TIcon(TIcons.add, size: ..., color: ...)`。在当前依赖0.0.6中，`TDIcons.list/video_camera_3/video_camera_3_filled` 没有同名新常量；旧 all Map 改为 `TIcons.allIconsMap`，键名也需核对。图标字体及 Widget 的迁移不能仅替换类名前缀。

<a id="migration-component-link"></a>
- **[Link 链接](https://tdesign.tencent.com/flutter/components/link?tab=api)**：`TDLink` → `TLink`。

  **需要调整**：字符串内容改为 `child: Text(...)`，事件使用 `onPressed`，前后图标用 `prefixIcon/suffixIcon`。旧样式及状态配置改为 `TLinkThemeData`、`size/colorPreset/underline`，不再传旧 `TDLinkStyle`。

<a id="migration-component-text"></a>
- **[Text 文本](https://tdesign.tencent.com/flutter/components/text?tab=api)**：`TDText / TDTextSpan` → `TText / TTextSpan`。

  **需要调整**：`textColor/fontWeight/fontFamily` 合并为 `style`，`textScaleFactor` → `textScaler`。删除字体 padding 与全局强制居中开关；通过父布局和文字 Theme 表达，不恢复旧全局变量。 [查看相关改法](#migration-theme)

</details>

<a id="migration-group-navigation"></a>
<details>
<summary>页面导航与页签</summary>


重点区分顶部页签、底部导航以及各自的控制器和受控值。

<a id="migration-component-back-top"></a>
- **[BackTop 返回顶部](https://tdesign.tencent.com/flutter/components/back-top?tab=api)**：`TDBackTop` → `TBackTop`。

  **需要调整**：`onClick` → `onPressed`；绑定 `ScrollController` 时组件可执行回顶，无控制器时由回调实现。使用 `shape/colorPreset/showText/visibilityOffset`；旧视觉样式迁到 `TBackTopThemeData`。

<a id="migration-component-drawer"></a>
- **[Drawer 抽屉](https://tdesign.tencent.com/flutter/components/drawer?tab=api)**：`TDDrawer / TDDrawerWidget` → `TDrawer / showTDrawer`。

  **需要调整**：内容用 `TDrawer(items: ..., title: ..., footer: ...)`，打开浮层用 `showTDrawer` 并保留返回句柄。旧 `TDDrawerWidget` 不再单独实例化；方向用 `TDrawerPlacement`，样式按 `TDrawerThemeData` 配置。

<a id="migration-component-indexes"></a>
- **[Indexes 索引](https://tdesign.tencent.com/flutter/components/indexes?tab=api)**：`TDIndexes` → `TIndexes`。

  **需要调整**：提供 `indexList` 与必填 `builderContent`；`initialIndex` 仅用于初始定位，不是受控 `value`。滚动接入 `scrollController`，通过 `onChanged/onSelect` 获取通知；外观使用 `TIndexesThemeData`。

<a id="migration-component-navbar"></a>
- **[Navbar 导航栏](https://tdesign.tencent.com/flutter/components/navbar?tab=api)**：`TDNavBar` → `TNavBar`。

  **需要调整**：`title/titleWidget` 合并为 Widget `title`，`leftBarItems/rightBarItems` 改为 `leading/actions` 的 `TNavBarItem`。返回按钮由 `useDefaultBack/onBack` 表达；背景、颜色、边线和阴影使用 `TNavBarThemeData`，高度与安全区仍按实例配置。

<a id="migration-component-side-bar"></a>
- **[SideBar 侧边栏](https://tdesign.tencent.com/flutter/components/side-bar?tab=api)**：`TDSideBar` → `TSideBar`。

  **需要调整**：去掉 `TDSideBarController.selectTo`，由必填 `value` 和 `onChanged` 管理选择；数据改为 `children: List<TSideBarItem>`。旧控制器加载状态迁到 `loading/loadingWidget`，尺寸仍按 `width/height` 配置。

<a id="migration-component-steps"></a>
- **[Steps 步骤条](https://tdesign.tencent.com/flutter/components/steps?tab=api)**：`TDSteps` → `TSteps.progress / selectable / display`。

  **需要调整**：先选 `TSteps.progress`、`selectable` 或 `display`。步骤数据使用 `TStepsItemData`，旧 `activeIndex` 改为 `value`；前两种模式由 `value` 持有当前索引，选择模式必须提供 `onChange`，展示模式不接选择状态。

<a id="migration-component-tab-bar"></a>
- **[TabBar 标签栏](https://tdesign.tencent.com/flutter/components/tab-bar?tab=api)**：`TDBottomTabBar` → `TTabBar`。

  **需要调整**：提供必填 `type/navigationTabs/value`，在 `onChanged` 回写索引；旧 basic/component/outline 三种配置分别核对 `type/itemStyle/style`。徽标使用 `TBadgeConfig`；旧 expansionPanel 和弹出菜单配置无直接替代。 [查看相关改法](#migration-tabs)

<a id="migration-component-tabs"></a>
- **[Tabs 选项卡](https://tdesign.tencent.com/flutter/components/tabs?tab=api)**：`TDTabBar / TDTabBarView` → `TTabsBar / TTabsBarView`。

  **需要调整**：顶部页签使用 `TTabsBar(tabs: ...)` 和 `TTabsBarView(children: ...)`，共享 `TabController` 或 `DefaultTabController`。旧 `isSlideSwitch` 改为显式 `physics`；不要迁成底部导航 `TTabBar`。 [查看相关改法](#migration-tabs)

</details>

<a id="migration-group-input"></a>
<details>
<summary>表单、输入与选择</summary>


先确认值由谁持有，再处理回调、表单校验和确认/取消流程。

<a id="migration-component-calendar"></a>
- **[Calendar 日历](https://tdesign.tencent.com/flutter/components/calendar?tab=api)**：`TDCalendar` → `TCalendar`。

  **需要调整**：必填 `value` 为 `List<DateTime>`，`variant` 决定单选/多选/区间，`onChanged` 回写。`minDate/maxDate` 管边界；旧 `TDCalendarPopup` 改用 `TPopup + TCalendar`，旧 builder/样式按当前具名回调与 Theme 重写。 [查看相关改法](#migration-picker)

<a id="migration-component-cascader"></a>
- **[Cascader 级联选择器](https://tdesign.tencent.com/flutter/components/cascader?tab=api)**：`TDCascader / TDMultiCascader` → `TCascader`。

  **需要调整**：旧 Map 数据改为 `TCascaderOption` 树，受控 `value` 是一条 `List<Object?>` 路径。旧 `TDMultiCascader` 的 multi 表示多级，回调中的逐层模型需转为 value 路径；旧自动关闭、字母排序和 Tab/Action 扩展改由业务处理，不能把它理解为多选开关。

<a id="migration-component-checkbox"></a>
- **[CheckBox 多选框](https://tdesign.tencent.com/flutter/components/checkbox?tab=api)**：`TDCheckbox / TDCheckboxGroup` → `TCheckbox / TCheckboxGroup`。

  **需要调整**：单项使用必填 `value` 和 `onChanged`，空回调禁用；组使用 `options` 和受控 `List<T>`。旧 `checked/id/controller` 不再作为状态源；自定义图标使用 `customIconBuilder`，组内容使用 `itemBuilder`。 [查看相关改法](#migration-controlled)

<a id="migration-component-date-time-picker"></a>
- **[DateTimePicker 时间选择器](https://tdesign.tencent.com/flutter/components/date-time-picker?tab=api)**：`TDDatePicker` → `TDateTimePicker`。

  **需要调整**：`DatePickerModel` 改为 `TDateTimePickerValue`，按 `DateTimePickerMode` 设置日期/时间列；边界用 `start/end`，步进用 `steps`。组件只选择，不提交业务结果；确认/取消在外部浮层管理。 [查看相关改法](#migration-picker)

<a id="migration-component-form"></a>
- **[Form 表单](https://tdesign.tencent.com/flutter/components/form?tab=api)**：`TDForm / FormController` → `TForm / TFormField / TFormController`。

  **需要调整**：旧 `items/rules/data` 改为 `TForm(child: ...)` 字段树；每个 `TFormField` 提供 `name/value/builder`，校验用 `required/validator`。`TFormController` 负责表单命令，不能继续传旧 `TDFormValidation` 列表。 [查看相关改法](#migration-form)

<a id="migration-component-input"></a>
- **[Input 输入框](https://tdesign.tencent.com/flutter/components/input?tab=api)**：`TDInput` → `TInput`。

  **需要调整**：`controller` 与 `initialValue` 互斥，`onChanged` 通知业务；占位用 `hintText`，插槽用 `prefix/suffix`。旧 `TDInputType` 是布局枚举，不对应 `TextInputType`；多行、卡片或附加布局分别用 `TTextarea`、Theme 和外层组合。 [查看相关改法](#migration-controlled)

<a id="migration-component-picker"></a>
- **[Picker 选择器](https://tdesign.tencent.com/flutter/components/picker?tab=api)**：`TDPicker / TDMultiPicker / TDMultiLinkedPicker` → `TPicker + TPickerColumns / TPickerLinked`。

  **需要调整**：列数据改为 `TPickerColumns` 或 `TPickerLinked`，每项是不可变 `TPickerOption`；当前值是 `List<Object?>`。旧 `TDPicker.show*` 把弹层和确认合在一起，1.0 用 `TPickerPopup` 外部组合草稿/确认/取消。实时选择用 `onChanged`，通用 Picker 的列停止滚动通知用 `onColumnScrollEnd`，两者不能当成同一触发时机。 [查看相关改法](#migration-picker)

<a id="migration-component-radio"></a>
- **[Radio 单选框](https://tdesign.tencent.com/flutter/components/radio?tab=api)**：`TDRadio / TDRadioGroup` → `TRadio / TRadioGroup<T>`。

  **需要调整**：单项 `TRadio<T>(value: ...)` 必须位于同类型 `TRadioGroup<T>` 下；选中值和 `onChanged` 在组上管理。数据化入口用 `TRadioGroup.options`，不再为每项保存 checked 或持有旧 State。 [查看相关改法](#migration-controlled)

<a id="migration-component-rate"></a>
- **[Rate 评分](https://tdesign.tencent.com/flutter/components/rate?tab=api)**：`TDRate` → `TRate`。

  **需要调整**：使用必填 `double value`、`onChanged` 和 `allowHalf`，`count` 为总星数。1.0 没有独立 readOnly 参数，空回调表示不可交互；图标构建使用 `icon`，文字用 `texts`，不要直接搬旧指示器位置枚举。

<a id="migration-component-search"></a>
- **[Search 搜索框](https://tdesign.tencent.com/flutter/components/search?tab=api)**：`TDSearchBar` → `TSearchBar`。

  **需要调整**：`placeHolder/onTextChanged/onActionClick` 分别改为 `hintText/onChanged/onActionPressed`。用 `actionText` 定义操作文字；`controller` 与 `initialValue` 不可同时配置，自动聚焦用 `autofocus`。旧 `TDSearchStyle` 改按 Theme 和实例形态配置。

<a id="migration-component-slider"></a>
- **[Slider 滑动选择器](https://tdesign.tencent.com/flutter/components/slider?tab=api)**：`TDSlider / TDRangeSlider` → `TSlider / TRangeSlider`。

  **需要调整**：单值用 `TSlider(value: double)`，区间用 `TRangeSlider(value: RangeValues)`；空 `onChanged` 禁用。用 `variant` 选择普通/胶囊，格式化用 `thumbFormatter/scaleFormatter`；旧 Track/Thumb 类和 mixin 无公开继承替代。

<a id="migration-component-stepper"></a>
- **[Stepper 步进器](https://tdesign.tencent.com/flutter/components/stepper?tab=api)**：`TDStepper` → `TStepper`。

  **需要调整**：提供必填 `value`，在 `onChanged` 接受候选数值后重建；边界和步长用 `min/max/step`。旧 `defaultValue/eventController` 不再有效，空回调表示禁用；自建状态不应再与控制器双向通知。 [查看相关改法](#migration-controlled)

<a id="migration-component-switch"></a>
- **[Switch 开关](https://tdesign.tencent.com/flutter/components/switch?tab=api)**：`TDSwitch` → `TSwitch`。

  **需要调整**：提供必填 `value` 并在 `onChanged` 回写，空回调禁用；旧 fill 改为 `TSwitchVariant.filled`，text/icon 按同名 variant；旧 loading 形态改为 `loading: true`。`loading` 表达加载状态，文字用 `openText/closeText`；具体配色从 `TSwitchThemeData` 配置。 [查看相关改法](#migration-controlled)

<a id="migration-component-textarea"></a>
- **[Textarea 多行文本框](https://tdesign.tencent.com/flutter/components/textarea?tab=api)**：`TDTextarea` → `TTextarea`。

  **需要调整**：保留多行组件职责，用 `minLines/maxLines`、`controller` 或 `initialValue` 和 `onChanged`。旧装饰、标签样式与 padding 迁入受支持的 `TTextareaThemeData` 或外部组合；限制长度与计数仍使用 `maxLength/maxCharacter/indicator`。 [查看相关改法](#migration-controlled)

<a id="migration-component-tree-select"></a>
- **[TreeSelect 树形选择](https://tdesign.tencent.com/flutter/components/tree-select?tab=api)**：`TDTreeSelect / TDSelectOption` → `TTreeSelect / TTreeSelectOption`。

  **需要调整**：旧 `TDSelectOption` 改为 `TTreeSelectOption(label/value/children)`；受控 `value` 是 `List<List<Object?>>`，单选也按路径列表传入。`multiple` 决定多选，空 `onChanged` 禁用；移除旧副作用控制器。

<a id="migration-component-upload"></a>
- **[Upload 上传](https://tdesign.tencent.com/flutter/components/upload?tab=api)**：`TDUpload` → `TUpload`。

  **需要调整**：必填 `files` 与 `onChanged` 管列表；`max/sizeLimit` → `maxFiles/maxFileSize`，一次只配置一种 `mediaType`。自定义 picker 返回 `Future<List<TUploadFile>>`；上传 HTTP、进度和持久化由业务负责。 [查看相关改法](#migration-upload)

</details>

<a id="migration-group-display"></a>
<details>
<summary>内容与数据展示</summary>


检查数据结构、内容插槽、状态以及具体尺寸的含义。

<a id="migration-component-avatar"></a>
- **[Avatar 头像](https://tdesign.tencent.com/flutter/components/avatar?tab=api)**：`TDAvatar` → `TAvatar`。

  **需要调整**：旧 `type` 改为 `image: ImageProvider` 或 `child` 的内容选择；网络图片先包装 `NetworkImage`。`size/shape` 仍是实例规格，具体颜色和尺寸使用 `TAvatarThemeData`；带样式的文字用 `child: Text(...)`。

<a id="migration-component-badge"></a>
- **[Badge 徽标](https://tdesign.tencent.com/flutter/components/badge?tab=api)**：`TDBadge` → `TBadge`。

  **需要调整**：数字文本改为字符串 `label`，结构用 `variant`，数字0显隐用 `showZero`。旧 `redPoint` 对应 `TBadgeVariant.dot`；组合组件的旧 `BadgeConfig` 改为 `TBadgeConfig` 或 `.custom`，不再传旧 `showBadge/tdBadge`。

<a id="migration-component-cell"></a>
- **[Cell 单元格](https://tdesign.tencent.com/flutter/components/cell?tab=api)**：`TDCell / TDCellGroup` → `TCell / TCellGroup`。

  **需要调整**：文字与图片改为 `title/subtitle/prefix/image/note/trailing` 的 Widget 槽；连续列表使用 `TCellGroup(cells: ...)`。旧单元格样式改按 `TCellThemeData`，组背景和分隔线由组管理，不重复添加 Divider。

<a id="migration-component-collapse"></a>
- **[Collapse 折叠面板](https://tdesign.tencent.com/flutter/components/collapse?tab=api)**：`TDCollapse / TDCollapsePanel` → `TCollapse / TCollapsePanel`。

  **需要调整**：提供 `children` 和受控 `List<T> value`，在 `onChanged` 回写；用 `mode` 决定展开模式。每个 `TCollapsePanel` 要有 `value/headerBuilder/body`，展开图标等自定义使用当前 builder，旧 Style 不直接复用。

<a id="migration-component-empty"></a>
- **[Empty 空状态](https://tdesign.tencent.com/flutter/components/empty?tab=api)**：`TDEmpty` → `TEmpty`。

  **需要调整**：旧 `type` 改为 `icon` 或 `image` 加 `emptyText/operation`。原插图类型、点击辅助类型不再作为公开入口；需要保留旧业务插图时传自己的 Widget，具体尺寸由 `TEmptyThemeData` 配置。

<a id="migration-component-footer"></a>
- **[Footer 页脚](https://tdesign.tencent.com/flutter/components/footer?tab=api)**：`TDFooter` → `TFooter`。

  **需要调整**：使用 `logo: Widget`、`text: String` 与 `links: List<Widget>`；旧 `TDFooterType` 不再决定布局。链接内容由业务创建 `TLink` 等 Widget，外观使用 `TFooterThemeData`，不把旧枚举直接改名。

<a id="migration-component-image"></a>
- **[Image 图片](https://tdesign.tencent.com/flutter/components/image?tab=api)**：`TDImage` → `TImage`。

  **需要调整**：`imgUrl` → `src`，本地文件可用 `imageFile`。旧 type 中适配方式拆到 `fit`，方形/圆角/圆形拆到 `shape`；宽高仍显式传入，加载与失败用现有 builder/widget，旧完整 Image 透传参数须逐项核对。

<a id="migration-component-image-viewer"></a>
- **[ImageViewer 图片预览](https://tdesign.tencent.com/flutter/components/image-viewer?tab=api)**：`TDImageViewer / TDImageViewerWidget` → `TImageViewer.show`。

  **需要调整**：`TDImageViewer/TDImageViewerWidget` 改为 `TImageViewer.show`，图片用 `List<ImageProvider>`，配置 `initialIndex/onIndexChanged`。`TDImageDialog` 是另一种业务对话框，应迁为 `TDialog` 的图片内容槽，不应迁成全屏预览。

<a id="migration-component-progress"></a>
- **[Progress 进度条](https://tdesign.tencent.com/flutter/components/progress?tab=api)**：`TDProgress` → `TProgress`。

  **需要调整**：不再调用普通 `TProgress(...)` 传 type；选用 `.linear/.plump/.circular/.microCircular/.button/.microButton`。`value` 仍是0到1的进度比例，旧 `progressStatus` 改为 `status`，`label` 传 Widget；圆环外框用 Theme 的 `circleSize`。

<a id="migration-component-result"></a>
- **[Result 结果](https://tdesign.tencent.com/flutter/components/result?tab=api)**：`TDResult` → `TResult`。

  **需要调整**：`theme` → `status`，旧 `TDResultTheme.defaultTheme` 对应 `TResultStatus.info`，其余 success/warning/error 按同名状态核对。`title/description/icon` 保留内容职责，标题样式使用 `TResultThemeData`。

<a id="migration-component-skeleton"></a>
- **[Skeleton 骨架屏](https://tdesign.tencent.com/flutter/components/skeleton?tab=api)**：`TDSkeleton / TDSkeletonRowCol*` → `TSkeleton / TSkeleton.custom`。

  **需要调整**：旧 `rowCol` 不再接受旧 RowCol 类；标准布局用 `variant`，自定义布局用 `TSkeleton.custom(layout: TSkeletonLayout(...))`。动画仍由 `animation/delay` 表达；不可把旧布局对象改前缀后复用。

<a id="migration-component-swiper"></a>
- **[Swiper 轮播图](https://tdesign.tencent.com/flutter/components/swiper?tab=api)**：`Swiper + TDSwiperPagination` → `TSwiper / TSwiperController`。

  **需要调整**：用 `TSwiper(children: ...)` 或 `itemBuilder/itemCount`，自建 `TSwiperController` 需释放。旧第三方分页插件改为 `pagination/paginationPlacement/paginationItemBuilder`，动画效果用 `pageEffect`；loop/autoplay 默认 false。 [查看相关改法](#migration-tabs)

<a id="migration-component-table"></a>
- **[Table 表格](https://tdesign.tencent.com/flutter/components/table?tab=api)**：`TDTable / TDTableCol` → `TTable<T> / TTableColumn<T>`。

  **需要调整**：`TDTableCol` 改为 `TTableColumn<T>(id/header/cellBuilder)`，表格必填 `columns/data`。选择用 `selectedRows/onSelectionChanged`，排序用 `sort/onSortChanged` 受控回写；旧自动排序、回调签名和行选择函数需改写。

<a id="migration-component-tag"></a>
- **[Tag 标签](https://tdesign.tencent.com/flutter/components/tag?tab=api)**：`TDTag / TDSelectTag` → `TTag / TSelectTag`。

  **需要调整**：保留 `text` 字符串；`theme` → `colorPreset`，描边/浅色等呈现改为 `variant`。`TSelectTag` 必填 `value` 并在 `onChanged` 回写，关闭用 `onCloseTap`；普通 `TTag` 的旧 disable 要反向转为 enabled，字体和圆角改按组件 Theme。

<a id="migration-component-time-counter"></a>
- **[TimeCounter 计时器](https://tdesign.tencent.com/flutter/components/time-counter?tab=api)**：`TDTimeCounter` → `TTimeCounter`。

  **需要调整**：`onChange` → `onChanged`，`time` 和回调值均为毫秒整数；`theme` 改为 `variant`，defaultTheme 对应 plain。旧 `TDTimeCounterStyle` 不是形态枚举：现有颜色/圆角用 `TTimeCounterThemeData`，任意数字块布局用 `content` 构建器。

</details>

<a id="migration-group-feedback"></a>
<details>
<summary>浮层、提示与交互反馈</summary>


核对打开与关闭方式、返回结果、时长、异步结束和资源释放。

<a id="migration-component-action-sheet"></a>
- **[ActionSheet 动作面板](https://tdesign.tencent.com/flutter/components/action-sheet?tab=api)**：`TDActionSheet` → `TActionSheet`。

  **需要调整**：按旧列表/宫格/分组意图选择 `showList/showGrid/showGridSections`，数据改为 `TActionSheetItem<T>`。`onClose` → `onClosed`；旧 `visible/theme` 不再驱动显示，保留返回的公开结果按入口契约处理。

<a id="migration-component-dialog"></a>
- **[Dialog 对话框](https://tdesign.tencent.com/flutter/components/dialog?tab=api)**：`TDAlertDialog / TDConfirmDialog / TDInputDialog` → `TDialog / TConfirmDialog / TDialogAction`。

  **需要调整**：单确认用 `TConfirmDialog`，多操作用 `TDialog(actions: [TDialogAction(...)])`；title/content 改传 Widget。旧输入弹窗和图片弹窗分别组合 `TInput` 或图片内容，业务持有输入与提交逻辑，不用全屏预览替代图片弹窗。 [查看相关改法](#migration-overlay)

<a id="migration-component-dropdown-menu"></a>
- **[DropdownMenu 下拉菜单](https://tdesign.tencent.com/flutter/components/dropdown-menu?tab=api)**：`TDDropdownMenu / TDDropdownItem` → `TDropdownMenu / TDropdownMenuItem`。

  **需要调整**：旧 `TDDropdownItem` 改为 `TDropdownMenuItem(label/panelBuilder)` 描述；选择内容使用 `TDropdownSingleSelectPanel/TDropdownMultiSelectPanel`。受控值保存在业务或面板，外部菜单开关用 `TDropdownMenuController`；重验关闭原因、滚动和锚点。

<a id="migration-component-loading"></a>
- **[Loading 加载](https://tdesign.tencent.com/flutter/components/loading?tab=api)**：`TDLoading` → `TLoading`。

  **需要调整**：`size` 现在是逻辑像素数值，不再传 `TDLoadingSize`；`icon` 仍使用当前 `TLoadingIcon`。颜色、排版和运动样式按 `TLoadingThemeData`，异步加载层用 `TLoadingController` 并在结束/卸载时关闭。

<a id="migration-component-message"></a>
- **[Message 全局提示](https://tdesign.tencent.com/flutter/components/message?tab=api)**：`TDMessage` → `TMessage`。

  **需要调整**：`theme` → `status`，`duration` 改为 `Duration`；旧 `visible` 用 Widget 树或命令句柄管理。`link` 改为 `action` Widget；`MessageMarquee.speed/delay` 毫秒改为 Duration，loop 的0/1语义改为 repeat false/true。

<a id="migration-component-notice-bar"></a>
- **[NoticeBar 消息提醒](https://tdesign.tencent.com/flutter/components/notice-bar?tab=api)**：`TDNoticeBar` → `TNoticeBar`。

  **需要调整**：`theme` → `status`，组合内容用 `prefix/operation`；点击用 `onPressed` 区分目标，旧 `onTap` 不能直接复制。滚动周期 `interval` 使用 Duration，`direction/items` 决定展示方式；外观使用 `TNoticeBarThemeData`。

<a id="migration-component-popover"></a>
- **[Popover 弹出气泡](https://tdesign.tencent.com/flutter/components/popover?tab=api)**：`TDPopover / TDPopoverWidget` → `TPopover`。

  **需要调整**：锚点内容使用 `TPopoverAnchor`，一次性展示使用 `TPopover.showPopover`；旧 Widget/回调与命令方式需按实际触发方式拆分。`theme` 的配色意图迁到 `colorPreset`，间距、箭头和圆角迁 `TPopoverThemeData`。

<a id="migration-component-popup"></a>
- **[Popup 弹出层](https://tdesign.tencent.com/flutter/components/popup?tab=api)**：`TDPopup*Panel / TDSlidePopupRoute` → `TPopup.show + TPopupOptions + TPopupHandle`。

  **需要调整**：`TDSlidePopupRoute/TDPopup*Panel` 改为 `TPopup.show`、方向专属 `TPopupOptions` 与句柄。通过 `handle.close/result` 管理关闭和结果；旧确认面板改用 `TPickerPopup` 或自己的 header/content 组合。 [查看相关改法](#migration-overlay)

<a id="migration-component-pull-down-refresh"></a>
- **[PullDownRefresh 下拉刷新](https://tdesign.tencent.com/flutter/components/pull-down-refresh?tab=api)**：`TDRefreshHeader` → `TPullDownRefresh`。

  **需要调整**：不再将 `TDRefreshHeader` 传给原第三方刷新库；使用 `TPullDownRefresh(child: ..., onRefresh: ..., onLoadMore: ...)` 包装内容。异步结果由回调或 `TPullDownRefreshController` 管理，旧 Header 继承/无限刷新专属参数无逐项兼容承诺。

<a id="migration-component-swipe-cell"></a>
- **[SwipeCell 滑动操作](https://tdesign.tencent.com/flutter/components/swipe-cell?tab=api)**：`TDSwipeCell / TDSwipeCellAction` → `TSwipeCell / TSwipeCellAction`。

  **需要调整**：旧 `cell/left/right/disabled` 改为 `child/start/end/enabled`；面板用 `TSwipeCellPanel`，动作回调用 `onPressed(context)`。开关通知统一为 `onOpenChanged`；旧互斥组、拖拽删除和二次确认需业务实现。

<a id="migration-component-toast"></a>
- **[Toast 轻提示](https://tdesign.tencent.com/flutter/components/toast?tab=api)**：`TDToast` → `TToast`。

  **需要调整**：时长统一为 `Duration`，加载提示默认也会结束；持续任务显式 `Duration.zero`。保留返回ID并用 `dismissToast(id)` 结束；旧 `TDToastConfig` 的视觉和拦截意图分别迁到 Theme/`TOverlayConfig`。 [查看相关改法](#migration-overlay)

</details>

<a id="migration-theme"></a>
## 主题、文字与样式

### 先处理旧配置

- 将读取当前主题的 `TDTheme.of(context)` 改为 `context.tTheme`，固定默认配置不能代替局部主题。
- 旧文字样式字段迁入 `TextStyle`；布局用父级Padding/Align表达，不恢复旧字体padding补偿。
- 全局Token、组件Theme和单个实例配置分别处理，不能把所有旧样式都放入全局JSON。

### 1.0写法与注意事项

旧 `TDTheme.of(context)` 对应 `context.tTheme`；全局数据为 `TThemeData`，应用使用 `TThemeBuilder.light/dark`。让组件跟随局部主题时读取 `context.tTheme`，不要用固定默认值绕开子树 Theme。

<!-- migration-example:theme:start -->
```dart
Widget migratedApp(Widget home) {
  final tokens = TThemeData.defaultData();
  return MaterialApp(
    theme: TThemeBuilder.light(tokens),
    darkTheme: TThemeBuilder.dark(tokens),
    home: home,
  );
}

Widget migratedTextTheme(BuildContext context, Widget child) {
  return Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TTextThemeData(textStyle: TextStyle(fontSize: 18))),
    child: child,
  );
}

TThemeData migratedThemeCopy(TThemeData tokens) {
  return tokens.copyWith(name: 'business', spacerMap: const {'spacer3': 12});
}
```
<!-- migration-example:theme:end -->

- TD 内置外观按全局 Token、TD 组件 Theme、受支持的显式实例配置解析。Material `textTheme`、按钮 Theme、`IconTheme`、visualDensity 等不再隐式改变 TD 内置视觉；原生 Material 和调用方自定义内容仍可使用自己的主题。
- 使用 `mergeExtension` 合并子树组件主题，避免用 `copyWith(extensions: [...])` 意外丢弃其他 ThemeExtension。
- `TText` 的单实例文字使用 `style: TextStyle(...)`；`TTextSpan` 也用 `style`。不要继续传旧 `fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor`，删除线使用 `TextDecoration.lineThrough`。
- `textScaleFactor` 改为 `textScaler`；未传时继承系统文字缩放。旧 `TDTextPaddingConfig` 改为父级 Padding/Align/Center，段落文字不要按单行居中规则强行裁切。
- 在线字体先由业务调用 `TFontLoader.load` 并管理加载状态，之后通过文字 `style.fontFamily` 或 TD 文字 Theme 配置，不再在文字 build 时请求字体 URL。
- 旧 `copyWithTDThemeData(name, marginMap: ...)` 改为 `copyWith(name: name, spacerMap: ...)`，不再需要把结果强制转换为具体主题类型；`copyWith/lerp` 返回 `TThemeData`，业务子类的重写签名也需同步。省略或传 null 的 name 保留当前名称。
- 旧 `ofColor/ofFont/ofCorner/ofFontFamily/ofShadow` 改为相应的 `colorMap/fontMap/radiusMap/fontFamilyMap/shadowMap` 按键查询；先检查键名及空值，不继续调用已删除的动态查询包装。`ofExtra<T>()` 改为读取 `extraThemeData` 并做业务类型判断。
- 旧公开 `parseThemeData` 不再可调用；统一使用 `TThemeData.fromJson`，输入必须是包含主题名称配置的 JSON 字符串，不能把旧 Map 直接作为字符串参数传入。
- 自定义主题 JSON 需要核对字段与最终默认值；旧按钮状态样式、组件形态、交互时长等不能一律塞进 Theme。具体视觉默认值与实例的状态/规格选择分开。

### 迁移后怎样确认

- 明暗切换和局部Theme下内置组件读取正确配色。
- 覆盖一个组件Theme时其他扩展保持预期，文字行高与系统缩放正常。

[返回组件导航](#migration-components)

<a id="migration-button"></a>
## 按钮与禁用语义

### 参数如何调整

- 文字：`text` 改为Widget内容 `child`，普通字符串用 `Text` 包装。
- 点击：`onTap` 改为 `onPressed`；禁用时传null，启用时必须传有效回调。
- 外观分类：`type` 改为 `variant`，`theme` 改为 `colorPreset`。
- 状态样式：旧 `style/activeStyle/disableStyle` 合并到 `ButtonStyle` 的状态属性。

### 1.0写法与注意事项

0.2.7：`TDButton(text: '保存', type: TDButtonType.fill, theme: TDButtonTheme.primary, onTap: save)`。

1.0 的对应写法：

<!-- migration-example:button:start -->
```dart
Widget migratedButton(VoidCallback? onPressed) {
  return TButton(
    variant: TButtonVariant.fill,
    colorPreset: TButtonColorPreset.primary,
    onPressed: onPressed,
    child: const Text('保存'),
  );
}
```
<!-- migration-example:button:end -->

`onPressed == null` 表示禁用；长按也要求按钮处于可点击状态。不要保留旧 `disabled: false` 却漏传回调。`icon` 使用 Widget，IconData 包在 `Icon(...)` 或 `TIcon(...)` 中。普通/按压/禁用的具体样式合并到 `ButtonStyle` 的状态属性；尺寸布局按 size、显式样式或外部约束表达，不搬旧 style/activeStyle/disableStyle 三套对象。

自定义反色主题时，默认配色的 `TButtonVariant.ghost` 文字与描边读取 `textColorAnti`，禁用时读取 `fontWhite4`；不要仅修改原始白色层级 `fontWhite1` 来控制这类按钮。单个按钮的前景、边框和交互状态仍通过 `ButtonStyle` 覆盖。

### 迁移后怎样确认

- 启用按钮点击一次仅执行业务回调一次。
- 禁用不执行点击/长按；普通、按压、加载及禁用样式符合业务预期。

[返回组件导航](#migration-components)

<a id="migration-controlled"></a>
## 受控值、输入与选择

### 值由谁更新

- 旧checked、id或Controller方案需要逐组件改写，不能对所有组件统一替换字段名。
- 在页面State或业务状态中持有当前值，传入value；在onChanged中保存新值并触发重建。
- 父级重置或外部修改时更新同一状态来源，不额外维护第二份选中状态。
- 输入框需要持续控制文本、重置或保留选区时使用TextEditingController；initialValue只负责初始化。

### 1.0写法与注意事项

对于 `TCheckbox`、`TRadioGroup`、`TSwitch`、`TStepper`、Picker、Calendar 等，父级应接受回调并重建传回新值。只记录回调而不更新 value，会导致保持旧值或滚动结束回退；空回调的禁用规则以各组件 API 为准。

<!-- migration-example:choices:start -->
```dart
Widget migratedCheckbox(bool value, ValueChanged<bool?>? onChanged) {
  return TCheckbox(value: value, onChanged: onChanged, title: '同意条款');
}

Widget migratedRadio(String value, ValueChanged<String>? onChanged) {
  return TRadioGroup<String>.options(
    value: value,
    onChanged: onChanged,
    options: const [
      TRadioOption(value: 'a', label: '方案 A'),
      TRadioOption(value: 'b', label: '方案 B'),
    ],
  );
}
```
<!-- migration-example:choices:end -->

`TRadio` 必须在同类型 `TRadioGroup<T>` 下，不能把 groupValue/onChanged 重新分散到每个 radio。复选框单项 value 为 bool?（null 表示不确定态），组的 value/options 以当前泛型 API 为准，旧 id、controller、passThrough 等不能原样套入。

输入框的 `controller` 与 `initialValue` 互斥；`initialValue` 仅初始化内部值。需要外部更新、表单重置或保留选区时使用 `TextEditingController`，由创建方释放。单行用 `TInput`，多行用 `TTextarea`；不要把旧 TDInput 的 maxLines 参数当成完整多行迁移方案。重验空内容粘贴、中文组合输入、清空按钮、焦点与键盘遮挡。

### 迁移后怎样确认

- 操作后显示新值，父级重置也能反映在组件上。
- 复选框不确定态及单选组泛型符合业务，输入清空、组合输入和焦点正常。
- 自建文本控制器在页面退出时释放。

[返回组件导航](#migration-components)

<a id="migration-form"></a>
## 表单改为字段树

### 旧版配置分别放到哪里

- `items`：改成TForm子树中的字段Widget，不再提交一份表单项配置列表。
- `data`：字段的业务值由调用方持有，通过TFormField.value/onChanged连接。
- `rules`：在字段上配置required或validator，并显示builder传出的错误文案。
- 提交/重置：调用方编排业务操作；提交前使用TFormController.validate()，重置时同步业务值与文本控制器。

### 1.0写法与注意事项

旧 `items/rules/data` 配置改为 `TForm + TFormField<T> + TFormItem`。字段持有业务 value/onChanged，validator 返回错误文案；`TFormController.validate()` 用于主动校验，`required: true` 执行必填校验，单独设置表单项必填标记不等于校验。

<!-- migration-example:form:start -->
```dart
Widget migratedForm({
  required TFormController form,
  required TextEditingController text,
  required String value,
  required ValueChanged<String> onChanged,
}) {
  return TForm(
    controller: form,
    child: TFormField<String>(
      name: 'name',
      value: value,
      onChanged: onChanged,
      required: true,
      requiredMessage: '请输入姓名',
      builder: (context, current, change, error) => TFormItem(
        label: '姓名',
        errorText: error,
        child: TInput(controller: text, onChanged: change),
      ),
    ),
  );
}
```
<!-- migration-example:form:end -->

示例中的 text/form 由页面持有，value 由父级在 onChanged 中更新；页面销毁时释放自建 TextEditingController。业务执行 reset 时，同时更新字段值与自己的文本控制器；不要指望 initialValue 覆盖现有编辑状态。

### 迁移后怎样确认

- 空值提交显示正确错误文案，合法值可以通过校验。
- 提交读取最新业务值，在校验通过前不会发起业务请求。
- 重置同步处理业务值、文本及适用的错误状态。

[返回组件导航](#migration-components)

<a id="migration-picker"></a>
## Picker、日期与浮层确认分离

### 将选择与提交分成两步

- 旧TDPicker.show*等入口可能同时处理内容、标题和确认回调；新面板只处理数据及候选值。
- 标题和操作按钮使用TPopupHeader等公开组件；打开时从业务保存值复制草稿。
- 滚动只更新草稿，确认才提交业务值，取消丢弃草稿。
- 旧日期数组和DatePickerModel应转换为当前日期值模型，旧回调参数不能原样传给新组件。

### 1.0写法与注意事项

`TDPicker/TDMultiPicker/TDMultiLinkedPicker` 改为 `TPicker` 和不可变 `TPickerColumns/TPickerLinked` 数据。面板回调只是候选值变化，不是业务确认。

<!-- migration-example:picker:start -->
```dart
TPopupHandle migratedPicker({
  required BuildContext context,
  required String initialValue,
  required ValueChanged<String> onConfirmed,
}) {
  var draft = initialValue;
  return TPickerPopup.show(
    context,
    child: StatefulBuilder(
      builder: (context, setPanelState) => TPicker(
        items: const TPickerColumns([
          [
            TPickerOption(label: '选项 A', value: 'a'),
            TPickerOption(label: '选项 B', value: 'b'),
          ],
        ]),
        value: [draft],
        onChanged: (next) => setPanelState(() {
          draft = next.values.single! as String;
        }),
      ),
    ),
    headerBuilder: (context, close) => TPopupHeader(
      title: const Text('请选择'),
      cancelButton: TButton(onPressed: close, child: const Text('取消')),
      confirmButton: TButton(
        onPressed: () {
          onConfirmed(draft);
          close();
        },
        child: const Text('确认'),
      ),
    ),
  );
}
```
<!-- migration-example:picker:end -->

调用方在 `onConfirmed` 中更新业务保存值，并确保对应业务 State 仍 mounted；取消只关闭、不提交草稿。重新打开时用保存值创建新草稿。`TPickerPopup` 会为标准头部和滚轮预留高度；自定义通用 Popup 时也须提供合理内容约束。

`TDDatePicker + DatePickerModel` 改为 `TDateTimePicker + TDateTimePickerValue + DateTimePickerMode`。默认年月日，按需组合时间列；start/end 与 steps 用当前模型，onChanged 实时回写。`TDCalendar` 的 value 改为 `List<DateTime>`，single/multiple/range 由 variant 表达，组件不再同时负责业务弹窗确认或时间选择。

<!-- migration-example:calendar:start -->
```dart
Widget migratedCalendar(
  List<DateTime> value,
  ValueChanged<List<DateTime>>? onChanged,
) {
  return SizedBox(
    height: 400,
    child: TCalendar(
      value: value,
      variant: TCalendarVariant.single,
      minDate: DateTime(2026, 1, 1),
      maxDate: DateTime(2026, 12, 31),
      onChanged: onChanged,
    ),
  );
}

Widget migratedDateTime(
  TDateTimePickerValue value,
  ValueChanged<TDateTimePickerValue>? onChanged,
) {
  return TDateTimePicker(value: value, onChanged: onChanged);
}
```
<!-- migration-example:calendar:end -->

**重新验证边界**：最小/最大日期的时分、跨天、闰日、区间端点、数据源变更、连续滚动与惯性。不要用整数时间戳或旧通知器替代新受控值。

### 迁移后怎样确认

- 滚动后取消，业务保存值不变化。
- 确认只提交当前草稿，重新打开从已保存值开始。
- 日期上下界、区间端点、数据变化和连续滚动正确。

[返回组件导航](#migration-components)

<a id="migration-overlay"></a>
## Popup、Dialog、Toast

### 按原业务目的选择新入口

- 普通弹出层使用TPopup.show，对应方向/布局放入TPopupOptions，保存句柄管理关闭和结果。
- 只有一个确认动作时可用TConfirmDialog；有确认/取消等多个动作时使用TDialog.actions与TDialogAction。
- 旧输入弹窗改为TDialog与TInput组合，由业务持有输入值和提交逻辑。
- 加载提示使用Toast并明确持续时间，任务结束后关闭对应ID。

### 1.0写法与注意事项

旧 `TDPopup*Panel/TDSlidePopupRoute` 组合改为 `TPopup.show(context, options: ...)`。按方向选择 `TPopupOptions.bottom/center/left/right/top` 与对应 Inset；从返回的 `TPopupHandle` 关闭/重开并读取本次 `result`。用正确 Theme/Navigator 子树的 context 打开；handle 重开不会自动重新解析已经合并的主题选项，需要新配置时重新创建。

`TConfirmDialog` 是单确认便捷组件；多操作使用 `TDialog.actions + TDialogAction`，输入弹窗组合 `TDialog + TInput`，不要寻找被删除的 TDInputDialog。

<!-- migration-example:dialog:start -->
```dart
Future<bool?> migratedDialog(BuildContext context) {
  return TDialog.show<bool>(
    context,
    dialog: const TConfirmDialog(
      title: '操作确认',
      content: '确认继续？',
      buttonText: '继续',
    ),
  );
}
```
<!-- migration-example:dialog:end -->

Toast 时长用 `Duration`；加载提示默认也会自动关闭。持续任务显式设置 `Duration.zero`，任务结束后按返回 ID 关闭。可见遮罩与背景点击/滚动拦截是独立配置，不要把半透明遮罩等同于不可穿透。

<!-- migration-example:toast:start -->
```dart
String migratedLoading(BuildContext context) {
  return TToast.showLoading(
    context: context,
    text: '处理中',
    duration: Duration.zero,
    overlay: const TOverlayConfig(preventScrollThrough: true),
  );
}
```
<!-- migration-example:toast:end -->

结束任务时调用 `TToast.dismissToast(id)`。匿名提示会复用匿名 ID；需要并存时提供不同 toastId。`TMessage.duration` 同样使用 Duration，显示由 Widget 树或其公开命令管理，不能继续用旧 visible 参数控制。

### 迁移后怎样确认

- 确认、取消、遮罩与返回键产生各自预期结果。
- 输入弹窗提交最新文本，取消不会误提交。
- 任务结束关闭自己的加载提示，不误关其他并存提示。

[返回组件导航](#migration-components)

<a id="migration-upload"></a>
## Upload 与平台依赖

### 旧参数和业务职责如何调整

- `files/onChange`：迁为受控files/onChanged，保存回调提供的新列表。
- `max/sizeLimit`：改用maxFiles/maxFileSize，示例中的文件大小以字节表达。
- `mediaType/multiple`：按新API选择单一媒体类型及数量上限，不直接传旧媒体类型列表。
- `disabled`：通过当前公开交互配置处理，例如onChanged为null；禁用不等于取消已开始的异步选择。
- 网络上传仍由业务执行并更新文件状态，选择完成不代表服务器上传成功。

### 1.0写法与注意事项

Upload 只负责选择及文件列表交互，不执行 HTTP 上传。旧 `max/sizeLimit/multiple/disabled/onChange` 不能仅改名：改为 `maxFiles/maxFileSize`、单一 mediaType、受控 files/onChanged；自定义业务 picker 使用 `Future<List<TUploadFile>>`。

<!-- migration-example:upload:start -->
```dart
Widget migratedUpload({
  required List<TUploadFile> files,
  required ValueChanged<List<TUploadFile>>? onChanged,
  TUploadPicker? picker,
}) {
  return TUpload(
    files: files,
    onChanged: onChanged,
    maxFiles: 2,
    maxFileSize: 5 * 1024 * 1024,
    picker: picker,
  );
}
```
<!-- migration-example:upload:end -->

回调列表不可变，接受时直接保存新列表，不原地 add/remove；上传进度和结果由业务创建新 TUploadFile/列表更新。`onChanged == null` 阻止新交互，但不会取消已经开始的选择；卸载后不通知。数量/大小错误、选择器异常和业务回调异常分别按当前回调契约处理。

相册权限、iOS Info.plist、文件持久化和 Android 进程回收后的恢复属于宿主集成。默认选择器底层是 image_picker；业务可用 picker 接入自己的权限、恢复和上传流程。升级后重新构建原生宿主，并检查实际解析的平台实现版本；Dart 编译通过不能证明权限与系统相册行为通过。

### 迁移后怎样确认

- 选择和删除后列表更新，取消选择不会误新增文件。
- 超过数量或大小限制、选择失败和上传失败有正确处理。
- 页面退出后，异步结果不会错误更新已销毁页面。

[返回组件导航](#migration-components)

<a id="migration-tabs"></a>
## 两种 TabBar 与 Swiper

### 先区分三种迁移路径

- 顶部页签：TDTabBar/TDTabBarView迁为TTabsBar/TTabsBarView，并共享TabController。
- 底部导航：TDBottomTabBar迁为TTabBar，由value/onChanged控制当前选择。
- 轮播：旧Swiper迁为TSwiper，不再传第三方控制器或分页插件。
- 先按下面的行为差异改写，再核对API；顶部页签和底部导航不能合并成一种替换。

### 1.0写法与注意事项

- **顶部页签**：旧 `TDTabBar/TDTabBarView` → `TTabsBar/TTabsBarView`，显式共享 TabController 或位于同一个 DefaultTabController。TTabsBarView 默认不可滑动，需要手势切页时显式配置 physics。
- **底部导航**：旧 `TDBottomTabBar` → `TTabBar`，提供 type、navigationTabs、受控 value/onChanged；旧 `topBorder/showTopBorder/centerDistance` 没有等价开关恢复，按新的默认边线和内置图文布局验收。
- **Swiper**：使用 `TSwiper` 的 children 或 itemBuilder/itemCount；自建 `TSwiperController` 并在页面 dispose 中释放。旧第三方 SwiperPlugin/SwiperController 和 TDSwiperPagination 不能直接传入；按当前分页、箭头与 pageEffect 能力重组。TSwiper 默认 loop/autoplay 均 false，业务需要时显式打开。

### 迁移后怎样确认

- 顶部页签与内容共享同一控制器，切换后内容一致。
- 底部导航回调更新value，外部重置也正确显示选中项。
- Swiper循环/自动播放显式符合业务需求，自建控制器被正确释放。

[返回组件导航](#migration-components)

<a id="migration-removed-capabilities"></a>
## 找不到旧类型时怎样处理

旧辅助类型可能已删除、拆分或改为 Widget 组合。先从附录进入具体组件条目，再按下面的职责选择替代方式；“能找到新名称”不表示旧参数和能力自动保留。

**图片业务弹窗与图片预览要分开。** 旧 `TDImageDialog` 同时支持图片、标题、正文和操作，是业务对话框；用 `TDialog` 的 `content` 组合图片与正文，用 `actions` 表达操作。旧图片位置用 Column 的子项顺序或自己的布局处理。全屏浏览多张图片才使用 `TImageViewer.show`；两者不是等价替换。打开下面的对话框内容时，仍通过 `TDialog.show(context, dialog: ...)` 获取结果。

**徽标配置仍有对应职责。** 旧 `BadgeConfig` 迁为 `TBadgeConfig`，组合组件不显示徽标时不提供配置；自定义旧 tdBadge 内容用 `TBadgeConfig.custom(badge: ...)`。旧 top/right 偏移不是可以原样套用的构造参数，需按新 `alignment/offset` 的坐标方向检查位置。普通徽标的 redPoint 改为 dot，数字文本作为字符串 label。

**跑马灯配置要转换单位和循环含义。** 旧 `MessageMarquee.speed/delay` 是毫秒数，改为 `TMessageMarquee.duration/delay` 的 Duration；speed 在旧实现中也是单次动画时长，不是像素速度。旧 loop 为0表示单次，1表示循环，分别改为 repeat false/true；没有提供值的旧代码需重新明确预期，不能把整数直接作为布尔值。

**计时样式对象不能替换成形态枚举。** `TDTimeCounterTheme` 的 defaultTheme/round/square 按 `TTimeCounterVariant.plain/round/square` 选择；`TDTimeCounterStyle` 的任意宽高、padding、字体等没有完整 Theme 对照。当前 `TTimeCounterThemeData` 只提供文档列出的颜色与圆角，完整自定义数字块使用 `content` 构建器。time 和回调使用毫秒；`onChange` 改为 `onChanged`，小数显示按 format 配置，不恢复旧 millisecond 参数。

下面是上述组合及进度/索引的最小1.0写法；以公开入口编译验证，与本指南其他片段共用同一示例源。

<!-- migration-example:removed-capabilities:start -->
```dart
TBadgeConfig? migratedBadge(bool showBadge, Widget badge) {
  return showBadge ? TBadgeConfig.custom(badge: badge) : null;
}

TMessageMarquee migratedMarquee(int speedMs, bool repeat, int delayMs) {
  return TMessageMarquee(
    duration: Duration(milliseconds: speedMs),
    repeat: repeat,
    delay: Duration(milliseconds: delayMs),
  );
}

Widget migratedImageDialog(Image image) {
  return TDialog(
    title: const Text('活动说明'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [image, const Text('图片下方的业务说明')],
    ),
    actions: const [TDialogAction(child: Text('知道了'), result: true)],
  );
}

Widget migratedCustomCounter(int milliseconds, Color color) {
  return TTimeCounter(
    time: milliseconds,
    autoStart: false,
    content: (time) => Text(
      '${time ~/ Duration.millisecondsPerSecond}s',
      style: TextStyle(color: color),
    ),
  );
}

Widget migratedProgress(double fraction) {
  return TProgress.circular(value: fraction);
}

Widget migratedIndexes() {
  return TIndexes(
    indexList: const ['A'],
    builderContent: (context, index) => Text(index),
  );
}
```
<!-- migration-example:removed-capabilities:end -->

**旧扩展面板与路由由业务组合。** 底部导航的 expansionPanel、PopUpMenuItem 和相关弹出菜单配置没有直接兼容入口；使用当前导航项，另以 `TActionSheet` 或 `TPopup` 组合业务菜单。旧选择器、日历的自动弹层与确认需使用 `TPickerPopup` 或 `TPopup` 显式编排。`TDMultiCascader` 的 multi 表示多级路径，不是多个路径多选；新 `TCascader` 返回 value 路径且不会替业务自动关闭浮层。

**旧布局样式与绘制继承点不再承诺兼容。** 旧 State/Inherited/Painter/Slider Track/Thumb 类及3个公开 mixin 不再提供相同继承点。优先使用当前内容槽、builder、Theme 和 formatter；如果现有公开扩展不能表达业务绘制，需业务自己实现该部分，不通过深层 src 导入恢复旧类。`TDInputType` 是旧布局枚举，不能当成键盘类型迁到 `inputType`；单行、多行与卡片布局分别选 `TInput`、`TTextarea` 与业务组合。

**图片的适配与形状已拆分。** 旧 `TDImageType.fitHeight/fitWidth/stretch/clip` 的适配意图使用 `fit`，square/roundedSquare/circle 使用 `shape`，不要对整个旧枚举做一次前缀替换。需要旧版才透传的 color/opacity/centerSlice 等原生 Image 配置时，使用 Flutter Image 及业务外层布局；`TImage` 没有这些参数的兼容入口。

**图标常量和字体信息也有差异。** 当前 `tdesign_flutter_icons 0.0.6` 不提供旧 `TDIcons.list`、`TDIcons.video_camera_3`、`TDIcons.video_camera_3_filled` 的同名常量。需要列表图标时可评估 `TIcons.view_list`，视频类从当前实际图标中选择；这些选择不保证与旧图形完全一致，需要保留原图形时由业务提供自己的图标资源。旧 `TDIcons.all` 改为 `TIcons.allIconsMap`，现有同名图标仍可使用例如 `accessibility_filled` 的键，但上述3个缺失图标不能继续按旧键查询，也不要假定两份全集完全一致；旧私有图标数据的 name 属性也不是新 IconData 的属性。不要复制旧 codePoint/fontFamily/fontPackage 来拼装新字体中的图标。

**文字全局开关改为局部配置。** `kTextForceVerticalCenterEnable` 与 `kTextNeedGlobalFontFamily` 已移除。通过 `TTextThemeData`、实例 TextStyle 以及父级布局管理字体和排版，保留系统文字缩放；没有新的全局布尔开关一一替代，也不要裁切段落恢复旧像素补偿。

<a id="migration-enums"></a>
### 枚举值不能只替换前缀

即使新旧枚举名称相似，也需检查成员和所在配置维度。以下是本次按源码发现的主要变化：

- `TDCellAlign.middle` → `TCellAlign.center`。
- `TDSwitchType.fill` → `TSwitchVariant.filled`；旧 loading 值改为独立 `loading: true`，不是新 variant 成员。
- `TDProgressStatus.primary/danger` → `TProgressStatus.normal/error`；warning/success 按同名状态。旧 micro 类型改选 `TProgress.microCircular`，不能调用不存在的普通构造并传入 variant。
- `TDLinkType.basic/withUnderline/withPrefixIcon/withSuffixIcon` 分别表达基础内容、下划线、前图标和后图标；使用 `underline/prefixIcon/suffixIcon` 组合，不能映射为 `TLinkColorPreset`。
- `TDButtonShape.filled` 不再存在。零圆角通过 ButtonStyle 的 shape 表达；旧 isBlock 或铺满容器的布局由父级约束表达，不把 filled 当成 fill variant。
- `TDBadgeSize.small` 没有新同名档位；选择当前 medium/large 后核对实际尺寸，必须保留特定小号外观时由业务组合 Widget，不宣称只改名即可保持旧像素。
- `TDStepsStatus.success` 没有对应全局状态。`TStepsStatus` 只表达当前步骤的 process/error；完成结果由业务内容或 `TResult` 等组合呈现，不能传超出步骤数量的 value 模拟全部完成，因为索引会被收敛到有效范围。
- `TDUploadFileStatus.loading/retry` → `TUploadFileStatus.uploading/retryableError`；文件模型是不可变配置，上传进度、错误和重试由业务更新文件列表。
- `TDTimeCounterTheme.defaultTheme` → `TTimeCounterVariant.plain`；旧 Style 对象的处置见上文，不能套用此枚举映射。
- `TDResultTheme.defaultTheme` → `TResultStatus.info`。徽标旧 redPoint 改为 dot；message/subscript 等形态需按当前 circle/ribbon/triangle 等实际外观选择，不承诺旧标识与新外观一一等价。

[返回组件导航](#migration-components)

## 编译通过后仍要检查

- 控件禁用条件、受控回调回写、连续操作与异步完成后的状态。
- 主题明暗切换、局部 Theme、系统字体和 1/1.5/2 倍字号；不要用旧截图作为当前默认值的唯一依据。
- 键盘、复制粘贴、输入法组合区、选区及焦点；返回键、安全区和 Overlay 的关闭/释放。
- 列表排序/选择、日期边界、滚轮惯性、Swiper 实际页码；上传取消、权限与页面退出。
- 业务创建的文本/Tab/Swiper/刷新控制器按其实际类型生命周期释放；回调中 setState 前确认 State 存活。

不存在替代入口的旧公开 State、Painter、布局适配和静态辅助类，不应通过深层 src 导入恢复。若业务依赖其具体能力，应使用公开 Widget/Theme/Flutter 原语重新组合，或在业务中维护对应实现；这类代码需要人工迁移。

<a id="migration-legacy-types"></a>
## 附录：按旧类型名称查找

以下覆盖 0.2.7 主入口追踪到的388项自有公开声明，包含公开 mixin 和顶层变量（不包括外部包导出）。它用于查找旧名和定位处置方向，**不是自动替换表**。即使目标同名，构造参数、回调、默认值或行为也可能变化。公开基类的继承成员与业务自行继承/深层导入需额外审查。当前入口还导出 Material；同名的 Flutter 类型不作为旧 TD 自有声明的兼容实现。

<details>
<summary>展开0.2.7旧类型名称对照表（388项）</summary>

| 0.2.7 名称 | 当前入口或处置 | 范围 |
|---|---|---|
| `BadgeConfig` | `TBadgeConfig / TBadgeConfig.custom` | 组合徽标配置重组；showBadge 改为是否提供配置，tdBadge 改为自定义 badge；偏移按新 alignment/offset 重验；[具体改法](#migration-component-badge) |
| `CalendarBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `CalendarFormat` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `CalendarTrigger` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `CalendarType` | `TCalendarVariant` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-calendar) |
| `CellBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cell) |
| `ChevronPainter` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `Chinese2Formatter` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-input) |
| `ContentBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `DatePickerCallback` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-date-time-picker) |
| `DatePickerModel` | `TDateTimePickerValue` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-date-time-picker) |
| `DateSelectType` | `DateSelectType` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-calendar) |
| `DateSelectTypeNotifier` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `DateTypeKey` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-date-time-picker) |
| `DefaultMapFactory` | `DefaultMapFactory` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `DefaultStickyHeaderController` | `DefaultStickyHeaderController` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `Font` | `Font` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `FontExtensions` | `FontExtensions` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `FontFamily` | `FontFamily` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `FormController` | `TFormController` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-form) |
| `FormItemNotifier` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-form) |
| `HollowCircle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-radio) |
| `IconBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `IconTextDirection` | `IconTextDirection` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-toast) |
| `ImageWidget` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image) |
| `ItemBuilderType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-picker) |
| `ItemDistanceCalculator` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-picker) |
| `LabelBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dropdown-menu) |
| `LeftItemBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image-viewer) |
| `LeftLinePainter` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cascader) |
| `LeftLineWidget` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cascader) |
| `LinkClick` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-link) |
| `MessageLink` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-message) |
| `MessageMarquee` | `TMessageMarquee` | speed/delay 的毫秒数改为 Duration；loop 0/1 改为 repeat false/true；[具体改法](#migration-component-message) |
| `MessageTheme` | `TMessageStatus` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-message) |
| `MultiCascaderCallback` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cascader) |
| `MultiCascaderListModel` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cascader) |
| `MultiLinkedPickerModel` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-picker) |
| `MultiPickerCallback` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-picker) |
| `OnCellTap` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `OnCheckBoxGroupChange` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `OnCheckValueChanged` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `OnClose` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image-viewer) |
| `OnDelete` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image-viewer) |
| `OnGroupChange` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `OnImageTap` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image-viewer) |
| `OnIndexChange` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image-viewer) |
| `OnLongPress` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image-viewer) |
| `OnLongTap` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popover) |
| `OnRadioGroupChange` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-radio) |
| `OnRowSelect` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `OnScroll` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `OnSelect` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `OnSliderThemeDataUpdate` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `OnSwitchChanged` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-switch) |
| `OnTap` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popover) |
| `PanelWithDownArrow` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `PlacementEnum` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-rate) |
| `PlatformUtil` | `PlatformUtil` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `PopRoute` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `PopUpMenuItem` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `PopupClick` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popup) |
| `PopupDialog` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `PopupDialogState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `Position` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `ProgressIndicator` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-progress) |
| `RadioCorner` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `RadioCornerIcon` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `RectClipper` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popup) |
| `RightItemBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-image-viewer) |
| `RowCheckFunc` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `ScaleFormatter` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `SelectableFunc` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `SideItemProps` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-side-bar) |
| `SlideTransitionFrom` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popup) |
| `SliderMeasureData` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `SliverStickyHeader` | `SliverStickyHeader` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `SliverStickyHeaderRenderObjectElement` | `SliverStickyHeaderRenderObjectElement` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `SliverStickyHeaderState` | `SliverStickyHeaderState` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `SliverStickyHeaderWidgetBuilder` | `SliverStickyHeaderWidgetBuilder` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `StickyHeaderController` | `StickyHeaderController` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `SwipeMotion` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swipe-cell) |
| `TDActionSheet` | `TActionSheet` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-action-sheet) |
| `TDActionSheetAlign` | `TActionSheetAlign` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-action-sheet) |
| `TDActionSheetItem` | `TActionSheetItem` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-action-sheet) |
| `TDActionSheetItemCallback` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-action-sheet) |
| `TDActionSheetTheme` | `TActionSheet.showList/showGrid/showGridSections` | 旧列表/宫格/分组意图改由对应打开入口表达；[具体改法](#migration-component-action-sheet) |
| `TDAlertDialog` | `TDialog` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-dialog) |
| `TDAvatar` | `TAvatar` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-avatar) |
| `TDAvatarShape` | `TAvatarShape` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-avatar) |
| `TDAvatarSize` | `TAvatarSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-avatar) |
| `TDAvatarType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-avatar) |
| `TDBackTop` | `TBackTop` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-back-top) |
| `TDBackTopStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-back-top) |
| `TDBackTopTheme` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-back-top) |
| `TDBadge` | `TBadge` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-badge) |
| `TDBadgeBorder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-badge) |
| `TDBadgeSize` | `TBadgeSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-badge) |
| `TDBadgeType` | `TBadgeVariant` | redPoint → dot；其余形态按 circle/square/bubble/ribbon 等当前枚举重新选择；[具体改法](#migration-component-badge) |
| `TDBarItemAction` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-navbar) |
| `TDBaseRangeSliderTrackShape` | 已移除；`TSlider / TRangeSlider` 的公开配置 | 不再公开 Track/Thumb mixin 继承契约；超出现有 Theme/formatter 的绘制需业务实现；[具体改法](#migration-component-slider) |
| `TDBottomTabBar` | `TTabBar` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarBasicType` | `TTabBarType` | text/iconText/icon 按需选择；expansionPanel 没有直接替代，不机械改为 doubleLayer；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarComponentType` | `TTabBarItemStyle` | normal/label 按当前条目样式配置；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarIndicatorAnimation` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarItemWithBadge` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarOutlineType` | `TTabBarStyle` | filled/capsule 按当前导航外形配置；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarPopUpBtnConfig` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarPopUpShapeConfig` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tab-bar) |
| `TDBottomTabBarTabConfig` | `TTabBarItemConfig` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-tab-bar) |
| `TDBoxShadows` | `TBoxShadows` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDButton` | `TButton` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-button) |
| `TDButtonEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-button) |
| `TDButtonIconPosition` | `TButtonIconPosition` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-button) |
| `TDButtonShape` | `TButtonShape` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-button) |
| `TDButtonSize` | `TButtonSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-button) |
| `TDButtonStatus` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-button) |
| `TDButtonStyle` | `ButtonStyle`（Flutter） | 状态属性合并普通/按压/禁用样式；不是旧样式类的兼容别名；[具体改法](#migration-component-button) |
| `TDButtonTheme` | `TButtonColorPreset` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-button) |
| `TDButtonType` | `TButtonVariant` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-button) |
| `TDCalendar` | `TCalendar` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-calendar) |
| `TDCalendarBody` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `TDCalendarCell` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `TDCalendarHeader` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `TDCalendarInherited` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `TDCalendarPopup` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `TDCalendarStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `TDCapsuleRangeSliderThumbShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDCapsuleRangeSliderTickMarkShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDCapsuleRectAdjustment` | 已移除；`TSlider / TRangeSlider` 的公开配置 | 不再公开 Track/Thumb mixin 继承契约；超出现有 Theme/formatter 的绘制需业务实现；[具体改法](#migration-component-slider) |
| `TDCapsuleRectRangeSliderTrackShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDCapsuleRectSliderTrackShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDCapsuleRectThemeData` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDCapsuleSliderThumbShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDCapsuleSliderTickMarkShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDCapsuleTrackShape` | 已移除；`TSlider / TRangeSlider` 的公开配置 | 不再公开 Track/Thumb mixin 继承契约；超出现有 Theme/formatter 的绘制需业务实现；[具体改法](#migration-component-slider) |
| `TDCardStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-input) |
| `TDCascader` | `TCascader` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-cascader) |
| `TDCascaderAction` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cascader) |
| `TDCell` | `TCell` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-cell) |
| `TDCellAlign` | `TCellAlign` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-cell) |
| `TDCellClick` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cell) |
| `TDCellGroup` | `TCellGroup` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-cell) |
| `TDCellGroupTheme` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cell) |
| `TDCellStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cell) |
| `TDCheckBoxSize` | `TCheckboxSize` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-checkbox) |
| `TDCheckbox` | `TCheckbox` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-checkbox) |
| `TDCheckboxGroup` | `TCheckboxGroup` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-checkbox) |
| `TDCheckboxGroupContainer` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `TDCheckboxGroupContainerState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `TDCheckboxGroupController` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `TDCheckboxGroupInherited` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `TDCheckboxGroupState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `TDCheckboxState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `TDCheckboxStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-checkbox) |
| `TDCircleIndicator` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-loading) |
| `TDCollapse` | `TCollapse` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-collapse) |
| `TDCollapseIconTextBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-collapse) |
| `TDCollapsePanel` | `TCollapsePanel` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-collapse) |
| `TDCollapseStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-collapse) |
| `TDColors` | `TColors` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDConfirmDialog` | `TConfirmDialog` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-dialog) |
| `TDContentDirection` | `TContentDirection` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-checkbox) |
| `TDCustomTab` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cascader) |
| `TDDatePicker` | `TDateTimePicker` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-date-time-picker) |
| `TDDialogButtonOptions` | `TDialogAction` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-dialog) |
| `TDDialogButtonStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dialog) |
| `TDDialogImagePosition` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dialog) |
| `TDDivider` | `TDivider` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-divider) |
| `TDDrawer` | `TDrawer` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-drawer) |
| `TDDrawerItem` | `TDrawerItem` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-drawer) |
| `TDDrawerItemClickCallback` | `TDrawerItemClickCallback` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-drawer) |
| `TDDrawerPlacement` | `TDrawerPlacement` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-drawer) |
| `TDDrawerWidget` | `TDrawer` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-drawer) |
| `TDDropdownItem` | `TDropdownMenuItem` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-dropdown-menu) |
| `TDDropdownItemBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dropdown-menu) |
| `TDDropdownItemContentBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dropdown-menu) |
| `TDDropdownItemController` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dropdown-menu) |
| `TDDropdownItemOption` | `TDropdownMenuOption` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-dropdown-menu) |
| `TDDropdownItemOptionsCallback` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dropdown-menu) |
| `TDDropdownMenu` | `TDropdownMenu` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-dropdown-menu) |
| `TDDropdownMenuDirection` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-dropdown-menu) |
| `TDEmpty` | `TEmpty` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-empty) |
| `TDEmptyType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-empty) |
| `TDExtraThemeData` | `TExtraThemeData` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDFab` | `TFab` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-fab) |
| `TDFabShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-fab) |
| `TDFabSize` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-fab) |
| `TDFabTheme` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-fab) |
| `TDFontFamilies` | `TFontFamilies` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDFontLoader` | `TFontLoader` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-text) |
| `TDFontLoaderWidget` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-text) |
| `TDFonts` | `TFonts` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDFooter` | `TFooter` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-footer) |
| `TDFooterType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-footer) |
| `TDForm` | `TForm` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-form) |
| `TDFormItem` | `TFormItem` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-form) |
| `TDFormItemType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-form) |
| `TDFormValidation` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-form) |
| `TDFractionPagination` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swiper) |
| `TDIconLabel` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-progress) |
| `TDIcons` | `TIcons` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-icon) |
| `TDImage` | `TImage` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-image) |
| `TDImageDialog` | `TDialog` + 图片 Widget | 图片业务弹窗保留标题、内容和操作；不是全屏 TImageViewer；[具体改法](#migration-component-dialog) |
| `TDImageType` | `TImage.shape` + `fit` | 形状和图片适配拆成两个维度；部分旧 Image 透传能力需使用 Flutter Image；[具体改法](#migration-component-image) |
| `TDImageViewer` | `TImageViewer` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-image-viewer) |
| `TDImageViewerWidget` | `TImageViewer` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-image-viewer) |
| `TDIndexes` | `TIndexes` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `TDIndexesAnchor` | `TIndexesAnchor` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `TDIndexesList` | `TIndexesList` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-indexes) |
| `TDInput` | `TInput` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-input) |
| `TDInputDialog` | `TDialog` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-dialog) |
| `TDInputSize` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-input) |
| `TDInputSpacer` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-input) |
| `TDInputType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-input) |
| `TDInputView` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-input) |
| `TDItemWidget` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-picker) |
| `TDLabelWidget` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-progress) |
| `TDLink` | `TLink` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-link) |
| `TDLinkConfiguration` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-link) |
| `TDLinkSize` | `TLinkSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-link) |
| `TDLinkState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-link) |
| `TDLinkStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-link) |
| `TDLinkType` | `TLink.underline/prefixIcon/suffixIcon` | 旧枚举表达结构，不对应配色选择器；按是否加下划线、前后图标分别组合；[具体改法](#migration-component-link) |
| `TDLoading` | `TLoading` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-loading) |
| `TDLoadingController` | `TLoadingController` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-loading) |
| `TDLoadingIcon` | `TLoadingIcon` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-loading) |
| `TDLoadingSize` | `TLoading.size` | 枚举改为逻辑像素数值，按当前规格验收；不承诺旧枚举尺寸完全一致；[具体改法](#migration-component-loading) |
| `TDMap` | `TMap` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDMessage` | `TMessage` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-message) |
| `TDMultiCascader` | `TCascader` | 多级单路径回调从逐层模型转为value路径；不再自动关闭，排序和Action/Tab扩展由业务组合；[具体改法](#migration-component-cascader) |
| `TDMultiLinkedPicker` | `TPicker` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-picker) |
| `TDMultiPicker` | `TPicker` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-picker) |
| `TDNavBar` | `TNavBar` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-navbar) |
| `TDNavBarItem` | `TNavBarItem` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-navbar) |
| `TDNavBarItemBorder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-navbar) |
| `TDNoOverlayShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDNoneIndicator` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tabs) |
| `TDNoticeBar` | `TNoticeBar` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-notice-bar) |
| `TDNoticeBarStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-notice-bar) |
| `TDNoticeBarTheme` | `TNoticeBarStatus` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-notice-bar) |
| `TDNoticeBarType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-notice-bar) |
| `TDPageTransformer` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swiper) |
| `TDPicker` | `TPicker` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-picker) |
| `TDPopover` | `TPopover` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-popover) |
| `TDPopoverPlacement` | `TPopoverPlacement` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-popover) |
| `TDPopoverTheme` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popover) |
| `TDPopoverWidget` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popover) |
| `TDPopupBasePanel` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popup) |
| `TDPopupBottomConfirmPanel` | `TPickerPopup` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-popup) |
| `TDPopupBottomDisplayPanel` | `TPopupOptions` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-popup) |
| `TDPopupCenterPanel` | `TPopupOptions` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-popup) |
| `TDProgress` | `TProgress` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-progress) |
| `TDProgressLabelPosition` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-progress) |
| `TDProgressStatus` | `TProgressStatus` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-progress) |
| `TDProgressType` | `TProgressVariant` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-progress) |
| `TDRadio` | `TRadio` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-radio) |
| `TDRadioGroup` | `TRadioGroup` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-radio) |
| `TDRadioGroupState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-radio) |
| `TDRadioState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-radio) |
| `TDRadioStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-radio) |
| `TDRadius` | `TRadius` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDRangeSlider` | `TRangeSlider` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-slider) |
| `TDRate` | `TRate` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-rate) |
| `TDRefreshHeader` | `TPullDownRefresh` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-pull-down-refresh) |
| `TDResourceDelegate` | `TResourceDelegate` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDResourceManager` | `TResourceManager` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDResult` | `TResult` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-result) |
| `TDResultTheme` | `TResultStatus` | defaultTheme → info；success/warning/error 按对应状态迁移；[具体改法](#migration-component-result) |
| `TDRoundRangeSliderThumbShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDRoundRangeSliderTickMarkShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDRoundSliderThumbShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDRoundSliderTickMarkShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDRoundedRectRangeSliderTrackShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDRoundedRectSliderTrackShape` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDSearchAlignment` | `TSearchBarAlignment` | 实例 textAlignment 配置，不作为旧样式对象复用；[具体改法](#migration-component-search) |
| `TDSearchBar` | `TSearchBar` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-search) |
| `TDSearchBarCallBack` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-search) |
| `TDSearchBarClearEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-search) |
| `TDSearchBarEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-search) |
| `TDSearchStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-search) |
| `TDSelectOption` | `TTreeSelectOption` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-tree-select) |
| `TDSelectTag` | `TSelectTag` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-tag) |
| `TDSideBar` | `TSideBar` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-side-bar) |
| `TDSideBarController` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-side-bar) |
| `TDSideBarItem` | `TSideBarItem` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-side-bar) |
| `TDSideBarStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-side-bar) |
| `TDSkeleton` | `TSkeleton` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-skeleton) |
| `TDSkeletonAnimation` | `TSkeletonAnimation` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-skeleton) |
| `TDSkeletonRowCol` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-skeleton) |
| `TDSkeletonRowColObj` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-skeleton) |
| `TDSkeletonRowColObjStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-skeleton) |
| `TDSkeletonRowColStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-skeleton) |
| `TDSkeletonTheme` | `TSkeletonVariant` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-skeleton) |
| `TDSlidePopupRoute` | `TPopup` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-popup) |
| `TDSlider` | `TSlider` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-slider) |
| `TDSliderState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-slider) |
| `TDSliderThemeData` | `TSliderThemeData` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-slider) |
| `TDSpacers` | `TSpacers` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDStepper` | `TStepper` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-stepper) |
| `TDStepperController` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-stepper) |
| `TDStepperEventType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-stepper) |
| `TDStepperIconButton` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-stepper) |
| `TDStepperIconType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-stepper) |
| `TDStepperOverlimitFunction` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-stepper) |
| `TDStepperOverlimitType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-stepper) |
| `TDStepperSize` | `TStepperSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-stepper) |
| `TDStepperTheme` | `TStepperVariant` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-stepper) |
| `TDSteps` | `TSteps` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-steps) |
| `TDStepsDirection` | `TStepsDirection` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-steps) |
| `TDStepsItemData` | `TStepsItemData` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-steps) |
| `TDStepsStatus` | `TStepsStatus` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-steps) |
| `TDSwipeCell` | `TSwipeCell` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-swipe-cell) |
| `TDSwipeCellAction` | `TSwipeCellAction` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-swipe-cell) |
| `TDSwipeCellInherited` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swipe-cell) |
| `TDSwipeCellPanel` | `TSwipeCellPanel` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-swipe-cell) |
| `TDSwipeDirection` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swipe-cell) |
| `TDSwiperArrowPagination` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swiper) |
| `TDSwiperDotsPagination` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swiper) |
| `TDSwiperPagination` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-swiper) |
| `TDSwitch` | `TSwitch` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-switch) |
| `TDSwitchSize` | `TSwitchSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-switch) |
| `TDSwitchState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-switch) |
| `TDSwitchType` | `TSwitchVariant` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-switch) |
| `TDTDResourceBuilder` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-theme) |
| `TDTab` | `TTab` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-tabs) |
| `TDTabBar` | `TTabsBar` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-tabs) |
| `TDTabBarIndicator` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tabs) |
| `TDTabBarOutlineType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tabs) |
| `TDTabBarVerticalIndicator` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tabs) |
| `TDTabBarView` | `TTabsBarView` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-tabs) |
| `TDTabOutlineType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tabs) |
| `TDTabSize` | `TTabsBarSize` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-tabs) |
| `TDTable` | `TTable` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-table) |
| `TDTableCol` | `TTableColumn` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-table) |
| `TDTableColAlign` | `TTableColumnAlign` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-table) |
| `TDTableColFixed` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `TDTableEmpty` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `TDTableState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-table) |
| `TDTag` | `TTag` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-tag) |
| `TDTagShape` | `TTagShape` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-tag) |
| `TDTagSize` | `TTagSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-tag) |
| `TDTagStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tag) |
| `TDTagTheme` | `TTagColorPreset` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-tag) |
| `TDTapEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-empty) |
| `TDTapFunction` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-stepper) |
| `TDText` | `TText` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-text) |
| `TDTextConfiguration` | `TTextThemeData` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-text) |
| `TDTextLabel` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-progress) |
| `TDTextPaddingConfig` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-text) |
| `TDTextSpan` | `TTextSpan` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-text) |
| `TDTextarea` | `TTextarea` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-textarea) |
| `TDTextareaLayout` | `TTextareaLayout` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-textarea) |
| `TDTheme` | `TThemeData` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-theme) |
| `TDThemeData` | `TThemeData` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-theme) |
| `TDTimeCounter` | `TTimeCounter` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-time-counter) |
| `TDTimeCounterController` | `TTimeCounterController` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-time-counter) |
| `TDTimeCounterDirection` | `TTimeCounterDirection` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-time-counter) |
| `TDTimeCounterSize` | `TTimeCounterSize` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-time-counter) |
| `TDTimeCounterStatus` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-time-counter) |
| `TDTimeCounterStyle` | `TTimeCounterThemeData` + `content` | 不等价于 TTimeCounterVariant；仅现有颜色/圆角可用 Theme，任意块布局由 content 实现；[具体改法](#migration-component-time-counter) |
| `TDTimeCounterTheme` | `TTimeCounterVariant` | 入口重组，见对应组件；不保证参数/行为兼容；[具体改法](#migration-component-time-counter) |
| `TDToast` | `TToast` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-toast) |
| `TDToastConfig` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-toast) |
| `TDTreeSelect` | `TTreeSelect` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-tree-select) |
| `TDTreeSelectChangeEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tree-select) |
| `TDTreeSelectStyle` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-tree-select) |
| `TDUpload` | `TUpload` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-upload) |
| `TDUploadBoxType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-upload) |
| `TDUploadClickEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-upload) |
| `TDUploadErrorEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-upload) |
| `TDUploadFile` | `TUploadFile` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-upload) |
| `TDUploadFileStatus` | `TUploadFileStatus` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-upload) |
| `TDUploadMediaType` | `TUploadMediaType` | 同名或前缀对应，仍需核对参数/默认行为；[具体改法](#migration-component-upload) |
| `TDUploadType` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-upload) |
| `TDUploadValidatorError` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-upload) |
| `TDUploadValidatorEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-upload) |
| `TDUploadValueChangedEvent` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-upload) |
| `TDate` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-calendar) |
| `TGIconHeaderWidget` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-pull-down-refresh) |
| `TGIconHeaderWidgetState` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-pull-down-refresh) |
| `TapCallback` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-cascader) |
| `TextAlignment` | `TDividerAlign` | 通过 align 配置；方向另由 layout 决定；[具体改法](#migration-component-divider) |
| `TrapezoidPath` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-badge) |
| `horizontalChild` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-radio) |
| `kTextForceVerticalCenterEnable` | 已移除；局部布局和文字样式 | 无新的全局强制居中开关，不能按旧像素补偿强制裁切段落；[具体改法](#migration-component-text) |
| `kTextNeedGlobalFontFamily` | 已移除；`TTextThemeData` / `TextStyle` | 字体通过局部主题或实例style配置，在线字体由业务预加载；[具体改法](#migration-component-text) |
| `slideTransitionFromToAlignment` | 旧声明已移除 | 不保留此类型的继承或调用契约；按该组件的公开参数、回调或内容槽改写；[具体改法](#migration-component-popup) |

</details>
