# 实施方案

## 技术方案

新增零运行时依赖的纯 Dart package `packages/css2token`（`publish_to: none`，暂不发布），Dart 源码、pubspec、README 与测试均可整体移出仓库。库只接收调用方提供的 CSS 和可选默认基线，不读取 DOM、文件系统或控制器包，不管理预设及持久化。站点 Theme Bridge 作为适配器，读取主题控制器维护的三个 CSS 样式表并发送原始 CSS；Example 通过 path 依赖调用 Dart 转换库，按 Flutter 现有 Token 名称生成 `light/dark` JSON。转换过程递归解析 CSS 引用，显式维护跨端语义名称映射，并为 mobile 控制器补齐其面板会读取但默认样式未声明的行高和尺寸基础 Token。

站点根组件观察样式表内容并对 CSS 消息去重，通过同源 `postMessage` 发送 JSON 字符串。组件文档 iframe 加载后发出 ready 事件，根组件重发最新主题。Flutter Web 监听器验证来源并兼容 JSON 字符串与历史 Map 数据，跨平台纯 Dart 解析器把增量消息合并到 Flutter 自身的 light/dark 默认主题，复合 Font 在 Example 单独适配以保留控制器递增模式产生的小数行高，再由 `MyApp` 更新 `TThemeBuilder.light/dark`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 站点 | `tdesign-site/site/app.vue`、Theme Bridge | 挂载控制器、补齐 CSS、广播原始 CSS 和基线 |
| Demo | Web theme listener、`main.dart` | 调用纯 Dart 转换库，合并并替换 Demo 的 `TThemeData` |
| 测试 | Dart 独立测试、Node 适配测试、Example Flutter 测试及双版本 CI | 固化转换与解析契约 |
| 依赖 | `@tdesign/theme-generator` | 使用当前 1.2.6 控制器 |

## API 变化

- 无公开组件 API 变化。
- 新增站点内部 CSS 消息协议 `flutter-css-theme-update`，兼容旧 `flutter-theme-update` Token JSON 协议，仅用于同源官网与其 Flutter iframe。

## 风险与取舍

- Web 尺寸体系比 Flutter Token 更细，不把组件专属尺寸直接塞入全局 Flutter Theme；仅用基础尺寸刻度驱动现有 spacer Token。
- 浏览器字体族不等于 Flutter 已打包字体，不覆盖 `numberFontFamily`，避免生成无法加载的 Flutter 字体。
- 控制器包的 mobile 默认 CSS 缺少部分 Flutter 字体层级，由桥接层幂等补齐并从相邻层级推导，避免修改或 fork 上游包。
- 控制器默认值与 Flutter 默认值存在细微差异，桥接只发送相对控制器包原始默认 CSS 的增量，未调整 Token 继续使用 Flutter 原生 light/dark 默认值。

## 验证策略

- 单元测试：CSS 颜色、引用、字体、圆角、阴影、尺寸及去重转换。
- 集成或 Widget 测试：消息 JSON 解析为 light/dark `TThemeData`。
- 静态检查：站点生产构建、Flutter strict analyze、diff check。
- 人工验收：本地站点连接 Flutter Web 构建，逐面板修改并观察 Demo。

## 当前 Token 的适配表

| 控制器输入 | Flutter 消费字段 |
| --- | --- |
| 品牌、功能、primary、gray 色阶及现有语义色 | color / ref；移除无消费者的 hover 等旧名称 |
| 字号和行高 | fontMetric 与同一层级的复合 font |
| small/default/large/extraLarge/round 数值圆角 | 同名 radius；circle 百分比保留 9999 例外 |
| shadow-1..4 / shadow-inset-top/right/bottom/left | shadow / insetShadow；none 清除 |
| size-4/5/6/8/10/13/15 | spacer/spacer1..6，末项按 80/64 比例；显式 spacer CSS 优先 |

默认 CSS 在 Vite 构建时从当前控制器包的三个 raw-loader 字符串提取，不执行其 bundle；包结构变化时明确失败。页面已保存的定制样式不再被误当作默认基线。默认字体指标、内阴影由 Flutter 解析器保留。

开发入口复用现有 /flutter/example/ 同源代理，代理端口与 dev 脚本共享 VITE_FLUTTER_WEB_PORT。Flutter 首帧注册监听后向父窗口发送 flutter-demo-ready，父窗口校验 origin 与 iframe source 后重发当前主题。

## 独立库契约

### Dart 迁移方案（2026-10-06）

最终转换端调整为 Flutter iframe：`packages/css2token` 改为纯 Dart package，零运行时依赖，`publish_to: none`，Example 通过 path 依赖调用。官网只发送完整 light/dark/extra CSS、控制器原始默认基线和模式；保留控制器 CSS 补齐、去重、同源通信及 ready 握手。纯库输出可 JSON 序列化的 Token Map，不依赖 Flutter、DOM 或控制器；Example 负责合并为 TThemeData。

使用独立 `flutter-css-theme-update` 协议承载原始 CSS；旧 `flutter-theme-update` Token JSON 协议兼容保留。消息校验 CSS 结构后再转换，缺失/非法结构不更新主题。删除 JS 转换实现、npm 包元数据、类型声明及 JS 转换测试，避免两份映射；JS 测试只验证控制器适配和消息。Dart 独立测试进入双版本 CI，同时验证官网实际发送 CSS 后由 Dart 应用 Light/Dark。

- `parseCssToFlutterTokens(css, baselineCss: ...)` 转换一个模式；`cssToFlutterTokens(lightCss: ..., darkCss: ..., extraCss: ..., baseline: ...)` 转换双模式。共享 CSS 在各模式后合并，最后声明优先。
- 支持 td 变量引用、嵌套 fallback 与循环检测；未知或无法解析的值跳过，不猜测浏览器计算样式。输入按声明集合处理，不计算选择器优先级。
- 未提供的 Token 不输出。仅提供字号或行高时，复合 font 的另一维使用 Flutter 当前映射默认值；输入已有另一维则使用输入值。
- 颜色转换、字体层级、圆角、外阴影、边缘内阴影与 spacing 映射保持现有 Flutter JSON 契约。
- 控制器 CSS 补齐、包默认值提取及 postMessage 协议留在站点适配器；控制器预设刷新和面板展示问题不属于独立库职责。
- 独立 Dart 测试与严格 analyze 进入 Flutter 双版本 CI；Dart 编译成 JS 后执行 Light/Dark 浏览器契约验收，官网联调验证真实 CSS 消息。
