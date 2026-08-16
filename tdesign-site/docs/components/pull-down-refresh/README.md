---
title: PullDownRefresh 下拉刷新
description: 用于快速刷新页面信息,刷新可以是整页刷新也可以是页面的局部刷新。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:easy_refresh/easy_refresh.dart';
```

## 代码演示

[t_refresh_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_refresh_page.dart)


      
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRefresh(BuildContext context) {
    return TPullDownRefresh(
      // 下拉刷新回调
      onRefresh: () {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            count++;
          });
        });
      },
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.tTheme.bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(context.tTheme.radiusLarge))),
              child: TText(
                PlatformUtil.isWeb ? 'Web暂不支持下拉，请下载安装apk体验' : '拖拽该区域演示 顶部下拉刷新',
                font: context.tTheme.fontBodyLarge,
                textColor: context.tTheme.textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.tTheme.bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(context.tTheme.radiusLarge))),
              child: TText(
                '下拉刷新次数：${count}',
                font: context.tTheme.fontBodyLarge,
                textColor: context.tTheme.textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 500),
          ],
        ),
      )),
    );
  }</pre>

</td-code-block>



## API
### TPullDownRefresh
#### 简介
以最小、Flutter 惯用的 API 封装下拉刷新，对齐官方（小程序 / mobile-vue）PullDownRefresh 行为：下拉 → 松手 → 刷新 → 完成四态，支持触底加载、禁用、超时、四态文案自定义与受控刷新。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 滚动内容（必填） |
| onRefresh | FutureOr<void> Function()? | - | 下拉触发刷新回调，为空时禁用刷新 |
| onLoadMore | FutureOr<void> Function()? | - | 触底加载回调，仅在 `enableLoadMore` 且非空时启用 |
| enableLoadMore | bool | false | 是否启用触底加载 |
| disabled | bool | false | 是否禁用下拉刷新 |
| controller | TPullDownRefreshController? | - | 受控刷新 / 加载控制器 |
| texts | TPullDownRefreshTexts? | - | 四态提示语，为空时回退 l10n |
| refreshTimeout | Duration? | - | 刷新超时时长，为空时不启用超时 |
| onTimeout | VoidCallback? | - | 刷新超时回调 |
| loadingBarHeight | double | 50 | Header 容器高度 = 触发阈值 |
| maxBarHeight | double | 80 | 最大下拉高度 |
| loadingTheme | TLoadingThemeData? | - | loading 指示器样式 |
| backgroundColor | Color? | - | Header 背景色 |
| onStateChanged | ValueChanged<TPullDownRefreshState>? | - | 刷新状态变化回调 |

### TPullDownRefreshController

受控控制器，对应官方受控 `value` 语义。方法：`refresh()` / `loadMore()` / `finishRefresh()` / `finishLoadMore()` / `reset()`。

### TPullDownRefreshTexts

四态提示语：`pullToRefresh` / `releaseToRefresh` / `refreshing` / `refreshComplete`，缺省回退 l10n。

### TRefreshHeader（低层，向后兼容）
#### 简介
TDesign刷新头部
结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| clamping | bool? | - | - |
| completeDuration | Duration? | - | 完成延时 |
| enableHapticFeedback | bool | true | 开启震动反馈 |
| enableInfiniteRefresh | bool | false | 是否开启无限刷新 |
| extent | double? | 48.0 | Header容器高度 |
| float | bool | false | 是否悬浮 |
| frictionFactor | - | - | - |
| hapticFeedback | bool? | - | - |
| hitOver | - | - | - |
| horizontalFrictionFactor | - | - | - |
| horizontalReadySpringBuilder | - | - | - |
| horizontalSpring | - | - | - |
| infiniteHitOver | bool? | - | - |
| infiniteOffset | double? | - | 无限刷新偏移量 |
| key | Key? | - | Key |
| listenable | - | - | - |
| loadingIcon | TLoadingIcon | TLoadingIcon.circle | loading样式 |
| maxOverOffset | - | - | - |
| notifyWhenInvisible | - | - | - |
| overScroll | bool | true | 越界滚动(`enableInfiniteRefresh`为true或`infiniteOffset`有值时生效) |
| position | - | - | - |
| processedDuration | Duration? | - | - |
| readySpringBuilder | - | - | - |
| safeArea | - | false | - |
| secondaryCloseTriggerOffset | - | - | - |
| secondaryDimension | - | - | - |
| secondaryTriggerOffset | - | - | - |
| secondaryVelocity | - | - | - |
| spring | - | - | - |
| springRebound | - | - | - |
| triggerDistance | double | 48.0 | 触发刷新任务的偏移量,同`triggerOffset` |
| triggerOffset | double? | - | - |
| triggerWhenReach | - | - | - |
| triggerWhenRelease | - | - | - |
| triggerWhenReleaseNoWait | - | - | - |


