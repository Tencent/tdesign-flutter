# 技术方案

## 分层修复

1. Demo 层只调整公开分组、实例、文案、状态和外部布局。
2. 组件层修复默认绘制、布局、交互和公开 API，不在 Demo 添加补丁。
3. Token 层只修改已由设计稿和其他移动端共同确认的共享灰阶。
4. 组件与 Demo 功能稳定后，在 CI 匹配的 Linux Flutter 3.32.0 环境更新 Golden，并无更新参数复跑。

## API 影响

- Breaking：`TProgress(variant: ...)` 收敛为六个命名构造函数。
- Breaking：`TFooter.logo` 不再吞掉非空 `text`，品牌页脚可以组合展示文案和品牌内容。
- 默认行为变化：`TSwiperPageEffect.scale` 与 `scaleAndFade` 按设计稿等比缩放和露出相邻卡片。
- 默认布局变化：`TCell.note` 使用受约束自然宽度；`TCheckbox` 根据真实行数切换垂直对齐。
- 新增：`TSlider.variant` / `TRangeSlider.variant` 以 `normal` 和 `capsule` 表达公开结构形态；默认为 `normal`，不改变旧调用行为。胶囊轨道的内缩、游标和刻度由组件统一绘制，不是 Demo 专用 API。
- 默认样式修复：`TButton` 图标插槽将已解析的图标色传给其中的 `TLoading`；显式 `TLoadingThemeData.iconColor` 仍保持最高优先级，独立 `TLoading` 默认色不变。
- Demo 边界修复：Input 必填标记的右侧配置移入 `InputBasicExample`，使运行页面与“查看代码”具有相同的主题上下文。
- Tag 修复不新增或修改公开 API；默认行盒、描边外框、图标尺寸与语义色按既有枚举和 Theme 契约纠正，不属于 breaking change。

## 视觉证据

- `evidence/design/`：28 个完整 Demo 的 Figma／develop 配准差异／current 配准差异／current 配准渲染／current 原始渲染五栏比较图。
- `evidence/golden/`：全部变更 Golden 的 develop／精确红色差异／当前基线比较图。
- `evidence/golden/manifest.tsv`：状态、尺寸、差异像素数、比例、最大通道差和比较图路径。

## 风险控制

- 共享 Token：审查全部连带 Golden，而不是只看目标页面。
- 共享 `TCell`：单独核对 Calendar、SwipeCell 与 Cascader 的布局变化。
- Breaking API：生成 API 文档、仓库全量编译与双版本回归共同验证调用点迁移。
- 平台栅格差异：Figma 比较用于设计人工审查；仓库 Golden 只在 Linux Flutter 3.32.0 写回。

## Demo 框架收敛

1. 删除仓库中没有调用点的 `showSingleChild` / `singleChild` 分支，以及 `ExampleModule` 未使用的 `Key?` 参数。
2. 将 `compactContentSpacing` 与 `compactSurface` 合并为不可变的 `CompactExampleStyle`；通过命名构造函数表达容器表面，避免继续向 `ExampleItem` 平铺紧凑模式布尔字段。
3. `CompactDemoSurface` 改为页面壳私有实现，公开示例只能声明布局意图，不能直接依赖或复制页面背景实现。
4. 将实际作为普通示例项 `margin` 使用的 `ExamplePage.padding` 更名为 `itemMargin`，调用值和渲染层级保持不变。
5. 不在本轮迁移历史 `test/showTestModule`、代码映射或 Scaffold 透传参数；这些字段涉及生成清单与调试入口，须另行证明可删除或合并，避免借重构扩大行为范围。

### 重构验证

- 重构前后对全部 Golden PNG 计算内容哈希，要求完全一致。
- 在 Linux amd64 Flutter 3.32.0 中只运行无更新参数的完整视觉回归；出现差异时先定位布局回归，只有设计证据证明旧基线错误才进入独立视觉修复，不在重构中接受新图。
- Flutter 3.32.0 与 latest 执行 Demo 结构、功能、生成示例和严格 analyze。

## Tag 行盒与边框槽位修复

1. 先按设计稿修正 Tag Demo 的导航栏标题、说明标点，以及“圆弧标签”同一行的三个形态实例；Demo 只负责实例组合和 16px 外部间距。
2. 所有变体统一绘制 1px 边框：outline 使用语义边框色，填充变体使用透明色；内容 padding 不再按 variant 扣减。
3. 单行标签以字体 Token 的行高和当前 `TextScaler` 建立固定行盒，使用均分 leading 的原生文本布局，不增加平台或字体专属位移。
4. 组件高度由缩放后的行高、内容 padding 与两侧边框计算；图标尺寸、图文间距和关闭图标颜色按尺寸与语义 Token 解析。
5. 先以组件测试锁定尺寸、变体、字体缩放和图标契约，再在 Linux Flutter 3.32.0 更新并复跑 Tag Demo Golden；Flutter 3.32.0 与 latest 均执行非视觉测试和严格 analyze。
