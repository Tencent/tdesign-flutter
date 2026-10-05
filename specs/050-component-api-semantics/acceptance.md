# 57 项 API 语义修复验收

基线 `origin/develop@a0b0d0fec45d50ebe6afc898b3bfb381c12330b7`；修复分支 `rss1102/fix/component-api-semantics`。日期 2026-10-04。

结论：本轮 API 语义范围的 16 项阻塞已处理，57 项均有实际测试执行证据。纯命名迁移保留为非阻塞建议；不代表跨端全部视觉场景已验收。

## 最终验证

- Flutter 3.32.0 与官方最新标签 3.47.6：各 2,741 条有效组件测试（57 项、116 个唯一登记文件），各 272 条 Demo 非 Golden 测试（51 个登记文件），均无失败或跳过。
- 双版本 `flutter analyze --no-pub --fatal-infos`：零诊断；调度器 19 条自测通过。3.32.0 使用最终源码的独立临时副本，不与 3.47.6 共用构建缓存。
- 修复组件覆盖率：BackTop 100%（182/182），NoticeBar 96.55%（308/319），均达到 95% 门禁。
- 从深色模式文档原文提取 Cell/Switch 完整示例，两版编译、点击切换模式测试均通过；临时文件已移出工作区。
- `node tool/generate_api.mjs`：生成全部 57 份 API 文档；没有说明为空的参数行。源码使用正式工具 main 依赖，未修改生成器缓存、未手改生成文档。
- `dart run tool/generate_example_code.dart --check`：通过。`git diff --check`：通过。
- 未改变绘制或视觉资源，未运行/更新 Golden；上述本地验证不能替代远端 CI。

### SDK 证据

