## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TThemeData

#### 声明

```dart
class TThemeData extends ThemeExtension<TThemeData>
```


#### 静态方法

##### TThemeData.defaultData

```dart
static TThemeData defaultData({TExtraThemeData? extraThemeData})
```


获取默认Data，一个App里只有一个，用于没有context的地方

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| extraThemeData | TExtraThemeData? | - | - | 否 |


##### TThemeData.fromJson

```dart
static TThemeData? fromJson(
  String name,
  String themeJson, {
  String? darkName,
  bool recoverDefault = false,
  TExtraThemeData? extraThemeData,
})
```


解析配置的json文件为主题数据

返回类型：`TThemeData?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 主题名称，目前只支持一级键 | 是 |
| themeJson | String | - | 主题json字符串，要求json配置必须正确 | 是 |
| darkName | String? | - | 暗色主题名称；为空时使用 `${name}Dark`。 | 否 |
| recoverDefault | bool | false | 是否恢复为默认主题数据 | 否 |
| extraThemeData | TExtraThemeData? | - | 额外扩展的主题数据 | 否 |

#### 默认构造方法


```dart
TThemeData({
  required this.name,
  required this.colorMap,
  required this.fontMap,
  TMap<String, double>? fontMetricMap,
  required this.radiusMap,
  required this.fontFamilyMap,
  required this.shadowMap,
  TMap<String, BorderSide>? insetShadowMap,
  required this.spacerMap,
  required this.refMap,
  this.extraThemeData,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| colorMap | TMap&lt;String, Color&gt; | - | 颜色 | 是 |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 | 否 |
| fontFamilyMap | TMap&lt;String, FontFamily&gt; | - | 字体样式 | 是 |
| fontMap | TMap&lt;String, Font&gt; | - | 字体尺寸 | 是 |
| fontMetricMap | TMap&lt;String, double&gt;? | - | 小程序独立字号与行高 Token，单位为 Flutter 逻辑像素。 | 否 |
| insetShadowMap | TMap&lt;String, BorderSide&gt;? | - | 小程序 blur=0 的内投影在 Flutter 中对应的内侧边线。 | 否 |
| name | String | - | 名称 | 是 |
| radiusMap | TMap&lt;String, double&gt; | - | 圆角 | 是 |
| refMap | TMap&lt;String, String&gt; | - | 映射关系 | 是 |
| shadowMap | TMap&lt;String, List&lt;BoxShadow&gt;&gt; | - | 阴影 | 是 |
| spacerMap | TMap&lt;String, double&gt; | - | 间隔 | 是 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dark | TThemeData? | - | 暗色主题 |
| light | TThemeData | - | 亮色主题 |


#### 实例方法

##### TThemeData.copyWith

```dart
TThemeData copyWith({
  String? name,
  Map<String, Color>? colorMap,
  Map<String, Font>? fontMap,
  Map<String, double>? fontMetricMap,
  Map<String, double>? radiusMap,
  Map<String, FontFamily>? fontFamilyMap,
  Map<String, List<BoxShadow>>? shadowMap,
  Map<String, BorderSide>? insetShadowMap,
  Map<String, double>? spacerMap,
  TExtraThemeData? extraThemeData,
})
```


复制 Token 主题并合并非空映射，返回具体的 `TThemeData`。
未传入的映射值、名称和扩展数据保留。

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String? | - | 名称 | 否 |
| colorMap | Map&lt;String, Color&gt;? | - | 颜色 | 否 |
| fontMap | Map&lt;String, Font&gt;? | - | 字体尺寸 | 否 |
| fontMetricMap | Map&lt;String, double&gt;? | - | 小程序独立字号与行高 Token，单位为 Flutter 逻辑像素。 | 否 |
| radiusMap | Map&lt;String, double&gt;? | - | 圆角 | 否 |
| fontFamilyMap | Map&lt;String, FontFamily&gt;? | - | 字体样式 | 否 |
| shadowMap | Map&lt;String, List&lt;BoxShadow&gt;&gt;? | - | 阴影 | 否 |
| insetShadowMap | Map&lt;String, BorderSide&gt;? | - | 小程序 blur=0 的内投影在 Flutter 中对应的内侧边线。 | 否 |
| spacerMap | Map&lt;String, double&gt;? | - | 间距 Token 的增量映射；非空值覆盖同名 Token，其他间距沿用当前配置。 | 否 |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 | 否 |


##### TThemeData.lerp

```dart
TThemeData lerp(ThemeExtension<TThemeData>? other, double t)
```


返回目标 Token 配置；other 为空或类型不匹配时保留当前主题。
当前实现不使用 t 连续插值，也不复制目标 extraThemeData。

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


##### TThemeData.ofExtra

```dart
T? ofExtra<T extends TExtraThemeData>()
```


读取指定类型的业务扩展主题；未配置或类型不匹配时返回 null。

返回类型：`T?`

### DefaultMapFactory
#### 类型定义

```dart
typedef DefaultMapFactory = TMap? Function();
```
