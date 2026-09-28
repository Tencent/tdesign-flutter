# 实施任务

- [ ] DOING 盘点组件 Theme、公开 API 和小程序组件变量的真实消费链；已初筛 116 个同名候选，包导出过滤后的 64 项已降至 0；异名同义及 804 个组件变量最终消费仍未完成。
- [ ] DOING 逐项确定唯一所有者、迁移路径和 breaking 风险；已确认项见 `ownership-table.md`，P0 未裁定项见 `report.md`。
- [ ] DOING 收敛确认重复的公开控制入口与 Token 回退；已迁移同名选择器，实例完整 `style` 与子树 Theme 默认值不机械视为重复；便利标量及异名同义字段仍须逐项审查。
- [x] DONE Avatar/Popover 异名同义入口：移除 Avatar Theme `textStyle` 和 Popover 实例 `overlayColor/radius`，将 Popover 圆角收敛到可逐角配置的 Theme `borderRadius`；双版本组件/Demo 功能测试、生成 API 文档与 3.32.0 Linux 无更新 Golden 已执行。Golden 仍有旧基线差异，列在视觉归因任务中，不视为通过。
- [x] Text 逐字段恢复 `TTextThemeData` 已发布子树默认能力，保留实例 `style` / 段落覆盖及 Flutter 文字继承；恢复 Cascader/Picker 消费。默认回退修正为小程序 14dp/22dp，Text Demo 两张 Linux Golden 在固定环境更新后无更新复跑通过；这不代表 Figma 像素验收。
- [x] Button/Input 按同一层级规则核对：保留组件 Theme 默认值与实例完整 `style`；Button 显式 `colorScheme` 的内置预设不再反向覆盖 Theme 具体样式，并补齐 outline 状态回退与测试。
- [ ] DOING 更新源码 dartdoc、Demo 用法与组件测试；已迁移范围完成，待全量回归和 breaking 迁移说明。
- [ ] DOING 双版本分析、聚焦功能和固定 Linux 3.32.0 无更新 Golden 比对；原 47 张仍记录 12/35，Text 两张已单独裁定并更新，Button 四张旧基线仍差异且本次修复前后实际输出一致。
- [ ] DOING 804 项组件变量已按冻结源码逐项建静态证据；纠正 Less 动态消费误判后，10 项未见静态消费者、81 项属于尚无 Flutter 对应组件的已消费变量；Button 12 项、Tag 12 项默认 Widget 值、Tag 5 项回退路径及 4 项组件 Theme 覆盖已裁定，仍有 680 项待逐项审查及最终视觉验证。
- [x] 已记录公开 API 删除及默认行为变化的 breaking 迁移草案，见 `migration.md`；发布前外部调用点编译回归仍待完成。
- [x] 已输出阶段性的修改、风险、Golden 问题与修复顺序报告：`report.md`；最终发布验收仍未完成。
