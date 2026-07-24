# TSwitch - v1.0 定稿

> **状态**：已实现 | **控制类**：B | **Sprint**：S2

**源码路径**：`lib/src/components/switch`

## 架构

| 项 | v1.0 |
|---|---|
| 控制 | `value` + `onChanged`，严格受控 |
| 禁用 | `onChanged: null` |
| 实现 | TDesign 自定义开关；承载 text / icon / loading 内容形态 |
| Theme | `TSwitchThemeData`；视觉默认值不进入构造器 |
| Token | 未配置 Theme 字段时回退 `context.tTheme` |

## API

### TSwitch

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `bool` | - | 受控开关状态 |
| `onChanged` | `ValueChanged<bool>?` | - | 状态变更；为 null 时禁用 |
| `size` | `TSwitchSize?` | - | 实例尺寸；未传时读取 Theme |
| `variant` | `TSwitchVariant?` | - | 实例内容形态；未传时读取 Theme |
| `openText` | `String?` | - | text 形态的开启文案 |
| `closeText` | `String?` | - | text 形态的关闭文案 |

### 类型

| 类型 | 成员 | 说明 |
|---|---|---|
| `TSwitchSize` | `large` / `medium` / `small` | 开关尺寸 |
| `TSwitchVariant` | `filled` / `text` / `loading` / `icon` | 滑块内容形态 |
| `TSwitchThemeData` | ThemeExtension | 组件级视觉默认值 |

`loading` 形态始终禁用交互；状态仍由 `value` 决定，不在组件内部维护业务值。

## Theme

`TSwitchThemeData` 通过 `Theme.of(context).mergeExtension(...)` 注入子树，或加入全局 `ThemeData.extensions`。

| 字段 | 说明 |
|---|---|
| `defaultSize` | 默认尺寸 |
| `defaultVariant` | 默认内容形态 |
| `trackOnColor` | 开启态轨道颜色 |
| `trackOffColor` | 关闭态轨道颜色 |
| `thumbContentOnColor` | 开启态滑块内容颜色 |
| `thumbContentOffColor` | 关闭态滑块内容颜色 |
| `thumbContentOnFont` | 开启态滑块内容文本样式 |
| `thumbContentOffFont` | 关闭态滑块内容文本样式 |
| `openText` | text 形态默认开启文案 |
| `closeText` | text 形态默认关闭文案 |

覆盖顺序：实例 `size` / `variant` / 文案 > `TSwitchThemeData` > Token。

## 实现约束

- 不提供业务 Controller、`enabled`、`disabled` 或额外回调 typedef。
- 构造器不暴露颜色、字体等 L4 样式字段。
- `TSwitchResolve` 是内部唯一样式解析入口，不从公共总出口导出。
- `TSwitchSize`、`TSwitchVariant` 位于独立类型文件，Theme 与 Widget 不通过公共总出口互相依赖。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖受控切换、禁用、四种形态、三种尺寸、Theme、LTR/RTL 拖动 |
| 文档 | tools 生成的公开 API 说明列不得为 `-` |
| 覆盖率 | 组件源码总覆盖率不低于 95% |
| API 边界 | 源码、测试、示例、API 文档不得出现额外控制器、重复禁用入口或构造器 L4 字段 |
