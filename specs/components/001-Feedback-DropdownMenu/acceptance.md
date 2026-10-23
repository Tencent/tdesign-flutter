# DropdownMenu 验证范围与结论

<a id="record-001-anchored-overlay"></a>
<a id="record-011-official-demos"></a>

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| TDropdownMenu：稳定锚定浮层与菜单切换动画 | `542d1b4c9da7e201ee9a2af35e71f67b4e79983a`；Flutter 3.32.0 | 组件与布局：未提取到可独立确认的通过结论；设备：仅按下文的实际操作与未覆盖范围解释 |
| DropdownMenu Figma、Demo 与组件契约对齐 | `fb26b8d5`、`c5ef738d`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

- 未新增公共 API；单选值和多选值继续由 `value` / `values` 与回调管理，`controller` 只承担跨树开关命令，避免重复状态源。
- `placement`、overlay 配置、自定义 trigger/panel 仍有独立职责，本次不删除既有公开能力；默认视觉变化不构成公开 API 签名 breaking change。
- 已复现的边界拉伸仿射滤镜与跨 Overlay Follower 几何分离已修复，结果见末节；非仿射 Impeller shader 路径与真机像素表现仍未验证，不能由当前测试推断通过。
- 向上展开、custom trigger、scrollable 与局部 Theme 属于 Flutter 扩展能力，不作为小程序公开矩阵的一对一视觉场景；组件聚焦测试继续覆盖这些路径。

普通滚动及方向翻转的严格断言通过，不等于边界拉伸问题已修复。不能通过加厚接缝、扩大容差，或静默禁用用户页面的拉伸效果来宣称修复。仿射滤镜问题已在第二阶段处理；Impeller shader 路径及真机像素表现仍未验证。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

<a id="controller-binding-validation"></a>

## 1.0.1 controller-binding 整组验收

本组包含 DropdownMenu、Form、PullDownRefresh、SwipeCell 和 Swiper 的绑定修复。公开 API 签名及默认值未变，不包含 API 别名或废弃迁移；生成 API 没有差异。各组件的绑定规则、异常类型及所有权保持兼容。

### 原独立候选

- 基线 develop `071efaba0111d868efe0b6a7ce55f6f784069a62`；候选 `58cb2736`，分支 `rss1102/fix/controller-binding-1.0.1`。
- macOS arm64；Flutter 3.32.0 / 3.47.7 stable，分别解析依赖并使用独立构建目录。每 SDK：8 个组件文件共 286 项、6 个 Example 文件共 37 项、调度器自测 30 项通过；严格 analyze 零诊断；API 检查 57 份及示例片段检查通过。
- 原候选的源码/测试指纹、依赖锁文件和日志摘要见[验证数据](evidence/1.0.1-independent.json)。原始日志、LCOV 和独立补丁位于工作区外层 `artifacts/pr1148-independent/02-controller-binding/`。以上是历史验证，不外推为当前提交的 CI 结果。

| 组件 | 两 SDK 原候选生产覆盖率 |
| --- | --- |
| DropdownMenu | 1014/1022 = 99.22% |
| Form | 384/389 = 98.71% |
| PullDownRefresh | 215/224 = 95.98% |
| SwipeCell | 304/315 = 96.51% |
| Swiper | 534/550 = 97.09% |

### 本次补充回归

以 PR #1191 `d14e7220` 为验证起点；仅新增 DropdownMenu 两项正式回归并整理 Spec/验收记录，生产实现和生成 API 未变。

