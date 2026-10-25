# 六组件命名迁移独立验收

当前结论以末节“同步 develop 9203d362 后的验收”为准；先前阶段只对应其原候选与范围。

## 初始拆分边界（历史）

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`；本轮从 #1196 撤出全部 Popup onTap 兼容迁移，保留六组件七组 API：NoticeBar、CheckboxGroup、Drawer、Popover、Steps，以及 TabBar 菜单与重复点击配置。

## 范围与兼容风险

新旧参数同时提供时非空新参数优先；未提供新参数时通过旧 getter 分派，保留已覆盖的继承用法、const 和旧构造函数类型。旧入口废弃，计划 2.0.0 删除。默认值、触发逻辑、受控值、手势过滤及 Controller 绑定规则不变。

这不是零 breaking：业务旧 implements 若实现新增 getter 的类，仍需补齐成员。FAQ 以 TTabBarItemConfig 的 notifyOnReselect 转发到 allowMultipleTaps 举例；包外消费者测试验证缺失诊断和补齐后零诊断，不使用 noSuchMethod。普通构造调用和继承默认实现不受该缺失成员问题影响，旧调用可能产生弃用诊断。

不改变 Popup 的 onClick、继承规则、copyWith 或 destroyOnClose；showTDrawer 内部继续使用旧 Popup onClick，因此独立于 Popup 2.0 草稿。菜单路由修复由 #1198 交付，本 PR 不含该实现或矩阵。

## 双版本验收

Flutter 3.32.0 / 3.47.7 各 749 项通过，覆盖六组件、27 项 API 兼容用例及完整工具套件（含外部消费者、API 文档及字体/清单检查）。严格 analyze 零诊断；两版 57 份 API --check 通过。FAQ 的站点主题/文档测试 16 项通过。

六组件生产覆盖率均超过 95%：NoticeBar 96.88%、Checkbox 高版 97.06%/低版 97.33%、Drawer 97.95%、Popover 98.03%、Steps 99.28%、TabBar 97.05%。原始日志及 LCOV 在工作区 artifacts/api-split-delivery/02-api-naming。

原 #1196 的八组件 882、兼容 33、其他旧范围结果不外推当前候选。未执行全包、真机或 Web release，未更新 Golden。远端检查以新 head 为准，不使用 0bf83e96 的旧 CI 结论。

## 本地 Review

Popup 生产源码、生成 API 和原测试恢复 develop；原 Popup 消费者样例已撤出。兼容测试迁入 TabBar 文件并登记 CI，新增消费者只针对本 PR 保留的类。示例、文档及各组件 Spec 同步；现存 implements 和弃用风险明确披露，不与行为修复或 Popup final 混为无风险重命名。


## 同步 develop 058ac453 后的验收

2026-10-26，将 develop `058ac453bc4bf5974ee9e69fef1150de8e156c0b` 合入 #1196 的 `c0bb1cd4022ecd6b11f26858c9b17935f88b0b4a`。基线已包含 #1198 菜单回调修复、#1199 蒙层配置及 #1197 生命周期修复；本 PR 相对该基线仍仅保留六组件七组命名兼容迁移。

冲突按职责合并：TabBar 保留 _selectItem 的原路由定向清理和回调前通知，调用端使用兼容 onSelected 分派；旧 onChanged 仍按原时机执行。测试清单同时保留命名兼容用例与 48 项菜单矩阵，Spec 两部分完整保留。Drawer 使用已合入的内部一次性展示入口，默认 false、关闭释放/遮挡和 Controller 规则不变。Popup/Picker 源码、测试及生成 API 与本次 develop 逐字节一致，不撤销已合入修复，也不再声称使用旧 Popup 参数而独立于配置修复。

API 由源码重新生成；共享测试字体与字形清单直接沿用 develop，真实 cmap 已覆盖所需字符，不再次扩充字体或更新 Golden。验证输入为该基线到 tdesign-component 及命名 FAQ 的二进制 diff，SHA-256：`85c071d385699d83e3a334c131955b28f966367f93edd09da8b89bf6ac8529fb`；双 SDK 快照这些输入逐字节一致，验收记录不纳入指纹。

| 当前检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 六组件 + Popup/Picker 登记回归、完整工具测试 | 1175 通过 | 1175 通过 |
| 相关示例、API 与代码查看测试 | 129 通过 | 129 通过 |
| 严格完整 analyze | 零诊断 | 零诊断 |
| API / 示例片段 --check | 57 份 / 通过 | 57 份 / 通过 |

八组件生产覆盖率均通过 95% 门禁：NoticeBar 341/352（96.88%），Checkbox 低版 364/374（97.33%）/高版 363/374（97.06%），Drawer 286/292（97.95%），Popover 649/660（98.33%），Steps 277/279（99.28%），TabBar 678/686（98.83%），Picker 402/412（97.57%），Popup 低版 678/694（97.69%）/高版 676/694（97.41%）。站点 Node 35 项及 57 份文档/360 份示例映射检查通过。

初次联网依赖解析等待后，改用已有缓存离线解析完成验证；未修改依赖约束。脚本、日志、低版本快照、LCOV 和补丁保存在仓库外 artifacts/pr1196-sync-develop-058ac453/。未改绘制或字体，不在 macOS 更新或运行 Linux Golden；未验证真机或 Web release 交互，不把本轮 1175/129 视为全包回归。

本地 Review 无阻塞项：旧 getter 继承分派、新参数非空优先和默认回调行为保留；已有 implements 需补齐 getter、弃用诊断及 2.0.0 旧入口删除风险不变。相对当前 develop 不新增 Popup/Picker/Drawer 生命周期变更；已合入的生命周期风险不因此消失。历史 749 项等结果不代替本节，新 head CI/Review 推送后单独核对，不合并 PR。


## 分组件升级 FAQ 收口验收

基于 ffc98c11，仅整理站点文档与 Spec。NoticeBar、Checkbox、Drawer、Popover、Steps、TabBar 的 1.0.0 → 1.0.1 提醒移入各自组件；全局 FAQ 删除原重复汇总。升级 FAQ 只保留新增公开 getter 的 implements 适配、同名成员冲突及实际的手势/视觉/生命周期风险。普通改名、废弃与删除计划、参数优先级和未改变的既有行为由 API 文档说明，不再混入升级 FAQ。Popup 保留 final 和会话保留/资源冲突两问，稳定锚点 popup-session-reuse 不变，相关组件链接仍有效。

Drawer 的 TDrawer.onItemTap，以及 TabBar 的 TTabBarItemConfig.notifyOnReselect / TTabBarPopUpBtnConfig.onSelected 适配仍须保留；两页不要求旧 ThemeData implements 补内部解析方法。#1200 独立交付内部解析兼容补修，发布前须确认已合入，不将其结果外推当前命名分支。

复查全部 getter 的公开签名和回退分派，FAQ 给出的转发关系与实现一致；业务同名成员冲突明确采用重命名或按新契约适配。原参数优先级、继承覆盖、默认行为和 Controller 规则保留；普通旧调用的废弃提示仍由 API/PR 说明披露。更新日志段落不变，不重复交付 #1197/#1198/#1199/#1200，也不增加 FAQ 整理条目。

本轮站点 Node 35 项通过，57 份组件文档 / 360 份示例映射、README 同步检查通过，七个组件 FAQ 均经浏览器逐页实看并保存截图。原始日志、文档审查和截图在工作区 artifacts/pr1196-faq-breaking-only，不入库。生产源码、测试、工具、生成 API 和 CHANGELOG 哈希不变；双 SDK 1175/129 等结果仍绑定上节实现输入，未声称本轮重跑组件、真机、Web release 或 Golden。推送后远端 CI 只认最新 head，不合并。

## 同步 develop 9203d362 后的验收

基于 #1196 的 2d6a78a7，合入最新 develop `9203d362e86778a18faf194bc13c6f57500fce01`（#1200），无冲突。保留六组件七组公开命名迁移与 FAQ；自动合并的组件清单同时保留命名兼容、48 项菜单矩阵和 ThemeData implements 回归。Popup/Picker 及两个 ThemeData 实现与最新 develop 一致。

#1200 修复内部解析成员，不移除本 PR 的公开 getter，因此两类消费者结果不同且均为正确预期：旧 ThemeData implements 无需补内部成员，旧 TTabBarItemConfig implements 缺 notifyOnReselect 仍报缺失成员，补充转发后通过。breaking 日志保留，限定“本次命名迁移涉及的类”，不重复记录 #1200 的修复，也不重新加入 FAQ 的废弃迁移说明。

| 合并后验证 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 八组件、完整工具与共享 Token 回归 | 1206 通过 | 1206 通过 |
| 相关示例/API/代码查看 | 129 通过 | 129 通过 |
| 严格 analyze | 零诊断 | 零诊断 |
| API / 示例片段 --check | 57 份 / 通过 | 57 份 / 通过 |

八组件生产覆盖率均超过95%：Drawer 296/302（98.01%）、TabBar 682/690（98.84%）；其余范围见本地 coverage 日志。站点 Node 35 项与57份文档/360份示例映射通过。两 SDK 的2330份源码、测试与生成资源逐字节一致，输入清单SHA-256 `9b3e4643011b6e31584ecbdacdac81715ecd798f8c9e4cd837c0098805a4474e`；相对新develop的组件输入补丁SHA-256 `4f803b14b56d55811ea5df605c1b916c09d8fc969c761e520064478f46b598aa`。记录之后只调整Spec和PR说明，不改变已验证源码。

原始日志、SDK隔离快照、输入清单及补丁在工作区 artifacts/pr1196-sync-develop-9203d362，不入库。未测试真机/Web release交互，不在macOS运行或更新Linux Golden。旧1175/129或其他head的CI不代替本节；推送后核对最新head，暂不合并。
