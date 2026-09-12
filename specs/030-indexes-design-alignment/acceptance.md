# Indexes 验收记录

## 设计与交互证据

- 新版 Figma 页面 `24386:5239` 及 375×812 展示帧已人工读取；组件集确认 8 个变体：number/a-z、normal/capsule、default/active。页面入口为“字母索引 / 数字索引 / 胶囊索引”三项。
- 已在小程序官网真实 WebView 点击“基础用法”：打开后默认定位 B，B 锚点和侧栏同时激活；源码确认点击与连续触摸选择、300ms 提示消退、页面级滚动约束。
- 小程序 develop Demo 目前只有“基础用法 / 胶囊索引”，缺少新版 Figma 单列的普通数字索引，已作为跨端差异记录。Flutter Demo 优先对齐新版 Figma 三项布局；字母示例以 initialIndex=B 同步激活态与滚动位置，数字与胶囊示例使用 1,3,5,7,8,10,#。Flutter 保留内嵌 ScrollController 能力。

## 本地验证

- Flutter 3.32.0：组件与 sticky-header 共 62 项测试通过；Example 结构/交互 5 项通过；组件与 Example 严格 analyze 零诊断。
- Flutter 3.47.0：相同 62 项组件测试和 5 项 Demo 测试通过；组件与 Example 严格 analyze 零诊断；当前 Demo 的 Example Web release build 通过。
- 生产代码覆盖率 667/699 = 95.42%。
- 三份示例代码片段已由仓库脚本生成并通过生成检查；数字与胶囊片段各自包含完整的 TButton + TPopup + TIndexes 组合，不依赖片段外私有委托；旧两项 Demo 片段已清理。
- Flutter 3.32.0 Linux 权威基线共 10 张：明暗整页、字母/数字/胶囊打开态 8 张，以及因 TIndexes 视觉变化受影响的共享导航组件矩阵 light/dark 2 张；两组均已无更新参数严格复跑通过，并逐张人工检查，无缺字、裁切或错误激活态。城市字形使用独立 Noto Sans SC 测试子集，不进入产品包。
- API/Theme Review：sticky、stickyOffset、capsuleTheme、reverse 属于组件行为实例字段；TIndexesThemeData 只持有视觉 token；initialIndex 为初始值而非受控状态；当前项由滚动视口派生；onSelect 仅在用户选择时触发；外部 ScrollController 的所有权和释放遵循 Flutter 组合惯例。
- Android 16 真机 `40302eeb` 已人工操作字母 B→G、普通数字 10、胶囊 10 与连续拖动至 #，并检查明暗主题。CodeBuddy 片段修复后再次执行 uppercase `R`，返回 `Restarted application in 940ms`，重新打开数字与胶囊弹层；真实 Example 路由集成测试再次 1/1 通过，最终输出 `All tests passed`。
- 正常 `lib/main.dart` APK 构建后已用 ADB 持久安装，返回 `Success`；`pm path`、普通 Launcher Intent、前台 `.MainActivity` 和安装后首页截图均已确认，应用保留在手机中。

## CodeBuddy 跟进

- GitHub PR：https://github.com/Tencent/tdesign-flutter/pull/1081；CNB PR：https://cnb.cool/tencent/tdesign/tdesign-flutter/-/pulls/147；Issue #1027 的 Indexes 条目已关联。
- 首轮 CodeBuddy 指出数字/胶囊“查看代码”只有一行 `_buildNumberScenario(...)` 委托，属于阻塞问题；现已将两项完整实现分别内联并重新生成 35 行可复制片段。
- 修复后的双版本 Example analyze、Demo 5/5、生成检查、真机 Hot Restart、人工数字/胶囊操作、设备集成 1/1 与普通 APK 重新构建/安装均通过。
- `db002a3a` 的 GitHub/CNB CI 与 CodeBuddy 首轮复审均已完成；本次新增专项修复仍需在推送后接受新的远端 CI。iOS 真机不在本轮设备范围内。

## 专项复审修复

- CodeBuddy 基于 `db002a3a` 的专项复审未发现阻塞问题，并指出 reverse 定位、动态 indexList 降级、Theme nullable 插值、超大 tipSize 约束和字母代码片段数据说明五项边界。
- 聚焦测试复现 `reverse: true + initialIndex` 的目标内容中心落到视口外（修复前为 -60.5），现改为通过当前 Scrollable 逐步确保近端与未构建远端锚点可见；初始 B、选择 C 和八段内容选择 H 均通过可见区域断言。
- indexList 移除当前活动项时回退新列表首项、同步到最小滚动位置并发送一次 onChanged；initialIndex 继续只在首次创建时校验和生效。
- TIndexesThemeData 的 nullable 插值不再把 null 当作 0 或透明值；tipSize 超过默认 99px 上限时有效 maxWidth 同步扩展，避免无效 BoxConstraints。
- 字母示例生成片段已标明 `_list` 的“索引 -> 城市列表”结构和代表数据；生成器及 `--check` 通过。
- Flutter 3.32.0：Indexes 组件与 sticky-header 共 67 项、Demo 5 项通过；组件与 Example analyze 零诊断；生产代码覆盖率 699/732 = 95.49%。合并 develop 后共享导航 light/dark Golden 已在固定 Flutter 3.32 Linux 容器重建、人工检查，并无更新参数严格复跑 2/2 通过。
- 最新 head 补充 reverse 最近锚点未推进场景：当 `ensureVisible` 尚未构建更近锚点时按一个视口步进，抵达滚动边界仍无进展则结束任务，避免相同参数反复 post-frame 调度；Flutter 3.32.0 聚焦用例与 Indexes + sticky-header 68 项回归通过，相关源码与测试严格 analyze 零诊断。
