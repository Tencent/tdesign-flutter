> 最新处置（2026-10-15，Spec060）：已实修Ghost语义回退的2个观察项，8项由既有Flutter契约及运行断言支持；21项差异与1项平台几何已有具体方案，524项仍待补运行。当前代码为30767a55上的未提交工作区，本地新指纹验证见 [Spec060](../060-token-difference-resolution/acceptance.md)，不沿用旧远端CI作为本次修复通过证据。

> 2026-10-15 发布前核销：当前自动检查与历史阶段记录分开；证据和保留待办见 [Spec 057](../057-release-readiness-audit/acceptance.md)。

# 实施任务

- [x] 合并前审查实测修复 Tag 描边总高少算 2dp、图标占位/关闭图标固定 14dp、小号图文间距错误；统一按尺寸预设和边框盒计算。Cell/CellGroup 各文字槽位按字段合并组件 Theme 与 Token 默认样式，覆盖 TText 和原生 Text；清除 Tag Theme 的 Material 回退残留注释及 API 生成清单中已删除的 Style 类型。新增 19 项组件回归，视觉验证状态见 `acceptance.md`。

- [ ] DOING 盘点组件 Theme、公开 API 和小程序组件变量的真实消费链；已初筛 116 个同名候选，包导出过滤后的 64 项已降至 0；异名同义及 804 个组件变量最终消费仍未完成。
- [ ] DOING 逐项确定唯一所有者、迁移路径和 breaking 风险；已确认项见 `ownership-table.md`，历史风险见 `report.md`；其中已被后续证据覆盖的状态以 Spec 057 为准。
- [ ] DOING 收敛确认重复的公开控制入口与 Token 回退；已处理的 Button、Input、Dialog action、TabsBar、Tag、SideBar、Text、SwipeCellAction 和 Popup 字段见 `migration.md`。仍须逐组件审查尚未裁定的异名同义入口，不能把已处理组件外推为全仓完成。
- [x] DONE Avatar/Popover 异名同义入口：移除 Avatar Theme `textStyle` 和 Popover 实例 `overlayColor/radius`，将 Popover 圆角收敛到可逐角配置的 Theme `borderRadius`；双版本组件/Demo 功能测试、生成 API 文档与 3.32.0 Linux 无更新 Golden 已执行。Golden 仍有旧基线差异，列在视觉归因任务中，不视为通过。
- [x] DONE AvatarGroup 设计稿复核：按 Figma 三档尺寸对齐全部组成员 1/2/3dp 描边和阴影，修正公开 Demo 的顺序、折叠文案与层叠方向；Figma/develop/current 同尺寸像素比较、双版本聚焦测试及 Linux Golden 无更新复跑见 `acceptance.md`。
- [x] DONE Avatar Theme 插值回退按实际小/中/大尺寸和当前全局圆角 Token 延迟解析；头像组描边、阴影与内容裁剪在自定义圆角下保持同形。已删除的 TabBar `topBorder/showTopBorder/centerDistance` 不恢复，组件配色仍仅使用 `colorPreset`，无兼容别名；本轮聚焦验收见 `acceptance.md`。
- [x] Text 逐字段恢复 `TTextThemeData` 已发布子树默认能力；恢复 Cascader/Picker 消费。默认回退修正为小程序 14dp/22dp。随后按单一来源规则移除 Material `TextTheme` 与 `DefaultTextStyle` 自动文字继承；旧 Text Demo Golden 结论须以最终源码重新验证，不代表 Figma 像素验收。
- [x] 恢复公开 `TText.style` 作为单实例完整视觉入口，将组合组件状态样式留在仅库内使用的解析路径；子树默认仍由 `TTextThemeData.textStyle` 管理。旧检查点的测试与 Golden 结论需以本轮最终源码重新验证。
- [x] 移除 Material `TextTheme` / 外层 `DefaultTextStyle` 对 TDesign 文字的自动推断；显式链路为全局 Token/Theme → 组件 Theme → 已有实例样式。移除 `TStyleResolver` 的 Material 转发 getter；双版本功能与字体注入测试见 `acceptance.md`。
- [ ] TODO 完成尚未验收的跨端/Figma 像素对照及未登记场景审查。2026-10-03 的 552 张基线记录保留为历史证据；当前已登记 Linux Golden 全绿，不能替代逐状态设计验收，见 Spec 057。
- [x] 全组件改为单向主题链：移除 `tExplicit*` 及 Material 组件外观反向读取，保留 TDesign Theme 向原生 Material 控件投影；Tag 前置图标与正文共用有效前景色。组件的内部已解析样式传递与明暗模式选择不等于外部外观入口。非 Golden 组件回归 2676/2676 通过，八张已裁定的 Linux Demo Golden 已更新；最终完整 Linux 视觉矩阵严格无更新通过，3.32.0/3.47.0 组件包和 Example 分析零诊断。
- [x] 实例保留 `TText.font` 作为 TDesign 字体预设，移除 `fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor` 分散便利字段，迁移仓内调用与测试；独立消费包已验证实例 style、富文本与组件 Theme 的公开替代调用。
- [x] 既有 Button/Input 层级规则和 outline 状态回退完成测试；本轮进一步移除与完整实例 `style` 重复的组件 Theme 字段，测试需按新的单入口契约复核，旧规则不再作为验收标准。
- [x] DONE 当前基线 dartdoc 审计、Demo/组件自动回归已通过，见 Spec 057。
- [x] 仅面向 0.2.7 → 1.0 的迁移指南已落地，覆盖组件入口、行为和删除能力；独立消费用例双版本通过，见[迁移指南](../../tdesign-site/site/docs/migration-0.2.7-to-1.0.md)与 Spec 058。此项不代表677项消费审查或全部业务迁移完成。
- [x] DONE 当前基线双版本分析、组件和 Demo 功能、独立消费包迁移检查及 Linux 3.32.0 登记 Golden 全部通过；消费包 CI 步骤实际成功，不再等待推送。历史检查点保留于 `acceptance.md`，当前证据见 Spec 057。
- [ ] DOING 804 项组件变量已按冻结源码逐项建静态证据；纠正 Less 动态消费误判后，10 项未见静态消费者、81 项属于尚无 Flutter 对应组件的已消费变量；Button 12 项、Tag 12 项默认 Widget 值，Tag 7 项及 Switch/Fab/Form/PullDownRefresh/DropdownItem 各 1 项回退路径已裁定，Progress 9 项已另做默认 Widget/Painter 消费链复核（不等于跨端视觉完成），历史基线为677项待核；最新分层结果见Spec059，116项默认运行证据已补，不直接扣减最终视觉待审数。
- [x] 按 2026-10-03 用户裁定修正 Button 深色禁用字色、Switch 禁用/加载分层状态色与 Slider 浅色禁用滑块描边；Button/Switch 依冻结小程序，Slider 依直接选取的 Figma 图层。双版本聚焦测试与严格分析通过，生成 API 已更新；隔离 Linux 逐张检查、仅更新 10 张受影响 Golden 并无更新复跑通过。PR head CI 与整页 Figma 像素验收仍属总任务门禁，不以本项完成代替。
- [x] DONE breaking 迁移清单的公开替代入口已扩展为可重复执行的仓库外独立消费包；3.32/3.47 严格分析及各 10 项测试通过，登记 GitHub/CNB 双版本功能 CI。未知第三方业务仓库的升级进度不作为库验收门禁；能力删除和默认行为变化仍须以 breaking 版本发布。677 项组件 Token 最终消费审查不因本项通过而完成。
- [x] DONE 将组件内置配色选择器统一命名为 `colorPreset`：5 个已导出枚举及 Button、Tag、SelectTag、Link、BackTop、Popover、DialogAction 入口均移除旧 `colorScheme` 同义名；Material `ThemeData.colorScheme` 保留原义。Spec、dartdoc、公开 Demo、生成片段、API 文档和聚焦测试同步；两种 Popover 展示入口及其余配色入口已进入独立消费编译验证。
- [x] 已输出阶段性的修改、风险、Golden 问题与修复顺序报告：`report.md`；最终发布验收仍未完成。
