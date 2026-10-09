## API

### TCollapse

类型参数：`T extends Object`


折叠面板列表组件，需配合 `TCollapsePanel` 使用

#### 构造方法

##### TCollapse

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| animationDuration | Duration? | - | 折叠面板展开和收起的动画时长；未设置时使用 Flutter 主题动画默认值。 | 否 |
| children | List&lt;TCollapsePanel&lt;T&gt;&gt; | - | 折叠面板列表的子组件 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| mode | TCollapseMode | TCollapseMode.multiple | 折叠面板模式 | 否 |
| onChanged | ValueChanged&lt;List&lt;T&gt;&gt;? | - | 展开值列表变更回调。 回调返回点击后的完整、不可修改列表。为 null 时整组不可交互，并使用禁用 视觉和语义；单项仍可通过 `TCollapsePanel.disabled` 禁用。 | 否 |
| value | List&lt;T&gt; | - | 当前展开面板的值列表，是所有模式唯一的展开状态源。 列表中的值必须唯一，并与唯一的 `TCollapsePanel.value` 匹配。 `TCollapseMode.accordion` 模式最多允许一个值。 | 是 |
| variant | TCollapseVariant? | - | 折叠面板视觉形态；未设置时为 `TCollapseVariant.block`。 | 否 |


### TCollapsePanel

类型参数：`T extends Object`


折叠面板配置。

#### 构造方法

##### TCollapsePanel

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 折叠面板的背景色。 | 否 |
| body | Widget | - | 折叠面板的内容组件。 | 是 |
| bodyHeight | double? | - | 展开内容区域的固定高度（包含内容内边距）。 适用于 `ListView` 等需要有界高度的内容；为空时由内容自然决定高度。 非空时必须是有限且大于 0 的值。 | 否 |
| disabled | bool | false | 是否禁用面板交互。 | 否 |
| expandIconBuilder | TCollapsePanelBuilder? | _defaultExpandIconBuilder | 构建展开图标。 省略时使用 TDesign 默认箭头；显式传入 null 时隐藏箭头；传入 builder 时以其返回的 Widget 替换默认箭头。Widget 会继承组件解析出的图标主题。 | 否 |
| headerBuilder | ExpansionPanelHeaderBuilder | - | 折叠面板的头部组件构造函数。 | 是 |
| key | Key? | - | 面板标识，用于列表插入、删除和重排时保留内容状态。 | 否 |
| leadingBuilder | TCollapsePanelBuilder? | - | 构建标题左侧区域。 返回的 Widget 会继承组件解析出的文字和图标主题。 | 否 |
| placement | TCollapsePlacement | TCollapsePlacement.bottom | 内容相对标题的展开方向。 | 否 |
| semanticsLabel | String? | - | 面板标题的无障碍标签；复杂自定义标题无法自动提取文本时使用。 | 否 |
| trailingBuilder | TCollapsePanelBuilder? | - | 构建标题右侧、展开图标之前的操作区域。 可根据 builder 收到的 `isExpanded` 显示“展开/收起”等文案或任意 Widget。 | 否 |
| value | T | - | 面板唯一标识，用于匹配父级 `TCollapse.value` 中的展开值。 | 是 |


### TCollapseMode

折叠面板展开模式。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| multiple | TCollapseMode | - | 多个面板可同时展开。 | - |
| accordion | TCollapseMode | - | 最多展开一个面板。 | - |


### TCollapseVariant

折叠面板视觉形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| block | TCollapseVariant | - | 通栏形态。 | - |
| card | TCollapseVariant | - | 卡片形态。 | - |


### TCollapsePlacement

折叠内容相对标题的展开方向。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| bottom | TCollapsePlacement | - | 内容在标题下方展开。 | - |
| top | TCollapsePlacement | - | 内容在标题上方展开。 | - |


### TCollapsePanelBuilder

根据折叠状态构建面板头部区域内容的回调。

位置参数：`context, isExpanded`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 折叠面板头部的构建上下文。 | 是 |
| isExpanded | bool | - | 当前面板是否展开。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 面板头部内容。 | - |


### TCollapseThemeData

折叠面板组件级 ThemeExtension

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认面板背景色 未配置时使用 bgColorContainer Token；单个面板的 backgroundColor 优先。 | 否 |
| cardBorderRadius | BorderRadius? | - | 卡片圆角。 仅卡片形态生效，未配置时使用 radiusLarge Token。 | 否 |
| cardMargin | EdgeInsetsGeometry? | - | 卡片外边距。 仅卡片形态生效，未配置时左右均使用 spacer2 Token。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距。 未配置时四边均使用 spacer2 Token。 | 否 |
| contentTextStyle | TextStyle? | - | 内容文字样式。 | 否 |
| disabledHeaderTextStyle | TextStyle? | - | 禁用状态标题文字样式。 | 否 |
| disabledIconColor | Color? | - | 禁用状态展开图标颜色。 未配置时使用 textColorDisabled Token。 | 否 |
| dividerColor | Color? | - | 分隔线颜色。 未配置时使用 componentStroke Token。 | 否 |
| elevation | double? | - | 阴影 未配置时为 0。 | 否 |
| headerTextStyle | TextStyle? | - | 标题文字样式。 | 否 |
| iconColor | Color? | - | 展开图标颜色。 未配置时使用 textColorPlaceholder Token。 | 否 |
