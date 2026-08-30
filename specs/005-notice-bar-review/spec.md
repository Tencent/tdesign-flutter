# TNoticeBar Review 修复与文档补全

## 背景

对 `TNoticeBar` 公告栏组件进行 review 后，发现以下问题需要落地修复与补全：

1. **滚动距离取错（P1）**：水平跑马灯 `_scroll()` 中 `scrollDistance = _getContextWidth() + (_size!.width - padding)` 使用了**屏幕宽度** `MediaQuery.of(context).size` 而非公告栏自身的可视区宽度，导致文本滚到尽头后要空转一大段才回绕，窄屏/宽屏表现异常。
2. **speed 语义与计时健壮性（P1）**：水平滚动每个 tick 固定 `animateTo(offset, duration: 1s)`，配合 `Timer.periodic(1s)` 叠加，存在时序漂移风险；需保证 `speed`（每秒逻辑像素）真正驱动速率。
3. **尺寸语义混乱（P2）**：`_key` 挂在第一个文本 `SizedBox` 上，`_getContextWidth()` 返回文本宽度，与可视区宽度混用，缺少对公告栏可视区真实宽度的统一测量。
4. **冗余 getter（轻微）**：`_effectiveMarquee`、`_effectiveInterval` 是纯透传 `widget.xxx`，冗余。
5. **站点文档过期（P2）**：`tdesign-site/docs/components/notice-bar/README.md` 仍引用不存在的旧 API（`TNoticeBarStyle`、`TNoticeBarTheme`、`TNoticeBarType`、`onTap`、`interval: int`、`height`、`theme`、`style`），与当前实现及生成的 `notice-bar_api.md` 严重不符。
6. **测试不足**：多为"不崩溃 + 元素存在"断言，未覆盖滚动距离（屏幕宽 bug）与 variant 具体色值。
7. **公开 Demo 矩阵与官方页面结构不一致**：滚动场景被插入“组件类型”，入口、状态与滚动场景按内部 Widget 拆分；部分示例文案、图标和自定义内容组合也与官方公开 Demo 不同。

## 目标

- 修复水平跑马灯滚动距离，改用公告栏可视区宽度，避免依赖屏幕宽度。
- 保证 `speed` 语义为"每秒滚动的逻辑像素"，并降低定时器时序漂移风险。
- 移除冗余 getter，统一尺寸测量。
- 补全站点 README，使其与当前 API 一致。
- 补充回归测试：滚动距离使用可视区宽度；variant 四档具体色值校验。
- 按官方公开页面收敛为“组件类型 / 组件状态 / 可滚动公告栏”三个分组，保持每个公开 Demo 块的实例数量、顺序、文案和组合一致。
- 内部点击验证不进入公开 Demo 或 Golden。

## 非目标

- 不机械复制小程序的 `boolean | object` 联合类型或字符串插槽。
- 不新增当前公开 Demo 未验证的 `loop`、`delay` 能力。
- 不改变 NoticeBar 之外组件的公开契约。

## 范围

### 涉及

- `tdesign-component/lib/src/components/notice_bar/t_notice_bar.dart`（滚动逻辑、尺寸测量、getter 清理）
- `tdesign-component/test/components/notice_bar/t_notice_bar_test.dart`（回归测试）
- `tdesign-site/docs/components/notice-bar/README.md`（过期 API 文档同步）
- `tdesign-component/example/lib/page/t_notice_bar_page.dart`、生成代码与 Example 测试
- `specs/005-notice-bar-review/`（本 Spec）

### 不涉及

- NoticeBar 之外的组件 ThemeExtension。
- 站点设计文档 `tdesign-site/docs/design/flutter/notice-bar.md`（非组件 API 文档）。

## 行为契约

- 水平跑马灯滚动总距离 = **文本宽度 + 公告栏可视区宽度**，与屏幕宽度无关。
- `speed` 表示横向跑马灯每秒滚动的逻辑像素数，单位为 px/s；不再控制纵向切换动画。
- `interval` 默认值为 2 秒且仅控制纵向轮播；纵向列表由 `direction == Axis.vertical` 与多条 `items` 启用，不依赖 `marquee`。
- `status` 是 info / success / warning / error 的唯一实例状态入口；ThemeData 不再保存枚举型状态选择器。
- `prefix` 是 Flutter Widget 插槽：null 使用 status 默认图标，自定义 Widget 覆盖默认图标，`SizedBox.shrink()` 隐藏前缀。
- `operation` 是内容右侧、尾部图标左侧的 Widget 插槽，可与 `suffixIcon` 共存；点击报告 `TNoticeBarTapTarget.operation`。
- 删除职责重复或含义模糊的 `left`、`right`、`prefixIcon` 与 ThemeData `variant`。
- 移除 `_effectiveMarquee`、`_effectiveInterval`，改用 `widget.marquee`、`widget.interval`。
- 站点 README 只描述最终 API：`content`、`items`、`status`、`prefix`、`operation`、`suffixIcon`、`direction`、`maxLines`、`marquee`、`speed`、`interval`、`onPressed`、`TNoticeBarTapTarget`、`TNoticeBarThemeData`、`TNoticeBarStatus`。
- 公开 Example 顺序为“组件类型 / 组件状态 / 可滚动公告栏”，对应官方页面 8 个 Demo 块、14 个 `TNoticeBar` 实例。
- “组件类型”依次展示纯文字、带图标、带关闭、带入口、自定义样式、自定义内容；同一官方 Demo 块中的多个实例由单个 Example builder 组合。
- “组件状态”在同一 Demo 块内依次展示普通、成功、警示、错误四种状态；“可滚动公告栏”在同一 Demo 块内依次展示无图标水平滚动、带图标水平滚动、垂直滚动。
- 公开文案、默认图标和操作组合与 `tdesign-miniprogram@1.16.0` NoticeBar Demo 一致；Flutter 使用 `prefix` / `operation` Widget 插槽表达自定义区域。
- `showTestModule` 关闭，内部点击验证不出现在公开页面与 Golden。

## 验收标准

- [x] 水平滚动距离使用可视区宽度（`_getEmptyWidth()`），不再依赖 `_size!.width - padding`。
- [x] 移除冗余 getter `_effectiveMarquee`、`_effectiveInterval`。
- [x] `flutter analyze` 对改动文件无 error/warning。
- [x] 新增测试：容器内公告栏的最大滚动位置 ≈ `文本宽 + 可视区宽`，明显小于 `文本宽 + 屏幕宽`。
- [x] 新增/加强测试：`resolve` 各 variant 的背景色与左侧图标色值校验到具体 Token 色值。
- [x] 站点 README API 表格与当前 `notice-bar_api.md` 一致。
- [x] Flutter 3.32.0 与 latest 的聚焦组件测试、Example 测试和严格 analyze 通过。
- [x] NoticeBar 生产源码 LCOV `LH/LF >= 95%`。
- [ ] 固定视口的 Flutter 3.32.0 Linux light/dark Golden 完成验收。
- [x] interval、speed、默认图标、status、prefix 与 operation 契约已获得维护者确认。

## Breaking change

- `left` 迁移为 `prefix`。
- `prefixIcon: IconData` 迁移为 `prefix: Icon(...)`；不传时改为显示 status 默认图标。
- `right` 迁移为 `operation`，且不再遮蔽 `suffixIcon`。
- `TNoticeBarVariant` 与 `TNoticeBarThemeData.variant` 迁移为实例 `TNoticeBar.status` / `TNoticeBarStatus`。
- `interval` 默认值从 3 秒调整为 2 秒；纵向轮播不再复用横向 `marquee` / `speed`。
