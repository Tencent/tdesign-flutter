# Form 验证范围与结论

<a id="record-008-input-contract-alignment"></a>
<a id="record-039-design-details"></a>

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| Form 与 Input 职责及 API 对齐 | `044122f61d78ce1c122b8f66b38742b13554dcf4`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |
| Form 受控状态、主题与 Demo 设计细节对齐 | `33fbe96d`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

### 原记录明确描述的设备范围

- [x] iPhone 16 模拟器运行移动端集成测试并采集水平、竖向和禁用态截图

- [x] Android 16 真机（1220 × 2656）安装并运行最终源码，水平、竖向、禁用态和提交成功集成流程通过

这些是原记录对应候选的操作描述，不外推到其他设备或当前 head。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 1.0.1 controller-binding 验收

- 保留重复绑定的 assert 和发布模式行为；替换失败后原 Controller 保持绑定，卸载按实际绑定对象清理。
- 本组公开 API 签名及默认值未变，不包含 API 别名或废弃迁移。
- 原独立候选 `58cb2736`：Flutter 3.32.0 / 3.47.7 的本组件生产覆盖率均为 384/389 = 98.71%；原始结果见[验证数据](../001-Feedback-DropdownMenu/evidence/1.0.1-independent.json)。
- 整组验证环境、命令、指纹及本次补充回归结果统一记录在 [DropdownMenu 验收记录](../001-Feedback-DropdownMenu/acceptance.md#controller-binding-validation)，不以原候选结果替代新候选验证。

<a id="form-web-release-validation"></a>

### Form Web release 双版本兼容验证（2026-10-23）

- 验证候选 `4b602f62`，修复前 Form 来源为 PR 基线 `02282342`（与原独立基线 `071efaba` 的 Form 源码一致）。每个 SDK 固定宿主、其余组件源码和依赖，仅替换 `t_form.dart`，分别运行修复前后实现。
- macOS arm64；Flutter 3.32.0 / 3.47.7，各自执行修复前后两个真实 `flutter build web --release` 构建，共 4 个构建，并在独立 headless Chrome 会话运行。宿主确认 `kReleaseMode == true`、断言关闭，校验使用普通条件检查，不依赖 assert 或 flutter_test。
- 每个构建完成 28 个绑定状态检查点、215 项校验，无 Flutter 框架错误；修复前后及两 SDK 的结果逐项一致。
- 场景包括初始重复绑定、替换为已占用 Controller、相同对象重复配置、有效替换、Controller 与 null 切换、旧绑定者/当前绑定者卸载、显式重新绑定及两个表单同帧交换 Controller。各检查点核对字段值、validate/submit 结果与真实 onSubmit 目标，并检查外部错误、清除和 reset 命令。
- release 下保留后绑定覆盖行为，不新增重复绑定异常；当前绑定者卸载后不自动恢复旧绑定。结论仅覆盖本次所测场景，不将其解释为新绑定契约。
- [验证数据](evidence/1.0.1-web-release.json)记录源码与宿主指纹、依赖锁文件摘要、四次运行的结果摘要及 28 个状态检查点。宿主源码、运行脚本、构建/浏览器日志与完整结果保存在工作区外层 `artifacts/pr1191-form-release/`。
- **仅验证 Web release，不外推 Android/iOS 真机 release。** 移动端构建通过不能代替真机运行；本页上方历史移动设备记录不属于本次验证。此项是独立的本地 release 实验，不计入 288 项 Widget 回归数量，也不表示已有对应 CI 执行入口。

本次只补充验证记录，生产实现、公开 API、默认行为、绑定规则、正式测试及生成 API 均未修改；复用上述相同源码的已有测试结果。

中文 API 注释及生成文档已补充推荐用法与原有绑定规则；本轮文档、字体覆盖及静态分析结果见[整组验收](../001-Feedback-DropdownMenu/acceptance.md#controller-api-doc-validation)，不改变实现或既有绑定限制。
