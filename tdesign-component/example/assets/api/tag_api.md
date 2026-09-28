## API
### TTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| colorScheme | TTagColorScheme | TTagColorScheme.defaultTheme | 标签预设配色。 |
| enabled | bool | true | 是否使用禁用视觉状态。 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 是否显示关闭图标。 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件。 标签本身不持有列表状态；需要移除标签时，请在此回调中更新父组件的 数据源并触发重建。 |
| onTap | GestureTapCallback? | - | 标签点击回调；为空时不创建标签点击行为。 |
| size | TTagSize | TTagSize.medium | 标签大小 |
| variant | TTagVariant | TTagVariant.dark | 绘制形态。 |


### TSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容。 |
| colorScheme | TTagColorScheme | TTagColorScheme.primary | 选中态预设配色。 |
| icon | IconData? | - | 标签图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool>? | - | 选中状态变更回调；为空时禁用交互。 |
| size | TTagSize | TTagSize.medium | 标签尺寸。 |
| value | bool | - | 当前选中状态。 |
| variant | TTagVariant | TTagVariant.dark | 标签绘制形态。 |


### TTagThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| dangerColor | Color? | - | danger 预设的基础色，对应小程序的 `--td-tag-danger-color`。 未设置时沿显式 Material `ColorScheme.error`、全局 `errorColor` 回退。 仅影响 danger 预设；浅色填充仍使用 danger 浅色默认值。 |
| fixedWidth | double? | - | 标签固定宽度 |
| font | Font? | - | 字体尺寸 |
| fontWeight | FontWeight? | - | 字体粗细 |
| maxLines | int? | - | 文字最大行数。 未设置时组件默认按紧凑标签语义使用单行。 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| padding | EdgeInsets? | - | 自定义间距 |
| shape | TTagShape? | - | 标签形状 |
| squareBorderRadius | double? | - | 方形标签圆角，对应小程序的 `--td-tag-square-border-radius`。 未设置时为 4 逻辑像素（375px 基准下的 8rpx）；不影响圆角和标记形状。 |
| textColor | Color? | - | 文字颜色 |
