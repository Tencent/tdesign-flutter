# destroyOnClose 独立候选验收与阻塞 Review

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`；分支 `rss1102/fix/popup-destroy-on-close`。仅本地实现与验证，不推送、不创建 PR、不合并。#1196 对应分支的本地撤出为 `12e18203`，与本候选独立。

## 已实现与风险

保留所有公开签名、默认 destroyOnClose=false，不增加宿主、dispose 或状态保留参数。true 关闭后销毁，false 同一句柄/同 Navigator 重开复用 State；路由正常移除，Navigator 卸载清理保留槽，跨 Navigator 释放旧内容后重建。隐藏时不命中、不参与焦点或语义、停用 Flutter ticker；保留自有滚动控制器与 PageStorage，关闭重开维持输入及滚动位置。

默认 false 的资源释放时机改变；旧显式 true 的遮挡释放映射也不再保留。丢弃句柄可能占用至 Navigator 卸载，根 Navigator 可长期存活；业务定时器/订阅不保证暂停。这是按确定的目标版本实现的生命周期变化，不能宣称所有旧行为兼容。Controller 公开绑定规则和参数签名未改。

## 通过的检查点（不是最终全绿）

实现检查点源码 SHA-256 `8e7a38bcbdb110e7317915ffe3ffb488401d47c71ccbe04a0b39a37b36a1b34e`。两版使用独立目录、SDK 与缓存；组件相关文件逐字节一致。

| 项目 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.7 / Dart 3.13.5 |
| --- | --- | --- |
| 全部登记组件功能回归 | 3959 通过 | 3959 通过 |
| Popup/Drawer/Picker 示例、API 和代码面板 | 98 通过 | 98 通过 |
| 工具测试（含字体覆盖） | 171 通过 | 171 通过 |
| 严格 analyze | 无诊断 | 无诊断 |
| API --check / 示例片段 --check | 57 份 / 通过 | 57 份 / 通过 |
| Popup 生产覆盖率 | 623/635 (98.11%) | 621/635 (97.80%) |
| Drawer 生产覆盖率 | 283/289 (97.92%) | 283/289 (97.92%) |
| Picker 生产覆盖率 | 406/412 (98.54%) | 406/412 (98.54%) |

检查点新增 17 项正式用例：关闭销毁/输入复用、零动画、系统返回、遮挡后的非栈顶关闭、关闭动画中重开、重复关闭、隐藏焦点/ticker、普通及未绘制卸载、跨 Navigator、独立会话、回调重入、Picker/Drawer 透传和滚动位置。既有嵌套 Popup 与自定义关闭按钮回归也执行，修复语义缓存问题。

## 阻塞发现：关闭后路由上下文丢失

最终 Review 新增第 18 项正式回归 `retained content has a route context while hidden and after reopen`，位于已登记的 t_popup_options_test.dart。内容构建中使用合法的 `ModalRoute.of(context)!.isCurrent`；普通 Overlay 停放在关闭后丢失原路由上下文，子树重新构建出现空值异常。Flutter 3.32.0 和 3.47.7 均复现。最新候选严格分析仍无诊断，但该回归两版失败，因此最终 Review 不通过，不能把上表检查点通过外推为当前候选全绿。

已尝试内部隐藏 Navigator 提供有效路由上下文；但扩大运行既有关闭回归时触发语义树断言（不仅新测试），已撤回该实验，没有保留未验证的框架缓存 workaround 或收紧业务契约。不能要求现有内容增加空判断来掩盖问题。后续需要重新设计内部内容/路由承载方式，继续保持公开 API 不变；方案范围待确认。

当前包含阻塞回归的源码 SHA-256：`889657eab2bac7ce6d6c38e1fc1e4b4d6f7bd07f9bc3bbbbcc209a295629a998`。高低版本对应文件逐字节一致。诊断在 fix-high/review-route-regression.log、fix-low/review-route-regression.log；分析在 review-analyze.log。原型和路由上下文实验的失败输出保存在 artifacts/popup-destroy-close/debug/。未跳过正式阻塞回归。

## 证据范围

工作区 artifacts/popup-destroy-close/fix-high、fix-low 保存通过检查点的日志、LCOV 与依赖锁；pre-scroll-review 为较早检查点，不作为当前验收。fix-review-source.patch 是当前未通过候选，fix-source.patch 是上述通过检查点，二者不得混用。

本地 macOS Widget/工具及示例验证，不外推 Android/iOS 真机或 Web release。未执行或修改 Linux Golden 基线；没有远端新候选 CI。没有推送、创建 PR 或合并。
