## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 链接内容，通常为 `Text`。 |
| colorScheme | TLinkColorScheme? | - | 语义颜色方案；未设置时默认为 `TLinkColorScheme.defaultTheme`。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调；为 null 时链接为禁用态。 |
| prefixIcon | Widget? | - | 前置图标；为 null 时不占位。 |
| semanticLabel | String? | - | 无障碍语义标签。 |
| size | TLinkSize? | - | 链接尺寸；未设置时默认为 `TLinkSize.medium`。 |
| suffixIcon | Widget? | - | 后置图标；为 null 时不占位。 |
| tooltip | String? | - | 鼠标悬浮提示。 |
| underline | bool? | - | 是否显示下划线；未设置时读取 `TLinkThemeData.underline`，最终回退 false。 |
