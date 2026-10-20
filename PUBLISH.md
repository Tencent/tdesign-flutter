# 版本发布流程

## 1.0 发布前准备

本轮状态、剩余项和关闭条件统一记录在 [发布候选收口记录](./specs/074-release-readiness-closeout/readiness.md)。先按该记录处理缺口，再在独立 `release/1.0.0` PR 升级版本并冻结候选；版本 PR 的建立不表示已经放行。

1. 固定发布候选提交，记录完整 SHA、目标版本及 Flutter/Dart 版本；统一组件 pubspec、示例 pubspec 与 example/assets/version 的版本展示及构建号。本轮准备不等于已经发布 1.0。
2. 从 `0.2.7` 升级的说明统一维护在 [迁移指南](./tdesign-site/site/docs/migration-0.2.7-to-1.0.md)。执行 `node scripts/sync-readme.mjs` 更新指南内可运行片段并同步包内副本，随后用 `--check` 确认；站点直接读取源文件，不直接改包内副本。
3. 在 Flutter 3.32.0 和当前 stable 的隔离环境解析依赖并执行严格分析、Upload 回归、独立迁移消费测试；记录图片选择器及平台实现包的实际版本。最低版本、正常升级、业务同时依赖较新图片选择器三个场景分别留证。
4. 运行 `dart run tool/run_component_regression.dart`、共享 Demo 功能及工具自测。Linux Flutter 3.32.0 的视觉回归先无更新运行；未登记场景单独验证。不能以批量更新 Golden 或更改容差消除未知差异。
5. 验证 Android/iOS/Web 构建；依照实际解析的插件最低要求检查宿主平台配置。iOS 无签名构建只证明构建链，不等于真机运行或 App Store 交付。
6. 在最终候选上填写 [人工验收表](./specs/058-release-preparation/manual-acceptance.md)，覆盖输入/输入法、浮层、日期/滚动、字体/主题、权限和异步结果。设备、设计、Review 记录缺失的项目仍待办，不因旧 PR 合并自动关闭。
7. 在 `tdesign-component` 执行 `flutter pub publish --dry-run`，检查版本、README/迁移说明、许可证和字体资源包含在包中，确认无单一版本依赖警告。独立宿主必须通过公开包入口编译与关键交互，不能依赖本库内部测试 helper。
8. 先核对 [首批差异最新处置](./specs/060-token-difference-resolution/acceptance.md)；候选补丁不等于已实施/通过视觉验收，32项处置不替代其余524项审查。再核对 [组件消费逐项验收](./specs/059-component-token-runtime-evidence/acceptance.md)：功能回归通过不等于Token/视觉审查完成；按该记录检查仍未关闭的差异和运行缺口。另核对 [发布准备记录](./specs/058-release-preparation/acceptance.md) 与 [尚未处理的 CI 审查](./specs/057-release-readiness-audit/ci-review.md)。本轮没有实施 CI/远端规则调整；未关闭的发布门槛仍须在正式发布前处理。

## 现有仓库自动化流程

以下描述已有实现，不表示所有正式交付环节都已自动化：

1. 从 `develop` 新建 `release/x.y.z` 分支，修改 `tdesign-component/pubspec.yaml` 中的版本号，并创建目标为 `develop` 的 Pull Request。
2. PR 打开或更新时，Auto Release workflow 会生成从上个版本到当前版本的 CHANGELOG 草稿，并评论到 release PR。
3. 发布人检查并整理 CHANGELOG；按 workflow 约定编辑对应评论，自动化会将确认后的内容写入 `tdesign-site/CHANGELOG.md`。组件 CHANGELOG 由 CLI 生成，不手工改写。
4. 确认无误后合并 release PR 到 `develop`。
5. release PR 合并后，Auto Release workflow 创建版本 tag。
6. tag 创建后，TAG_PUSH workflow 将当时的 `develop` 合并到 `main` 并推送。

相关实现：`.github/workflows/auto-release.yml`、`.github/workflows/tag-push.yml`。现有流程存在候选 SHA 与移动分支不一致的风险，具体审查保留在上述 CI 报告。正式发布人必须核实 tag、包及线上产物来源；不能证明一致时暂停交付。不要将 tag 创建或任务关闭当成包/站点/APK 已验证成功。

## 正式上传和上线核对

- 在最终 release PR 中把目标版本切换为 `1.0.0`，完成最终检查后由发布人按团队的 pub.dev/站点/CDN 发布权限执行实际上传；准备阶段不提前发布，不复用已存在的版本号。
- 包、站点及 Demo APK 使用同一验收候选，记录来源 SHA、版本和产物哈希。确认正式站点的迁移页、API、示例代码与包接口一致。
- pub.dev 正式 1.0 可用后，将根 README 的预发布源码依赖示例改为 `tdesign_flutter: ^1.0.0`，再同步包和站点副本。不要在版本不存在时给用户一个无法安装的稳定版依赖。
- 发布后新建业务宿主，只声明 pub.dev 的 `tdesign_flutter: ^1.0.0`，重新获取依赖并验证本文迁移示例。准备阶段的 path 依赖和运行时文件副本验证不能替代该步骤。
- 检查正式站点资源和缓存；从二维码/下载链接实际下载 APK，核对包版本、安装和主要页面。CDN 链接能访问不代表文件就是目标版本。
- 交付失败时停止传播有问题的版本，记录受影响产物；按 pub.dev 的实际机制处理撤回或后续修复版本。不要移动已对外发布的 tag 或悄悄替换相同版本内容。

## 更新日志一致性

现有站点和组件包CHANGELOG由各自发布工具维护，发布前对照同一候选版本逐项确认发布说明一致并保留历史记录。文档同步器不生成或互相覆盖CHANGELOG；两条发布生成链路的收敛另行实施。

## Demo APK 构建

PR 的 Flutter 3.32.0 下载包由 `PREVIEW_BUILD` 调用共享 APK workflow 生成；`test-build` 的 latest APK 用于兼容验证，不加入同一发布序列。版本资源和文件名共用组件版本，Android `versionCode` 为 `2030000000 + PREVIEW_BUILD run_number`，以兼容旧日期版本号并随运行递增。重试同一次运行保持版本号；正式交付不覆盖同版本产物。

固定 Flutter 3.32.0 的 Demo 使用已提交的 Example 锁文件；更新依赖时用该 SDK 重新解析并验证。latest 兼容任务删除其工作副本中的锁文件后独立解析。API、示例片段和构建日期由资源准备任务生成后传递，编译目录和插件元数据不跨 SDK 复用。资源准备 workflow 每个工作流执行一次，PR 的测试构建与预览构建仍分别准备资源。

本地或 CNB 直接打包时，先在 `tdesign-component` 执行 `dart tool/write_demo_build_info.dart`，再在 Example 执行 `flutter build apk --release --build-number <明确的构建号>`。未传构建号时采用 Example pubspec 的默认值，不保证可覆盖现有预览包。Flutter 3.32.0 的原生 release 构建保留默认插件准备，不添加 `--no-pub`。
