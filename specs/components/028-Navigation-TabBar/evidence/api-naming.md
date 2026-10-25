# 六组件命名迁移独立验收

当前结论以末节“同步 develop 058ac453 后的验收”为准；初始拆分记录仅对应原候选。

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