- 后绑定菜单已打开时，旧组件卸载后，面板仍显示、openIndex 仍为 0，且关闭、重新打开命令正常。
- 后绑定菜单已打开时，旧组件更换 Controller 后同样保持上述行为；替换 Controller 保持关闭，不多发打开/关闭回调。
- 两项测试均在现有 manifest 已登记的 `test/components/dropdown_menu/t_dropdown_menu_test.dart` 内；本次不新增测试入口。
- 共享 Controller 时旧菜单更新 items 仍可能清空当前打开状态，单独跟踪 [Issue #1195](https://github.com/Tencent/tdesign-flutter/issues/1195)。本组仅保护旧组件卸载/换绑时的命令入口，不宣称完整的共享状态隔离。

### 本次验证结果

- Flutter 3.32.0 / 3.47.7 均在独立目录验证：8 个正式组件测试文件共 288 项通过（原 286 项 + 新增 2 项）；组件包严格 analyze 零诊断；五个组件生产覆盖率与上表一致，最低 95.98%，均通过 95% 门禁。
- 验证输入按排序路径/NUL/文件字节 SHA-256：`51e110dfdc32cca869a852bc1a0c7ba55269580b28a0725af270ba95d9d44c14`；相对验证起点的代码/测试二进制 diff SHA-256：`129a3f859886bc191bed8b00f19a0528273196ad1548638f2085a036a9d10fe9`。两 SDK 相关源码与测试逐文件一致，详细命令、环境、依赖锁文件及日志摘要见[本次验证数据](evidence/1.0.1-open-owner.json)。
- 测试命令为组件包中 `flutter test --no-pub --coverage --reporter expanded <8 个 manifest 文件>`，随后执行 `flutter analyze --no-pub --fatal-infos` 和五个组件的 `dart run tool/check_component_coverage.dart <组件>`。完整参数见验证数据；原始日志位于工作区外层 `artifacts/pr1148-independent/publication/pr1191-open-owner/`。
- 本轮没有重跑 Example、API/示例生成器或调度器自测；没有修改生产代码、生成产物、依赖声明及测试清单。原候选与远端 CI 结论分别记录，不伪装成本轮本地验证。

本次无绘制、布局、主题或资源改动，不更新 Golden；设备行为未验证。历史视觉/设备待办保留，不由本次功能回归核销。

Form 关闭断言后的绑定兼容性另有独立的[双版本 Web release 验证](../008-Input-Form/acceptance.md#form-web-release-validation)，不计入本节 288 项 Widget 回归；仅覆盖 Web release，不代表 Android/iOS 真机 release 已验证。

<a id="controller-api-doc-validation"></a>

### 五组件中文 API 注释与生成文档

本轮以 `b5842f05` 为起点，补充 Form、SwipeCell、Swiper、PullDownRefresh、DropdownMenu 的 controller 字段及 Controller 类注释，同步五份生成 API。字段说明推荐独立组件分别使用 Controller；类说明准确描述各自原有的拒绝或后绑定覆盖规则，不增加绑定限制或未来迁移计划。

- Form 明确同一 Controller 同时绑定多个表单时，断言开启会报错，断言关闭时保留后绑定覆盖；未把同一表单重建描述为重复绑定错误。
- SwipeCell / Swiper 分别保留 FlutterError / StateError；Refresh / DropdownMenu 说明后绑定覆盖、单目标命令及卸载不恢复旧绑定。DropdownMenu 不承诺共享状态完整隔离。
- Dart 分析器比较六个修改源码的非注释 token，与起点完全一致。实现、公开 API 签名、默认值、所有权及既有绑定规则不变；本轮不重跑组件或 Web release 实验，不将历史运行结果改记为新 head 的运行结果。
- 本地站点 Form API 页已实际预览，推荐用法和类说明正常显示；原始截图与过程保存在工作区外层 `artifacts/pr1191-api-docs-local/`。

- Flutter 3.32.0 / 3.47.7 在独立目录分别生成并检查 57 份 API，两版本全部产物逐字一致；相对起点仅五份目标 API 文档变化。
- 每 SDK：字体覆盖及相关工具测试 14 项通过，组件包严格 analyze 零诊断；未修改字体清单或资源。命令包括 `node tool/generate_api.mjs`、`node tool/generate_api.mjs --check`、`flutter test --no-pub test/tool/run_visual_regression_test.dart --reporter expanded`、`flutter analyze --no-pub --fatal-infos`，均使用对应 SDK。
- 六份源码及五份生成 API 的路径/NUL/字节 SHA-256 为 `799e3947381c0fd1747aaafd582dda9d3d78bf6eff716040b39d87b6b193ce2f`。环境、依赖锁文件、命令、token 对比与日志摘要见[验证数据](evidence/1.0.1-controller-api-docs.json)；原始日志保存在工作区外层 `artifacts/pr1148-independent/publication/pr1191-controller-api-docs/`。
