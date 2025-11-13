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
import 'package:easy_refresh/easy_refresh.dart';
```

## 代码演示

[td_refresh_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_refresh_page.dart)


      
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRefresh(BuildContext context) {
    return EasyRefresh(
      // 下拉样式
      header: TDRefreshHeader(),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // spacing: 16,
          children: [
            Container(
              height: 171,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TDTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(TDTheme.of(context).radiusLarge))),
              child: TDText(
                PlatformUtil.isWeb ? 'Web暂不支持下拉，请下载安装apk体验' : '拖拽该区域演示 顶部下拉刷新',
                font: TDTheme.of(context).fontBodyLarge,
                textColor: TDTheme.of(context).textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TDTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(TDTheme.of(context).radiusLarge))),
              child: TDText(
                '下拉刷新次数：${count}',
                font: TDTheme.of(context).fontBodyLarge,
                textColor: TDTheme.of(context).textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 500),
          ],
        ),
      )),
      // 下拉刷新回调
      onRefresh: () {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            count++;
          });
        });
      },
    );
  }</pre>

</td-code-block>
                


## API
### TDRefreshHeader
#### 简介
TDesign刷新头部
 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| clamping |  | - |  |
| completeDuration | Duration? | - | 完成延时 |
| enableHapticFeedback | bool | true | 开启震动反馈 |
| enableInfiniteRefresh | bool | false | 是否开启无限刷新 |
| extent | double? | 48.0 | Header容器高度 |
| float | bool | false | 是否悬浮 |
| frictionFactor |  | - |  |
| hapticFeedback |  | - |  |
| hitOver |  | - |  |
| horizontalFrictionFactor |  | - |  |
| horizontalReadySpringBuilder |  | - |  |
| horizontalSpring |  | - |  |
| infiniteHitOver |  | - |  |
| infiniteOffset | double? | - | 无限刷新偏移量 |
| key | Key? | - | Key |
| listenable |  | - |  |
| loadingIcon | TDLoadingIcon | TDLoadingIcon.circle | loading样式 |
| maxOverOffset |  | - |  |
| notifyWhenInvisible |  | - |  |
| overScroll | bool | true | 越界滚动([enableInfiniteRefresh]为true或[infiniteOffset]有值时生效) |
| position |  | - |  |
| processedDuration |  | - |  |
| readySpringBuilder |  | - |  |
| safeArea |  | false |  |
| secondaryCloseTriggerOffset |  | - |  |
| secondaryDimension |  | - |  |
| secondaryTriggerOffset |  | - |  |
| secondaryVelocity |  | - |  |
| spring |  | - |  |
| springRebound |  | - |  |
| triggerDistance | double | 48.0 | 触发刷新任务的偏移量，同[triggerOffset] |
| triggerOffset |  | - |  |
| triggerWhenReach |  | - |  |
| triggerWhenRelease |  | - |  |
| triggerWhenReleaseNoWait |  | - |  |


  