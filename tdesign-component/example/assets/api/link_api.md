## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 链接内容，一般是 `Text` |
| colorScheme | TLinkColorScheme? | - | 语义颜色方案 |
| hover | bool | true | 是否开启点击反馈。为 false 时点击链接不会出现 InkWell 水波纹 / 高亮反馈， 但仍可正常响应点击（对应 h5 的 `hover` 能力）。默认 true。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调。为 null 时链接为禁用态 |
| prefixIcon | Widget? | - | 前置图标（仅在 `variant` 为 `TLinkVariant.icon` 时生效） |
| semanticLabel | String? | - | 语义标签（无障碍） |
| size | TLinkSize? | - | 尺寸；未传时读取 `TLinkThemeData.defaultSize`，再回退 medium。 |
| suffixIcon | Widget? | - | 后置图标（仅在 `variant` 为 `TLinkVariant.icon` 时生效） |
| tooltip | String? | - | 悬浮提示 |
| variant | TLinkVariant? | - | 链接形态；未传时读取 `TLinkThemeData.defaultVariant`，再回退 basic。 |
