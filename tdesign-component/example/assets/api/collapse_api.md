## API
### TCollapse
#### 简介
折叠面板列表组件，需配合 `TCollapsePanel` 使用
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 折叠面板列表的动画时长 |
| children | List<TCollapsePanel<T>> | - | 折叠面板列表的子组件 |
| elevation | double? | - | 折叠面板列表的阴影 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | TCollapseMode | TCollapseMode.multiple | 折叠面板模式 |
| onChanged | ValueChanged<T?>? | - | 手风琴模式下 value 变更回调 |
| onExpansionChanged | ExpansionPanelCallback? | - | 折叠面板列表的回调函数； 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded |
| value | T? | - | 手风琴模式下当前展开面板的 value |


### TCollapsePanel
#### 简介
折叠面板配置。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 折叠面板的背景色。 |
| body | Widget | - | 折叠面板的内容组件。 |
| expandIconTextBuilder | TCollapseIconTextBuilder? | - | 展开图标旁的说明文案构建器。 |
| headerBuilder | ExpansionPanelHeaderBuilder | - | 折叠面板的头部组件构造函数。 |
| isExpanded | bool | false | 折叠面板是否展开。 |
| value | T? | - | 手风琴模式下用于标识面板的值。 |


### TCollapseThemeData
#### 简介
折叠面板组件级 ThemeExtension
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 动画时长 |
| backgroundColor | Color? | - | 默认面板背景色 |
| elevation | double? | - | 阴影 |
| variant | TCollapseVariant? | - | 面板风格（block/card） |


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


### TCollapseIconTextBuilder
#### 类型定义

```dart
typedef TCollapseIconTextBuilder = String Function(BuildContext context, bool isExpanded);
```
