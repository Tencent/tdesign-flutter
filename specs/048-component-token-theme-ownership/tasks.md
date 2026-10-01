# 实施任务

- [ ] DOING 盘点组件 Theme、公开 API 和小程序组件变量的真实消费链；已初筛 116 个同名候选，包导出过滤后的 64 项已降至 0；异名同义及 804 个组件变量最终消费仍未完成。
- [ ] DOING 逐项确定唯一所有者、迁移路径和 breaking 风险；已确认项见 `ownership-table.md`，P0 未裁定项见 `report.md`。
- [ ] DOING 收敛确认重复的公开控制入口与 Token 回退；已处理的 Button、Input、Dialog action、TabsBar、Tag、SideBar、Text、SwipeCellAction 和 Popup 字段见 `migration.md`。仍须逐组件审查尚未裁定的异名同义入口，不能把已处理组件外推为全仓完成。
- [x] DONE Avatar/Popover 异名同义入口：移除 Avatar Theme `textStyle` 和 Popover 实例 `overlayColor/radius`，将 Popover 圆角收敛到可逐角配置的 Theme `borderRadius`；双版本组件/Demo 功能测试、生成 API 文档与 3.32.0 Linux 无更新 Golden 已执行。Golden 仍有旧基线差异，列在视觉归因任务中，不视为通过。
- [x] DONE AvatarGroup 设计稿复核：按 Figma 三档尺寸对齐全部组成员 1/2/3dp 描边和阴影，修正公开 Demo 的顺序、折叠文案与层叠方向；Figma/develop/current 同尺寸像素比较、双版本聚焦测试及 Linux Golden 无更新复跑见 `acceptance.md`。
- [x] Text 逐字段恢复 `TTextThemeData` 已发布子树默认能力与 Flutter 文字继承；恢复 Cascader/Picker 消费。默认回退修正为小程序 14dp/22dp，Text Demo 两张 Linux Golden 在固定环境更新后无更新复跑通过；这不代表 Figma 像素验收。
- [x] 恢复公开 `TText.style` 作为单实例完整视觉入口，将组合组件状态样式留在仅库内使用的解析路径；子树默认仍由 `TTextThemeData.textStyle` 管理。旧检查点的测试与 Golden 结论需以本轮最终源码重新验证。
- [x] 实例保留 `TText.font` 作为 TDesign 字体预设，移除 `fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor` 分散便利字段，迁移仓内调用与测试；外部第三方调用编译仍待验证。
- [x] 既有 Button/Input 层级规则和 outline 状态回退完成测试；本轮进一步移除与完整实例 `style` 重复的组件 Theme 字段，测试需按新的单入口契约复核，旧规则不再作为验收标准。
- [ ] DOING 更新源码 dartdoc、Demo 用法与组件测试；已迁移范围完成，待全量回归和 breaking 迁移说明。
- [ ] DOING 双版本分析、聚焦功能和固定 Linux 3.32.0 无更新 Golden 比对；原 47 张仍记录 12/35，Text 两张已单独裁定并更新，Button 四张旧基线仍差异且本次修复前后实际输出一致。
- [ ] DOING 804 项组件变量已按冻结源码逐项建静态证据；纠正 Less 动态消费误判后，10 项未见静态消费者、81 项属于尚无 Flutter 对应组件的已消费变量；Button 12 项、Tag 12 项默认 Widget 值及 Tag 7 项回退路径已裁定，Progress 9 项已另做默认 Widget/Painter 消费链复核（不等于跨端视觉完成），其余项目仍在 682 项待核队列中，不能直接扣减最终视觉待审数。
- [ ] DOING 已记录公开 API 删除及默认行为变化的 breaking 迁移草案，见 `migration.md`；仓库外独立迁移夹具已在 3.32/3.47 各编译运行 1/1，但真实第三方业务调用点尚未提供、不能宣布外部迁移全量验收。
- [x] DONE 将组件内置配色选择器统一命名为 `colorPreset`：5 个已导出枚举及 Button、Tag、SelectTag、Link、BackTop、Popover、DialogAction 入口均移除旧 `colorScheme` 同义名；Material `ThemeData.colorScheme` 保留原义。Spec、dartdoc、公开 Demo、生成片段、API 文档和聚焦测试同步；真实第三方迁移与全部旧 Golden 仍是独立门禁。
- [x] 已输出阶段性的修改、风险、Golden 问题与修复顺序报告：`report.md`；最终发布验收仍未完成。
