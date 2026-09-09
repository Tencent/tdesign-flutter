# 验收记录

## 目标与行为

- 设计目标：Figma `28600:37263`，375 宽移动端展示；小程序公开 Demo 仅作为功能交互参考。
- 公开 Demo 顺序为基础、带操作说明、手风琴、卡片；模块标题由页面基础设施统一编号。
- 基础和带操作说明各一项，手风琴和卡片各三项；后两组均为第一项初始展开，末项为可交互普通面板。
- 公开 Demo 关闭 Debug 专用的“单元测试”模块，页面在卡片示例后结束。
- multiple 和 accordion 的展开状态均仅由 `TCollapse.value` 与
  `TCollapsePanel.value` 决定，不再存在 Panel 级第二状态源。
- Demo 未使用外层视觉补丁；标题、正文、分隔线、卡片与展开图标由组件和 `TCollapseThemeData` 负责。

## 自动化验证

| 环境与命令 | 结果 | 证据 |
| --- | --- | --- |
| Flutter 3.32.0 Collapse 组件测试 | PASS，29 项 | 覆盖统一受控状态、Header 扩展点、Theme、禁用及契约断言 |
| Flutter 3.32.0 `flutter test --no-pub test/collapse_demo_test.dart` | PASS，5 项 | 覆盖分组、初始状态、Accordion 末项展开、Card 首项收起和基础面板收起 |
| Flutter 3.32.0 组件包与 Example `flutter analyze --no-pub --fatal-infos` | PASS | 两处均为 `No issues found` |
| Flutter 3.47.0 clean 临时副本中的相同组件/Demo 测试 | PASS，29 + 5 项 | 不复用 3.32 `.dart_tool`，重新解析依赖后执行 |
| Flutter 3.47.0 组件包与 Example `flutter analyze --no-pub --fatal-infos` | PASS | 两处均为 `No issues found` |
| `dart run tool/generate_example_code.dart --check` | PASS | 四个 Collapse 片段与真实 Demo 同源；核心片段说明数据、初始状态和回写路径 |
| `sh ./demo_tool/all_build.sh` | PASS | Collapse API 生成文档反映新 `List<T>` 契约；已排除生成器产生的无关 Drawer 噪音 |
| `node scripts/check-flutter-component-contracts.mjs` | PASS | 56 个站点路由的源码、Example 和文档入口完整 |
| `git diff --check` | PASS | 无空白错误 |

组件生产代码聚焦覆盖率为 `219/229 = 95.63%`，高于 95% 门禁。

## Linux Golden

- 固定环境：`docker.cnb.cool/liweijie0812/docker/flutter-3.32.0`，Linux amd64，375 宽、DPR 1，确定性 CJK、TDesign、Cupertino 与 Material Icons 字体。
- 更新前严格比较确认旧基线为 375×1892、当前实际图为 375×1721；差异来自删除旧“向上展开”示例、修正重复模块编号及移除 Accordion/Card 末项禁用态。
- 人工检查更新前实际图：浅色/深色均无缺字方框，展开图标方向正确，Accordion/Card 末项为正常可交互视觉。
- 仅更新 `collapse_page_light.png` 与 `collapse_page_dark.png`，随后在同一容器移除 `--update-goldens` 复跑，2/2 通过；仓库默认 `LocalFileComparator` 严格比较，未放宽容差。
- 根据 Figma 实际移动端画板将 Accordion/Card 从四项收敛为三项；更新前严格比较确认旧基线 375×1481、当前实际图 375×1367，高度差来自 Accordion/Card 各删除一个多余折叠行。
- 人工检查明暗实际图及真机截图：实例数量为 1 + 1 + 3 + 3，Accordion/Card 均为首项展开、后两项折叠，无缺字、裁切或禁用态。
- 仅更新 Collapse 明暗两张基线，随后在同一 Linux Flutter 3.32.0 容器中不带更新参数复跑，2/2 通过。
- 最终两张基线均为 375×1367。SHA-256：light `cc606ddfac6c10e7a4266651daf770e9d27837ab71969b172e0742ad5831be73`；dark `39c75280597c6eff70f9c25098814bc480f780851aa326b9f380ec75b0132af2`。
- API 重构后先严格比较定位到 `trailingBuilder` 误用 16px 标题字号导致的
  light 434px / dark 430px 差异；修正为 14px 辅助文案样式后，在同一
  Linux Flutter 3.32 容器中不更新快照复跑，light/dark 2/2 严格通过。
- iPhone 16 / iOS 18.2 模拟器联动发现 Accordion 局部 value 会在其他组
  `setState` 时重置；已将其提升到页面 State，并增加跨组交互回归。
- 同一模拟器热重启后复验：手风琴切换至第三项，再展开/收起卡片第二项，
  手风琴仍保持第三项；卡片第一、二项可同时展开，箭头方向与内容状态一致。

## 远端状态边界

- HEAD `8922305a` 的上一轮 CNB 为 7/8：双版本 analyze、Flutter latest test、双版本 APK/Web 均通过；Flutter 3.32 visual regression 因旧 Golden 失败。
- 本轮已在 CI 同款 Linux 3.32 环境更新并严格复验 Golden。推送产生新 HEAD 后仍须以新流水线结果为准，旧 HEAD 的 7/8 不作为最终 CI 通过证据。

## Breaking API 重构

- 已完成目标契约：`List<T> value/onChanged` 统一所有展开状态，nullable callback
  负责整组启停；Panel 保留单项 `disabled`，不新增组级 `disabled`。
- 已完成扩展点：`leadingBuilder`、`trailingBuilder` 与三态
  `expandIconBuilder`；删除 `isExpanded`、`onExpansionChanged` 和
  `expandIconTextBuilder`。
- 生产源码、Demo、站点文档、API/示例生成产物和回归测试已同步；
  本节上方的当前命令结果为本次重构验收证据。
