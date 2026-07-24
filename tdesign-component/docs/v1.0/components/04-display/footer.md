# TFooter

> **状态**：已实现 | **控制类**：纯展示 | **Sprint**：S3

`TFooter` 是无状态页脚组件，支持文字、链接和品牌三种形态。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `variant` | `TFooterVariant` | 必填 | `text`、`link` 或 `brand` |
| `text` | `String` | 空字符串 | 页脚文字 |
| `links` | `List<TLink>` | 空列表 | 链接列表 |
| `logo` | `String?` | `null` | 品牌图片 URL 或 asset |
| `width` | `double?` | `null` | 品牌图片宽度 |

`TFooterThemeData.height` 控制页脚默认高度。Theme 不保存实例 variant。源码逐文件覆盖率均高于 97%。
