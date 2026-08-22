# 实施方案

- 重写 TextStyle 解析为单一 merge 链，并补齐 Flutter 原生 Text 参数。
- 保留 `TTextSpan` 的 Token 便利参数，但不再读取 Theme 或填充默认样式。
- 保留 `getRawText`，与组件内部 Text 共用同一构建入口。
- 将 `TFontLoader` 改为共享 Future 缓存，移除与 TText 绑定的 StatefulWidget。
- 迁移 Example、测试和文档，删除所有旧 API 调用；Demo 按普通文本、
  富文本两种模式分组展示可视能力。
- 分别验证 Flutter 3.32.0 与 latest，运行组件测试、analyze 和 Web 构建。
