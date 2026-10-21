# 版本发布流程

## 发布候选与验收

发布前待关闭事项集中维护在 [发布验收 Spec](./specs/engineering/057-Release-readiness/spec.md) 和 [候选清单](./specs/engineering/057-Release-readiness/readiness.md)。它们不表示当前已经放行；每次发布绑定新的最终候选。

1. 冻结完整源码 SHA、目标版本、Flutter/Dart、依赖和构建来源；统一组件 pubspec、示例版本、展示元数据及构建号。构建日期在实际打包时写入。
2. 根据 [迁移指南](./tdesign-site/site/docs/migration-0.2.7-to-1.0.md) 验证适用的外部消费场景。用户指南的可运行示例和包内副本通过 `node scripts/sync-readme.mjs` 生成，再用 `--check` 核对；不直接修改生成副本。
3. 在 Flutter 3.32.0 和当前 stable 的隔离环境解析依赖，执行严格分析、功能与独立消费检查；记录真实 SDK、插件版本和宿主平台最低要求。
4. 使用仓库回归入口执行已登记场景；Linux Flutter 3.32.0 的 Golden 先无更新比对，按 [Golden 规范](./specs/engineering/044-Testing-golden-regression/spec.md) 逐项确认。未登记状态单独验证，不以批量更新基线或更改容差消除未知差异。
5. 验证 Android/iOS/Web 构建，并在最终候选填写 [人工验收表](./specs/engineering/057-Release-readiness/manual-acceptance.md)。构建、安装、前台运行、设备与设计验收分别留证。
6. 核对 [Token 运行证据](./specs/engineering/048-Theme-configuration-contracts/acceptance.md) 的候选范围与未决项；静态映射、历史报告或功能通过不能代替设计与最终像素结论。
7. 在 `tdesign-component` 执行 `flutter pub publish --dry-run`，核对版本、README、迁移说明、许可证和资源。独立宿主通过公开包入口验证，不依赖库内部 helper。
8. 最后一次自动修改后重新核对完整 head、实际 CI、适用扫描、Review 和人工门槛；旧 head 的绿灯不能作为当前候选放行依据。

## 当前仓库自动化边界

以下按本地工作流源码说明，不代表远端配置或实际发布已验证：

- [auto-changelog.yml](./.github/workflows/auto-changelog.yml)：针对 release PR 生成 CHANGELOG 评论，并处理确认评论的写回；当前写回路径是 `tdesign-component/CHANGELOG.md`。按现有工具流程确认发布说明，不手工维护自动生成的 CHANGELOG。
- [tag-push.yml](./.github/workflows/tag-push.yml)：tag 创建后检出 main，将执行时的 develop 合并到 main，并触发关闭对应发布 Issue。
- 本地已经没有旧 `auto-release.yml`，不能沿用“合并 release PR 会自动创建 tag”的旧描述。创建 tag、正式上传和站点/APK 交付须在实际发布时核对现有入口及权限。

`tag-push.yml` 读取移动的 develop，不能据此推定 main 与 tag 指向同一候选。正式发布人必须核对来源；不能证明一致时不放行。本轮不修改工作流或远端规则。

## 正式交付与发布后验证

- 包、tag、站点和 Demo 安装产物核对同一候选，记录 SHA、版本与哈希。确认发布说明覆盖用户可见变更、breaking 和迁移方法。
- 按团队的实际权限与入口执行正式上传和上线；不复用已有版本号，不将 tag 创建或任务关闭当成正式交付成功。
- 发布后使用只依赖正式包的新业务宿主验证关键场景，不能用 path 依赖代替正式包消费。
- 实际访问站点、迁移页、API 和示例；从二维码或正式下载链接取得安装包，核对版本、安装及主要页面。链接可访问不代表文件就是目标版本。
- 交付失败时停止传播有问题的产物，保留来源和影响范围；不移动已对外发布的 tag 或悄悄替换同版本内容。

## 维护边界

通用发布流程维护在本文件，候选尚未关闭的验收事项维护在 Release Spec。该轮门槛关闭后，通用规则归入本文件，再移除临时 Spec；不长期保留旧版号升级、PR 拆分和阶段性准备方案。

## Demo APK 构建

PR 的 Flutter 3.32.0 APK 由 PREVIEW_BUILD 的共享 workflow 构建，同时提供验证与下载；latest APK 由 test-build 验证，develop push 保留两个版本。下载文件名沿用组件版本与工作流运行编号；Android 包内版本逻辑维持原方案，本轮不迁移版本号。

API、示例片段与构建日期集中准备后传给各平台，依赖与编译目录不跨 SDK 共享。APK 构建保留默认依赖解析与原生插件准备，不添加 --no-pub。本轮不提交 Example 锁文件；可复现依赖与同日重复 versionCode 问题后续独立处理。
