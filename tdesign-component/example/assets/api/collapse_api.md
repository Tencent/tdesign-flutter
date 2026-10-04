## API
### TCollapse
#### 简介
折叠面板列表组件，需配合 `TCollapsePanel` 使用
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 折叠面板展开和收起的动画时长；未设置时使用 Flutter 主题动画默认值。 |
| children | List<TCollapsePanel<T>> | - | 折叠面板列表的子组件 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | TCollapseMode | TCollapseMode.multiple | 折叠面板模式 |
| onChanged | ValueChanged<List<T>>? | - | 展开值列表变更回调。 回调返回点击后的完整、不可修改列表。为 null 时整组不可交互，并使用禁用 视觉和语义；单项仍可通过 `TCollapsePanel.disabled` 禁用。 |
| value | List<T> | - | 当前展开面板的值列表，是所有模式唯一的展开状态源。 列表中的值必须唯一，并与唯一的 `TCollapsePanel.value` 匹配。 `TCollapseMode.accordion` 模式最多允许一个值。 |
| variant | TCollapseVariant? | - | 折叠面板视觉形态；未设置时为 `TCollapseVariant.block`。 |


### TCollapsePanel
#### 简介
折叠面板配置。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 折叠面板的背景色。 |
| body | Widget | - | 折叠面板的内容组件。 |
| bodyHeight | double? | - | 展开内容区域的固定高度（包含内容内边距）。 适用于 `ListView` 等需要有界高度的内容；为空时由内容自然决定高度。 |
| disabled | bool | false | 是否禁用面板交互。 |
| expandIconBuilder | TCollapsePanelBuilder? | _defaultExpandIconBuilder | 构建展开图标。 省略时使用 TDesign 默认箭头；显式传入 null 时隐藏箭头；传入 builder 时以其返回的 Widget 替换默认箭头。Widget 会继承组件解析出的图标主题。 |
| headerBuilder | ExpansionPanelHeaderBuilder | - | 折叠面板的头部组件构造函数。 |
| key | Key? | - | 面板标识，用于列表插入、删除和重排时保留内容状态。 |
| leadingBuilder | TCollapsePanelBuilder? | - | 构建标题左侧区域。 返回的 Widget 会继承组件解析出的文字和图标主题。 |
| placement | TCollapsePlacement | TCollapsePlacement.bottom | 内容相对标题的展开方向。 |
| semanticsLabel | String? | - | 面板标题的无障碍标签；复杂自定义标题无法自动提取文本时使用。 |
| trailingBuilder | TCollapsePanelBuilder? | - | 构建标题右侧、展开图标之前的操作区域。 可根据 builder 收到的 `isExpanded` 显示“展开/收起”等文案或任意 Widget。 |
| value | T | - | 面板唯一标识，用于匹配父级 `TCollapse.value` 中的展开值。 |


### TCollapseThemeData
#### 简介
折叠面板组件级 ThemeExtension
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认面板背景色 |
| cardBorderRadius | BorderRadius? | - | 卡片圆角。 |
| cardMargin | EdgeInsetsGeometry? | - | 卡片外边距。 |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距。 |
| contentTextStyle | TextStyle? | - | 内容文字样式。 |
| disabledHeaderTextStyle | TextStyle? | - | 禁用状态标题文字样式。 |
| disabledIconColor | Color? | - | 禁用状态展开图标颜色。 |
| dividerColor | Color? | - | 分隔线颜色。 |
| elevation | double? | - | 阴影 |
| headerTextStyle | TextStyle? | - | 标题文字样式。 |
| iconColor | Color? | - | 展开图标颜色。 |


### TCollapseMode
#### 简介
折叠面板展开模式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| multiple | 多个面板可同时展开。 |
| accordion | 最多展开一个面板。 |


### TCollapseVariant
#### 简介
折叠面板视觉形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| block | 通栏形态。 |
| card | 卡片形态。 |


### TCollapsePlacement
#### 简介
折叠内容相对标题的展开方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| bottom | 内容在标题下方展开。 |
| top | 内容在标题上方展开。 |


### TCollapsePanelBuilder
#### 简介
根据折叠状态构建面板头部区域内容的回调。
#### 类型定义

```dart
typedef TCollapsePanelBuilder = Widget Function(BuildContext context, bool isExpanded);
```
