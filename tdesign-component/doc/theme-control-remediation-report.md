# 全组件样式控制修复与人工介入报告

## 已采用的统一规则

```text
实例显式参数
> TDesign 组件 ThemeExtension
> 调用方显式配置的 Material 子主题
> 调用方显式配置的 ColorScheme
> TDesign Token
> Flutter 未被 TDesign 定义的隐式默认值（包括 M3）
```

这里的“显式 Material”不包括 Flutter 根据 `useMaterial3` 自动生成的
`TextTheme`、`IconTheme`、`ColorScheme`、`VisualDensity` 和
`MaterialTapTargetSize`，也不包括 `TThemeBuilder` 从 Token 投影出的 Material
主题。找不到唯一 Material 对应物时，不再强行接入相似的 Material Theme；
组件 Theme 和 Token 已有定义的字段继续由 TDesign 控制，只有 TDesign
完全未定义的原生控件字段才允许落到 Flutter 默认值。

## 本轮修复

- 新增显式来源识别，过滤 M2/M3 自动生成的颜色、字体、图标、禁用色、
  分割线和点击区域默认值。
- `TThemeBuilder` 对 ColorScheme、TextTheme、IconTheme、DividerTheme 和
  ButtonStyle 的 Token 投影带来源标记，避免投影反过来遮蔽组件 Theme/Token。
- 修复 Button、Badge、Cell、Checkbox、Collapse、Drawer、DropdownMenu、
  Form、Icon、Input、Link、Loading、Navbar、Progress、Radio、Rate、Result、
  Slider、Stepper、Switch、Tabs、Tag、Text 的逐字段优先级。
- Input 新增实例 `style`、`cursorColor`，组件 Theme 新增 `textStyle`、
  `cursorColor`、`decorationTheme`、`clearIconColor`；边框、提示文字和清除图标
  不再由 M3 隐式默认值决定。
- Checkbox/Radio 只读取显式 `VisualDensity` 和
  `MaterialTapTargetSize`；默认点击区域保持 TDesign 既有尺寸。
- Popover 阴影改用 TDesign `shadowsTop` Token；Rate 半星浮层阴影改用组件
  Theme/`shadowsBase`；Loading 渐变从当前颜色透明化，不再写死白色。
- Popup、DropdownMenu 已捕获触发子树主题；本轮补齐 LoadingController、
  Message、Toast，并让 Rate 半星浮层冻结触发子树解析出的 Theme/Token，
  root overlay 不再丢失局部 ThemeExtension。

## 56 个组件审查结果

| 组件组 | 组件 | 结论 |
|---|---|---|
| 有明确 Material 对应物，逐字段桥接 | badge、button、cell、checkbox、collapse、dialog、divider、dropdown_menu、input、loading、navbar、progress、radio、slider、stepper、switch、tabs | 实例/组件 Theme 优先；只读取显式 Material 字段；颜色再回退显式 ColorScheme 和 Token；未合并完整 M3 style |
| TDesign 语义优先，无唯一 Material 对应物 | action_sheet、avatar、backtop、calendar、cascader、date_time_picker、drawer、empty、footer、image、image_viewer、indexes、message、notice_bar、picker、popover、popup、rate、refresh、result、search、sidebar、skeleton、steps、swipe_cell、table、time_counter、toast、tree、upload | 不强接相似 Material Theme；组件 Theme > Token；原生子控件仅在 TDesign 未定义字段上保留 Flutter 默认 |
| 基础样式能力 | icon、link、tag、text | 已按实例 > 组件 Theme > 显式 Material/ColorScheme > Token 解析；Tag 几何仍由 TDesign 控制，不接入 ChipTheme 几何 |
| 组合/委托组件 | fab、form、textarea | FAB 视觉委托 Button；Form 文字和 Input 分层负责；Textarea 复用 Input，同一优先级链 |
| 带 Overlay 的组件 | dropdown_menu、loading、message、popover、popup、rate、toast | 触发子树 Theme 被捕获或在打开时完成解析；不会因为插入 root overlay 回退到应用根主题 |
| 纯 TDesign 自绘/布局 | swiper、tabbar | TDesign Theme/Token 控制已有视觉；只允许其内部原生按钮读取未被 TDesign 定义的行为字段，不引入 M3 几何兜底 |

## 防回归测试与快照

- `t_material_theme_priority_test.dart`
  - 验证隐式 M2/M3 Theme 不进入显式优先级。
  - 验证 `TThemeBuilder` 投影仍属于 Token 层。
  - 验证 Switch、Checkbox、Loading、Input 以及展示组件的优先级和几何稳定。
- `t_button_theme_priority_test.dart`
  - 验证 Button 的实例、组件 Theme、Material Theme、ColorScheme、Token 链。
- `t_m3_isolation_golden_test.dart`
  - 同屏渲染 M2/M3。
  - 覆盖 Checkbox、Radio、Switch、Progress、Loading、Link、Tag、Badge、
    Rate、Input、Tabs、Icon、Text、Slider、Button。
  - 两侧 TDesign 控件视觉必须一致。
- Overlay 回归测试
  - DropdownMenu、Popup 既有捕获测试。
  - 新增 Rate、LoadingController、Message、Toast 的局部 ThemeExtension
    继承测试。
- 既有 golden 不做批量更新；仅在人工对比确认视觉正常后，更新
  Button、Base Components、Navigation Components 中由 TDesign Token
  字体度量优先级修正产生的预期基线。
- 最终验证：`flutter analyze` 无问题；完整 `flutter test` 共 2049 项全部
  通过；M2/M3 隔离快照已人工核对，颜色、文字、几何和状态一致。

## 仍需人工决策，但不阻塞本轮样式修复

### 1. ThemeData 无法保留 TextTheme 的“构造来源”

Flutter 在 `MaterialApp` 中会本地化并补全 TextTheme，运行时无法百分之百区分
“只显式设置了一个与默认值相同的文字颜色”和“框架自动生成的颜色”。当前
策略以字体度量变化识别显式 TextTheme，颜色优先建议使用组件 Theme、
局部 `DefaultTextStyle` 或显式 ColorScheme。不要加入按颜色常量猜来源的兼容
分支。

### 2. 公开 API 职责迁移

- `TImageThemeData.cacheWidth/cacheHeight/excludeFromSemantics`
- `TStepsThemeData.status`
- `TNoticeBarThemeData.prefixIcon/suffixIcon`

这些字段涉及性能、业务状态、内容或无障碍，不属于样式 Token。本轮不做
破坏性迁移，也没有为其新增双轨兼容；需单独确定 breaking-change 方案。

### 3. Material 缺少 success 语义色

Link、Tag、Result、NoticeBar、Upload 的 success 继续使用组件 Theme 或
TDesign Token。未把 `tertiary` 硬编码为 success，也没有因为缺少 Material
语义而降低 TDesign 优先级。

### 4. 可选的产品策略，不是兼容缺陷

- Tag 是否未来允许 ChipTheme 控制 padding/shape/side。
- TabBar 是否未来对接 NavigationBarTheme。
- Search 是否未来选择 SearchBarTheme 或 InputDecorationTheme 作为唯一
  Material 桥接层。

在产品明确前，维持 TDesign Theme/Token 控制比同时接入多个 Material 候选
更稳定。
