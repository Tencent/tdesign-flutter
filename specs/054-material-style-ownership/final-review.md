> 2026-10-13 严格边界的最新本地实现、验证与 review 见 [strict-boundary.md](./strict-boundary.md)。本页保留此前阶段记录，不代替新边界验收。

# 最终 Review 与交付（2026-10-13）

用户授权：对 PR #1157 的全部本地改动进行最终 Review，无阻断问题后提交、推送并更新 PR 标题和描述。此前记录中的“仅本地、未推送”描述对应当时的历史状态，不再作为本轮交付限制。

审查范围为 `faab46b2` 至 `93c1d747` 加全部本地修正；原工作区的用户修改未纳入。完整组件与共享文字、图标、原生适配层已逐项复核：

- TD 内置视觉仅接受受支持的实例 style、TD ThemeExtension、Token；外部 Material 组件视觉主题不作为覆盖入口。
- 自定义内容恢复原 Theme，保留已公开的插槽默认值；Button layer builder 在挂载后恢复主题，普通 Material 内容不再注入 TD 图标颜色/尺寸。
- 原生选择、编辑、键盘、焦点、语义和 Tooltip 行为保留；反馈与 mouseCursor 按状态回退，实例配置优先。
- Button/IconButton 的状态属性空值回退 TD 默认，显式透明/无边框仍有效；渐变背景有意空值不误回退。
- 渐变 outline/ghost 四档宽高与普通按钮一致；显式约束、状态边框、内容位置、缩放与点击区保持。Cell 必填标记与 Divider 字体隔离遗漏已修复。
- Radio 测试字体通过 TD Token 注册，四张错误基线已修复；未重新开放 Material 字体继承。

最终结论：本次约定边界内未发现剩余阻断问题。外部 Material 视觉覆盖能力移除仍为预期 breaking；并不删除原生能力或调用方自定义内容主题。不宣称所有平台/设计稿逐像素一致。

## 验证证据

生产 lib 指纹 `bd1ed0db713833c49201d8dbde70b32a0bba3ea5078828f6375196688707a59d` 与 Flutter 3.32.0、3.47.7 和 Linux 验证副本一致。没有在纯最终 Review 中重复运行相同检查：

- 双版本各 57 组 / 2876 项组件回归、365 项 Demo 回归通过；生产覆盖率最低 95.55%，Button 99.58%；组件和 Demo 严格 analyze 零诊断。
- Linux 全量 Golden 75 个登记入口 / 74 个独立套件 / 672 项通过；Radio 字体修复后另以无更新参数复跑四项，其余未受影响套件复用同源码/环境/命令结果。比较容差未修改。
- Radio 最终双版本补跑各 56 项组件/共享边界与 7 项 Demo/字体回归，Demo analyze 零诊断；示例片段 --check 通过。
- 当前 613 张运行基线：最终 Radio 修正仅改变四张，其余 609 张不变。相对原始 PR base 的主体/尺寸变化已逐组件比较，Radio 修正后四图再次逐项检查。
- 文档/生成 API 对应最终能力边界；无新增公开 API、无新 CI 清单遗漏。`git diff --check` 通过。

详细证据：[边界修正](./local-adjustment.md)、[渐变几何](./gradient-geometry.md)、[Radio 字体](./radio-golden-fonts.md)。前两轮已成功的构建结果属于此前源码，最终提交的远端 CI 需独立读取，不将旧 head CI 当成新 head 已通过。
