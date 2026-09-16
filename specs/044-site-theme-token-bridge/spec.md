# 官网主题控制器全量 Token 同步

## 背景

Flutter 官网的主题控制器会把亮色、暗色和公共尺寸样式写入三个 CSS `style` 节点。历史实现只转换了部分颜色、圆角、阴影和字号，字体名称与 `TThemeData` 不匹配，行高、字重、间距和直接语义色也无法可靠传入 Flutter Web Demo。

## 目标

- 官网主题控制器修改的颜色、字体、圆角、阴影和尺寸 Token 同步到当前页面内全部 Flutter Web Demo。
- 亮色与暗色配置独立转换，并跟随官网明暗模式切换。
- 新建或重新加载的 Demo iframe 能收到当前主题，不要求用户再次操作控制器。
- 非法、缺失或跨源消息不改变 Flutter Demo 当前主题。

## 非目标

- 不改变 `TThemeData` 的公开 API、默认值或组件 ThemeExtension 优先级。
- 不把 Web 组件专属尺寸 Token 机械扩展为 Flutter 组件公开 API。
- 不修改 Golden 基线；默认控制器配置下 Flutter 默认视觉应保持不变。

## 范围

### 涉及

- 官网主题控制器依赖及挂载。
- CSS Token 到 `TThemeData` JSON 的转换和 iframe 消息同步。
- Flutter Web Demo 的主题消息解析、应用和安全边界。
- 转换单元测试、Demo 消息解析测试和 CI 回归登记。

### 不涉及

- 原生 Android/iOS Demo 的跨窗口主题同步。
- 组件级 ThemeData 字段和实例参数。
- 主题控制器上游 Web Component 的交互设计。

## 行为契约

1. 控制器以 mobile 默认主题初始化，默认颜色、字体、圆角和阴影与 Flutter `TThemeData.defaultData()` 的语义保持一致。
2. 转换器按字段处理：调色板和直接语义色进入 `color`，CSS 引用解析为叶子颜色后进入 `ref`，字体进入 `font`，圆角进入 `radius`，投影进入 `shadow`，基础尺寸映射为 `margin`。
3. 字体的字号、行高和字重必须组成同一个 Flutter Font Token；只修改其中一个字段时其余字段保持有效默认值。
4. CSS `#RGB/#RGBA/#RRGGBB/#RRGGBBAA`、`rgb()`、`rgba()`、百分比 alpha、`transparent` 和嵌套 `var()` 必须得到 Flutter 可解析的 `#AARRGGBB` 或 `#RRGGBB`。
5. 圆形/胶囊圆角转换为 Flutter 的大半径语义；阴影保留每层 offset、blur、spread 和颜色。
6. 每次有效 Token 变化只发送一次去重后的 JSON 字符串 `flutter-theme-update`；iframe load 后重发当前配置。
7. Flutter 仅接受同源、结构完整的消息。解析失败时保留当前主题，不抛出导致 Demo 中断。

## 验收标准

- [x] 主题控制器的颜色、字体、圆角、阴影和尺寸面板变化均可改变 Flutter Web Demo 对应 Token。
- [x] light/dark 主题独立生效，切换模式不丢失定制值。
- [x] 直接色值、CSS 引用、透明色、百分比 alpha 和多层阴影转换测试通过。
- [x] Flutter 解析测试覆盖全部 JSON 分组以及 dark 主题。
- [x] 新加载 iframe 能收到当前主题；重复内容不会重复广播。
- [x] 站点生产构建、Example 聚焦测试、调度器自测和严格 analyze 通过。
