# 当前公开契约消费证据

三批共 82 个 Flutter 消费用例，覆盖全部 57 个 manifest 组件。只有公开包入口导入，不导入组件 src。`.dart.txt` 为可复现证据源码，不作为 API 页示例；将文件复制为临时 `.dart`，在 tdesign-component 下使用目标 SDK 执行 `flutter test --no-pub <临时文件> --reporter expanded`。切换 SDK 前必须先运行该 SDK 的 `flutter pub get`，不要混用 package_config。

这些测试验证列明的契约，不代表每个 API 的全部业务/视觉边界。批次 1 的 Theme.lerp 额外数据丢失、批次 2 的 Upload 同步业务异常转发属于现有行为特征记录，不应当被解释为这些组件问题已修复。

逐组件对应证据、当前源码哈希和核对范围见 `../current-semantic-ledger.json`。
