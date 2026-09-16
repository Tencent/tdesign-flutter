# 实施方案

## 技术方案

在站点新增纯函数 Theme Bridge：解析主题控制器维护的三个 CSS 样式表，按 Flutter 现有 Token 名称生成 `light/dark` JSON。转换过程递归解析 CSS 引用，显式维护跨端语义名称映射，并为 mobile 控制器补齐其面板会读取但默认样式未声明的行高和尺寸基础 Token。

站点根组件观察样式表内容并对转换结果去重，通过同源 `postMessage` 发送 JSON 字符串。组件文档 iframe 加载后发出 ready 事件，根组件重发最新主题。Flutter Web 监听器验证来源并兼容 JSON 字符串与历史 Map 数据，跨平台纯 Dart 解析器把增量消息合并到 Flutter 自身的 light/dark 默认主题，再由 `MyApp` 更新 `TThemeBuilder.light/dark`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 站点 | `tdesign-site/site/app.vue`、Theme Bridge | 挂载控制器并转换、广播全部兼容 Token |
| Demo | Web theme listener、`main.dart` | 动态替换 Demo 的 `TThemeData` |
| 测试 | Node 单测、Example Flutter 测试、manifest | 固化转换与解析契约 |
| 依赖 | `@tdesign/theme-generator` | 使用当前 1.2.6 控制器 |

## API 变化

- 无公开组件 API 变化。
- 新增站点内部消息协议 `flutter-theme-update`，仅用于同源官网与其 Flutter iframe。

## 风险与取舍

- Web 尺寸体系比 Flutter Token 更细，不把组件专属尺寸直接塞入全局 Flutter Theme；仅用基础尺寸刻度驱动现有 spacer Token。
- 浏览器字体族不等于 Flutter 已打包字体，不覆盖 `numberFontFamily`，避免生成无法加载的 Flutter 字体。
- 控制器包的 mobile 默认 CSS 缺少部分 Flutter 字体层级，由桥接层幂等补齐并从相邻层级推导，避免修改或 fork 上游包。
- 控制器默认值与 Flutter 默认值存在细微差异，桥接只发送相对初始样式的增量，未调整 Token 继续使用 Flutter 原生 light/dark 默认值。

## 验证策略

- 单元测试：CSS 颜色、引用、字体、圆角、阴影、尺寸及去重转换。
- 集成或 Widget 测试：消息 JSON 解析为 light/dark `TThemeData`。
- 静态检查：站点生产构建、Flutter strict analyze、diff check。
- 人工验收：本地站点连接 Flutter Web 构建，逐面板修改并观察 Demo。
