## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TEmpty
#### 简介
用于空数据、网络异常和操作引导的空状态组件。
### 主题配置
组件主题通过 `TEmptyThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TEmptyThemeData` 说明。

#### 声明

```dart
class TEmpty extends StatelessWidget
```

#### 默认构造方法


```dart
const TEmpty({
  this.icon = TIcons.info_circle_filled,
  this.image,
  this.emptyText,
  this.operation,
  Key? key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| emptyText | String? | - | 描述文字。 | 否 |
| icon | IconData? | TIcons.info_circle_filled | 默认图标；image 非空时不显示，显式 null 仍回退为 info_circle_filled。 | 否 |
| image | Widget? | - | 自定义图片或插画；优先于 `icon`。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| operation | Widget? | - | 描述下方的操作内容，通常为按钮。 | 否 |


### TEmptyThemeData
#### 简介
空态组件级 ThemeExtension

#### 声明

```dart
class TEmptyThemeData extends ThemeExtension<TEmptyThemeData>
```

#### 默认构造方法


```dart
const TEmptyThemeData({this.emptyTextColor, this.emptyTextFont})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| emptyTextColor | Color? | - | 描述文字颜色 未配置时使用 textColorPlaceholder Token。 | 否 |
| emptyTextFont | Font? | - | 描述文字字号 未配置时使用 fontBodyMedium Token。 | 否 |


#### 实例方法

##### TEmptyThemeData.copyWith

```dart
TEmptyThemeData copyWith({Color? emptyTextColor, Font? emptyTextFont})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TEmptyThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| emptyTextColor | Color? | - | 描述文字颜色 未配置时使用 textColorPlaceholder Token。 | 否 |
| emptyTextFont | Font? | - | 描述文字字号 未配置时使用 fontBodyMedium Token。 | 否 |


##### TEmptyThemeData.lerp

```dart
TEmptyThemeData lerp(ThemeExtension<TEmptyThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TEmptyThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TEmptyThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |
