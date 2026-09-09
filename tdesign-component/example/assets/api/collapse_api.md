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
| onChanged | ValueChanged<List<T>>? | - | 展开值列表变更回调。 回调返回点击后的完整、不可修改列表。为 null 时整组不可交互，并使用禁用 视觉和语义；单项仍可通过 `TCollapsePanel.disabled` 禁用。 |
| value | List<T> | - | 当前展开面板的值列表，是所有模式唯一的展开状态源。 列表中的值必须唯一，并与唯一的 `TCollapsePanel.value` 匹配。 `TCollapseMode.accordion` 模式最多允许一个值。 |
| variant | TCollapseVariant? | - | 折叠面板视觉形态。未设置时从 `TCollapseThemeData.variant` 读取。 |
