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
      header: TRefreshHeader(),
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
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(TTheme.of(context).radiusLarge))),
              child: TText(
                PlatformUtil.isWeb ? 'Web暂不支持下拉，请下载安装apk体验' : '拖拽该区域演示 顶部下拉刷新',
                font: TTheme.of(context).fontBodyLarge,
                textColor: TTheme.of(context).textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(TTheme.of(context).radiusLarge))),
              child: TText(
                '下拉刷新次数：${count}',
                font: TTheme.of(context).fontBodyLarge,
                textColor: TTheme.of(context).textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 500),
          ],
        ),
      )),
      // 下拉刷新回调
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          count++;
        });
      },
    );
  }</pre>

</td-code-block>
                


## API
### TRefreshHeader
#### 简介
TDesign刷新头部
结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | Header 背景颜色。 |
| completeDuration | Duration? | - | 完成状态停留时长。 |
| enableHapticFeedback | bool | true | 是否启用震动反馈。 |
| extent | double? | 48.0 | Header 容器高度。 |
| float | bool? | false | 是否悬浮展示刷新头。 |
| hapticFeedback | bool? | - | 是否启用震动反馈；为空时使用 `enableHapticFeedback`。 |
| key | Key? | - | Key |
| loadingIcon | TLoadingIcon? | TLoadingIcon.circle | loading 样式。 |
| overScroll | bool? | true | 是否允许越界滚动。 |
| position | IndicatorPosition | IndicatorPosition.above | 刷新头位置。 |
| processedDuration | Duration? | - | 刷新完成后的处理动画时长。 |
| triggerDistance | double? | 48.0 | 触发刷新任务的偏移量。 |

> 说明：TDesign 层仅暴露视觉参数与最常用行为参数；高级能力（弹簧配置、二楼、无限刷新、triggerWhen* 等）请直接使用 `easy_refresh` 原生 `Header`。


  