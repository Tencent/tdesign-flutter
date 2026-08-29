---
title: Rate 评分
description: 用于对某行为或事物进行打分。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

完整示例见 [t_rate_page.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/t_rate_page.dart)。

## 基础用法

`TRate` 是严格受控组件。`value` 是唯一评分状态源，`onChanged` 为 null 时组件禁用。

```dart
class RateExample extends StatefulWidget {
  const RateExample({super.key});

  @override
  State<RateExample> createState() => _RateExampleState();
}

class _RateExampleState extends State<RateExample> {
  double value = 3;

  @override
  Widget build(BuildContext context) => TRate(
    value: value,
    onChanged: (next) => setState(() => value = next),
  );
}
```

## 半星

```dart
TRate(
  value: value,
  allowHalf: true,
  onChanged: (next) => setState(() => value = next),
)
```

点击半星评分后会显示半星与整星选择浮层。拖动和读屏增减的步长同样为 `0.5`。

## 辅助文案

`texts` 是辅助文案是否显示及显示内容的唯一入口：null 时不显示，非 null 时显示。0 分或没有对应档位时显示本地化的“未评分”。

```dart
TRate(
  value: value,
  texts: const ['极差', '失望', '一般', '满意', '惊喜'],
  onChanged: (next) => setState(() => value = next),
)
```

半星仍按五档文案解析，例如 `2` 与 `2.5` 都对应第二档；读屏语义会同时保留精确数值，能够区分两个评分。

## 自定义图标

图标 builder 会同时用于主评分和半星选择浮层。通过 `filled` 区分选中与未选中图标，并可继承组件提供的 `IconTheme` 尺寸和颜色。

```dart
TRate(
  value: value,
  icon: (filled) => const Icon(TIcons.thumb_up),
  onChanged: (next) => setState(() => value = next),
)
```

## 数量与样式

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TRateThemeData(
      iconSize: 20,
      iconGap: 4,
      starColor: Color(0xFF00A870),
    ),
  ),
  child: TRate(
    value: value,
    count: 3,
    onChanged: (next) => setState(() => value = next),
  ),
)
```

## 从 1.0.0-alpha.1 迁移

`TRateThemeData.showText` 已移除。内容是否显示不再由 Theme 控制：

```dart
// 旧写法
Theme(
  data: Theme.of(context).mergeExtension(
    const TRateThemeData(showText: true),
  ),
  child: TRate(value: value, texts: texts),
)

// 新写法
TRate(value: value, texts: texts)
```

- 需要显示文案：向 `TRate.texts` 传入非 null 列表；
- 不显示文案：保持 `TRate.texts` 为 null；
- 文案的 `textStyle`、`textGap`、`textWidth` 仍由 `TRateThemeData` 控制。

## API

### TRate

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| value | double | 必填 | 唯一的受控评分值，范围为 0 到 count；整星模式下小数向下归一化 |
| onChanged | ValueChanged<double>? | - | 评分变化回调；为 null 时禁用 |
| onChangeStart | ValueChanged<double>? | - | 一次指针或语义交互开始时触发一次 |
| onChangeEnd | ValueChanged<double>? | - | 一次交互结束时触发一次；指针取消时返回当前受控值 |
| count | int | 5 | 评分项数量，必须大于 0 |
| allowHalf | bool | false | 是否允许半星 |
| icon | TRateIconBuilder? | - | 自定义选中与未选中图标 |
| texts | List<String>? | - | 各评分档位的辅助文案；null 时不显示 |

### TRateIconBuilder

```dart
typedef TRateIconBuilder = Widget Function(bool filled);
```

### TRateThemeData

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| starColor | Color? | 选中星标颜色 |
| inactiveStarColor | Color? | 未选中星标颜色 |
| iconSize | double? | 图标尺寸 |
| iconGap | double? | 图标间距 |
| textWidth | double? | 文案最大布局宽度；未设置时在有界父布局内使用剩余宽度 |
| textGap | double? | 图标与文案间距 |
| textStyle | TextStyle? | 文案样式 |
| overlayBoxShadow | List<BoxShadow>? | 半星选择浮层阴影 |
