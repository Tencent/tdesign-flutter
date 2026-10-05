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
- 独立 `packages/css2token` 库负责 CSS Token 到 `TThemeData` JSON 转换；站点适配器负责控制器补齐及 iframe 消息同步。
- Flutter Web Demo 的主题消息解析、应用和安全边界。
- 转换单元测试、Demo 消息解析测试和 CI 回归登记。

### 不涉及

- 原生 Android/iOS Demo 的跨窗口主题同步。
- 组件级 ThemeData 字段和实例参数。
- 主题控制器上游 Web Component 的交互设计。

## 行为契约

1. 控制器以 mobile 默认主题初始化，默认颜色、字体、圆角和阴影与 Flutter `TThemeData.defaultData()` 的语义保持一致。
2. 转换器按字段处理：调色板和直接语义色进入 `color`，CSS 引用解析为叶子颜色后进入 `ref`，字体进入 `font`，圆角进入 `radius`，投影进入 `shadow`，全局 `--td-spacer[-1..6]` 间距映射为 `margin`。
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

## develop 同步适配（2026-10-06）

桥接字段使用当前 develop 的品牌及功能色、componentStroke/componentBorder、textColorDisabled、shadow1..4 和 spacer/spacer1..6 名称；圆角按同名 Token 映射，radiusCircle 保留固定逻辑像素例外。

## 当前 Token 重整契约

- 以 develop 的公开全局 Token 为准，移除已删除语义色别名；控制器 CSS 和 Flutter 字段名称分开映射。
- 字号与行高同时更新 fontMetric 和对应复合 font；保留默认 fontMetric 与 insetShadow。
- 尺寸面板 size-4/5/6/8/10/13/15 分别驱动 spacer/spacer1..6，显式 spacer CSS 优先。
- 数值圆角按逻辑像素传递；仅 radiusCircle 的百分比值使用固定大半径例外。
- 支持四层外阴影、零模糊定向内阴影与 none 清除阴影。
- iframe 在开发与生产均走同源路径；Flutter 首帧注册监听后通知父页面 ready，由父页面重发最新配置。

默认比较基线取控制器包原始 CSS。控制器自身选项持久化及重载后恢复 CSS 属于上游交互行为；桥接同步实际生效的 CSS，不从选项名称推断样式。

## 独立库交付

转换库零运行时依赖，提供 ESM 入口、TypeScript 声明、使用说明与独立测试，可整体移出仓库。当前 private，不发布；保留现有 Flutter JSON 协议，无组件公开 API 变化。未提供或无效的 Token 不生成默认覆盖，站点的控制器 CSS 补齐不进入转换库。库不管理控制器预设、持久化或刷新恢复。
