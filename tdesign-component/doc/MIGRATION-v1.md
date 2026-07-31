# TDesign Flutter v1 迁移记录

> `0.2.7` → `1.0.0-alpha.1` · `main@36af3143` → `develop@1f527212`

> [!WARNING]
> Alpha 期间 API 和视觉仍可能调整，请锁定精确版本。

## 升级前必读

```yaml
environment:
  sdk: ">=3.8.0 <4.0.0"
  flutter: ">=3.32.0"
dependencies:
  tdesign_flutter: 1.0.0-alpha.1
```

- 统一从 `package:tdesign_flutter/tdesign_flutter.dart` 导入；不要深层导入 `lib/src`。
- 公开类从 `TD*` 改为 `T*`，无 v0 兼容层；`TDIcons.*` 改为 `TIcons.*`。
- 选择类组件更多改为受控模式；Picker、Calendar、Cascader 的标题、确认和 Popup 由业务组合。

## 统一控制契约

| 范围 | 用户要做的事 |
| --- | --- |
| 受控状态 | `value` 是唯一真值，在 `onChanged` 中回写；部分组件无回调即禁用 |
| Controller | 谁创建谁释放；不在 `build` 中创建；同一 Controller 不绑定多个组件 |
| Overlay | 从目标 Theme/Navigator 子树的 context 调用；异步前检查 `mounted`；按需设置 `useRootNavigator` |
| 应用样式 | Token 通过 `TThemeBuilder.light/dark` 接入 |
| 组件样式 | 全局/局部使用对应 `T*ThemeData`，局部覆盖使用 `mergeExtension` |
| 单实例样式 | 使用显式参数或 Flutter 标准样式对象；内容使用 Widget 槽位/builder |

```text
实例显式参数
  > 组件 ThemeData
  > 用户显式设置的 Flutter 子树主题
  > 用户显式设置的 Material 主题
  > TDesign Token
```

Flutter/M3 隐式默认值不参与解析。禁止用 `copyWith(extensions: [...])` 覆盖整个扩展列表，也不要把数据、内容、回调或 Controller 放入 ThemeData。

## 组件速查

**高**：需重写调用；**中**：需调整参数/状态；**低**：主要是改名/主题迁移。下表不重复列出通用的 `TD* → T*`。

