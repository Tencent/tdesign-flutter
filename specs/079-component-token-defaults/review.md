# PR #1172 / #1174 拆分复审

## 固定版本

- develop：3bc89d28e96d580e0893526c627dc38f16b16d82。
- #1172：590df49a6209d31978e70e2eb4ea26101c605a6f。
- #1174 初次拆分检查点：b374adc29503907bd51724c202d14eb3c8b44ab0；后续插值修正单独验证。

## #1172 范围与结论

检查其全部生产差异：CSS 字体与尺寸转换、sizeMap 传递/默认/稀疏插值、五类浮层实时继承，以及 Badge 气泡圆角、Button 四档图标、Tag 四档净 padding 九个可选字段。

未新增组件全局尺寸/圆角/间距依赖。Button 的高度、水平/垂直 padding、图标各档与 develop 相同；Badge square=2、气泡=10/10/10/1、dot=8；Tag 原始盒模型及统一 padding 优先级不变。其他九组调整在此 PR 全部回退。主题字段未配置时的默认值保持，显式局部组件主题继续优先。控制器开始正确传递既有语义字体等属于修复目标，不能误称所有自定义主题行为都无变化。

最终 head 的 test-build run 39124903963 已整体 success：双 SDK analyze/test、六项构建、Linux 原基线精确视觉比较均通过。autofix 没有产生额外 head。Golden diff 为 0。没有阻塞的源码问题；仍需按仓库 Draft、Reviewer、CLA 等要求处理，不能据此绕过平台门禁。

## #1174 默认与全局依赖边界

九组默认值差异仍以 spec.md 的旧→新表为准，没有新增数值目标。逐项检查原 114 个处置点：36 节点绑定、22 项用户授权一致刻度及其余语义修正/撤回/待确认处置按 077 原表保留，未将待确认项重新绑定。

新增全局消费涉及 Avatar、BackTop、Badge、Button、Cell、Drawer、Dropdown、Loading、Search、SideBar、Stepper、Swiper、Switch、TabBar、Table、Tabs、TimeCounter、Toast、TreeSelect。尺寸相同但从固定值改为全局取值的属性仍属于 breaking；不能因默认截图没变化而漏报。

18dp 的小/超小 Button 图标、Badge 气泡圆角与 Tag 分档 padding 保持组件配置，不扩大站点控制器。Search 前缀自身显式 20dp，外层 IconTheme 的 size 只参与既有主题/布局回退，不声称可独立改变前缀图标。

98 张 PNG 的 afterSha256 全部匹配，文件集合与 PR 的 Golden 变更集合完全一致。原因归类：BackTop 10、Badge 10、Dropdown 16、Toast 36、Refresh 4、SideBar 4、Table 18。Cell/Tabs 的默认差异由实际布局断言覆盖；这 98 张图片不是 57 页全部视觉场景的证明。

## 发现且修复：新增全局默认的 nullable 插值

实际复现：`TTableThemeData().lerp(TTableThemeData(cellPadding: EdgeInsets.all(20)), 0)` 渲染 header 的 padding 为零，正确端点应为当前 spacer1（默认左右 12）。BackTop 在自定义 size13=80 时，原插值仍以固定 48 起步。

修复消费端延迟解析的 14 项几何字段：BackTop 四项、Cell 卡片圆角、Table padding、TabBar 高度、Drawer 两项 padding 与图标间距、Search padding/两种图标主题 size、Toast 分形态 padding。未增加全局引用或修改最终默认值。Search 的 IconThemeData 整体替换时，未指定 size 按原契约回退全局默认，不保留被替换对象的旧过渡。copyWith/merge 的显式字段清除对应过渡，其他字段继续保留；中断后再次插值沿用已解析的过渡。SideBar 已用 nullable 离散切换，Stepper 已按完整有效样式递归解析，无需重复修改。

新增 17 项回归涵盖双向 nullable、端点、中间值、copyWith、二次插值、显式覆盖、Directional padding 与实际 Table 与 BackTop Widget 布局。初次登记在theme入口；squash后真实CI分组核对将其中3项Drawer用例原样移到Drawer组件入口，其余14项保留theme入口。详见ci-registration-results.json的双版本独立门禁结果。

## 风险与合入条件

#1174 会改变默认外观及自定义全局主题的联动范围，需以 breaking 发布。Cell/Table/BackTop/Dropdown/Toast 有直接显式覆盖；Badge square、SideBar 内块、Tabs 内框没有独立组件字段，局部全局 token 也会影响其他消费者；Refresh 内部 25 无公开单属性旧 24 的恢复入口。

完整远端 CI 只对 develop 目标运行。#1174 目前基于 #1172，现有检查不等于双版本功能/构建/视觉 CI；必须 #1172 合入后切换 base，验证最终 head 和合并结果，再决定 #1174 合入。不能使用 af58482e 的历史全绿替代本次修正后的验证。

### 堆叠 PR 的合入保护

#1174 当前目标为 #1172 分支，不可直接合入，否则会把 breaking 改动带回原 PR。先合入 #1172 后检查其旧 head 590df49a 是否仍为 develop 的祖先：普通 merge 保留祖先时可正常改 base；若 #1172 经 squash/rebase 合并导致祖先关系丢失，须将 #1174 在 590df49a 之后的独有提交重新整理到最新 develop（处理冲突并重新验证），再核对最终 diff 只有 breaking 增量，执行新 head 完整 CI。仅切 base 不能保证差异范围正确。

## 最终本地检查结果

双SDK各512组件测试、157页面测试、八组>95%覆盖率、严格分析及API审计通过；17项新增回归通过。25组Linux Flutter3.32无更新视觉比较全部通过，覆盖原16组已审阅基线的所有归属套件及本轮修改影响的套件。98张PNG哈希仍与批准记录一致；比较器与容差未修改。详见review-results.json的源码指纹、资源指纹与分项结果。这是当前源码的本地证据，不是#1174完整远端CI。
