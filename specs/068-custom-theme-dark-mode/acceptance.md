# 本地验收

- 根因1：三个DocumentationThemeDemo各自使用默认light的MaterialApp，模式仅更新一个场景。已改为统一入口只有一个MaterialApp，ExamplePage及三个无应用壳场景共享同一状态。单独场景仍保留应用壳。
- 根因2：fromJson私有解析链的_emptyData始终绑定默认浅色factory，稀疏深色块只有brandColor变化。已将深色解析的color/ref/font/fontMetric/radius/fontFamily/shadow/insetShadow/spacer回退选择为默认深色；公开签名未变，原无暗色块回退和显式ref优先规则保留。此为错误回退的修复，存在稀疏暗色块的运行外观会改变，不是API移除或重命名。
- 文档说明同一tokens包含浅深两套配置，light/dark构建分别选择；示例显示当前模式、当前外观及ocean/oceanDark名称，初始跟随外层外观，显式system跟随系统。全页背景、三个场景容器与文字一起切换。
- Flutter3.32.0与隔离副本3.47.7：各51项组件主题测试+23项Demo/Web主题消息非Golden测试通过；两版本相关源码和测试分析均无问题。回归包含背景与文字实际Token值、不同模式映射、原有无暗色块行为、全部场景同步更新和局部样式隔离。
- 高版本首次运行遇到用户配置目录不可写及旧副本package_config失效；用临时XDG_CONFIG_HOME及隔离副本离线pub get修复环境后重新运行通过，未改主检出依赖。
- Theme API由正式生成器单独重新生成，差异仅增加fromJson回退说明。同步检查、差异空白检查通过。
- 站点主题6项、文档24项与57组件/360示例映射通过，生产构建通过；保留既有构建警告。
- Flutter19005热重启及站点19004强制重启完成。实际?import指南包含新说明及共享custom-theme路由，Flutter代理main.dart.js为HTTP200。预览：http://localhost:19004/flutter/custom-theme。
- 未执行实际浏览器像素/窄屏人工验收、Linux Golden或Release构建，不更新Golden。仅本地修改，未暂存、提交、推送或更新PR；未修改CI、版本或CHANGELOG。

## 部分配置数值展示

JSON场景新增四项浅深配置对照：brandColor、bgColorPage、bgColorContainer、textColorPrimary。值从当前Token的light/dark关联直接读取，未另存颜色值；标记当前列及JSON覆盖/默认继承，提供色块和保留alpha的十六进制值说明。

Flutter3.32.0与3.47.7各13项Theme非Golden测试通过，新增回归核对八个实际值、两套配置来源、模式标记、实际背景/文字一致性及320dp无溢出。相关源码和测试3.32静态分析无问题；站点30项相关测试与生产构建通过，差异空白检查通过。Flutter19005热重启、站点19004重启及实际编译指南检查完成。未执行浏览器像素人工检查。仅本地修改，未提交推送。

## 交付状态更新

用户已授权将本地改动提交、推送到PR1163，并以推送后的提交进行全局Review；上文“仅本地/不推送”为此前实施阶段的历史记录，不再是本次交付限制。合并放行以当前提交的CI、Review及适用视觉验收为准。
