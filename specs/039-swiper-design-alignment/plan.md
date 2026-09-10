# 实施方案

1. 冻结 Flutter develop、移动端相邻设计节点和小程序公开 Demo/源码版本，记录六个公开条目及交互。
2. 修正组件运动参数继承、默认圆角、导航视觉、卡片效果和 Theme nullable 插值。
3. 重写公开 Demo，使每个代码面板直接包含关键 TSwiper 配置和交互状态。
4. 补充组件根因测试与 Demo 结构/操作测试，登记统一回归清单。
5. 功能确认后生成浅色/深色 Golden，再执行覆盖率、双版本 analyze 和 Web 操作验收。
6. 单提交、独立 PR，并只更新 GitHub Issue #1027 正文中的 Swiper 项。

## 风险控制

- `animationDuration` 保持现有默认值；新增可选 API 不构成 breaking change。
- 删除 `TSwiperThemeData.pagination/pageEffect/paginationPlacement` 属于 breaking change；更新日志明确迁移到 `TSwiper` 同名实例参数，不保留会继续制造第二状态源的兼容别名。
- Controller 单次显式参数优先，避免组件配置改变已有显式调用。
- 固定 Linux Flutter 3.32.0 生成 Golden，latest 不写回像素基线。
- Flutter latest 若自动改写分析配置，验证后恢复，不带入 PR。
