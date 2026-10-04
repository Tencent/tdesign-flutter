# 57 项审视与本轮处理决策

以下为 20545066 的审查记录。其绑定风险已在本 Spec 修复；文档缺口已补齐。行为选择和低优先名称的最终决策见 acceptance.md。审查中“仍需处理”是修复前状态，不代表本轮尚未实施。

# 57 项组件 API 复审

提交：2054506633f79079f425a62443801267d8a846c2；PR #1148；2026-10-05。
本轮只审查，仓库源码、Spec、PR 均未修改。桌面清单作为评审资料，不作为修改指令。

## 仍需处理

1. DropdownMenu Controller 绑定丢失：后绑定覆盖，旧组件无身份解绑清空新绑定。临时副本测试已复现：同时挂载 A/B，移除 A 后 B 的 controller.open 无效。日志 /private/tmp/api-review-binding-probe.log。
2. Form Controller 单绑定只通过 assert 保证，release 会覆盖；替换先解绑旧再绑定新，绑定失败不能保持实际旧绑定。源码确认，未新增 release 运行复现。
3. 公开 API 文档缺口：直接导出的 DropdownMenuController、MenuItem、Option、单多选 Panel、CheckboxOption、TMessageHandle，以及 TNavBarThemeData、TButtonThemeData 等多个 Theme 无独立章节。生成 57 个文件不等于公开类型完整覆盖。

建议收敛：Popover Controller 单目标绑定与未绑定行为；Radio 重选通知；Checkbox 半选/二态交互契约。低优先：Input/Textarea 边框命名、Popover 内容手势目标、剩余 Click 词；BackTop 补单 ScrollPosition 约束。Loading 未首次绘制卸载的延迟清理是已说明的限制，立即释放需求另评估。

## 逐项审视

下表覆盖全部 57 项。范围包括公开入口、参数/枚举、状态与事件职责、Controller、Theme 和文档。静态审视不等于穷举所有参数组合；本轮新增运行复现仅覆盖 DropdownMenu 绑定场景。

| # | 组件 | 当前结论 |
| ---: | --- | --- |
| 1 | Avatar | 展示与组合能力，未发现需要新增选择状态入口 |
| 2 | ActionSheet | onSelected 表示选择动作，不能直接与受控 onChanged 合并 |
| 3 | Badge | 独立徽标动作与父组件动作要按实际命中区区分；当前 TabBar 配置并非原清单中的三重回调模型 |
| 4 | Cell | onTap/onLongPress 为标准手势语义 |
| 5 | BackTop | 激活与完成已分离；仍应明确 ScrollController 只能有一个 ScrollPosition，offset/position 不支持多位置。 |
| 6 | Button | 已修复独立长按启用；样式覆盖与动作职责独立。 |
| 7 | Cascader | 受控路径选择与层级浏览职责不同 |
| 8 | Picker | onChanged 选择请求与 onColumnScrollEnd 滚动阶段不同 |
| 9 | Progress | button/micro 支持独立长按；与 Button 的启用规则需联动讨论 |
| 10 | DateTimePicker | 选择结果与列滚动阶段不应合并 |
| 11 | Calendar | onChanged 是日期选择，onMonthChanged 是月份导航 |
| 12 | Tag | onCloseTap 是关闭图标动作，不表示组件已移除 |
| 13 | Popover | 长按与生命周期说明已处理。Controller 最后挂载覆盖，open 未绑定仅 assert 后强制取值；建议与其他单目标 Controller 统一运行时约束。内容 onTap 可进一步消歧。 |
| 14 | Checkbox | 超限回调已收敛；null 是半选展示、点击转 true。半选不是循环三态，需明确该契约而非删除能力。 |
| 15 | Collapse | 受控展开值与条目禁用职责明确，不必套用 Material expansionCallback 签名 |
| 16 | Divider | 无业务事件或状态竞争 |
| 17 | Empty | 操作由组合的子 Widget 承担，无需额外复制按钮回调 |
| 18 | ImageViewer | 当前 show 无 onClose 参数，原清单该项已不适用；等待 Future 可观察路由结束 |
| 19 | Dialog | 按钮动作与自动返回结果分离；没有回调仍可拥有自动关闭动作 |
| 20 | DropdownMenu | 已复现 Controller 绑定缺陷：后绑定覆盖，旧菜单卸载清空新绑定。应运行时单绑定并按 owner 解绑。单选重选仍提交/关闭是已有明确契约，不机械去重。 |
| 21 | Drawer | onItemTap 和 typedef 已收敛；保留 index/item 数据及 Popup 关闭能力。 |
| 22 | FAB | 动作、拖动结束与吸附是不同职责，不能把拖动结束当吸附完成 |
| 23 | Footer | 链接/子项动作保持局部职责 |
| 24 | Indexes | onSelect 是侧栏交互，onChanged 包括滚动派生；命名可优化，不属于冗余同一事件 |
| 25 | Image | 加载成功、错误通知与错误占位构建职责不同 |
| 26 | Refresh | 已修复运行时单绑定和身份解绑、失败替换保留实际旧绑定；刷新动作与状态分离。 |
| 27 | Rate | onChangeStart/onChanged/onChangeEnd 是不同交互阶段 |
| 28 | Result | 组合动作，无需强加选择状态 |
| 29 | TabBar | 已收敛 onSelected/notifyOnReselect；主选择与条目动作独立。type/itemStyle/style 是不同视觉轴，不因名字相近删能力。 |
| 30 | Navbar | 返回动作与导航栏组合槽职责清楚 |
| 31 | Tabs | TTabsBar.onTap 包括重选；TabController 持有选中状态，符合 Material TabBar 模型 |
| 32 | Swiper | Controller 与业务索引通知各有职责，循环页索引应保持业务语义 |
| 33 | Skeleton | 预设/自定义布局与动画设置不是重复业务状态 |
| 34 | TimeCounter | 时间通知与结束事件不同，Controller 的广播语义不等于普通单组件控制器 |
| 35 | Icon | 图标/字体能力，无需借用业务状态 API |
| 36 | Link | 按钮动作语义可保留，不统一替换为手势名 |
| 37 | Loading | 已修复已绘制 Overlay 卸载及后续恢复；未首次绘制卸载延迟到下一次 show/dismiss 释放，已声明限制。 |
| 38 | Message | 关闭按钮动作、超时结束原因、全部关闭完成三个职责；可另评估带原因的关闭完成事件 |
| 39 | NoticeBar | onTargetTap 已修复；区域短按与子控件动作独立。 |
| 40 | Popup | onTap 和流程阶段说明已修复；closeOnClick 等剩余词可低优先统一为 Tap。 |
| 41 | Radio | 仍需确认重选契约：当前重选会 onChanged；若选择去重，需保留有价值的独立重选动作。 |
| 42 | Table | 选择、排序、单元格点击和行点击是不同作用域 |
| 43 | Text | 文本/排版能力，没有业务状态冲突 |
| 44 | Search | 清除按钮、动作按钮、输入变化与提交职责不同，不建议压成同一事件 |
| 45 | Steps | 已修复为 onStepTapped，包含当前项；value 外部受控，progress/display/selectable 保留。 |
| 46 | Sidebar | 当前项去重，返回业务 value；不能改成显示 index。 |
| 47 | Slider | 受控值与开始/结束交互分离，符合 Material Slider 基础模型 |
| 48 | Stepper | 这是数值步进器，不能按 Flutter Material Stepper 流程组件强行对齐 |
| 49 | Switch | value/onChanged 与 loading 的暂时禁用职责不同 |
| 50 | TreeSelect | 受控路径与层级浏览职责不同 |
| 51 | Upload | 文件集变化、文件点击、校验失败职责不同 |
| 52 | Form | 需要加固：单绑定仅 assert，release 会覆盖；更换 Controller 先解绑再绑定，失败缺少回滚。建议运行时拒绝重复并在绑定成功后切换。 |
| 53 | Input | 受控编辑、initialValue 互斥、enabled/readOnly 各有职责；borderless 与 Textarea.bordered 可统一表达方向。 |
| 54 | Textarea | 基础编辑契约保留；bordered 与 Input.borderless 反向命名可统一，保留默认视觉。 |
| 55 | Theme | 视觉默认和令牌职责保留，本轮未发现 value/status 双控制源；多个已导出 Theme 缺生成 API 章节。 |
| 56 | Toast | 展示/替换/清理属于通知生命周期，不等同于 Material SnackBar 排队模型 |
| 57 | SwipeCell | onOpenChanged 是开合目标状态，不承诺动画完成；Action.onPressed(context) 有上下文价值，不建议删除 |

## 当前证据

当前本地与远端 head 一致。PR 可合并；双版本 analyze/test、Linux Golden、APK/iOS/Web 构建均 SUCCESS。现有门禁通过不代表未覆盖的语义组合无缺陷。

源码根：/Users/rs/.codex/worktrees/api-semantics/tdesign-flutter。
关键定位：dropdown_menu/t_dropdown_menu.dart:179、190、436、513；form/t_form.dart:248、308；popover/t_popover.dart:79、93；backtop/t_backtop.dart:36、135（均在 tdesign-component/lib/src/components 下）。文档对照：tdesign-component/lib/tdesign_flutter.dart、tool/components.json、example/assets/api。

公开参数提取：/private/tmp/api-review-current-inventory.txt。既有 57 项测试与覆盖证据：specs/052-api-foundation-contracts/validation-results.json。本轮未重新运行无源码变动的整套测试。

优先顺序：修复绑定风险，补文档，再决定重选/半选，最后做命名统一。保留基础能力，不增加旧 API 兼容别名。
