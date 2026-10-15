---
title: 从 0.2.7 升级到 1.0
description: 0.2.7 使用方升级到 1.0 的接口与行为迁移说明。
spline: explain
---

# 从 0.2.7 升级到 1.0

本文仅面向 `tdesign_flutter 0.2.7` 使用方。1.0 是不兼容升级，旧参数和旧行为不会通过兼容别名保留；不能对全项目执行一次 `TD` → `T` 替换后就认为迁移结束。

本文按 0.2.7 实际发布包与当前 1.0 候选编写。正式 1.0 发布后使用 `tdesign_flutter: ^1.0.0`；发布前不要把这个版本约束当作已经可从 pub.dev 安装的稳定版本。已有 alpha 的升级不在本文范围。

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

## 主题、文字与样式

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
```
<!-- migration-example:theme:end -->

- TD 内置外观按全局 Token、TD 组件 Theme、受支持的显式实例配置解析。Material `textTheme`、按钮 Theme、`IconTheme`、visualDensity 等不再隐式改变 TD 内置视觉；原生 Material 和调用方自定义内容仍可使用自己的主题。
- 使用 `mergeExtension` 合并子树组件主题，避免用 `copyWith(extensions: [...])` 意外丢弃其他 ThemeExtension。
- `TText` 的单实例文字使用 `style: TextStyle(...)`；`TTextSpan` 也用 `style`。不要继续传旧 `fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor`，删除线使用 `TextDecoration.lineThrough`。
- `textScaleFactor` 改为 `textScaler`；未传时继承系统文字缩放。旧 `TDTextPaddingConfig` 改为父级 Padding/Align/Center，段落文字不要按单行居中规则强行裁切。
- 在线字体先由业务调用 `TFontLoader.load` 并管理加载状态，之后通过文字 `style.fontFamily` 或 TD 文字 Theme 配置，不再在文字 build 时请求字体 URL。
- 自定义主题 JSON 需要核对字段与最终默认值；旧按钮状态样式、组件形态、交互时长等不能一律塞进 Theme。具体视觉默认值与实例的状态/规格选择分开。

## 按钮与禁用语义

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

## 受控值、输入与选择

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

## 表单改为字段树

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

## Picker、日期与浮层确认分离

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

## Popup、Dialog、Toast

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

## Upload 与平台依赖

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

## 两种 TabBar 与 Swiper

- **顶部页签**：旧 `TDTabBar/TDTabBarView` → `TTabsBar/TTabsBarView`，显式共享 TabController 或位于同一个 DefaultTabController。TTabsBarView 默认不可滑动，需要手势切页时显式配置 physics。
- **底部导航**：旧 `TDBottomTabBar` → `TTabBar`，提供 type、navigationTabs、受控 value/onChanged；旧 `topBorder/showTopBorder/centerDistance` 没有等价开关恢复，按新的默认边线和内置图文布局验收。
- **Swiper**：使用 `TSwiper` 的 children 或 itemBuilder/itemCount；自建 `TSwiperController` 并在页面 dispose 中释放。旧第三方 SwiperPlugin/SwiperController 和 TDSwiperPagination 不能直接传入；按当前分页、箭头与 pageEffect 能力重组。TSwiper 默认 loop/autoplay 均 false，业务需要时显式打开。

## 全部组件迁移索引

下表是入口与职责迁移索引，不承诺旧构造参数一一保留。每个组件的全部当前字段与默认值以 1.0 API 文档为准；旧名查找见文末导出索引。

| 组件 | 0.2.7 入口 | 1.0 入口 | 必须检查的迁移点 |
|---|---|---|---|
| button | `TDButton` | `TButton` | text→child；onTap→onPressed；type→variant；theme→colorPreset；状态样式合并为 ButtonStyle。 |
| divider | `TDDivider` | `TDivider` | 按当前构造及 TDividerThemeData 配置；方向/内容与具体视觉默认值分开。 |
| fab | `TDFab` | `TFab` | 重新核对尺寸/形态枚举、内容和事件；具体视觉从 TFabThemeData 配置。 |
| icon | `TDIcons / Icon` | `TIcons / TIcon` | 图标数据来自 tdesign_flutter_icons；TIcon 的默认视觉由 TD 控制，实例 size/color 可覆盖。 |
| text | `TDText / TDTextSpan` | `TText / TTextSpan` | 删除分散字体、在线加载和 padding 入口；用 style、textScaler、显式父布局，见文字一节。 |
| link | `TDLink` | `TLink` | 内容改用 Widget child；内置规格与 colorPreset 留实例，具体视觉从 TLinkThemeData 配置。 |
| backtop | `TDBackTop` | `TBackTop` | 按当前滚动绑定与形态配置；仅提供滚动控制器时按组件契约回顶，不用空回调猜禁用。 |
| drawer | `TDDrawer / TDDrawerWidget` | `TDrawer / showTDrawer` | 内容与浮层打开分开；宽度/背景移入 TDrawerThemeData，旧内容实现类型不再直接构造。 |
| indexes | `TDIndexes` | `TIndexes` | 重新核对受控索引及滚动对象；字母列表最大高度在组件 Theme 配置。 |
| navbar | `TDNavBar` | `TNavBar` | title/操作保留内容职责，背景、颜色、间距、边框和阴影迁入 TNavBarThemeData。 |
| sidebar | `TDSideBar` | `TSideBar` | 选择交给 value/onChanged；去掉旧 Controller/数据项样式依赖，视觉使用 TSideBarThemeData。 |
| steps | `TDSteps` | `TSteps.progress / selectable / display` | 选择进度、可选择或纯展示模式；不把三种状态源混用。 |
| tab_bar | `TDBottomTabBar` | `TTabBar` | 底部导航：显式 type、navigationTabs、value/onChanged；尺寸/颜色/分隔线迁 Theme。 |
| tabs | `TDTabBar / TDTabBarView` | `TTabsBar / TTabsBarView` | 顶部页签：共享 TabController 或 DefaultTabController；不是底部 TTabBar。 |
| form | `TDForm / FormController` | `TForm / TFormField / TFormController` | 从 items/rules/data 配置改为字段 Widget 树；value/onChanged、validator 与控制器职责分开。 |
| input | `TDInput` | `TInput` | controller 与 initialValue 互斥；onChanged/hintText/prefix/suffix；不要把 initialValue 当持续受控值。 |
| textarea | `TDTextarea` | `TTextarea` | 多行输入独立组件；用 minLines/maxLines、controller 与字段回调，核对计数/字符限制。 |
| search | `TDSearchBar` | `TSearchBar` | placeHolder→hintText、onTextChanged→onChanged、onActionClick→onActionPressed；不保留旧样式对象。 |
| checkbox | `TDCheckbox / TDCheckboxGroup` | `TCheckbox / TCheckboxGroup` | checked/id/controller 方案改为 value/onChanged；组提供 options 和受控选中集合，类型按当前 API。 |
| radio | `TDRadio / TDRadioGroup` | `TRadio / TRadioGroup<T>` | 单项必须位于同类型组下；组持有 value/onChanged，不再为每项维护选中状态。 |
| switch | `TDSwitch` | `TSwitch` | value/onChanged 管开关状态；空回调禁用；规格与具体配色分别从实例/Theme 设置。 |
| stepper | `TDStepper` | `TStepper` | required value；回调接受后重建；旧 defaultValue/eventController 不能作为迁移目标。 |
| slider | `TDSlider / TDRangeSlider` | `TSlider / TRangeSlider` | 按当前值及回调类型迁移；旧 Thumb/Track/Painter 类型不再作为可继承公开入口。 |
| rate | `TDRate` | `TRate` | 按当前受控数值与回调迁移；重验半星、禁用、只读与自定义指示器。 |
| picker | `TDPicker / TDMultiPicker / TDMultiLinkedPicker` | `TPicker + TPickerColumns / TPickerLinked` | 列数据改不可变 option 树；选择面板不负责业务确认，使用 TPickerPopup 组合草稿/确认/取消。 |
| date_time_picker | `TDDatePicker` | `TDateTimePicker` | DatePickerModel 改为 TDateTimePickerValue + DateTimePickerMode；上下界/步进显式传入，外部管理确认。 |
| cascader | `TDCascader / TDMultiCascader` | `TCascader` | 使用 TCascaderOption 树与受控路径；旧自定义 Tab/Action/多选控制类型不能机械替换，按当前能力重组。 |
| tree_select | `TDTreeSelect / TDSelectOption` | `TTreeSelect / TTreeSelectOption` | 树数据、选中集合与 multiple 明确配置；不再复用旧副作用控制器。 |
| calendar | `TDCalendar` | `TCalendar` | value 是 List<DateTime>；variant 决定单选/多选/区间；onChanged 回写，时间选择和弹层外部组合。 |
| upload | `TDUpload` | `TUpload` | files/onChanged 受控；单一 mediaType，maxFiles/maxFileSize、不可变结果；上传请求由业务执行。 |
| avatar | `TDAvatar` | `TAvatar` | 形状用 shape，物理大小/颜色迁 TAvatarThemeData；特殊文字用 child: Text(style: ...)。 |
| badge | `TDBadge` | `TBadge` | 统一 label/size 等当前入口；旧数字/红点/丝带类型按组件 API 重组，不复用旧 BadgeConfig。 |
| cell | `TDCell / TDCellGroup` | `TCell / TCellGroup` | 以内容槽组合；连续列表用 TCellGroup；统一背景/分隔线由组或 Theme 管理。 |
| collapse | `TDCollapse / TDCollapsePanel` | `TCollapse / TCollapsePanel` | 受控展开值与内容分开；形态/动画属于实例，具体外观从 TCollapseThemeData 配置。 |
| empty | `TDEmpty` | `TEmpty` | 旧 type 改为 icon/image/emptyText/operation 组合；不再查找 TDEmptyType，也不导入内部插图。 |
| footer | `TDFooter` | `TFooter` | 按当前内容/链接数据与组件 Theme 迁移，不继续使用旧 FooterType 作为类型。 |
| image | `TDImage` | `TImage` | 重验加载/失败/裁剪；尺寸和占位以当前 API 为准，旧 TDImageType 不能仅改前缀。 |
| image_viewer | `TDImageViewer / TDImageDialog` | `TImageViewer.show` | images 使用 ImageProvider 列表；initialIndex 与 onIndexChanged，内部 State/Dialog 类型不再直接实例化。 |
| progress | `TDProgress` | `TProgress` | variant/status 与主题分开；圆环 circleSize 表示外框边长，不能把旧半径语义套入。 |
| result | `TDResult` | `TResult` | 重选当前语义状态与内容插槽，背景/文字视觉使用 TResultThemeData。 |
| skeleton | `TDSkeleton / TDSkeletonRowCol*` | `TSkeleton / TSkeleton.custom` | 标准形态用 variant；自定义布局使用 TSkeletonLayout，不复用旧 RowCol 配置类型。 |
| swiper | `Swiper + TDSwiperPagination` | `TSwiper / TSwiperController` | 不再用第三方 SwiperController/SwiperPlugin；迁移 children 或 itemBuilder、分页及自有控制器。 |
| table | `TDTable / TDTableCol` | `TTable<T> / TTableColumn<T>` | 列使用 id/header/cellBuilder，data 必填；排序和选择是受控值，旧列/行选择回调需要改写。 |
| tag | `TDTag / TDSelectTag` | `TTag / TSelectTag` | 语义色用 colorPreset；选中/关闭遵循当前回调；具体字体和圆角从 Theme 设置。 |
| time_counter | `TDTimeCounter` | `TTimeCounter` | time 和 onChanged 均使用毫秒整数；重验自动开始、方向与结束；自建 Controller 由业务释放。 |
| action_sheet | `TDActionSheet` | `TActionSheet` | 按当前列表/宫格入口及 TActionSheetItem 组合；旧主题枚举不是新 Theme 类型。 |
| dialog | `TDAlertDialog / TDConfirmDialog / TDInputDialog` | `TDialog / TConfirmDialog / TDialogAction` | 单确认便捷弹窗与多操作槽分开；输入弹窗用 TDialog+TInput 组合，不恢复专用旧类。 |
| dropdown_menu | `TDDropdownMenu / TDDropdownItem` | `TDropdownMenu / TDropdownMenuItem` | 菜单项描述与 Single/MultiSelectPanel 组合；重验外部值更新、遮罩和 anchor，不直接改名前缀。 |
| loading | `TDLoading` | `TLoading` | 按当前 icon/内容与 TLoadingController 使用；旧内部指示器/State 不作为公开继承点。 |
| message | `TDMessage` | `TMessage` | duration 使用 Duration；status 替代旧 theme；显示由 Widget 树或命令句柄管理，不保留 visible 开关。 |
| notice_bar | `TDNoticeBar` | `TNoticeBar` | 语义状态/滚动/多行用当前 API；重验循环、点击与关闭，不搬旧样式类。 |
| popover | `TDPopover / TDPopoverWidget` | `TPopover` | 锚点和一次性命令按当前入口使用；offset/arrowSize/padding/背景/圆角从 TPopoverThemeData 设置。 |
| popup | `TDPopup*Panel / TDSlidePopupRoute` | `TPopup.show + TPopupOptions + TPopupHandle` | 面板、路由与控制统一；选择方向专属 Options/Inset，关闭结果从 handle.result 获取。 |
| refresh | `TDRefreshHeader` | `TPullDownRefresh` | 用 wrapper、受控回调和 TPullDownRefreshController 迁移；旧第三方 Header 不能仅改名。 |
| swipe_cell | `TDSwipeCell / TDSwipeCellAction` | `TSwipeCell / TSwipeCellAction` | 侧滑交互与逐项动作配置使用当前 API；不要依赖旧 Inherited/State，避免重复通知。 |
| toast | `TDToast` | `TToast` | duration 为 Duration，加载默认也会超时；持续加载显式 Duration.zero，背景拦截放 TOverlayConfig。 |
| theme | `TDTheme / TDThemeData` | `context.tTheme / TThemeData / TThemeBuilder` | 全局 Token→TD 组件 Theme→支持的实例配置；Material 外观不再反向影响 TD 默认视觉。 |

## 编译通过后仍要检查

- 控件禁用条件、受控回调回写、连续操作与异步完成后的状态。
- 主题明暗切换、局部 Theme、系统字体和 1/1.5/2 倍字号；不要用旧截图作为当前默认值的唯一依据。
- 键盘、复制粘贴、输入法组合区、选区及焦点；返回键、安全区和 Overlay 的关闭/释放。
- 列表排序/选择、日期边界、滚轮惯性、Swiper 实际页码；上传取消、权限与页面退出。
- 业务创建的文本/Tab/Swiper/刷新控制器按其实际类型生命周期释放；回调中 setState 前确认 State 存活。

不存在替代入口的旧公开 State、Painter、布局适配和静态辅助类，不应通过深层 src 导入恢复。若业务依赖其具体能力，应使用公开 Widget/Theme/Flutter 原语重新组合，或在业务中维护对应实现；这类代码需要人工迁移。

## 0.2.7 公开导出名称索引

以下覆盖 0.2.7 主入口追踪到的自有公开声明（不包括外部包导出）。它用于查找旧名和定位处置方向，**不是自动替换表**。即使目标同名，构造参数、回调、默认值或行为也可能变化。公开基类的继承成员与业务自行继承/深层导入需额外审查。当前入口还导出 Material；同名的 Flutter 类型不作为旧 TD 自有声明的兼容实现。

| 0.2.7 名称 | 当前入口或处置 | 范围 |
|---|---|---|
| `BadgeConfig` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `CalendarBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `CalendarFormat` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `CalendarTrigger` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `CalendarType` | `TCalendarVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `CellBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `ChevronPainter` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `Chinese2Formatter` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `ContentBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `DatePickerCallback` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `DatePickerModel` | `TDateTimePickerValue` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `DateSelectType` | `DateSelectType` | 同名或前缀对应，仍需核对参数/默认行为 |
| `DateSelectTypeNotifier` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `DateTypeKey` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `DefaultMapFactory` | `DefaultMapFactory` | 同名或前缀对应，仍需核对参数/默认行为 |
| `DefaultStickyHeaderController` | `DefaultStickyHeaderController` | 同名或前缀对应，仍需核对参数/默认行为 |
| `Font` | `Font` | 同名或前缀对应，仍需核对参数/默认行为 |
| `FontExtensions` | `FontExtensions` | 同名或前缀对应，仍需核对参数/默认行为 |
| `FontFamily` | `FontFamily` | 同名或前缀对应，仍需核对参数/默认行为 |
| `FormController` | `TFormController` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `FormItemNotifier` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `HollowCircle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `IconBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `IconTextDirection` | `IconTextDirection` | 同名或前缀对应，仍需核对参数/默认行为 |
| `ImageWidget` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `ItemBuilderType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `ItemDistanceCalculator` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `LabelBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `LeftItemBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `LeftLinePainter` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `LeftLineWidget` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `LinkClick` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `MessageLink` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `MessageMarquee` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `MessageTheme` | `TMessageStatus` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `MultiCascaderCallback` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `MultiCascaderListModel` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `MultiLinkedPickerModel` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `MultiPickerCallback` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnCellTap` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnCheckBoxGroupChange` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnCheckValueChanged` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnClose` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnDelete` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnGroupChange` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnImageTap` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnIndexChange` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnLongPress` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnLongTap` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnRadioGroupChange` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnRowSelect` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnScroll` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnSelect` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnSliderThemeDataUpdate` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnSwitchChanged` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `OnTap` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `PanelWithDownArrow` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `PlacementEnum` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `PlatformUtil` | `PlatformUtil` | 同名或前缀对应，仍需核对参数/默认行为 |
| `PopRoute` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `PopUpMenuItem` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `PopupClick` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `PopupDialog` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `PopupDialogState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `Position` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `ProgressIndicator` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `RadioCorner` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `RadioCornerIcon` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `RectClipper` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `RightItemBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `RowCheckFunc` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `ScaleFormatter` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `SelectableFunc` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `SideItemProps` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `SlideTransitionFrom` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `SliderMeasureData` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `SliverStickyHeader` | `SliverStickyHeader` | 同名或前缀对应，仍需核对参数/默认行为 |
| `SliverStickyHeaderRenderObjectElement` | `SliverStickyHeaderRenderObjectElement` | 同名或前缀对应，仍需核对参数/默认行为 |
| `SliverStickyHeaderState` | `SliverStickyHeaderState` | 同名或前缀对应，仍需核对参数/默认行为 |
| `SliverStickyHeaderWidgetBuilder` | `SliverStickyHeaderWidgetBuilder` | 同名或前缀对应，仍需核对参数/默认行为 |
| `StickyHeaderController` | `StickyHeaderController` | 同名或前缀对应，仍需核对参数/默认行为 |
| `SwipeMotion` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDActionSheet` | `TActionSheet` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDActionSheetAlign` | `TActionSheetAlign` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDActionSheetItem` | `TActionSheetItem` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDActionSheetItemCallback` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDActionSheetTheme` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDAlertDialog` | `TDialog` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDAvatar` | `TAvatar` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDAvatarShape` | `TAvatarShape` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDAvatarSize` | `TAvatarSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDAvatarType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBackTop` | `TBackTop` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDBackTopStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBackTopTheme` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBadge` | `TBadge` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDBadgeBorder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBadgeSize` | `TBadgeSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDBadgeType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBarItemAction` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBar` | `TTabBar` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDBottomTabBarBasicType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBarComponentType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBarIndicatorAnimation` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBarItemWithBadge` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBarOutlineType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBarPopUpBtnConfig` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBarPopUpShapeConfig` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDBottomTabBarTabConfig` | `TTabBarItemConfig` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDBoxShadows` | `TBoxShadows` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDButton` | `TButton` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDButtonEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDButtonIconPosition` | `TButtonIconPosition` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDButtonShape` | `TButtonShape` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDButtonSize` | `TButtonSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDButtonStatus` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDButtonStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDButtonTheme` | `TButtonColorPreset` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDButtonType` | `TButtonVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDCalendar` | `TCalendar` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCalendarBody` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCalendarCell` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCalendarHeader` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCalendarInherited` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCalendarPopup` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCalendarStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCapsuleRangeSliderThumbShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCapsuleRangeSliderTickMarkShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCapsuleRectRangeSliderTrackShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCapsuleRectSliderTrackShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCapsuleRectThemeData` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCapsuleSliderThumbShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCapsuleSliderTickMarkShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCardStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCascader` | `TCascader` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCascaderAction` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCell` | `TCell` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCellAlign` | `TCellAlign` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCellClick` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCellGroup` | `TCellGroup` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCellGroupTheme` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCellStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCheckBoxSize` | `TCheckboxSize` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDCheckbox` | `TCheckbox` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCheckboxGroup` | `TCheckboxGroup` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCheckboxGroupContainer` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCheckboxGroupContainerState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCheckboxGroupController` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCheckboxGroupInherited` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCheckboxGroupState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCheckboxState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCheckboxStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCircleIndicator` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCollapse` | `TCollapse` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCollapseIconTextBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDCollapsePanel` | `TCollapsePanel` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCollapseStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDColors` | `TColors` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDConfirmDialog` | `TConfirmDialog` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDContentDirection` | `TContentDirection` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDCustomTab` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDDatePicker` | `TDateTimePicker` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDDialogButtonOptions` | `TDialogAction` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDDialogButtonStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDDialogImagePosition` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDDivider` | `TDivider` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDDrawer` | `TDrawer` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDDrawerItem` | `TDrawerItem` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDDrawerItemClickCallback` | `TDrawerItemClickCallback` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDDrawerPlacement` | `TDrawerPlacement` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDDrawerWidget` | `TDrawer` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDDropdownItem` | `TDropdownMenuItem` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDDropdownItemBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDDropdownItemContentBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDDropdownItemController` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDDropdownItemOption` | `TDropdownMenuOption` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDDropdownItemOptionsCallback` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDDropdownMenu` | `TDropdownMenu` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDDropdownMenuDirection` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDEmpty` | `TEmpty` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDEmptyType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDExtraThemeData` | `TExtraThemeData` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFab` | `TFab` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFabShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDFabSize` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDFabTheme` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDFontFamilies` | `TFontFamilies` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFontLoader` | `TFontLoader` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFontLoaderWidget` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDFonts` | `TFonts` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFooter` | `TFooter` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFooterType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDForm` | `TForm` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFormItem` | `TFormItem` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDFormItemType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDFormValidation` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDFractionPagination` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDIconLabel` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDIcons` | `TIcons` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDImage` | `TImage` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDImageDialog` | `TImageViewer` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDImageType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDImageViewer` | `TImageViewer` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDImageViewerWidget` | `TImageViewer` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDIndexes` | `TIndexes` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDIndexesAnchor` | `TIndexesAnchor` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDIndexesList` | `TIndexesList` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDInput` | `TInput` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDInputDialog` | `TDialog` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDInputSize` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDInputSpacer` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDInputType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDInputView` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDItemWidget` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDLabelWidget` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDLink` | `TLink` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDLinkConfiguration` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDLinkSize` | `TLinkSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDLinkState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDLinkStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDLinkType` | `TLinkColorPreset` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDLoading` | `TLoading` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDLoadingController` | `TLoadingController` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDLoadingIcon` | `TLoadingIcon` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDLoadingSize` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDMap` | `TMap` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDMessage` | `TMessage` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDMultiCascader` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDMultiLinkedPicker` | `TPicker` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDMultiPicker` | `TPicker` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDNavBar` | `TNavBar` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDNavBarItem` | `TNavBarItem` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDNavBarItemBorder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDNoOverlayShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDNoneIndicator` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDNoticeBar` | `TNoticeBar` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDNoticeBarStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDNoticeBarTheme` | `TNoticeBarStatus` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDNoticeBarType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDPageTransformer` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDPicker` | `TPicker` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDPopover` | `TPopover` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDPopoverPlacement` | `TPopoverPlacement` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDPopoverTheme` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDPopoverWidget` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDPopupBasePanel` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDPopupBottomConfirmPanel` | `TPickerPopup` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDPopupBottomDisplayPanel` | `TPopupOptions` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDPopupCenterPanel` | `TPopupOptions` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDProgress` | `TProgress` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDProgressLabelPosition` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDProgressStatus` | `TProgressStatus` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDProgressType` | `TProgressVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDRadio` | `TRadio` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDRadioGroup` | `TRadioGroup` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDRadioGroupState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRadioState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRadioStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRadius` | `TRadius` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDRangeSlider` | `TRangeSlider` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDRate` | `TRate` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDRefreshHeader` | `TPullDownRefresh` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDResourceDelegate` | `TResourceDelegate` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDResourceManager` | `TResourceManager` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDResult` | `TResult` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDResultTheme` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRoundRangeSliderThumbShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRoundRangeSliderTickMarkShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRoundSliderThumbShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRoundSliderTickMarkShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRoundedRectRangeSliderTrackShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDRoundedRectSliderTrackShape` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSearchAlignment` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSearchBar` | `TSearchBar` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSearchBarCallBack` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSearchBarClearEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSearchBarEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSearchStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSelectOption` | `TTreeSelectOption` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDSelectTag` | `TSelectTag` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSideBar` | `TSideBar` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSideBarController` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSideBarItem` | `TSideBarItem` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSideBarStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSkeleton` | `TSkeleton` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSkeletonAnimation` | `TSkeletonAnimation` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSkeletonRowCol` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSkeletonRowColObj` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSkeletonRowColObjStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSkeletonRowColStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSkeletonTheme` | `TSkeletonVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDSlidePopupRoute` | `TPopup` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDSlider` | `TSlider` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSliderState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSliderThemeData` | `TSliderThemeData` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSpacers` | `TSpacers` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDStepper` | `TStepper` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDStepperController` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDStepperEventType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDStepperIconButton` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDStepperIconType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDStepperOverlimitFunction` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDStepperOverlimitType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDStepperSize` | `TStepperSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDStepperTheme` | `TStepperVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDSteps` | `TSteps` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDStepsDirection` | `TStepsDirection` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDStepsItemData` | `TStepsItemData` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDStepsStatus` | `TStepsStatus` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSwipeCell` | `TSwipeCell` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSwipeCellAction` | `TSwipeCellAction` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSwipeCellInherited` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSwipeCellPanel` | `TSwipeCellPanel` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSwipeDirection` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSwiperArrowPagination` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSwiperDotsPagination` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSwiperPagination` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSwitch` | `TSwitch` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSwitchSize` | `TSwitchSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDSwitchState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDSwitchType` | `TSwitchVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTDResourceBuilder` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTab` | `TTab` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTabBar` | `TTabsBar` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTabBarIndicator` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTabBarOutlineType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTabBarVerticalIndicator` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTabBarView` | `TTabsBarView` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTabOutlineType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTabSize` | `TTabsBarSize` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTable` | `TTable` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTableCol` | `TTableColumn` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTableColAlign` | `TTableColumnAlign` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTableColFixed` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTableEmpty` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTableState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTag` | `TTag` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTagShape` | `TTagShape` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTagSize` | `TTagSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTagStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTagTheme` | `TTagColorPreset` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTapEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTapFunction` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDText` | `TText` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTextConfiguration` | `TTextThemeData` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTextLabel` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTextPaddingConfig` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTextSpan` | `TTextSpan` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTextarea` | `TTextarea` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTextareaLayout` | `TTextareaLayout` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTheme` | `TThemeData` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDThemeData` | `TThemeData` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTimeCounter` | `TTimeCounter` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTimeCounterController` | `TTimeCounterController` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTimeCounterDirection` | `TTimeCounterDirection` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTimeCounterSize` | `TTimeCounterSize` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTimeCounterStatus` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTimeCounterStyle` | `TTimeCounterVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDTimeCounterTheme` | `TTimeCounterVariant` | 入口重组，见对应组件；不保证参数/行为兼容 |
| `TDToast` | `TToast` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDToastConfig` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTreeSelect` | `TTreeSelect` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDTreeSelectChangeEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDTreeSelectStyle` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDUpload` | `TUpload` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDUploadBoxType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDUploadClickEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDUploadErrorEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDUploadFile` | `TUploadFile` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDUploadFileStatus` | `TUploadFileStatus` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDUploadMediaType` | `TUploadMediaType` | 同名或前缀对应，仍需核对参数/默认行为 |
| `TDUploadType` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDUploadValidatorError` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDUploadValidatorEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDUploadValueChangedEvent` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TDate` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TGIconHeaderWidget` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TGIconHeaderWidgetState` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TapCallback` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TextAlignment` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `TrapezoidPath` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `horizontalChild` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
| `slideTransitionFromToAlignment` | 无对应的 TD 自有声明；按组件 Widget / Theme / Flutter 原语改写 | 旧实现无兼容契约；同名 Flutter 类型不代表等价 |
