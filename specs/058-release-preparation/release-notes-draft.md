# 1.0.0 发布说明草稿

仅供最终 release PR 整理；不替代自动生成的 CHANGELOG，目标版本尚未发布。

## Breaking Changes

- 最低环境调整为 Flutter 3.32.0、Dart 3.8.0。组件统一迁移至 T 前缀，删除旧参数/样式/辅助类型的兼容入口；按 [0.2.7 → 1.0 迁移指南](../../tdesign-site/site/docs/migration-0.2.7-to-1.0.md) 迁移，不能批量替换前缀后直接上线。
- 全局 Token、TD 组件 Theme 与显式实例配置分层；TD 默认视觉不再反向读取外部 Material/M2/M3 配置。文字使用 style/textScaler 与显式布局，自定义内容仍保留自己的主题及原生编辑能力。
- 表单改为声明式字段树，选择与输入组件按当前受控值契约回写；父级创建的 Controller 按其类型负责释放。
- Picker/DateTimePicker/Calendar 的选择与业务确认分开；Popup 采用 Options/Handle，Dialog 使用内容槽与 Action，底部导航和顶部页签分别为 TTabBar 与 TTabsBar。
- Swiper 使用独立控制器和分页配置；Upload 使用不可变 files/onChanged 与明确的数量/大小限制。Toast/Message 时长使用 Duration，持续加载须显式设置 Duration.zero。
- 多组件主题字段、默认尺寸、字体行盒、状态色与安全区行为调整；无等价替代的删除能力在迁移指南中单列，不承诺旧视觉和全部旧控制入口保留。

## 用户可见改进

- 统一 TD/Material 导出入口与主题配置方式，提供迁移说明及可验证的新调用示例。
- 修复输入、日期选择、异步文件选择及内置文字排版等已纳入 1.0 候选的回归，具体范围由最终 release PR 的更新日志生成。
- 放宽相册插件依赖约束，允许业务按 SDK 解析兼容版本，减少精确版本依赖冲突。

## 发布前仍需确认

最终候选的真实设备、设计对照和残余 Review 记录尚需核销；本轮排除的 CI/发布流程问题仍另行跟进。正式 pub.dev 包、站点和 APK 交付后的消费/下载验证也必须执行。不得把本草稿视为已经可以发布的声明。

## 后续修复补充

- fix(button): 修复默认幽灵按钮的文字与描边未跟随自定义反色主题的问题；禁用样式与实例状态样式优先级保持原约定。

- fix(theme): 修复稀疏自定义深色JSON未配置的背景、文字与引用回退为浅色Token的问题（已随PR1166合入；见[Spec068](../068-custom-theme-dark-mode/acceptance.md)及主题回归测试）。

该草稿不代替自动生成的CHANGELOG。其他运行差异仍以Spec060逐项方案及待验收状态为准。
