# destroyOnClose 独立候选验收

当前结论以末节“Drawer 历史生命周期保持后的当前验收”为准；此前候选的 Drawer 关闭后保留方案已撤回，历史统计不作为当前验证。

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`；分支 `rss1102/fix/popup-destroy-on-close`。最终组件源码/测试/生成 API 二进制 diff 的 SHA-256：`2488ca62bad4cc0b2736dfdbb45d82e9dcbbc79f4477757790bcdce9f45ed7ad`；高低版本 12 个相关文件逐字节一致。独立 PR 交付；#1196 另行撤出状态参数及 copyWith 迁移（实现提交 `12e18203`）。本表绑定本地已验证源码，远端 CI 以各 PR 最终 head 为准，暂不合并。

## 最终实现与复审

保留公开签名、destroyOnClose 默认 false 及 Controller 绑定规则；不新增公开宿主、dispose、maintainState 或复制入口。true 关闭后销毁，false 同一句柄/同 Navigator 重开复用真实 State；独立 show 互不复用，切换 Navigator 释放旧内容后重建。

可见路由仍正常 push/pop/remove；隐藏时使用内部持有的原生 ModalRoute 提供上下文，不进入返回栈、不新增嵌套 Navigator。可见内容的 Navigator 祖先不变。保留边界只覆盖内容面板，动画、布局、重新捕获的主题位于边界外；隐藏时保持面板已布局尺寸，避免视口变化截断末端滚动位置；内容面板有独立语义边界，脱离渲染父节点后清理自身缓存，不操作 Flutter 私有实现或全局语义状态。隐藏时不命中、不参与焦点/语义、停用 ticker；私有路由的返回通知内部消化。Navigator 卸载（含未绘制即卸载）幂等释放；内部路由结果和资源随释放完成。

本次修复范围复审无阻塞项：原有两项非栈顶关闭测试已覆盖并通过；ModalRoute 隐藏/重开、语义树预先启用及运行中启用、重复关闭重开、PopScope 可见时 veto/隐藏时不外泄通知、底层可点击、NavigatorObserver 无额外路由、局部主题切换、底部面板隐藏视口与末端滚动位置、内容自有嵌套 Navigator 均有正式回归。输入、滚动、零动画、回调重入、跨 Navigator、普通/遮挡/未绘制卸载、Drawer/Picker 透传和原回调回归一并通过。没有把 null 防护或额外宿主变成调用方要求。

## LocalHistoryEntry 复审闭环

此前 3ee11d3d 中，LocalHistoryEntry 消费返回后 _popping 未恢复，直接移除跳过停放，两个 SDK 复审均发现 State 丢失。本轮在 super.didPop 返回 false 时恢复先前标记；成功 pop 仍在 super.didPop 前设置标记，关闭动画结束后停放。fireCloseStart 的原位置保持，包括局部历史消费时既有的 close-start 通知行为；公开 API、默认 false、Controller 绑定以及 result/onOpened/onClosed 时机不变，不扩大已记录的生命周期变化。

新增四项正式回归：前三项各连续消费两条局部历史，再分别直接 removeRoute、遮挡后非栈顶 handle.close、正常 pop；第四项消费局部历史后替换 Navigator.pages 的关联页面。直接/非栈顶移除验证关闭后不 dispose、同句柄复用同一 State 和输入、Navigator 卸载只释放一次；正常 pop 在 30/120ms 时验证内容仍在原可见路由、result 已完成且 onClosed 尚未触发，动画结束后才停放。正式文件已登记，无需新增 manifest 项。修复前高版本这三项为 2 失败、1 通过，修复后完整受影响测试两版各 418 项通过。

复审另发现 Navigator.pages 构建阶段完成路由移除时，原生 ModalRoute.changedInternalState 跳过 setState，内容可能未同帧停放。私有路由改用自有 ValueNotifier 驱动内部内容 builder，保证同帧转移且在路由释放时销毁信号；不新增公开 API、NavigatorObserver 或宿主。第四项正式回归验证同 Navigator 的 State/输入复用、result 与 onClosed 时机及卸载只释放一次。之前的修复检查点 3968 组件通过不覆盖这一边界，已保留为历史证据。

零动画 onClosed 同步重开导致 Navigator !_debugLocked 的问题，已在此前精确 develop 基线双版本确认，明确排除本轮修复；本轮未调整该回调的同步调用时机，也不把它写成已解决。旧 review-3ee11d3d 报告和失败日志保留，LocalHistoryEntry P2 由本轮最终源码与正式回归闭环。

## 同步前历史双版本门禁

| 项目 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.7 / Dart 3.13.5 |
| --- | --- | --- |
| 全部登记组件功能回归 | 3969 通过 | 3969 通过 |
| Popup/Drawer/Picker 示例、API 和代码面板 | 98 通过 | 98 通过 |
| 工具测试（含字体覆盖） | 171 通过 | 171 通过 |
| 严格 analyze | 无诊断 | 无诊断 |
| API --check / 示例片段 --check | 57 份 / 通过 | 57 份 / 通过 |
| Popup 生产覆盖率 | 670/686 = 97.67% | 668/686 = 97.38% |
| Drawer 生产覆盖率 | 283/289 = 97.92% | 283/289 = 97.92% |
| Picker 生产覆盖率 | 406/412 = 98.54% | 406/412 = 98.54% |

27 项新增正式用例位于已登记的 t_popup_options_test.dart，连同既有组件用例执行；单独运行全部受影响 Popup/Drawer/Picker 测试，两版各 418 项通过。完整入口使用 componentTestManifests 登记文件，排除 demo 标签；覆盖率遵循仓库生产源码目标和 95% 门槛。

实际命令：flutter pub get --offline；flutter analyze --fatal-infos；全部登记组件 flutter test --exclude-tags demo --coverage --concurrency=4；flutter test test/tool；node tool/generate_api.mjs --check；dart run tool/generate_example_code.dart --check；受影响示例与 API/codeviewer flutter test --exclude-tags golden --dart-define=TDESIGN_DEMO_TEST_MODULES=false。依赖锁、组件清单入口、LCOV 与完整输出保存于工作区 artifacts/popup-destroy-close/fix-local-history-pages-high、fix-local-history-pages-low；源码补丁及文件清单为 fix-final-source.*。

## 已闭环诊断与历史证据

此前普通 Overlay 停放丢失 ModalRoute，已注册的正式回归两版失败；旧原型 `4abff2e8` 不可交付。内部嵌套 Navigator 尝试触发语义断言，已撤回。后续诊断又发现局部主题切换会重建 State，以及高版本非栈顶关闭的语义几何断言，已分别由面板保留边界和独立语义边界修复；底部面板隐藏时约束变化截断滚动位置的复审遗漏，已通过在同一语义根内保存面板尺寸约束修复。上述测试均未删除或跳过。

旧 fix-high/fix-low、fix-route-*、fix-panel-*、fix-final-*、fix-verified-*、fix-local-history-high/low、debug 和 pre-scroll-review 目录仅保存历史通过检查点、失败或中止诊断，不替代本表最终证据。旧候选指纹和输出可从 Git 历史及对应补丁追溯；最终使用 fix-local-history-pages-*，不混用较早结果。

## 兼容与验证范围

默认 false 从关闭释放变为保留，旧 true 的遮挡释放映射也改为仅控制关闭销毁，属于有意的生命周期行为变化；不能声称所有旧行为兼容。丢弃句柄可能保留到 Navigator 卸载，根 Navigator 可长期存在；业务定时器/订阅不保证暂停。本候选按用户确定的 1.0.1 修复范围单独处理，不与命名迁移混合。公开 API、参数默认值及 Controller 绑定规则未改变。

本地 macOS Widget、工具及示例验证，不外推 Android/iOS 真机或 Web release。可见绘制和布局无意改变；按仓库平台规则未执行或修改 Linux Golden 基线。远端 CI 与 Review 以独立 PR 最终 head 的实际结果为准，不沿用其他提交的通过状态，暂不合并。


## Spec 风险链接修正复核

本轮仅将 Picker 与 Drawer 的 Popup 风险链接更新到“destroyOnClose 关闭销毁修复（独立交付）”的现有锚点，两个链接均与目标标题匹配。生产实现、公开注释、生成 API、回归测试未变，源码指纹仍2488ca62bad4cc0b2736dfdbb45d82e9dcbbc79f4477757790bcdce9f45ed7ad；复用上表同指纹双 SDK 功能验收。本轮两 SDK 另运行57份API --check、工具清单/字体覆盖14项均通过，日志见 artifacts/popup-destroy-close/implements-fix-docs。新head远端CI另行核对，不把旧CI状态当作当前通过，不合并。


## 同步 develop fabe5f6b 后的当前验收

基线更新至 `fabe5f6bbd68d35ce304deee1b840c77df46465e`（已合入 #1199），本次合并父提交为 `1ed6de286feca64e54bc8ebcebe0128b9288ba8d`。解决 Popup 的 spec/plan/tasks/acceptance 及 t_popup_options_test.dart 共五处文本冲突，保留生命周期和配置回调两边的全部章节与正式回归。两边新增测试块逐字核对保留；私有保留承载及 LocalHistoryEntry、声明式页面替换修复未回退。配置类型、onTap/onClick 解析直接沿用 develop，不在本 PR 重新实现。

| 当前检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 全部登记组件回归 | 4026 通过 | 4026 通过 |
| 受影响示例、API 与代码面板 | 98 通过 | 98 通过 |
| 工具与字体检查 | 176 通过 | 176 通过 |
| 完整严格 analyze | 零诊断 | 零诊断 |
| API --check / 示例片段 --check | 57 份 / 通过 | 57 份 / 通过 |
| Popup 覆盖率 | 672/688 = 97.67% | 670/688 = 97.38% |
| Drawer 覆盖率 | 283/289 = 97.92% | 283/289 = 97.92% |
| Picker 覆盖率 | 406/412 = 98.54% | 406/412 = 98.54% |

站点主题/文档 35 项通过，57 份组件文档与 360 份示例映射检查通过。两 SDK 使用独立目录，生产源码、测试、工具及生成 API 已核对一致；源码输入指纹 `f13a0bb104b2035bd32070f4c45f1e60d156f6ce7ced36ce98b181e22e917530`。日志、输入哈希、清单驱动的执行脚本和 LCOV 位于本地 artifacts/popup-destroy-close/sync-develop-fabe5f6b，补丁为同目录 candidate.patch。

复审确认本 PR 相对最新 develop 仍仅叠加 destroyOnClose 生命周期修复及文档，不撤销 #1199 的 final/回调兼容契约，不改变 Controller 绑定规则，不混入零动画 onClosed 历史问题。默认 false 的关闭状态保留、旧 true 的遮挡行为及资源释放成本仍按前述风险说明，不能宣称生命周期透明兼容。本地 macOS 检查不外推真机/Web release；未在本地运行或修改 Linux Golden，远端检查以合并提交 head 为准。暂不合并 PR。

## Drawer 历史生命周期保持后的当前验收

2026-10-26，基线 develop `fabe5f6bbd68d35ce304deee1b840c77df46465e`，上一 PR head `8b971830`。验证输入为基线到当前候选的 `tdesign-component .github .cnb scripts packages` 二进制 diff，SHA-256：`6d7e25cfc9e99ffcab5004552615533e7c47f6c843d4581a86f499edee6c1f2a`。本节替代此前候选的 Drawer 保留策略及相关风险结论。

### 当前契约与兼容边界

- Drawer 保持 v1.0.0：默认/显式 false 被不透明路由遮挡时保留 State，true 时允许释放；两种取值都在关闭完成后释放。无重开能力，不创建隐藏保留会话。
- Popup/Picker 保持本 PR 现有保留规则：false 同句柄/同 Navigator 重开复用，true 关闭释放，Navigator 卸载自动清理。其关闭释放时机与旧 true 的遮挡规则仍是有意的生命周期 breaking，不能声称完全兼容旧资源行为；丢弃句柄、业务订阅与长期存活 Navigator 的成本仍存在。
- 不新增公开 API，不改变参数默认值、回调时机、Controller 绑定或 #1199 的 onTap/onClick/final 契约。私有一次性策略只在 Drawer 内部桥接接入；桥接不从主库导出，消费者诊断回归验证无法调用。

### 正式回归与历史对照

已登记的 `t_popup_options_test.dart` 新增 24 项 Widget 回归：21 项 Drawer 覆盖省略参数/false/true 下的句柄关闭、系统返回、蒙层点击、遮挡后非栈顶关闭、直接移除、遮挡返回及关闭动画释放、五次连续丢弃句柄；另 1 项验证 Popup true 遮挡保留，2 项经真实 Picker 入口验证同句柄重开输入复用/重建及 Navigator 清理。同步恢复 Drawer 原 maintainState 断言，调整共享入口释放断言。既有 LocalHistoryEntry、声明式页面替换、语义、主题、滚动与正常 pop 回归全部保留。

同样的 21 项 Drawer 测试在 v1.0.0 标签原始源码上以 Flutter 3.32.0 / 3.47.7 均全部通过；该对照沿用当前 SDK 的依赖解析，用于确认历史组件行为，不代表复现旧发布环境或真机结果。

### 双版本当前结果（macOS）

| 检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 全部登记组件（排除 demo 标签） | 4050 通过 | 4050 通过 |
| 受影响示例、API、代码面板 | 98 通过 | 98 通过 |
| 工具/字体/消费者 | 177 通过 | 177 通过 |
| 严格完整 analyze | 零诊断 | 零诊断 |
| API 生成同步 | 57 份通过 | 57 份通过 |
| 示例片段同步 | 通过 | 通过 |
| Popup 生产覆盖率 | 678/694 = 97.69% | 676/694 = 97.41% |
| Drawer 生产覆盖率 | 283/289 = 97.92% | 283/289 = 97.92% |
| Picker 生产覆盖率 | 406/412 = 98.54% | 406/412 = 98.54% |

站点 Node 35 项及文档入口检查通过。双 SDK 从 componentTestManifests 选择全部登记组件（`--coverage --exclude-tags demo`）及 Popup/Drawer/Picker 示例，工具执行 `flutter test test/tool`，严格分析使用 `--fatal-infos`；生成器执行 API 与示例片段 `--check`。正式文件已由现有 CI 入口调度，无需新增清单项。原字体、字形清单与 Golden 基线均未改变。

日志、验证脚本、LCOV、源码指纹补丁及历史对照保存在仓库外 `artifacts/popup-destroy-close/drawer-legacy-lifecycle/`，不提交录制素材或运行日志。当前范围无绘制修改，本地未执行 Linux Golden，不外推 Android/iOS 真机及 Web release；远端 CI 按推送后的最终 head 独立核对。零动画 onClosed 中同步重开的历史问题仍不混入，不合并 PR。
