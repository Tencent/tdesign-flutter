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
