# v1.0 分批 PR 迁移方案

> 目标：将当前 v1 重构成果按可 review、可验证、低回滚成本的方式分批提交到 `tdesign-flutter` 主仓。

## 总体拆分原则

- **小步可验收**：每个 PR 控制在一个组件域，或 2-4 个低复杂组件。
- **依赖先行**：先合基础规则、Theme/Token、底层 base 组件，再合依赖它们的复杂组件。
- **文档随源码**：组件源码、测试、Dartdoc 注释、生成 API 文档、v1 组件文档必须同 PR 更新。
- **不带历史包袱**：不恢复已清理旧 API，例如旧 enum、旧 wrapper、`bool draggable/magnet` 等兼容写法。
- **tools 独立演进**：`tdesign-flutter-tools` 的解析能力、validate 配置和测试独立 PR；v1 仓库只提交生成结果和源码注释。

## 推荐 PR 阶段

### PR 0：重构基础设施与验收约束

**目标**：先让主仓接受 v1 重构的工作方式和验收口径。

**范围**

- v1 文档目录结构和迁移说明
- API 注释规范和 tools 生成规则
- 组件验收 checklist
- 测试覆盖率门槛和本地验证命令
- CI/脚本的最小必要调整

**不包含**

- 大量组件源码
- 旧 API 兼容层
- 与 tools 仓库自身实现相关的重构

**验收**

- 文档链接完整
- analyze/test/doc-generation 指令可执行
- review 方能明确后续 PR 的通过标准

### PR 1：Foundation / Theme / Token 基础能力

**目标**：合入后续组件共享的底层能力，避免每个组件复制 Theme merge 逻辑。

**范围**

- `TThemeData`
- 基础 token
- ThemeExtension 约定
- `t_component_theme_data.dart` 组件 ThemeData 专用导出入口
- `TThemeBuilder` 默认注入所需的组件 `T{Xxx}ThemeData` 纯定义
- 颜色、字号、圆角、间距等 resolve 基础机制
- foundation 文档

**边界**

- `TThemeBuilder` 不反向 import `tdesign_flutter.dart` 总出口，避免 Foundation PR 拉入完整组件实现。
- 组件 `T{Xxx}ThemeData` 可先随 PR 1 迁移，作为全局 Theme 承载定义。
- 组件 widget、resolve 行为、API 清理和 Theme 消费测试在后续组件 PR 中完成。

**验收**

- foundation 定向 analyze/test 通过
- Theme 优先级 P0-P4 行为清晰
- `TThemeBuilder.light/dark` 可构建 M3 `ThemeData` 并注入当前组件 ThemeData 默认定义
- `TThemeBuilder` 仅依赖 Foundation 与组件 ThemeData 专用 barrel，不依赖包总出口
- 无组件级临时兼容写法

### PR 2：01-base 第一批：低交互基础组件

**建议组件**

- `text`
- `divider`
- `icon`

**目标**：用低交互组件验证 v1 API、Dartdoc 注释、tools 生成和测试覆盖率路线。

**验收重点**

- API 表不出现本组件公开参数的 `说明 = -`
- 组件定向覆盖率稳定达标
- docs 与生成 API 同步
- 不引入旧版兼容 API

### PR 3：01-base 第二批：交互基础组件

**建议组件**

- `button`
- `link`

**目标**：合入后续组件最常依赖的交互基础能力。

**验收重点**

- disabled 语义清晰
- instance/theme/default/token 优先级稳定
- P0 `style` 覆盖路径明确
- icon/child 组合和语义标签可测
- widget 测试覆盖关键交互路径，而不只是构建成功

### PR 4：01-base 第三批：FAB

**建议组件**

- `fab`

**目标**：单独合入 FAB，降低组合组件 review 成本。

**原因**

FAB 同时包含定位层、拖拽、吸附、边界、child 模式和内嵌 `TButton` 透传，复杂度明显高于 `divider/icon/text`。

**验收重点**

- `draggable` 使用 `TFabDragAxis?`，不回退到 `bool | TFabDragAxis`
- `magnet` 使用 `TFabMagnet?`，不回退到 `bool | TFabMagnet`
- 不恢复 `TFabTheme`、`TFabShape`、`TFabSize` 等历史 API
- `onDragStart` / `onDragEnd` 回调真实触发
- 拖拽边界按实际 FAB 尺寸计算
- props 更新后拖拽位置同步或 clamp
- API 文档 validate 达到 `ERROR=0, WARN=0`

### PR 5：Overlay / Popup 基础设施

**目标**：先合入弹层路由、定位和生命周期基础能力。

**依赖裁决**

- `drawer` 已直接依赖 `TPopup`，因此 Popup 必须早于包含 Drawer 的 Navigation PR。
- Feedback 业务壳与 Popup 基础设施分开，避免 Toast、Dialog、Popover 的 API review 混入路由底层。
- picker / dropdown 等复杂组件若依赖 Popup，也只能在本 PR 之后迁移。

**建议范围**

- popup route / handle / options / layout
- overlay tracking 与安全区行为

**验收重点**

- 层级、重复打开和关闭生命周期清晰
- 点击外部关闭、返回键、嵌套 Navigator、无障碍行为可测
- `TPopupOptions` 与 `TPopupThemeData` 的职责边界稳定

### PR 6：03-input / Form 基础能力

**目标**：迁移输入类组件前，先稳定受控/非受控、禁用、只读和表单联动模型。

**建议拆分**

- input 基础
- textarea
- radio / checkbox / switch
- form / form-field

**验收重点**

- value/defaultValue 口径一致
- disabled/readOnly 优先级一致
- 表单校验状态和组件状态不互相覆盖
- 不把业务组件逻辑提前塞进基础输入 PR

### PR 7：Feedback 业务组件

**目标**：在 Popup 基础能力稳定后迁移反馈类业务组件。

**建议范围**

- toast / message / dialog / popover
- action-sheet / notice-bar / loading / refresh / swipe-cell

**验收重点**

- ThemeExtension 只承载视觉和布局默认值
- 命令式句柄、自动关闭、timer/controller 生命周期可测
- 不保留旧静态入口、弱类型回调或业务状态 Theme 字段

### PR 8：Display / Navigation 中低风险组件

**建议拆分**

- display：`avatar`、`badge`、`tag`、`loading`、`empty`
- navigation：`tabs`、`navbar`、`steps`

**验收重点**

- 组件间依赖稳定
- 文档和生成 API 同步
- 覆盖率不因视觉组件较多而只保留构建测试

### PR 9+：复杂业务组件按依赖链单独推进

**建议组件**

- picker
- date-picker
- dropdown
- select
- table
- upload

**建议方式**

复杂组件优先单独 PR。必要时拆成：

1. 基础能力 PR
2. 组件源码 PR
3. demo/docs 收口 PR

### Final PR：收口与全量验收

**目标**：清理临时桥接、统一 export、补齐索引和 CI 门禁。

**范围**

- public exports
- 示例入口
- 文档索引
- 全量 analyze/test/docs validate
- 删除迁移期临时文件或过渡逻辑

**不建议包含**

- 大规模业务逻辑重写
- 新组件迁移
- 与验收无关的重构

## 单个 PR 的 Definition of Done

每个组件 PR 合入前至少满足：

- `flutter analyze` 定向范围 0 issues
- `flutter test` 定向范围全部通过
- 组件源码总覆盖率达到既定门槛，01-base 当前按总行覆盖率 `>= 95%`
- API Dartdoc 注释可被 tools 解析
- 生成 API 文档已更新
- v1 组件文档和源码 API 口径一致
- 无旧 API 兼容层、无未说明的行为差异
