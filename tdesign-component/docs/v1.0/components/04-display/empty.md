# TEmpty

> **状态**：已实现 | **控制类**：A | **Sprint**：S3

`TEmpty` 展示空状态，并可选择提供操作区域。`onPressed == null` 时默认按钮禁用；自定义操作内容通过 `customOperationWidget` 提供。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `variant` | `TEmptyVariant` | `plain` | 纯展示或操作空态 |
| `icon` | `IconData?` | info icon | 默认图标 |
| `image` | `Widget?` | `null` | 替换默认图标的内容 |
| `emptyText` | `String?` | `null` | 描述文字 |
| `operationText` | `String?` | `null` | 默认按钮文案 |
| `onPressed` | `VoidCallback?` | `null` | 默认按钮回调 |
| `customOperationWidget` | `Widget?` | `null` | 自定义操作区域 |

`TEmptyThemeData` 只包含描述文字颜色、字体和默认按钮语义色，不保存 variant 或内容。

源码逐文件覆盖率为 100%。
