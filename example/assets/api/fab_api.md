## API
### TDFab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| theme | TDFabTheme | TDFabTheme.defaultTheme | 主题 |
| shape | TDFabShape |TDFabShape.circle | 形状 |
| size | TDFabSize | TDFabSize.large | 大小 |
| text | String? | - | 文本 |
| icon | Icon? | - | 图标 |
| onClick | VoidCallback? | - | 监听点击事件 |

#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDFabTheme.primary  | 品牌色 |
| TDFabTheme.defaultTheme  | 默认色 |
| TDFabTheme.light  | 高亮色 |
| TDFabTheme.danger  | 危险色 |

| 名称  | 说明 |
| --- |  --- |
| TDFabShape.circle  | 圆形 |
| TDFabShape.square  | 矩形 |

| 名称  | 说明 |
| --- |  --- |
| TDFabSize.large  | 大 |
| TDFabSize.medium  | 中 |
| TDFabSize.small  | 小 |
| TDFabSize.extraSmall  | 特小 |