| 组件 | 风险 | 迁移动作 |
| --- | --- | --- |
| ActionSheet | 中 | 重建 item/分组；样式转 `TActionSheetThemeData` |
| Avatar | 中 | 换用图片/文字/图标槽位 |
| BackTop | 低 | 替换形状枚举与 ThemeData |
| Badge | 中 | 使用 `label`、`variant`、`child`；按需设 `showZero` |
| Button | 高 | `text/onTap/disabled` 改为 `child/onPressed/null`。单例样式用 `ButtonStyle`，公共样式用 `TButtonThemeData` |
| Calendar | 高 | 时间戳 `List<int>` 改为 `List<DateTime>` 受控值，内建 Popup/时间选择移除。业务需回写 `value`，并自行组合标题和确认操作 |
| Cascader | 高 | `List<Map>` 改为 `TCascaderOption` 树，组件改为严格受控。业务需维护并回写选中路径 |
| Cell | 中 | `TDCellStyle` 转槽位和 `TCellThemeData` |
| Checkbox | 中 | 回写受控值；替换尺寸/内容 builder |
| Collapse | 中 | 回写展开值；样式转 `TCollapseThemeData` |
| DateTimePicker | 高 | `TDDatePicker/TDPicker.showDatePicker` 改为纯选择的 `TDateTimePicker`。用 `mode/value/start/end/steps` 表达列与边界，弹层/确认外置 |
| Dialog | 高 | Input/Image/Alert 等多套类型统一为 `TDialog` + `TDialogAction`。输入、图片和自定义内容改用 Widget 槽位 |
| Divider | 低 | 替换 layout/align 枚举与 ThemeData |
| Drawer | 中 | 替换 placement/item 回调；回归安全区 |
| DropdownMenu | 高 | 旧内建选项模型改为 item + panel builder。业务自行管理面板草稿、确认和取消状态 |
| Empty | 低 | 替换 variant；图片/操作用槽位 |
| FAB | 中 | 样式转 `TFabThemeData`；回归拖拽边界 |
| Footer | 低 | 替换 variant 和链接槽位 |
| Form | 高 | `TDFormValidation` 改为 `TFormRule`，FormItem 值与 builder 契约调整。需重接校验时机和错误展示 |
| Icon | 高 | `TDIcons.*` 改 `TIcons.*`；不再依赖主包图标字体 |
| Image | 中 | 替换 variant 和加载/失败槽位 |
| ImageViewer | 高 | 移除对旧 Swiper 的参数透传。改用 itemBuilder/新页码回调，回归动态数据和关闭生命周期 |
| Indexes | 中 | 替换索引/锚点类型；回归滚动 |
| Input | 中 | 保留业务 controller/focusNode；公共样式转 ThemeData |
| Link | 中 | 替换配色/尺寸/变体；内容用槽位 |
| Loading | 中 | 替换 size/icon 枚举；样式转 ThemeData |
| Message | 高 | 移除 `MessageLink/MessageMarquee`；内容改用 Widget |
| NavBar | 中 | 替换 item action；回归安全区/边框 |
| NoticeBar | 中 | 移除 Style 类；样式转 ThemeData，点击用 tap target |
| Picker | 高 | 旧 MultiPicker/`TDPicker.show*` 改为 `TPickerOption` + columns/linked 受控模型。header、取消、确认和 Popup 由业务组合 |
| Popover | 中 | 替换 placement/回调；样式转 ThemeData |
| Popup | 高 | 旧 Panel/Route 入口统一为 `TPopupOptions` + `TPopupHandle`。top/bottom 默认高 240，left/right 默认宽 280，center 默认 240×240，显式尺寸优先 |
| Progress | 中 | 替换 variant/labelPosition；回归 button/micro 事件 |
| Radio | 中 | 回写受控值；替换尺寸/内容 builder |
| Rate | 中 | 回写分值；自定义图标改用 builder |
| Refresh | 低 | 替换类型名与 ThemeData |
| Result | 低 | 替换 variant；图标/标题/操作用槽位 |
| Search | 中 | 重接输入回调；公共样式转 ThemeData |
| SideBar | 中 | 移除旧 Controller；改用受控选中值 |
| Skeleton | 高 | RowCol 旧类型改为 `TSkeletonLayout/Block`，`delay` 改为 `Duration`。可使用预设 variant 或重建 block 布局 |
| Slider | 中 | 替换单值/区间值契约；回写受控值 |
| Stepper | 中 | 替换 size/variant；按新 value/callback 迁移 |
| Steps | 中 | 替换 item/direction/status 类型 |
| SwipeCell | 高 | 左右 Widget 参数改为 panel/action/side/motion 模型。需重建操作列表并处理开关状态回调 |
| Swiper | 高 | 移除旧第三方 Swiper 透传，改为自有 `TSwiper`。需迁移 Controller、autoplay、pagination 和 pageEffect |
| Switch | 中 | 回写 `value`；样式转 `TSwitchThemeData` |
| TabBar | 高 | `TDBottomTabBar*` 改 `TTabBar*`；重建 item/variant/badge |
| Table | 高 | `TDTableCol/Empty` 改为泛型列与 Widget 空态。业务需回写排序和选择状态 |
| Tabs | 高 | 改用 `TTabsBar/TTabsBarView/TTab`。需同步 controller/index，并回归 Tab 与 View 联动 |
| Tag | 中 | 移除 Style 类；样式转 ThemeData，回写选中态 |
| Text | 中 | 替换 Text/Span/Configuration；回归文本继承 |
| Textarea | 中 | 保留业务 controller/focusNode；样式转 ThemeData |
| Theme | 高 | 应用入口用 `TThemeBuilder`；局部覆盖用 `mergeExtension` |
| TimeCounter | 高 | 改用 status/builder/新 Controller；由创建方释放 |
| Toast | 高 | 替换 show/close 与图文方向；使用正确 context |
| TreeSelect | 高 | 重建选项数据和受控值；回归动态更新 |
| Upload | 高 | 转换文件/状态模型和回调；回归权限/失败流程 |

## 验收

先处理高风险组件，再在深浅色、窄屏、大字号、RTL、键盘、系统返回和动态数据下回归。

详细迁移指南将在后续文档列出。
