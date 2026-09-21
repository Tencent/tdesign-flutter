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
- 无新增 Demo 专用公共 API。

## 视觉证据

- `evidence/design/`：28 个完整 Demo 的 Figma／develop 差异／current 差异／当前实现比较图。
- `evidence/golden/`：全部变更 Golden 的 develop／精确红色差异／当前基线比较图。
- `evidence/golden/manifest.tsv`：状态、尺寸、差异像素数、比例、最大通道差和比较图路径。

## 风险控制

- 共享 Token：审查全部连带 Golden，而不是只看目标页面。
- 共享 `TCell`：单独核对 Calendar、SwipeCell 与 Cascader 的布局变化。
- Breaking API：生成 API 文档、仓库全量编译与双版本回归共同验证调用点迁移。
- 平台栅格差异：Figma 比较用于设计人工审查；仓库 Golden 只在 Linux Flutter 3.32.0 写回。
