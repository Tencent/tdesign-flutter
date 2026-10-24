# destroyOnClose 独立候选验收

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`；分支 `rss1102/fix/popup-destroy-on-close`。最终组件源码/测试/生成 API 二进制 diff 的 SHA-256：`71b577d44c0840b69a31d33432b4759dde88fec0e5a30b1985fc077e40d9b43f`；高低版本 12 个相关文件逐字节一致。仅本地实现与验证，不推送、不创建 PR、不合并。#1196 的迁移撤出仍为独立本地提交 `12e18203`。

## 最终实现与复审

保留公开签名、destroyOnClose 默认 false 及 Controller 绑定规则；不新增公开宿主、dispose、maintainState 或复制入口。true 关闭后销毁，false 同一句柄/同 Navigator 重开复用真实 State；独立 show 互不复用，切换 Navigator 释放旧内容后重建。

可见路由仍正常 push/pop/remove；隐藏时使用内部持有的原生 ModalRoute 提供上下文，不进入返回栈、不新增嵌套 Navigator。可见内容的 Navigator 祖先不变。保留边界只覆盖内容面板，动画、布局、重新捕获的主题位于边界外；隐藏时保持面板已布局尺寸，避免视口变化截断末端滚动位置；内容面板有独立语义边界，脱离渲染父节点后清理自身缓存，不操作 Flutter 私有实现或全局语义状态。隐藏时不命中、不参与焦点/语义、停用 ticker；私有路由的返回通知内部消化。Navigator 卸载（含未绘制即卸载）幂等释放；内部路由结果和资源随释放完成。

复审无阻塞项：原有两项非栈顶关闭测试已覆盖并通过；ModalRoute 隐藏/重开、语义树预先启用及运行中启用、重复关闭重开、PopScope 可见时 veto/隐藏时不外泄通知、底层可点击、NavigatorObserver 无额外路由、局部主题切换、底部面板隐藏视口与末端滚动位置、内容自有嵌套 Navigator 均有正式回归。输入、滚动、零动画、回调重入、跨 Navigator、普通/遮挡/未绘制卸载、Drawer/Picker 透传和原回调回归一并通过。没有把 null 防护或额外宿主变成调用方要求。

## 最终双版本门禁

| 项目 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.7 / Dart 3.13.5 |
| --- | --- | --- |
| 全部登记组件功能回归 | 3965 通过 | 3965 通过 |
| Popup/Drawer/Picker 示例、API 和代码面板 | 98 通过 | 98 通过 |
| 工具测试（含字体覆盖） | 171 通过 | 171 通过 |
| 严格 analyze | 无诊断 | 无诊断 |
| API --check / 示例片段 --check | 57 份 / 通过 | 57 份 / 通过 |
| Popup 生产覆盖率 | 663/679 = 97.64% | 661/679 = 97.35% |
| Drawer 生产覆盖率 | 283/289 = 97.92% | 283/289 = 97.92% |
| Picker 生产覆盖率 | 406/412 = 98.54% | 406/412 = 98.54% |

23 项新增正式用例位于已登记的 t_popup_options_test.dart，连同既有组件用例执行；单独运行全部受影响 Popup/Drawer/Picker 测试，两版各 414 项通过。完整入口使用 componentTestManifests 登记文件，排除 demo 标签；覆盖率遵循仓库生产源码目标和 95% 门槛。

实际命令：flutter pub get --offline；flutter analyze --fatal-infos；全部登记组件 flutter test --exclude-tags demo --coverage --concurrency=4；flutter test test/tool；node tool/generate_api.mjs --check；dart run tool/generate_example_code.dart --check；受影响示例与 API/codeviewer flutter test --exclude-tags golden --dart-define=TDESIGN_DEMO_TEST_MODULES=false。依赖锁、组件清单入口、LCOV 与完整输出保存于工作区 artifacts/popup-destroy-close/fix-verified-high、fix-verified-low；源码补丁及文件清单为 fix-final-source.*。

## 已闭环诊断与历史证据

此前普通 Overlay 停放丢失 ModalRoute，已注册的正式回归两版失败；旧原型 `4abff2e8` 不可交付。内部嵌套 Navigator 尝试触发语义断言，已撤回。后续诊断又发现局部主题切换会重建 State，以及高版本非栈顶关闭的语义几何断言，已分别由面板保留边界和独立语义边界修复；底部面板隐藏时约束变化截断滚动位置的复审遗漏，已通过在同一语义根内保存面板尺寸约束修复。上述测试均未删除或跳过。

旧 fix-high/fix-low、fix-route-*、fix-panel-*、fix-final-*、debug 和 pre-scroll-review 目录仅保存历史通过检查点、失败或中止诊断，不替代本表最终证据。旧候选指纹和输出可从 Git 历史及对应补丁追溯；最终使用 fix-verified-*，不混用较早结果。

## 兼容与验证范围

默认 false 从关闭释放变为保留，旧 true 的遮挡释放映射也改为仅控制关闭销毁，属于有意的生命周期行为变化；不能声称所有旧行为兼容。丢弃句柄可能保留到 Navigator 卸载，根 Navigator 可长期存在；业务定时器/订阅不保证暂停。本候选按用户确定的 1.0.1 修复范围单独处理，不与命名迁移混合。公开 API、参数默认值及 Controller 绑定规则未改变。

本地 macOS Widget、工具及示例验证，不外推 Android/iOS 真机或 Web release。可见绘制和布局无意改变；按仓库平台规则未执行或修改 Linux Golden 基线。无远端新候选 CI，没有推送、创建 PR 或合并。
