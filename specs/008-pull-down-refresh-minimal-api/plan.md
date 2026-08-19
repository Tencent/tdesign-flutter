# 实施方案

## 技术方案

核心思路：新增**顶层组件 `TPullDownRefresh`**，在内部封装 `EasyRefresh`，对外只暴露最小、Flutter 惯用的 API；将原先裸透传 easy_refresh 参数的 `TRefreshHeader` 收敛为内部私有实现。状态由 easy_refresh 的 `Header`（`IndicatorState.mode`）驱动，通过 `TPullDownRefreshController` 与 `onStateChanged` 对外暴露。

### 1. 目录与文件结构

```
tdesign-component/lib/src/components/refresh/
├── t_pull_down_refresh.dart          # 新增：顶层组件 TPullDownRefresh + 状态枚举
├── t_pull_down_refresh_controller.dart  # 新增：TPullDownRefreshController
└── t_pull_down_refresh_texts.dart    # 新增：TPullDownRefreshTexts
```

### 2. TPullDownRefresh 内部封装 EasyRefresh

```dart
class _TPullDownRefreshState extends State<TPullDownRefresh> {
  EasyRefreshController _easyController = EasyRefreshController();

  Widget build(BuildContext context) {
    final header = _TRefreshHeader(
      extent: widget.loadingBarHeight,
      triggerDistance: widget.loadingBarHeight,
      maxOverOffset: widget.maxBarHeight,
      texts: effectiveTexts,
      onStateChanged: _handleStateChanged,
    );
    return EasyRefresh(
      controller: _easyController,
      header: widget.onRefresh == null ? null : header,
      onRefresh: widget.onRefresh == null ? null : _handleRefresh,
      onLoad: widget.onLoadMore == null ? null : _handleLoadMore,
      child: widget.child,
    );
  }
}
```

### 3. 状态映射与超时

- 在 Header 的 `build(context, state)` 中，把 `IndicatorMode` 映射为 `TPullDownRefreshState`，通过 `onStateChanged` 上抛。
- 超时：`onRefresh` 被触发时启动 `Timer(refreshTimeout)`，超时仍未完成则上报一次 `timeout`、调用内部受控完成机制收起 Header 并回到 `inactive`；`onRefresh` 正常返回或失败时只完成当前刷新一次，迟到 Future 不再改变状态。

### 4. 删除 TRefreshHeader 双入口

- 删除旧 `TRefreshHeader` 及其 `TRefreshThemeData`；所需 Header 作为 `TPullDownRefresh` 的内部私有实现，仅保留受控字段：`extent`、`triggerDistance`、`maxOverOffset`、`texts`、`onStateChanged`；背景使用全局 `bgColorContainer` token。
- Loading 样式从 Theme 子树的 `TLoadingThemeData` 继承，公开入口、站点文档与示例统一为 `TPullDownRefresh`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | t_pull_down_refresh.dart / controller / texts | 新增组件 + 内部私有 header |
| 测试 | test/components/refresh/t_refresh_test.dart | 对齐新组件与默认值、状态、超时、触底、受控 |
| 示例 | example/lib/page/t_pull_down_refresh_page.dart | 改用 TPullDownRefresh + 补 demo |
| l10n | example/lib/l10n/app_en.arb | 修正英文缺空格 |
| 站点文档 | tdesign-site/docs/components/pull-down-refresh/README.md | 死链与示例不一致修正 |

## API 变化

- 新增公开类：`TPullDownRefresh`、`TPullDownRefreshController`、`TPullDownRefreshTexts`、`TPullDownRefreshState`（非 breaking）。
- 删除 `TRefreshHeader` / `TRefreshThemeData`，统一迁移到 `TPullDownRefresh`（breaking）。
- 尺寸默认值 48 → 50（潜在视觉 breaking）。

## 风险与取舍

- 封装 easy_refresh 会隐藏部分高级能力（secondary 等），符合"最小 API"目标；确有需求可用 `childBuilder` 等再扩展。
- 超时语义：`refreshTimeout` 默认 `3000ms`（对齐官方），超时自动结束刷新、通过 `onStateChanged(timeout)` 一次性上报并回到 `inactive`；传入 `null` 关闭超时。
- `flutter@3.32.0` 与 `latest`：均为纯 Dart + easy_refresh 交互，不引入新依赖，双版本兼容。

## 验证策略

- Widget 测试：默认渲染 / onRefresh 为空时禁用 / texts / refreshTimeout / onLoadMore / controller / onStateChanged / Theme 子树继承。
- 静态检查：`flutter analyze lib/src/components/refresh test/components/refresh` 0 error/warning。
- 示例：`flutter analyze example/lib/page/t_pull_down_refresh_page.dart`。
- 完整性：`git diff --check`。
