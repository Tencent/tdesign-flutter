# TDesign Flutter 仓库协作约定

本文件定义 `tdesign-flutter` 仓库的协作规范，供所有在本仓库工作的 AI 助手（NPC）参考。执行涉及分支 / PR / 组件改动的任务时，请先遵循以下约定。

## 一、分支与 PR 规范

在创建 PR / 分支时，必须严格遵守以下分支命名约定：

- 格式：`<cnb.username/>/<types>/<功能需求>`
  - `<cnb.username/>`：当前操作者的 CNB 用户名（不要猜测，通过环境变量或平台信息获取）。
  - `<types>`：改动类型，从以下取值中选择一个最贴切的：
    - `feat`：新特性 / 新组件
    - `fix`：缺陷修复
    - `docs`：文档改进
    - `refactor`：重构（不改变行为）
    - `chore`：构建、工具、依赖等杂项
    - `ci`：CI/CD 相关改动
    - `test`：测试用例
    - `style`：样式 / 交互改进
    - `release`：版本发布
  - `<功能需求>`：用简短、小写、以连字符分隔的英文短语描述本次改动要解决的功能需求。
- 示例：`rss1102/feat/add-badge-component`、`alice/fix/button-overflow`
- PR 标题遵循 Conventional Commits 格式：`type(scope): 修改描述`，scope 可填写组件、文档或 CI 模块，例如 `fix(TButton): 修复按钮溢出问题`。
- 在创建分支、提交 PR 前，先复核分支名是否符合上述规范。

## 二、Flutter 版本双兼容

`tdesign-flutter` 需要同时兼容 `flutter@3.32.0` 与 `flutter@latest`（stable 通道最新版）。当前项目通过 CI（`.github/workflows/test-build.yml`）分别对两个版本执行构建。

- `flutter@3.32.0`：项目基线版本，`pubspec.yaml` 中声明 `flutter: ">=3.32.0"`，`.fvmrc` 固定为 3.32.0。
- `flutter@latest`：stable 通道最新版本，用于前瞻性兼容。

在分析或修改代码时，必须同时考虑两个版本的差异：

1. 检查使用的 Flutter / Dart API 在 3.32.0 与 latest 中是否都存在且行为一致。
2. 注意可能被弃用（deprecated）或行为变更的 API，避免在 low 版本不可用、high 版本已移除。
3. 若引入新依赖或新 API，需确认其最低要求不超过 3.32.0，且不破坏 latest 构建。
4. 结论中请明确标注改动对 `flutter@3.32.0` 与 `flutter@latest` 各自的兼容性影响。

## 三、组件变更的 breaking change 分析

当考虑组件（TDesign 组件，如 TButton、TInput 等）的修改时，必须分析是否会造成 breaking change：

1. 判断该改动是否改变现有公开 API 的签名、默认行为或删除已有能力。
2. 新增参数：若仅新增可选参数且不改变既有行为，通常不算 breaking；若新增必填参数或改变默认值则需谨慎。
3. 删除 / 重命名 / 更改参数类型、回调签名、枚举取值：均属于 breaking change，需重点提示。
4. 组件样式 / 布局默认值变化：可能影响既有页面视觉表现，应作为潜在 breaking change 提醒。
5. 涉及公共 API 变更或组件重构时，按仓库规范应创建对应的 Spec（`specs/<编号>-<短名称>/`）。
6. 输出时明确给出结论：是 / 否 breaking change，影响范围、受影响的 API，以及建议的迁移或兼容策略。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 涉及代码时给出可复制的最小示例。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对上述规范再动手。
