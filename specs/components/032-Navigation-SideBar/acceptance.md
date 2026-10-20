# SideBar 验证范围与结论

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `3d5ed773`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

- 根因：多个 `handleSidebarChange` 并发复用 `_isProgrammaticScroll`；旧动画结束或取消时会提前恢复视口同步，并以中间位置覆盖最后一次选择。
- 修复：为程序化滚动增加递增任务序号，只有最新任务可以结束程序化滚动态并根据最终视口校准，旧任务完成后不再回写。
- 回归：新增 `2 → 5 → 3`、每次间隔 80ms 的连续选择测试。修复前稳定得到 `Expected: 3 / Actual: 1`；修复后动画中及结束后均保持 3，并对齐第三项标题。
- Flutter 3.32.0 / 3.47.0：Example 严格 analyze 均无诊断，SideBar 非视觉功能测试各 9/9 通过；示例代码片段 `--check` 通过。
- 按用户要求未运行或生成 Golden/截图，未提交、未推送。

- 范围：修复仅配置 `selectedTextStyle.fontSize` 时指示线颜色为空；按字段合并实例与组件 Theme，选中文字、图标和指示线遵循同一颜色优先级。无 API 签名变更；默认视觉不变。
- 新增 32 个矩阵用例，覆盖 8 组颜色配置 × M2/M3 × light/dark；修复前复现 24 个失败，修复后组件 75/75 通过。测试验证最终颜色、字号、字重及 3×14dp 指示线尺寸。
- Flutter 3.32.0 / 3.47.0：组件 75/75、Demo 8/8，组件包与 Example 严格 analyze 无诊断；SideBar 生产覆盖率 237/237 = 100%。回归调度清单自测 8/8。
- Flutter 3.32.0 Linux：共享导航 2 张、SideBar Demo 6 张严格 Golden 全部通过，未更新基线。首次复跑遇到构建缓存内图标字体资源缺失，隔离副本重新解析依赖后通过。
- 公开 API 注释已同步，并通过生成器更新 `side-bar_api.md`，没有手工修改生成文档。
- 重新查看 Figma `28591:34071`：默认选中指示线与选中文字为品牌色；本次只核对该修复范围，不代表整页视觉差异全部消除。
- 真机验证未完成：新增默认样式与仅改字号的 light/dark 并排截图场景，但 Android 安装返回 `INSTALL_FAILED_USER_RESTRICTED`，当前修改未能在设备上运行。旧截图不能作为本次修复证据，需用户允许安装后重跑。

以下为此前版本的历史验收记录，不代表本次修改已通过远端 CI、CodeBuddy 或真机验收。

- 设备：原文有范围说明，不能据此确认当前真机通过
- 最终源码通过 `flutter run` 安装并执行 uppercase `R`，返回 `Restarted application in 1,337ms`。
- 手工可见操作：从首页进入 SideBar；锚点页点击第四项并滚动内容；切页页点击禁用第五项后选中态不变，再点击第三项成功；进入带图标与 tag 页面；切换 light/dark。
- tag 页首帧图片尚未解码时右侧短暂空白，等待稳定后 8 个纵向图文行完整出现；Golden 已预缓存同一资产以消除非确定性。
- `flutter test integration_test/sidebar_example_test.dart -d 40302eeb` 最终代码 1/1 通过。
- integration 后重新构建普通 APK；首次安装被系统拒绝，改为检测到“USB安装提示”后精确确认，ADB 返回 `Success`；强停冷启动后检测到“`TDesign Flutter 组件库`”。
- 截图：`/private/tmp/sidebar-phone-anchor-default.png`、`/private/tmp/sidebar-phone-anchor-click.png`、`/private/tmp/sidebar-phone-anchor-dark.png`、`/private/tmp/sidebar-phone-icon.png`、`/private/tmp/sidebar-phone-tag-late.png`、`/private/tmp/sidebar-phone-tag-dark.png`。

## 原记录提到的验证入口

- `flutter run`
- `flutter test integration_test/sidebar_example_test.dart -d 40302eeb`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
