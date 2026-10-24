# 六组件命名迁移独立验收

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
