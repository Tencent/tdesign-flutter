## API
### TTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| colorScheme | TTagColorScheme? | - | 语义色 |
| enabled | bool | true | 是否使用禁用视觉状态。 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 是否显示关闭图标。 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件。 标签本身不持有列表状态；需要移除标签时，请在此回调中更新父组件的 数据源并触发重建。 |
| onTap | GestureTapCallback? | - | 标签点击回调；为空时不创建标签点击行为。 |
| size | TTagSize | TTagSize.medium | 标签大小 |


### TSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容。 |
| colorScheme | TTagColorScheme? | - | 选中态语义色。 |
| icon | IconData? | - | 标签图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool>? | - | 选中状态变更回调；为空时禁用交互。 |
| size | TTagSize | TTagSize.medium | 标签尺寸。 |
| value | bool | - | 当前选中状态。 |
