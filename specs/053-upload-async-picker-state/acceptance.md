# 验收

2026-10-10 修订检查点：Flutter 3.32.0 / Dart 3.8.0 与 Flutter stable 3.47.6 / Dart 3.13.5。

新增“禁用只暂停交互”的回归先在 PR 原 head `b061490f` 上检出 5 项失败：禁用后完成的结果、数量/大小校验错误与选择器异常被丢弃。修复后两版 Upload 组件测试均 50 项通过；生产源码 LH/LF 423/438 = 96.58%，超过 95% 门禁；两版 `flutter analyze --fatal-infos` 均 No issues found。

覆盖选择期间禁用、禁用后恢复、父级替换文件、收紧数量/大小限制、当前回调优先及请求开始时回调回退；禁用与在途锁均阻止新选择。既有回归继续覆盖卸载、取消/失败后重试、业务回调异常传播、不可变列表与布局切换。

API 文档使用 `tdesign_flutter_tools:main generate` 从 Upload dartdoc 重新生成，未手工编辑产物。公开基类、构造签名和默认值不变，不增加公开参数；与 develop 基线一致，临时禁用不取消在途请求，只修正其读取旧文件列表/限制的问题。

本次修订不改变绘制、主题或 Demo，不更新 Golden；最终 head 的双版本完整 CI 与 Linux Golden 由现有 workflow 验证。原 head 的 CI 成功不作为修订提交的通过证据。
