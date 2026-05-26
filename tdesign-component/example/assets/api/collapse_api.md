## API
### TCollapse
#### 简介
折叠面板列表组件，需配合 [TCollapsePanel] 使用
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration | kThemeAnimationDuration | 折叠面板列表的动画时长 |
| children | List<TCollapsePanel> | - | 折叠面板列表的子组件 |
| elevation | double | 0 | 折叠面板列表的阴影 |
| expansionCallback | ExpansionPanelCallback? | - | 折叠面板列表的回调函数； 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| style | TCollapseStyle | TCollapseStyle.block | 折叠面板列表的样式 - [TCollapseStyle.block] 通栏风格 - [TCollapseStyle.card] 卡片风格 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| initialOpenPanelValue | Object? | - | 折叠面板列表的默认展开面板的值； 当使用 [TCollapse.accordion] 时，此值生效 |


#### 工厂构造方法

##### TCollapse.accordion

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TCollapsePanel> | - | 折叠面板列表的子组件 |
| style | TCollapseStyle | TCollapseStyle.block | 折叠面板列表的样式 - [TCollapseStyle.block] 通栏风格 - [TCollapseStyle.card] 卡片风格 |
| expansionCallback | ExpansionPanelCallback? | - | 折叠面板列表的回调函数； 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded |
| animationDuration | Duration | kThemeAnimationDuration | 折叠面板列表的动画时长 |
| elevation | double | 0 | 折叠面板列表的阴影 |
| initialOpenPanelValue | Object? | - | 折叠面板列表的默认展开面板的值； 当使用 [TCollapse.accordion] 时，此值生效 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |


### TCollapseStyle
#### 简介
折叠面板的组件样式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| block | Block 通栏风格 |
| card | Card 卡片风格 |
