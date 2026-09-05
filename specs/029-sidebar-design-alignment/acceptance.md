# 验收记录

## 环境

- 分支：`rss1102/breaking/sidebar-design-alignment`
- 基线：`origin/develop` (`f3e14c43`)
- Figma：页面 `24787:18812`，移动端画板 `28591:34071`
- 小程序：`Tencent/tdesign-miniprogram` develop `ae55fb05`

## 自动化验证

| 项目 | 结果 | 证据 |
| --- | --- | --- |
| 组件行为 | 43/43 通过 | 受控回写、禁用、loading、line/tag、语义和 Theme 优先级 |
| 生产覆盖率 | 通过 | SideBar 生产源码 LH/LF = 232/232 = 100% |
| Demo 行为 | 8/8 通过 | 10 项数据、Badge、锚点双向同步、末项、文本缩放与公开入口 |
| 严格 Golden | 6/6 通过 | Flutter 3.32 Linux：入口、锚点、tag 各 light/dark；更新后无 `--update-goldens` 复跑 |
| 双 SDK | 通过 | Flutter 3.32.0 / 3.47.0 组件包与 Example analyze 均 0 error / 0 warning；功能测试通过 |
| 构建 | 通过 | 两个 SDK 的 Web release 与 Android debug 均成功 |
| 生成产物 | 通过 | API 与示例片段已生成，`generate_example_code.dart --check` 通过 |
| Android 16 | 通过 | uppercase `R`、手工可见操作、真机 integration 1/1、普通 APK 安装 `Success` 与冷启动 |

## 人工 Figma / 小程序对照

- [x] 读取新版 Figma 移动画板 `28591:34071`（375×667），核对 103dp 左栏、10 项、默认第二项、Badge 位置和右侧纵向图文行。
- [x] 读取小程序 develop 的 SideBar 组件与公开 Demo，保留受控切换、锚点同步和禁用项操作模式。
- [x] 明确记录重大跨端差异：小程序为 5 项 + 64dp 圆图三列宫格；新版 Figma 为约 10 项 + 48dp 圆角方图纵向列表。Flutter 公开详情按用户指定优先对齐新版 Figma。
- [x] 逐张检查 6 个最终 Golden；独立 CJK 子集无缺字方框，长页无裁切，light/dark 状态和结构一致。

## API / Theme Review

- `value/onChanged` 是唯一受控状态源；不复制小程序 `defaultValue` 或动态事件对象。
- `style` 为非空实例结构状态（`line` / `tag`）；`width`、`height` 也是实例布局契约，Theme 不持有结构选择器或尺寸状态。
- `TSideBarThemeData` 只保留颜色、文字样式和内边距；优先级为实例视觉参数 > ThemeExtension > TDesign 语义 Token。
- disabled 同时落到不可点击行为与 `Semantics.enabled=false`；选中态写入逐项语义。
- 默认标签使用 Body Large Token；103dp 宽度、3×14 指示线和 9dp 圆角均有组件测试与 Golden 证据。
- Breaking 范围已记录：枚举 `normal/outline` 改为 `line/tag`，移除 Theme `style/height`，新增 103dp `width`，默认宽度行为变化。

## 真机证据

- 设备：Xiaomi Android 16，ADB `40302eeb`。
- 最终源码通过 `flutter run` 安装并执行 uppercase `R`，返回 `Restarted application in 1,337ms`。
- 手工可见操作：从首页进入 SideBar；锚点页点击第四项并滚动内容；切页页点击禁用第五项后选中态不变，再点击第三项成功；进入带图标与 tag 页面；切换 light/dark。
- tag 页首帧图片尚未解码时右侧短暂空白，等待稳定后 8 个纵向图文行完整出现；Golden 已预缓存同一资产以消除非确定性。
- `flutter test integration_test/sidebar_example_test.dart -d 40302eeb` 最终代码 1/1 通过。
- integration 后重新构建普通 APK；首次安装被系统拒绝，改为检测到“USB安装提示”后精确确认，ADB 返回 `Success`；强停冷启动后检测到“`TDesign Flutter 组件库`”。
- 截图：`/private/tmp/sidebar-phone-anchor-default.png`、`/private/tmp/sidebar-phone-anchor-click.png`、`/private/tmp/sidebar-phone-anchor-dark.png`、`/private/tmp/sidebar-phone-icon.png`、`/private/tmp/sidebar-phone-tag-late.png`、`/private/tmp/sidebar-phone-tag-dark.png`。

## 待完成

- 独立 GitHub / CNB PR、Issue #1027 SideBar 条目关联及 CodeBuddy Review。
