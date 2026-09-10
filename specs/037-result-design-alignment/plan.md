# 实施方案

## 技术方案

- 将结果业务状态收敛到 `TResultStatus` / `status`，删除同义 variant 入口。
- 将辅助文案收敛为 `description`，保持字符串契约，不为当前设计额外扩张 Widget slot API。
- 默认状态图标继续使用 TDesign outline 图标，尺寸调整为 80px；自定义 icon 保持调用者所有权。
- 标题改用 `fontTitleMedium`，描述改用 `fontBodyMedium`，相邻内容间距取 `spacer12`。
- 扩展 `TResultThemeData` 的 `iconSize` 与 `descriptionStyle`，补齐 copyWith/lerp 和运行时验证。
- 页面示例由 Demo 通过 `Navigator` 组合 `TResult` 与 `TButton`，不把页面跳转能力放入组件。

## 影响范围

| 范围 | 影响 |
| --- | --- |
| 组件 | 状态和描述 API 重命名，修正默认尺寸、字体、间距及语义 |
| Theme | 新增 iconSize、descriptionStyle 视觉覆盖 |
| Demo | 重建设计稿示例矩阵并增加页面示例操作 |
| 测试 | 组件、Demo、Golden、覆盖率和集中回归登记 |

## API 收敛

| API | 状态源与语义 | 结论 |
| --- | --- | --- |
| `status` | 唯一结果业务状态，决定默认图标、颜色和语义 | 保留 |
| `icon` | 完整自定义视觉内容，覆盖默认状态图标 | 保留 |
| `title` | 主要结果文本 | 保留 |
| `description` | 辅助描述文本 | 保留 |
| Theme style/iconSize | 子树视觉默认，不选择业务状态 | 保留 |
| callback/controller | 静态内容无需内部交互状态 | 不新增 |

## 风险与取舍

- API 重命名属于 breaking change，但避免长期保留两个同义状态源和描述入口。
- 自定义结果复用仓库已有 illustration 资源，不新增远程图片依赖。
- 页面示例属于 Demo 编排；组件保持声明式静态 Widget。

## 验证策略

- 组件测试验证公开参数、默认图标和尺寸、token/Theme 优先级、语义与空值布局。
- Demo 测试逐项验证公开矩阵，并真实点击进入/返回页面示例。
- 功能合理后生成固定 Linux Golden，并立即无更新复验。
- 双版本执行功能测试和严格 analyze，最后运行 Web Demo 完成页面示例往返操作。
