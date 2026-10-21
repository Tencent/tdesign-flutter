# 方案

从 develop 验证基线 d0de29e8 建立独立本地副本 button-navbar-text-slots-clean，分支 rss1102/breaking/button-navbar-text-defaults。只提取 Button/NavBar 实现、原登记测试、两份必要测试辅助文件及 Spec082；不复制此前其他组件源码、Spec081、CI 清单或工具链改动。原两份工作副本保持不动。

Button 在 child 内部 Builder 读取主题恢复或自绘 Material 之后的实际 DefaultTextStyle，再接入既有 scope，复用最终状态/动画样式。NavBar 用 scope 提供已有标题样式并保留单行省略。TText 核心只改 dartdoc，不改任何可执行逻辑；共享解析器/scope 不改。

文档统一“正文默认、组件默认、显式覆盖”，公开入口为 TText/TTextThemeData、Button.child、NavBar.title 的 dartdoc 及站点自定义主题说明；Spec migration 记录默认行为 breaking 影响与已有接口迁移。正式 API 生成器同步 text/theme/button/navbar 产物。

独立干净源码重新运行双版本功能、覆盖率、Demo、文字契约及严格分析；Linux3.32原Button/NavBar Golden不更新。旧前后图只有在两组件可执行源码与字体/环境一致时复用，不能沿用含Dialog修复的整分支验收结论。