3.47.6 framework `5fc346839b5d0eef006ed8404392afb4dfae428d`，engine revision `692136cb6582dbfc5af3fb33c2515a069f2f66d0`，Dart 3.13.5。通过官方 git 标签检出并下载对应 engine。官方压缩包/发布 JSON 返回 404，因此采用源码安装；本机已有 3.47.0 未被替换。官方最新补丁依据：[Flutter changelog](https://github.com/flutter/flutter/blob/master/CHANGELOG.md)。

### 执行命令

```sh
flutter test --no-pub --exclude-tags "demo || golden" --reporter json <manifest 全部 componentTests 去重>
# example 目录
flutter test --no-pub --exclude-tags golden --reporter json <manifest exampleTests + sharedExampleTests 去重>
flutter analyze --no-pub --fatal-infos
flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart
flutter test --no-pub --coverage test/components/backtop/t_backtop_test.dart test/components/notice_bar/t_notice_bar_test.dart
dart run tool/check_component_coverage.dart backtop
dart run tool/check_component_coverage.dart notice_bar
node tool/generate_api.mjs
dart run tool/generate_example_code.dart --check
```

逐项执行数与登记文件保存在 `evidence/components-*.json`；共享测试文件可能归属多个组件，不累加各行得到整库唯一测试数。完整执行日志为 `/private/tmp/api-repair-{components,demo,analyze,runners}-<version>.log`，文档示例日志为 `/private/tmp/api-repair-doc-example-<version>.log`，生成日志为 `/private/tmp/api-repair-generate-final.log`。`evidence/api-doc-check.json` 保存生成文档的 SHA-256。

## 57 项逐项验收

| # | 登记项 | 结论 | 当前契约与处理结果 | 3.32.0 / 3.47.6 执行数 |
|---:|---|---|---|---:|
| 1 | avatar | 通过 | onTap 是头像动作；Group 的 maxCount/overflow 是内容组合，size/shape 是呈现选择。 | 43 / 43 |
| 2 | action_sheet | 通过 | onSelected 保留领域动作；scroll.itemMinWidth 的源码参数说明已进入生成文档。 | 59 / 59 |
| 3 | badge | 通过 | TBadge.onTap 覆盖徽标及 child；TBadgeConfig 只配置视觉，没有第二个点击入口。 | 52 / 52 |
| 4 | cell | 通过 | 保持 onTap/onLongPress；深色模式完整 Cell/Switch 示例使用现行 API，两版编译和交互验证通过。 | 27 / 27 |
| 5 | backtop | 通过 | 保留历史 onPressed 时机；实际到顶且绑定对象/滚动位置仍一致才报告，取消、替换、解绑和卸载有回归。 | 54 / 54 |
| 6 | button | 通过 | onPressed=null 禁用，长按受同一启用条件约束；variant/colorPreset/shape/size 与 ButtonStyle 职责分离。 | 130 / 130 |
| 7 | cascader | 通过 | value 是受控路径；onChanged 提交不可变候选路径，父级回写才推进导航。 | 25 / 25 |
| 8 | picker | 通过 | 受控值模型保留；TPickerPopup 的 context/child/headerBuilder 说明已进入生成文档。 | 56 / 56 |
| 9 | progress | 通过 | value/status/variant 分离；只有 button/microButton 接受动作；长按可独立，不能把点击解释为进度完成。 | 67 / 67 |
| 10 | date_time_picker | 通过 | 受控日期时间值；onChanged 去重且初始挂载不通知；mode、start/end、steps 保留领域模型。 | 154 / 154 |
| 11 | calendar | 通过 | 日期与月份回调独立；生成文档移除根库未导出的 TCalendarStyle，公共类型保持不变。 | 54 / 54 |
| 12 | tag | 通过 | onTap/onCloseTap 是动作，移除归父级；SelectTag.value/onChanged 是选择请求；enabled 控制已有动作。 | 98 / 98 |
| 13 | popover | 通过 | 保留动作与开合入口；补公开函数参数文档，明确每个 Controller 绑定一个 Anchor 及重复绑定的现有行为。 | 66 / 66 |
| 14 | checkbox | 通过 | value/onChanged 单一受控源；超限只报告 onMaxSelected，不发成功变更；单项 disabled 与整组禁用分层。 | 50 / 50 |
| 15 | collapse | 通过 | onChanged 返回完整不可变展开集合；mode 为单/多展开，variant 为呈现；条目与整组禁用分层。 | 29 / 29 |
| 16 | divider | 通过 | layout/align/dashed 为绘制配置，child 为内容；竖向忽略横向选项已说明；无需状态回调。 | 39 / 39 |
| 17 | empty | 通过 | image/icon 优先级明确；operation 组合 Widget，动作由子组件负责，不增加重复 onOperation。 | 6 / 6 |
| 18 | image_viewer | 通过 | 路由 Future 是关闭结果；索引、删除、点击、长按分离；最新 API 已无清单中的 onClose。 | 25 / 25 |
| 19 | dialog | 通过 | 保持按钮动作与自动关闭顺序；show、ConfirmDialog 及可空插值参数说明已补齐。 | 32 / 32 |
| 20 | dropdown_menu | 通过 | 单选候选请求、多选草稿确认分离；明示重选仍提交关闭，核心参数、展开位置及关闭原因已补全。 | 95 / 95 |
| 21 | drawer | 通过（保留迁移建议） | 内容与 showTDrawer 生命周期分开；onItemClick 可迁移 onItemTap，连同 typedef；onOverlayClick 等也应纳入同义迁移。 | 40 / 40 |
| 22 | fab | 通过 | onPressed 是按钮激活，onDragStart/End 是拖动阶段；draggable 可空不由动作回调推导；要求 Stack 直接子节点。 | 72 / 72 |
| 23 | footer | 通过 | links 通过 Widget 组合自带动作；logo 与 links 优先级明确，不增加重复链接事件。 | 10 / 10 |
| 24 | indexes | 通过（保留迁移建议） | onSelect 仅侧栏，onChanged 还含滚动派生；侧栏切换先 onSelect 后 onChanged；同项不通知，不因同次触发就合并。 | 71 / 71 |
| 25 | image | 通过 | onLoad/onError 每来源周期一次，与 UI builder 职责分开；onTap 独立；图源互斥明确。 | 14 / 14 |
| 26 | refresh | 通过（保留迁移建议） | Future 决定任务结束，Controller 发起命令，onStateChanged 报状态；超时和迟到去重；共用 Controller 的绑定规则需明示。 | 31 / 31 |
| 27 | rate | 通过 | 受控评分；onChangeStart/End 为阶段；取消以当前受控值结束，不改成统一结果回调。 | 38 / 38 |
| 28 | result | 通过 | status 决定图标、颜色与无障碍含义，属于内容状态；icon 是显式内容覆盖。 | 23 / 23 |
| 29 | tab_bar | 通过（保留迁移建议） | 父级负责选择请求，item.onTap 为附加动作；重选受 allowMultipleTaps 控制，不再 onChanged；无受控菜单值的菜单事件宜评估 onSelected。 | 45 / 45 |
| 30 | navbar | 通过 | onBack 接管默认返回，否则 maybePop；普通操作 onTap=null 禁用；customWidget 自带行为。 | 62 / 62 |
| 31 | tabs | 通过 | Controller 为状态源；onTap 包含重选，程序切换与滑动由 Controller 监听，自动切换时机已说明。 | 77 / 77 |
| 32 | swiper | 通过 | Controller 管实际业务索引，循环原始页不泄漏；监听与 onChanged 分工；children/itemBuilder 互斥。 | 42 / 42 |
| 33 | skeleton | 通过 | 预设与 custom 互斥；animation=null 静态，delay 为延迟展示；无需增加第二加载状态源。 | 18 / 18 |
| 34 | time_counter | 通过 | onChanged 按 format 精度采样；onFinish 到终点一次；time 更新优先于临时 reset；Controller 广播已有明确文档。 | 47 / 47 |
| 35 | icon | 通过 | 显式样式、内部 TD 样式、Token 顺序明确；未知名称抛错；内部 StyleScope 未从根库公开。 | 23 / 23 |
| 36 | link | 通过 | onPressed 为链接激活，为 null 禁用；不是值变化组件。 | 20 / 20 |
| 37 | loading | 通过 | 公开 Controller show/dismiss 已纳入生成文档；明示全局单例、重复 show 忽略和调用方关闭职责。 | 39 / 39 |
| 38 | message | 通过 | 独立关闭阶段保留；show.context 说明已进入生成文档，manifest 使用现行 TMessageMarquee。 | 35 / 35 |
| 39 | notice_bar | 通过 | 自定义目标只报告单指主按钮短按；拖动、长按、取消、多指和次按钮不误报，正常点击保留子动作。 | 56 / 56 |
| 40 | popup | 通过（保留迁移建议） | visible 在发起阶段，opened 在展开动画结束，closed 在周期结束；不是重复完成通知；overlay.onClick 可同义迁移。 | 170 / 170 |
| 41 | radio | 通过 | 受控组保留重选请求；options 参数及重选语义已补入源码和生成文档。 | 40 / 40 |
| 42 | table | 通过 | 选择集合/排序各自受控；普通格先 onCellTap 后 onRowTap，选择控件不报告行点击；滚动独立。 | 51 / 51 |
| 43 | text | 通过 | FontLoader 保留并发去重语义；name/fontFamilyUrl 的声明级参数文档已正常生成。 | 37 / 37 |
| 44 | search | 通过（保留迁移建议） | Controller/initialValue 互斥；清除实际 clear→onClearPressed→onChanged；右侧 action 与键盘 submitted 分开，不隐式释放焦点。 | 10 / 10 |
| 45 | steps | 通过（保留迁移建议） | progress/selectable/display 职责分开；onChange 报点按索引，包括同项；改名先确定动作或候选选择，不能机械加 d。 | 30 / 30 |
| 46 | sidebar | 通过 | value 是业务值而非数组索引；只在不同项选择时请求变化；loading、条目 disabled 与整栏禁用分工。 | 64 / 64 |
| 47 | slider | 通过 | Slider/RangeSlider 受控；start/end 是拖动阶段；divisions/formatters/展示开关不是第二数值源。 | 28 / 28 |
| 48 | stepper | 通过 | value 单一受控源；按钮/提交/失焦请求变更；边界不再通知，未接受草稿恢复。 | 44 / 44 |
| 49 | switch | 通过 | value/onChanged 受控；loading 表示进行中，会禁用，不能由 callback 可空性推导。 | 37 / 37 |
| 50 | tree_select | 通过 | value 为受控路径集合；multiple 为模式；内部导航不替代业务选中值。 | 20 / 20 |
| 51 | upload | 通过 | files 受控，onFileTap 不自动上传/预览；校验与选择器异常分开；status 属于文件模型。 | 29 / 29 |
| 52 | form | 通过 | 字段负责业务值；注册快照先更新，再无参 onChanged；submit 先校验；外部同步不冒充用户变更。 | 63 / 63 |
| 53 | input | 通过 | Controller/initialValue 互斥；enabled/readOnly 不由 callback 推导；submitted/editingComplete 不同阶段；status 是校验状态。 | 36 / 36 |
| 54 | textarea | 通过 | 复用输入内核；layout 是内部标题布局，label 不代替表单标签；bordered 与 Input.borderless 极性差异为一致性建议。 | 14 / 14 |
| 55 | theme | 通过 | Token、组件 Theme 和 Material ThemeData 映射；实例 status/value/callback 不迁入 Theme；ColorScheme 是实际调色板。 | 89 / 89 |
| 56 | toast | 通过 | 所有入口明确匿名实例共用固定 ID 并替换；显式 ID 的并存/替换语义保留。 | 48 / 48 |
| 57 | swipe_cell | 通过 | onOpenChanged 在动画前报告目标开合；补 start/end 的方向语义，保留 Action.context。 | 31 / 31 |

## 兼容性及保留建议

公开名称、类型及正常操作时机保持不变。NoticeBar 取消操作和 BackTop 未成功到顶不再误报，属于回调触发条件变化，按 breaking 评估交付；调用方不应依赖这些错误通知。

原清单的同义命名迁移（Popover.onLongTap、Drawer.onItemClick 及 typedef、Popup.overlay.onClick）需独立版本方案，当前不新增兼容别名或重复事件。Steps 的点按/候选选择先明确领域模型；TabBar item 动作与父级状态请求独立，菜单命名另评估。Indexes、Calendar、CheckboxGroup、Message、Popup 的不同来源/阶段保持分离；Form 无参通知保留 Controller.values 读取路径。ImageViewer 的旧 onClose 及 TabBar badge.onTap 已不属于当前公开面。

衡量顺序仍为真实事件和阶段、单一状态所有权、Flutter 惯例、同义一致性、迁移成本；M3 不作为机械重命名规则。

最终复核：3.32.0 独立副本补齐调度器读取的原始 `.github` / `.cnb` 配置后，19 条自测全部通过；工作区临时示例测试与 coverage 已清理，原用户工作区产物未改动。
