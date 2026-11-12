# DropdownMenu 实施方案

<a id="record-001-anchored-overlay"></a>
<a id="record-011-official-demos"></a>

## 实现组织

保留 OverlayEntry 与锚定跟随架构，而不在 Demo 修正位置；实际几何与生命周期必须由组件负责。

自动 placement 使用滞后与重新测量，接受实现复杂度以避免临界视口反复跳向。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/dropdown_menu](../../../tdesign-component/lib/src/components/dropdown_menu) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/dropdown_menu](../../../tdesign-component/test/components/dropdown_menu) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

前期文档整理未执行上述实现或候选验收，不据旧命令流水推定当前检查通过；本轮共享 Controller 修复的执行范围按末节与 acceptance.md 记录。


## 1.0.1 controller-binding

仅修改本分支所属组件生产实现及已登记回归文件，保留既有 API、默认行为及 Controller 绑定规则。直接基于最新 develop 独立验证，不依赖其他修复分支。按实际 CI manifest 执行相关组件、示例非视觉测试及调度器自测；双 SDK 分别解析依赖、严格 analyze、生产覆盖率检查和生成器一致性检查。API 别名、废弃声明等 PR 5 内容不纳入。


## 共享 Controller 状态与回调隔离（#1195 / #1203）

在 #1203 的 owner 写保护上补齐请求入口和异步恢复检查，改动限于 DropdownMenu 私有状态机；保留关闭时的本地资源清理，将共享状态/业务回调/焦点副作用与之分开。didUpdateWidget 的 post-frame 回调执行时复核 owner，不仅在安排回调时检查。

回归加入既有 manifest 已登记的 t_dropdown_menu_test.dart，复用已有 item helper，不新增独立 CI 测试入口。分别验证旧 trigger、打开与关闭动画换绑、items 禁用/删除及新 owner 关闭重开，并执行整个 dropdown_menu 组件套件和生产覆盖率检查。双 SDK 分别解析依赖，运行严格分析，保留独立锁文件和 LCOV。

本事项不改变 API、公开 Demo、主题、绘制或资源；不生成或更新 Golden，也不添加 specs 图片。验收证据使用文字和 JSON；本地追加补丁以已拉取的 PR head 为基线，远端合并和 CI 另行核对。
