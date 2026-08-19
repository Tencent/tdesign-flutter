---
title: PullDownRefresh 下拉刷新
description: 用于快速刷新页面信息，刷新可以是整页刷新也可以是页面的局部刷新。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_pull_down_refresh_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_pull_down_refresh_page.dart)

### 顶部下拉刷新

基础用法与小程序公开 Demo 对应：大骨架、三组双列骨架和中央刷新提示。移动端下拉触发；Web 预览点击中央提示区域触发。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRefresh(BuildContext context) {
    return SizedBox(
      height: 620,
      child: TPullDownRefresh(
        controller: _controller,
        // 下拉刷新回调
        onRefresh: () =>
            Future<void>.delayed(const Duration(milliseconds: 1500)),
        child: _buildOfficialDemoContent(context),
      ),
    );
  }</pre>

</td-code-block>

### 自定义提示语

通过 `texts` 覆盖四态提示语（对应官方 `loadingTexts`）。

> **说明**：本 Demo 为小程序已有公开 props（`loadingTexts`）的新增 API 演示，Demo 形态仅参考 Mobile Vue，不表示小程序现有公开 Demo。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLoadingTexts(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        loadingBarHeight: 70,
        maxBarHeight: 100,
        texts: const TPullDownRefreshTexts(
          pullToRefresh: '下拉即可刷新...',
          releaseToRefresh: '释放即可刷新...',
          refreshing: '加载中...',
          refreshComplete: '刷新成功',
        ),
        onRefresh: () {
          return Future<void>.delayed(const Duration(seconds: 1), () {
            setState(() {
              loadingTextsCount++;
            });
          });
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _demoHint(context, '下拉刷新'),
            const SizedBox(height: 16),
            _demoHint(context, '自定义提示语刷新次数：${loadingTextsCount}'),
          ],
        ),
      ),
    );
  }</pre>

</td-code-block>

### 刷新超时

通过 `refreshTimeout` 与 `onStateChanged` 的 `timeout` 状态在刷新超时时给出提示并自动结束。

> **说明**：本 Demo 为小程序已有公开 props（`refreshTimeout` + `timeout`）的新增 API 演示，Demo 形态仅参考 Mobile Vue，不表示小程序现有公开 Demo。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTimeout(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        refreshTimeout: const Duration(seconds: 1),
        onStateChanged: (state) {
          if (state == TPullDownRefreshState.timeout) {
            TToast.showText('已超时', context: context);
          }
        },
        onRefresh: () {
          // 模拟长时间未完成的刷新，等待超时回调。
          return Completer<void>().future;
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _demoHint(context, '下拉刷新'),
            const SizedBox(height: 16),
            _demoHint(context, '超时刷新次数：${timeoutCount}'),
          ],
        ),
      ),
    );
  }</pre>

</td-code-block>

### TPullDownRefresh
#### 简介
以最小、Flutter 惯用的 API 封装下拉刷新，对齐官方（小程序 / mobile-vue）PullDownRefresh 行为：下拉 → 松手 → 刷新 → 完成四态，支持触底加载、禁用、超时、四态文案自定义与受控刷新。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 滚动内容（必填） |
| onRefresh | FutureOr<void> Function()? | - | 下拉触发刷新回调，为空时禁用刷新 |
| onLoadMore | FutureOr<void> Function()? | - | 触底加载回调，非空时自动启用；不绘制额外 Footer UI |
| lowerThreshold | double | 50 | 距离底部多少逻辑像素时触发加载 |
| controller | TPullDownRefreshController? | - | 从页面外部主动触发刷新的控制器 |
| texts | TPullDownRefreshTexts? | - | 四态提示语，为空时回退 l10n |
| refreshTimeout | Duration? | 3000ms | 刷新超时时长，超过时长自动结束并上报 timeout 状态；传 null 关闭 |
| loadingBarHeight | double | 50 | Header 容器高度 = 触发阈值 |
| maxBarHeight | double | 80 | 最大下拉高度 |
| successDuration | Duration | 500ms | 刷新完成提示展示时长 |
| onStateChanged | ValueChanged<TPullDownRefreshState>? | - | 刷新状态变化回调 |

### TPullDownRefreshController

外部刷新控制器，仅提供 `refresh()`。刷新完成由 `onRefresh` 返回的 Future 统一决定，无需调用方释放。

Loading 指示器样式自动继承 Flutter Theme 子树中的 `TLoadingThemeData`，组件仅固定横向排列。

### TPullDownRefreshTexts

四态提示语：`pullToRefresh` / `releaseToRefresh` / `refreshing` / `refreshComplete`，缺省回退 l10n。
