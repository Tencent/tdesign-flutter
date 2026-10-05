# 实施方案

## 技术方案

新增零运行时依赖的独立 ESM 库 `packages/css2token`（暂时 private，不发布），入口、类型声明、README 与测试均可整体移出仓库。库只接收调用方提供的 CSS 和可选默认基线，不读取 DOM、文件系统或控制器包，不管理预设及持久化。站点 Theme Bridge 作为适配器：解析主题控制器维护的三个 CSS 样式表，按 Flutter 现有 Token 名称生成 `light/dark` JSON。转换过程递归解析 CSS 引用，显式维护跨端语义名称映射，并为 mobile 控制器补齐其面板会读取但默认样式未声明的行高和尺寸基础 Token。

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

- `parseCssToFlutterTheme(css, baseline?)` 转换一个模式；`generateFlutterThemeFromParts(light, dark, extra, baseline?)` 转换双模式。共享 CSS 在各模式后合并，最后声明优先。
- 支持 td 变量引用、嵌套 fallback 与循环检测；未知或无法解析的值跳过，不猜测浏览器计算样式。输入按声明集合处理，不计算选择器优先级。
- 未提供的 Token 不输出。仅提供字号或行高时，复合 font 的另一维使用 Flutter 当前映射默认值；输入已有另一维则使用输入值。
- 颜色转换、字体层级、圆角、外阴影、边缘内阴影与 spacing 映射保持现有 Flutter JSON 契约。
- 控制器 CSS 补齐、包默认值提取及 postMessage 协议留在站点适配器；控制器预设刷新和面板展示问题不属于独立库职责。
- 独立 Node 测试进入站点现有 CI 命令；增加脱离站点目录的运行验证和 Light/Dark 浏览器验收。
