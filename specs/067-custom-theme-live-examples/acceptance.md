# 本地验收

- custom-theme指南以flutterExample:custom-theme接入plugin-tdoc/component.vue的共享组件预览结构：td-doc-main + DEMO正文 + td-doc-phone + 同一iframe样式及说明。未复制手机容器CSS；普通组件标签与API分支保留。
- 已移除正文三个独立iframe，保留三个场景独立预览链接。统一custom-theme路由使用ExamplePage分组展示JSON配置、局部样式、明暗模式，复用原DocumentationThemeDemo及文档函数。
- Flutter3.32.0：Theme文件11项非Golden测试通过，包含原有主题行为、三个独立路由、统一路由页面结构、三个场景同时展示、局部样式隔离与明暗/系统切换；相关源码与测试静态分析无问题。
- npm run site --prefix tdesign-site：主题6项、文档24项通过，57组件/360示例映射通过，生产构建通过。保留原有构建警告。
- 文档同步--check和git diff --check通过。
- Flutter19005热重启、站点19004强制重启完成。解析custom-theme.md?import确认flutterExample指向统一路由、保持非组件指南且正文无iframe；编译的共享Vue模块保留手机与主容器。指南、Flutter代理、main.dart.js均HTTP200。
- 预览：http://localhost:19004/flutter/custom-theme。未执行实际浏览器像素/窄屏人工验收、高版本Flutter或Release构建；未运行/更新Golden。
- 仅本地修改，未暂存、提交、推送或更新PR；不改CI、版本、CHANGELOG。

## 交付状态更新

用户已授权将本地改动提交、推送到PR1163，并以推送后的提交进行全局Review；上文“仅本地/不推送”为此前实施阶段的历史记录，不再是本次交付限制。合并放行以当前提交的CI、Review及适用视觉验收为准。
