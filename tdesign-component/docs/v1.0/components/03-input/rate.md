# TRate

> 状态：已完成 | 控制类型：严格受控 | Sprint：S3

`TRate` 用于对内容进行评分。组件不保存业务评分，显示值始终由 `value` 决定。

## 架构

| 项 | v1.0 方案 |
|---|---|
| 状态 | `value` + `onChanged` 严格受控 |
| 禁用 | `onChanged == null` |
| 实现 | 基于 Flutter 手势与图标裁剪实现 |
| 主题 | `TRateThemeData` ThemeExtension |
| Token | 未配置组件主题时读取 `TThemeData` |

## API

### TRate

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `double` | 必填 | 当前评分，范围为 `0..count` |
| `onChanged` | `ValueChanged<double>?` | `null` | 评分变化回调；为 `null` 时禁用 |
| `onChangeStart` | `ValueChanged<double>?` | `null` | 开始交互时触发 |
| `onChangeEnd` | `ValueChanged<double>?` | `null` | 结束交互时触发 |
| `count` | `int` | `5` | 评分项数量 |
| `allowHalf` | `bool` | `false` | 是否允许用户选择半星；点击后展示当前星级的半星/整星选择器。 |
| `icon` | `TRateIconBuilder?` | `null` | 自定义选中与未选中图标 |
| `texts` | `List<String>?` | `null` | 各评分对应文案 |

`TRateIconBuilder` 的签名为 `Widget Function(bool filled)`。半星由组件裁剪选中图标，builder 只需分别返回选中和未选中状态。

启用 `allowHalf` 后，点击星标会先按点击位置更新受控值，再显示该星级的 `x.5` 与 `x.0` 选择器；选择器外部点击会保留首次选择并结束交互。拖动评分时直接连续更新，不显示选择器。

### 文案索引

- `texts.length >= count * 2` 时按半星档位读取文案。
- 其他情况下按整星档位读取文案。
- `value == 0`、文案为空或索引越界时显示评分数值。
- 是否显示文案由 `TRateThemeData.showText` 控制。

## Theme

| 字段 | 类型 | 说明 |
|---|---|---|
| `starColor` | `Color?` | 选中图标颜色 |
| `inactiveStarColor` | `Color?` | 未选中图标颜色 |
| `iconSize` | `double?` | 图标尺寸 |
| `iconGap` | `double?` | 图标间距 |
| `showText` | `bool?` | 是否显示评分文案 |
| `textWidth` | `double?` | 文案区域宽度 |
| `textGap` | `double?` | 图标与文案间距 |
| `textStyle` | `TextStyle?` | 文案样式 |

子树主题覆盖：

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TRateThemeData(
      starColor: Colors.green,
      iconSize: 28,
      showText: true,
    ),
  ),
  child: TRate(
    value: value,
    onChanged: (next) => setState(() => value = next),
  ),
)
```

## 示例

```dart
TRate(
  value: value,
  allowHalf: true,
  onChangeStart: (value) {},
  onChanged: (next) => setState(() => value = next),
  onChangeEnd: (value) {},
)
```

禁用状态只通过移除 `onChanged` 表达：

```dart
const TRate(value: 3)
```

## 验收

- 受控值、点击、拖动和半星选择均有测试。
- `onChanged == null` 时不安装交互回调并使用禁用 Token。
- 自定义图标、评分文案和 ThemeExtension 均有测试。
- 源码、测试和示例通过定向 analyze。
- Rate 源码行覆盖率为 100%。
