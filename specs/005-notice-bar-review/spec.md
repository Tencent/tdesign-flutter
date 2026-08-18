# TNoticeBar Review 修复与文档补全

## 背景

对 `TNoticeBar` 公告栏组件进行 review 后，发现以下问题需要落地修复与补全：

1. **滚动距离取错（P1）**：水平跑马灯 `_scroll()` 中 `scrollDistance = _getContextWidth() + (_size!.width - padding)` 使用了**屏幕宽度** `MediaQuery.of(context).size` 而非公告栏自身的可视区宽度，导致文本滚到尽头后要空转一大段才回绕，窄屏/宽屏表现异常。
2. **speed 语义与计时健壮性（P1）**：水平滚动每个 tick 固定 `animateTo(offset, duration: 1s)`，配合 `Timer.periodic(1s)` 叠加，存在时序漂移风险；需保证 `speed`（每秒逻辑像素）真正驱动速率。
3. **尺寸语义混乱（P2）**：`_key` 挂在第一个文本 `SizedBox` 上，`_getContextWidth()` 返回文本宽度，与可视区宽度混用，缺少对公告栏可视区真实宽度的统一测量。
4. **冗余 getter（轻微）**：`_effectiveMarquee`、`_effectiveInterval` 是纯透传 `widget.xxx`，冗余。
5. **站点文档过期（P2）**：`tdesign-site/docs/components/notice-bar/README.md` 仍引用不存在的旧 API（`TNoticeBarStyle`、`TNoticeBarTheme`、`TNoticeBarType`、`onTap`、`interval: int`、`height`、`theme`、`style`），与当前实现及生成的 `notice-bar_api.md` 严重不符。
6. **测试不足**：多为"不崩溃 + 元素存在"断言，未覆盖滚动距离（屏幕宽 bug）与 variant 具体色值。
7. **公开 Demo 矩阵不完整**：官方垂直滚动与自定义内容场景藏在 `test` 分组；Flutter 特有的“卡片顶部”没有小程序平台依据。

## 目标

- 修复水平跑马灯滚动距离，改用公告栏可视区宽度，避免依赖屏幕宽度。
- 保证 `speed` 语义为"每秒滚动的逻辑像素"，并降低定时器时序漂移风险。
- 移除冗余 getter，统一尺寸测量。
- 补全站点 README，使其与当前 API 一致。
- 补充回归测试：滚动距离使用可视区宽度；variant 四档具体色值校验。
- 将垂直滚动和自定义内容移入公开 Demo，并删除无平台依据的“卡片顶部”示例。

## 非目标

- 不改变 `TNoticeBar` 的公开 API 签名与默认行为（仅内部实现修复与文档/测试补全）。
- 不新增组件能力。
- 未经维护者确认，不改变 `interval`、默认图标、内边距、垂直交互或点击目标等公开契约。

## 范围

### 涉及

- `tdesign-component/lib/src/components/notice_bar/t_notice_bar.dart`（滚动逻辑、尺寸测量、getter 清理）
- `tdesign-component/test/components/notice_bar/t_notice_bar_test.dart`（回归测试）
- `tdesign-site/docs/components/notice-bar/README.md`（过期 API 文档同步）
- `tdesign-component/example/lib/page/t_notice_bar_page.dart`、生成代码与 Example 测试
- `specs/005-notice-bar-review/`（本 Spec）

### 不涉及

- `TNoticeBarThemeData` 公共 API（`TNoticeBarVariant`、`TNoticeBarThemeData`）保持不变。
- 站点设计文档 `tdesign-site/docs/design/flutter/notice-bar.md`（非组件 API 文档）。

## 行为契约

- 水平跑马灯滚动总距离 = **文本宽度 + 公告栏可视区宽度**，与屏幕宽度无关。
- `speed` 表示每秒滚动的逻辑像素数，单位为 px/s；水平滚动每个 tick 前进 `speed` 像素。
- 垂直 step 每步位移 = 公告栏高度，时长 = `位移 / speed`。
- 移除 `_effectiveMarquee`、`_effectiveInterval`，改用 `widget.marquee`、`widget.interval`。
- 站点 README 只描述当前存在的 API：`content`、`items`、`left`、`right`、`prefixIcon`、`suffixIcon`、`direction`、`maxLines`、`marquee`、`speed`、`interval`、`onPressed`、`TNoticeBarTapTarget`、`TNoticeBarThemeData`、`TNoticeBarVariant`；不再出现 `TNoticeBarStyle`、`TNoticeBarTheme`、`TNoticeBarType`、`onTap`。
- 官方垂直滚动和自定义内容场景可从公开 Example 入口访问；“卡片顶部”不再展示或生成代码片段。

## 验收标准

- [x] 水平滚动距离使用可视区宽度（`_getEmptyWidth()`），不再依赖 `_size!.width - padding`。
- [x] 移除冗余 getter `_effectiveMarquee`、`_effectiveInterval`。
- [x] `flutter analyze` 对改动文件无 error/warning。
- [x] 新增测试：容器内公告栏的最大滚动位置 ≈ `文本宽 + 可视区宽`，明显小于 `文本宽 + 屏幕宽`。
- [x] 新增/加强测试：`resolve` 各 variant 的背景色与左侧图标色值校验到具体 Token 色值。
- [x] 站点 README API 表格与当前 `notice-bar_api.md` 一致。
- [x] Flutter 3.32.0 与 latest 的聚焦组件测试、Example 测试和严格 analyze 通过。
- [x] NoticeBar 生产源码 LCOV `LH/LF >= 95%`。
- [ ] 真实运行时截图与垂直触摸交互完成验收。
- [ ] 待确认的公开契约已获得维护者决策或明确留作后续。
