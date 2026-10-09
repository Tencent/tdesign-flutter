## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TThemeData
#### 简介
主题数据

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
## 返回值
全局默认 Token 主题；首次调用时创建并缓存，后续调用返回同一默认主题。

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| extraThemeData | TExtraThemeData? | - | 扩展主题数据；默认主题仅在首次初始化时读取。 | 否 |


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


解析主题 JSON；空字符串、格式错误或缺少 name 对应配置时返回 null。
## 返回值
解析成功的 Token 主题；空字符串、格式错误或缺少指定配置时为 null。

返回类型：`TThemeData?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 主题名称，目前只支持一级键 | 是 |
| themeJson | String | - | 主题json字符串，要求json配置必须正确 | 是 |
| darkName | String? | - | 暗色主题名称；为空时使用 `${name}Dark`。 | 否 |
| recoverDefault | bool | false | 解析成功后是否将结果设为全局默认主题，默认 false | 否 |
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
| fontMetricMap | TMap&lt;String, double&gt;? | - | 独立字号与行高 Token，单位为 Flutter 逻辑像素。 | 否 |
| insetShadowMap | TMap&lt;String, BorderSide&gt;? | - | 内投影对应的定向内侧边线。 | 否 |
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


复制主题配置。
## 返回值
复制 Token 主题并合并传入的映射；未传入的映射值沿用当前配置。
name 和 extraThemeData 为空时保留当前名称和扩展数据。

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String? | - | 名称 | 否 |
| colorMap | Map&lt;String, Color&gt;? | - | 颜色 | 否 |
| fontMap | Map&lt;String, Font&gt;? | - | 字体尺寸 | 否 |
| fontMetricMap | Map&lt;String, double&gt;? | - | 独立字号与行高 Token，单位为 Flutter 逻辑像素。 | 否 |
| radiusMap | Map&lt;String, double&gt;? | - | 圆角 | 否 |
| fontFamilyMap | Map&lt;String, FontFamily&gt;? | - | 字体样式 | 否 |
| shadowMap | Map&lt;String, List&lt;BoxShadow&gt;&gt;? | - | 阴影 | 否 |
| insetShadowMap | Map&lt;String, BorderSide&gt;? | - | 内投影对应的定向内侧边线。 | 否 |
| spacerMap | Map&lt;String, double&gt;? | - | 间距 Token 的增量映射；传入值覆盖同名 Token，其他值沿用当前配置。 | 否 |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 | 否 |


##### TThemeData.lerp

```dart
TThemeData lerp(ThemeExtension<TThemeData>? other, double t)
```


在当前主题与目标主题间生成过渡配置。
t 为 0 或 1 时返回对应端点；目标为空时返回当前主题。
颜色、字号、行高、圆角、阴影和间距按有效 Token 值插值，
单侧存在的 Token 保留；名称、字体族、业务扩展和明暗关联在 t=0.5 切换。
相同且未显式覆盖的 Token 引用继续沿用，其他值保存在新的映射中。
## 返回值
两端之间的 Token 主题；端点返回原主题，中间值返回独立映射。

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TThemeData&gt;? | - | 目标主题；为空或类型不匹配时返回当前主题。 | 是 |
| t | double | - | 过渡进度；0 为当前主题，1 为目标主题，离散配置在 0.5 切换。 | 是 |


### Font
#### 简介
字体宽高数据

#### 声明

```dart
class Font
```


#### 工厂构造方法

##### Font.fromJson

```dart
factory Font.fromJson(Map<String, dynamic> map)
```


| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| map | Map&lt;String, dynamic&gt; | - | 字体 JSON 配置，包含 size、lineHeight 和可选的 fontWeight（1 至 9，默认 4）。 | 是 |

#### 默认构造方法


```dart
Font({
  required int size,
  required int lineHeight,
  this.fontWeight = FontWeight.w400,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| fontWeight | FontWeight | FontWeight.w400 | 字重，默认 FontWeight.w400。 | 否 |
| lineHeight | int | - | 行高，单位为逻辑像素；构造后转换为相对于字号的比例。 | 是 |
| size | int | - | 字体大小，单位为逻辑像素。 | 是 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| height | double | - | 行高与字号的比值，用于 TextStyle.height；构造时按 lineHeight / size 计算。 |


### FontFamily
#### 简介
字体样式

#### 声明

```dart
class FontFamily
```


#### 工厂构造方法

##### FontFamily.fromJson

```dart
factory FontFamily.fromJson(Map<String, dynamic> map)
```


| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| map | Map&lt;String, dynamic&gt; | - | 字体栈 JSON 配置，包含 fontFamily、可选 package 和 fallback。 | 是 |

#### 默认构造方法


```dart
FontFamily({required this.fontFamily, this.package, this.fallback})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| fallback | List&lt;String&gt;? | - | 主字体不可用时按顺序尝试的备用字体名称。 | 否 |
| fontFamily | String | - | 主字体名称。 | 是 |
| package | String? | - | 字体所在资源包；为空时从应用或系统字体解析。 | 否 |


### TResourceManager
#### 简介
资源管理器

#### 声明

```dart
class TResourceManager
```

#### 默认构造方法


```dart
TResourceManager()
```

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| instance | TResourceManager | - | 单例对象 |


#### 实例方法

##### TResourceManager.delegate

```dart
TResourceDelegate delegate(BuildContext context)
```


获取资源
## 返回值
当前上下文的资源代理；构建器不存在或返回 null 时使用默认资源代理。

返回类型：`TResourceDelegate`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |


##### TResourceManager.setResourceBuilder

```dart
void setResourceBuilder(TResourceBuilder delegate, needAlwaysBuild)
```


设置资源代理

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| delegate | TResourceBuilder | - | 根据构建上下文提供资源代理的回调。 | 是 |
| needAlwaysBuild | dynamic | - | 是否每次读取资源时调用构建器；false 时复用首次成功构建的缓存，返回 null 时继续尝试构建。 | 是 |


### TResourceDelegate
#### 简介
资源管理器，允许外部重写，设计成抽象类，防止有新增字段时，用户没有感知

#### 声明

```dart
abstract class TResourceDelegate
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| april | String | - | `TCalendar` 四月 |
| august | String | - | `TCalendar` 八月 |
| back | String | - | `TBackTop` 返回 |
| badgeZero | String | - | `TBadge`为0时的默认文案 |
| cancel | String | - | TDialog等 取消 |
| cascadeLabel | String | - | `TRate` 选择选项 |
| close | String | - | `TSwitch`的关闭状态文案 |
| completeRefresh | String | - | `TPullDownRefresh` 刷新完成 |
| confirm | String | - | TDialog等 确认 |
| dateLabel | String | - | 日 |
| days | String | - | `TTimeCounter` 天 |
| december | String | - | `TCalendar` 十二月 |
| emptyData | String | - | `TTable` 空数据 |
| end | String | - | `TCalendar` 结束 |
| february | String | - | `TCalendar` 二月 |
| friday | String | - | `TCalendar` 星期五 |
| hours | String | - | `TTimeCounter` 时 |
| january | String | - | `TCalendar` 一月 |
| july | String | - | `TCalendar` 七月 |
| june | String | - | `TCalendar` 六月 |
| knew | String | - | `TConfirmDialog` 知道了 |
| loading | String | - | `TLoading` 加载中 |
| loadingWithPoint | String | - | `TToast` 加载中... |
| march | String | - | `TCalendar` 三月 |
| may | String | - | `TCalendar` 五月 |
| milliseconds | String | - | `TTimeCounter` 毫秒 |
| minutes | String | - | `TTimeCounter` 分 |
| monday | String | - | `TCalendar` 星期一 |
| monthLabel | String | - | 月 |
| notRated | String | - | `TRate` 未评分 |
| november | String | - | `TCalendar` 十一月 |
| october | String | - | `TCalendar` 十月 |
| open | String | - | `TSwitch`的打开状态文案 |
| other | String | - | `TDropdownMenu` 其他 |
| picker | String | - | `TPicker` 整组无障碍容器 label |
| pullToRefresh | String | - | `TPullDownRefresh` 下拉刷新 |
| refreshing | String | - | `TPullDownRefresh` 正在刷新 |
| releaseRefresh | String | - | `TPullDownRefresh` 松手刷新 |
| reset | String | - | `TDropdownMenu` 重置 |
| saturday | String | - | `TCalendar` 星期六 |
| seconds | String | - | `TTimeCounter` 秒 |
| september | String | - | `TCalendar` 九月 |
| start | String | - | `TCalendar` 开始 |
| sunday | String | - | `TCalendar` 星期日 |
| thursday | String | - | `TCalendar` 星期四 |
| time | String | - | `TCalendar` 时间 |
| top | String | - | `TBackTop` 顶部 |
| tuesday | String | - | `TCalendar` 星期二 |
| uploadFailed | String | - | `TUpload` 上传失败。 |
| uploading | String | - | `TUpload` 上传中。 |
| uploadPending | String | - | `TUpload` 待上传状态。 |
| uploadRetry | String | - | `TUpload` 重新上传。 |
| uploadSelect | String | - | `TUpload` 选择文件的无障碍标签。 |
| uploadSuccess | String | - | `TUpload` 上传成功。 |
| wednesday | String | - | `TCalendar` 星期三 |
| weeksLabel | String | - | 周 |
| year | String | - | `TCalendar` 年 |
| yearLabel | String | - | 年 |


#### 实例方法

##### TResourceDelegate.pickerColumn

```dart
String pickerColumn(int colIndex)
```


`TPicker` 第 `colIndex` 列（1-based）的无障碍 label
## 返回值
第 colIndex 列的本地化无障碍标签；列序号从 1 开始。

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| colIndex | int | - | 从 1 开始的滚轮列序号。 | 是 |


### TStyleResolver
#### 简介
TDesign 样式解析器。
实例显式样式、组件 Theme 和全局 Token 是单向样式链。
用法：

#### 声明

```dart
class TStyleResolver
```


#### 静态方法

##### TStyleResolver.of

```dart
static TStyleResolver of(BuildContext context)
```


创建解析器实例
## 返回值
绑定当前 context 的样式解析器。

返回类型：`TStyleResolver`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| token | TThemeData | - | 全局设计 Token（色板 / 间距原始值）。 |


#### 实例方法

##### TStyleResolver.componentExtension

```dart
E? componentExtension<E extends ThemeExtension<E>>()
```


组件 ThemeExtension。
## 返回值
上下文主题中的指定 ThemeExtension；未配置时为 null。

返回类型：`E?`

### TMaterialThemeBuilder
#### 简介
Token → 完整 ThemeData 的构建器
将 `TThemeData` 的颜色与字体映射为 Material 配色、文字样式和组件主题，
同时保留该 Token 主题作为 ThemeExtension。
通常不直接使用，通过 `TThemeBuilder.light` / `TThemeBuilder.dark` 入口。

#### 声明

```dart
class TMaterialThemeBuilder
```

#### 默认构造方法


```dart
const TMaterialThemeBuilder(this.token)
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| token | TThemeData | - | Token 数据源 | 是 |


#### 实例方法

##### TMaterialThemeBuilder.buildDark

```dart
ThemeData buildDark()
```


构建暗色 ThemeData
## 返回值
由暗色 Token 构建的 Material ThemeData；无暗色配置时回退当前 Token。

返回类型：`ThemeData`

##### TMaterialThemeBuilder.buildLight

```dart
ThemeData buildLight()
```


构建亮色 ThemeData
## 返回值
由亮色 Token 构建的 Material ThemeData。

返回类型：`ThemeData`

### TThemeBuilder
#### 简介
应用入口：Token → 完整 ThemeData
对齐 `MaterialApp.theme` / `darkTheme` / `themeMode` 三参数模式。
用法：

#### 声明

```dart
class TThemeBuilder
```


#### 静态方法

##### TThemeBuilder.dark

```dart
static ThemeData dark(TThemeData token)
```


暗色主题
## 返回值
由指定 Token 构建的暗色 Material ThemeData。

返回类型：`ThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| token | TThemeData | - | 用于构建完整 Material 主题的 Token 数据源。 | 是 |


##### TThemeBuilder.light

```dart
static ThemeData light(TThemeData token)
```


亮色主题
## 返回值
由指定 Token 构建的亮色 Material ThemeData。

返回类型：`ThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| token | TThemeData | - | 用于构建完整 Material 主题的 Token 数据源。 | 是 |


### TExtraThemeData
#### 简介
扩展主题数据

#### 声明

```dart
abstract class TExtraThemeData
```


#### 实例方法

##### TExtraThemeData.parse

```dart
void parse(String name, Map<String, dynamic> curThemeMap)
```


解析json

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 待解析主题的名称。 | 是 |
| curThemeMap | Map&lt;String, dynamic&gt; | - | 当前主题对应的已解析 JSON 映射。 | 是 |


### TMap
#### 简介
自定义Map

#### 声明

```dart
class TMap<K, V> extends DelegatingMap<K, V>
```

#### 默认构造方法


```dart
TMap({this.factory, this.refs})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| factory | DefaultMapFactory? | - | 查不到本地值或引用值时获取默认映射的回调；为空时不使用默认映射。 | 否 |
| refs | TMap? | - | Token 名称到引用名称的映射；本地显式值优先于引用，循环引用会中止该引用链的解析。 | 否 |


#### 实例方法

##### TMap.[]

```dart
V? operator [](Object? key)
```


读取 Token 值：依次尝试本地显式值、引用链和默认映射。
循环引用会中止该引用链；仍可尝试默认映射，全部未命中时返回 null。
## 返回值
依次查找本地值、引用链和默认映射得到的 Token；全部未命中时为 null。

返回类型：`V?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Object? | - | 要查询的 Token 键；支持当前映射的键类型。 | 是 |


##### TMap.get

```dart
V? get(Object? key)
```


仅读取 `key` 的本地存储值，不解析引用或默认映射。
## 返回值
本地存储的 Token 值；不存在时为 null，不解析引用链或默认映射。

返回类型：`V?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Object? | - | 要读取本地存储值的键；不解析引用或默认映射。 | 是 |


### PlatformUtil
#### 简介
区分 Flutter Web 与原生宿主平台的工具。

#### 声明

```dart
class PlatformUtil
```

#### 默认构造方法


```dart
PlatformUtil()
```

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isAndroid | bool | - | 当前是否运行于 Android 原生平台；Web 始终返回 false。 |
| isFuchsia | bool | - | 当前是否运行于 Fuchsia 原生平台；Web 始终返回 false。 |
| isIOS | bool | - | 当前是否运行于 IOS 原生平台；Web 始终返回 false。 |
| isLinux | bool | - | 当前是否运行于 Linux 原生平台；Web 始终返回 false。 |
| isMacOS | bool | - | 当前是否运行于 MacOS 原生平台；Web 始终返回 false。 |
| isOhos | bool | - | 当前是否运行于 Ohos 原生平台；Web 始终返回 false。 |
| isWeb | bool | - | 当前是否编译并运行于 Flutter Web。 |
| isWindows | bool | - | 当前是否运行于 Windows 原生平台；Web 始终返回 false。 |


### TToolbarPressable
#### 简介
工具栏文字/图标按钮统一按压反馈：按下时整体透明度动画。
用于 `TPicker`、`TPopup` 等「取消 | 标题 | 确认」类工具栏，后续组件请复用。

#### 声明

```dart
class TToolbarPressable extends StatefulWidget
```

#### 默认构造方法


```dart
const TToolbarPressable({
  super.key,
  required this.child,
  this.onTap,
  this.padding,
  this.enabled = true,
  this.pressDuration = kToolbarPressDuration,
  this.pressedOpacity = kToolbarPressedOpacity,
  this.mergeTextStyle,
  this.mergeIconTheme,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 工具栏按钮内容。 | 是 |
| enabled | bool | true | 是否允许交互，默认 true；还需要 `onTap` 非空。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| mergeIconTheme | IconThemeData? | - | 为子树 `Icon` 提供默认样式。 | 否 |
| mergeTextStyle | TextStyle? | - | 为子树 `Text` 提供默认样式（merge 语义，子控件已有样式优先）。 | 否 |
| onTap | VoidCallback? | - | 点击回调；为空时不响应点击或显示按压反馈。 | 否 |
| padding | EdgeInsetsGeometry? | - | 内容内边距；为空时使用全局 spacer 水平间距和 spacer1 垂直间距。 | 否 |
| pressDuration | Duration | kToolbarPressDuration | 按压透明度动画时长，默认 100ms。 | 否 |
| pressedOpacity | double | kToolbarPressedOpacity | 按下时整体透明度，默认 0.5。 | 否 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| kToolbarPressDuration | Duration | Duration(milliseconds: 100) | 按压动画时长（与 TDesign 工具栏规范一致）。 |
| kToolbarPressedOpacity | double | 0.5 | 按下时的目标透明度。 |


### FontExtensions
#### 简介
Font字体宽高的扩展

#### 声明

```dart
extension FontExtensions on Font
```


#### 实例方法

##### FontExtensions.withSize

```dart
Font withSize(int newSize)
```


调整字体大小。
## 返回值
使用 `newSize` 字号的字体副本，保留字重，并按当前行高比例计算新行高后取整。

返回类型：`Font`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| newSize | int | - | 字体大小，单位为逻辑像素。 | 是 |


### TColors
#### 简介
业务使用时有两种方法替换主题：
第一种：有独立设计风格的app，明确知道哪些色值用到，哪些设置没用到，有自己设计规范，则可单独配置色值。
第二种：直接接入TDesign，配置所有色值组，此时不需再自定义key-value，可以直接使用。
如果业务需要扩展，可以按以下方式定义自己的 ColorData；只要 key 能在主题中找到对应颜色即可。
TDesign 主题包含完整色值组，业务可以按需二次封装。未显式配置的颜色通常会按各 getter
的 Token 回退规则取默认值；只有依赖特定业务语义的自定义组件才需要额外保证对应 key 存在。

#### 声明

```dart
extension TColors on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bgColorComponent | Color | - | 组件默认背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorComponentActive | Color | - | 组件按压态背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorComponentDisabled | Color | - | 组件禁用态背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorContainer | Color | - | 容器背景色；浅色默认引用 `fontWhite1`。 |
| bgColorContainerActive | Color | - | 容器背景的按压态颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorPage | Color | - | 页面背景色；优先同名 Token，未解析到时回退 grayColor1。 |
| bgColorSecondaryComponent | Color | - | 次要组件背景色，默认引用灰阶 4。 |
| bgColorSecondaryComponentActive | Color | - | 次要组件激活背景色，默认引用灰阶 6。 |
| bgColorSecondaryContainer | Color | - | 次级容器背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorSecondaryContainerActive | Color | - | 次级容器背景的按压态颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorSpecialComponent | Color | - | 特殊组件背景色；暗色主题默认透明。 |
| borderLevel1Color | Color | - | 一级分割线颜色，默认与 `componentStroke` 使用同一色阶。 |
| borderLevel2Color | Color | - | 二级边框颜色，默认与 `componentBorder` 使用同一色阶。 |
| brandColor | Color | - | 未解析到同名 Token 时的回退色：#0052D9。 |
| brandColor1 | Color | - | 未解析到同名 Token 时的回退色：#F2F3FF。 |
| brandColor10 | Color | - | 未解析到同名 Token 时的回退色：#001A57。 |
| brandColor2 | Color | - | 未解析到同名 Token 时的回退色：#D9E1FF。 |
| brandColor3 | Color | - | 未解析到同名 Token 时的回退色：#B5C7FF。 |
| brandColor4 | Color | - | 未解析到同名 Token 时的回退色：#8EABFF。 |
| brandColor5 | Color | - | 未解析到同名 Token 时的回退色：#618DFF。 |
| brandColor6 | Color | - | 未解析到同名 Token 时的回退色：#366EF4。 |
| brandColor7 | Color | - | 未解析到同名 Token 时的回退色：#0052D9。 |
| brandColor8 | Color | - | 未解析到同名 Token 时的回退色：#003CAB。 |
| brandColor9 | Color | - | 未解析到同名 Token 时的回退色：#002A7C。 |
| brandColorActive | Color | - | 未解析到同名 Token 时的回退色：#003CAB。 |
| brandColorDisabled | Color | - | 未解析到同名 Token 时的回退色：#B5C7FF。 |
| brandColorFocus | Color | - | 未解析到同名 Token 时的回退色：#F2F3FF。 |
| brandColorLight | Color | - | 未解析到同名 Token 时的回退色：#F2F3FF。 |
| brandColorLightActive | Color | - | 浅色品牌色点击态，默认使用品牌色阶 2。 |
| componentBorder | Color | - | 组件边框颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| componentStroke | Color | - | 组件分隔线颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| errorColor | Color | - | 未解析到同名 Token 时的回退色：#D54941。 |
| errorColor1 | Color | - | 未解析到同名 Token 时的回退色：#FFF0ED。 |
| errorColor10 | Color | - | 未解析到同名 Token 时的回退色：#490002。 |
| errorColor2 | Color | - | 未解析到同名 Token 时的回退色：#FFD8D2。 |
| errorColor3 | Color | - | 未解析到同名 Token 时的回退色：#FFB9B0。 |
| errorColor4 | Color | - | 未解析到同名 Token 时的回退色：#FF9285。 |
| errorColor5 | Color | - | 未解析到同名 Token 时的回退色：#F6685D。 |
| errorColor6 | Color | - | 未解析到同名 Token 时的回退色：#D54941。 |
| errorColor7 | Color | - | 未解析到同名 Token 时的回退色：#AD352F。 |
| errorColor8 | Color | - | 未解析到同名 Token 时的回退色：#881F1C。 |
| errorColor9 | Color | - | 未解析到同名 Token 时的回退色：#68070A。 |
| errorColorActive | Color | - | 未解析到同名 Token 时的回退色：#AD352F。 |
| errorColorDisabled | Color | - | 未解析到同名 Token 时的回退色：#FFB9B0。 |
| errorColorFocus | Color | - | 未解析到同名 Token 时的回退色：#FFD8D2。 |
| errorColorLight | Color | - | 未解析到同名 Token 时的回退色：#FFF0ED。 |
| errorColorLightActive | Color | - | 浅色错误色点击态，默认使用错误色阶 2。 |
| fontGray1 | Color | - | 未解析到同名 Token 时的回退色：#e6000000。 |
| fontGray2 | Color | - | 未解析到同名 Token 时的回退色：#99000000。 |
| fontGray3 | Color | - | 未解析到同名 Token 时的回退色：#66000000。 |
| fontGray4 | Color | - | 未解析到同名 Token 时的回退色：#42000000。 |
| fontWhite1 | Color | - | 未解析到同名 Token 时的回退色：#FFFFFFFF。 |
| fontWhite2 | Color | - | 未解析到同名 Token 时的回退色：#8CFFFFFF。 |
| fontWhite3 | Color | - | 未解析到同名 Token 时的回退色：#59FFFFFF。 |
| fontWhite4 | Color | - | 未解析到同名 Token 时的回退色：#38FFFFFF。 |
| grayColor1 | Color | - | 未解析到同名 Token 时的回退色：#F3F3F3。 |
| grayColor10 | Color | - | 未解析到同名 Token 时的回退色：#4B4B4B。 |
| grayColor11 | Color | - | 未解析到同名 Token 时的回退色：#383838。 |
| grayColor12 | Color | - | 未解析到同名 Token 时的回退色：#2C2C2C。 |
| grayColor13 | Color | - | 未解析到同名 Token 时的回退色：#242424。 |
| grayColor14 | Color | - | 未解析到同名 Token 时的回退色：#181818。 |
| grayColor2 | Color | - | 未解析到同名 Token 时的回退色：#EEEEEE。 |
| grayColor3 | Color | - | 未解析到同名 Token 时的回退色：#E8E8E8。 |
| grayColor4 | Color | - | 未解析到同名 Token 时的回退色：#DCDCDC。 |
| grayColor5 | Color | - | 未解析到同名 Token 时的回退色：#C5C5C5。 |
| grayColor6 | Color | - | 未解析到同名 Token 时的回退色：#A6A6A6。 |
| grayColor7 | Color | - | 未解析到同名 Token 时的回退色：#8B8B8B。 |
| grayColor8 | Color | - | 未解析到同名 Token 时的回退色：#777777。 |
| grayColor9 | Color | - | 未解析到同名 Token 时的回退色：#5E5E5E。 |
| maskActive | Color | - | 弹层遮罩色。 |
| maskBackground | Color | - | 二维码等背景遮罩色。 |
| maskDisabled | Color | - | 禁用态遮罩色。 |
| primaryColor1 | Color | - | 主色阶；默认分别引用同级品牌色阶。 |
| primaryColor10 | Color | - | 主色第 10 级色阶；未配置时使用 `brandColor10`。 |
| primaryColor2 | Color | - | 主色第 2 级色阶；未配置时使用 `brandColor2`。 |
| primaryColor3 | Color | - | 主色第 3 级色阶；未配置时使用 `brandColor3`。 |
| primaryColor4 | Color | - | 主色第 4 级色阶；未配置时使用 `brandColor4`。 |
| primaryColor5 | Color | - | 主色第 5 级色阶；未配置时使用 `brandColor5`。 |
| primaryColor6 | Color | - | 主色第 6 级色阶；未配置时使用 `brandColor6`。 |
| primaryColor7 | Color | - | 主色第 7 级色阶；未配置时使用 `brandColor7`。 |
| primaryColor8 | Color | - | 主色第 8 级色阶；未配置时使用 `brandColor8`。 |
| primaryColor9 | Color | - | 主色第 9 级色阶；未配置时使用 `brandColor9`。 |
| scrollbarColor | Color | - | 滚动条颜色。 |
| scrollbarHoverColor | Color | - | 滚动条悬停颜色。 |
| scrollTrackColor | Color | - | 滚动条轨道颜色。 |
| successColor | Color | - | 未解析到同名 Token 时的回退色：#2BA471。 |
| successColor1 | Color | - | 未解析到同名 Token 时的回退色：#E3F9E9。 |
| successColor10 | Color | - | 未解析到同名 Token 时的回退色：#002515。 |
| successColor2 | Color | - | 未解析到同名 Token 时的回退色：#C6F3D7。 |
| successColor3 | Color | - | 未解析到同名 Token 时的回退色：#92DAB2。 |
| successColor4 | Color | - | 未解析到同名 Token 时的回退色：#56C08D。 |
| successColor5 | Color | - | 未解析到同名 Token 时的回退色：#2BA471。 |
| successColor6 | Color | - | 未解析到同名 Token 时的回退色：#008858。 |
| successColor7 | Color | - | 未解析到同名 Token 时的回退色：#006C45。 |
| successColor8 | Color | - | 未解析到同名 Token 时的回退色：#005334。 |
| successColor9 | Color | - | 未解析到同名 Token 时的回退色：#003B23。 |
| successColorActive | Color | - | 未解析到同名 Token 时的回退色：#008858。 |
| successColorDisabled | Color | - | 未解析到同名 Token 时的回退色：#92DAB2。 |
| successColorFocus | Color | - | 未解析到同名 Token 时的回退色：#C6F3D7。 |
| successColorLight | Color | - | 未解析到同名 Token 时的回退色：#E3F9E9。 |
| successColorLightActive | Color | - | 浅色成功色点击态，默认使用成功色阶 2。 |
| tableShadowColor | Color | - | 表格专用阴影色。 |
| textColorAnti | Color | - | 反色文字颜色，默认引用 `fontWhite1`。 |
| textColorBrand | Color | - | 品牌文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorDisabled | Color | - | 禁用文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorLink | Color | - | 链接文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorPlaceholder | Color | - | 占位文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorPrimary | Color | - | 主要文字颜色；优先同名 Token，未解析到时回退 fontGray1。 |
| textColorSecondary | Color | - | 次要文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| warningColor | Color | - | 未解析到同名 Token 时的回退色：#E37318。 |
| warningColor1 | Color | - | 未解析到同名 Token 时的回退色：#FFF1E9。 |
| warningColor10 | Color | - | 未解析到同名 Token 时的回退色：#3B1700。 |
| warningColor2 | Color | - | 未解析到同名 Token 时的回退色：#FFD9C2。 |
| warningColor3 | Color | - | 未解析到同名 Token 时的回退色：#FFB98C。 |
| warningColor4 | Color | - | 未解析到同名 Token 时的回退色：#FA9550。 |
| warningColor5 | Color | - | 未解析到同名 Token 时的回退色：#E37318。 |
| warningColor6 | Color | - | 未解析到同名 Token 时的回退色：#BE5A00。 |
| warningColor7 | Color | - | 未解析到同名 Token 时的回退色：#954500。 |
| warningColor8 | Color | - | 未解析到同名 Token 时的回退色：#713300。 |
| warningColor9 | Color | - | 未解析到同名 Token 时的回退色：#532300。 |
| warningColorActive | Color | - | 未解析到同名 Token 时的回退色：#BE5A00。 |
| warningColorDisabled | Color | - | 未解析到同名 Token 时的回退色：#FFB98C。 |
| warningColorFocus | Color | - | 未解析到同名 Token 时的回退色：#FFD9C2。 |
| warningColorLight | Color | - | 未解析到同名 Token 时的回退色：#FFF1E9。 |
| warningColorLightActive | Color | - | 浅色警告色点击态，默认使用警告色阶 2。 |
| whiteColor1 | Color | - | 未解析到同名 Token 时的回退色：#FFFFFF。 |


### TResolvedFontFamily
#### 简介
将主题字体栈解析为当前 Flutter 平台可绘制的字体选择。
保留 Token 原值；非 Apple 平台对默认栈使用 Roboto 作为主字体。

#### 声明

```dart
extension TResolvedFontFamily on FontFamily
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| flutterFontFamily | String | - | Flutter 使用的主字体；非 Apple 平台的默认中文字体栈回退为 Roboto，其他配置保持原值。 |
| flutterFontFamilyFallback | List&lt;String&gt;? | - | Flutter 的备用字体栈；PingFang SC 栈未包含 Roboto 时追加它，其他配置保持原值。 |


### TFontFamilies
#### 简介
按主题 Token 读取主字体与中等字重字体栈。

#### 声明

```dart
extension TFontFamilies on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fontFamily | FontFamily? | - | 默认字体栈；可用于 Flutter `TextStyle.fontFamily` 和 `fontFamilyFallback`。`TText` 在非 Apple 平台会为默认字体栈选择 Flutter 可用的主字体，不改变这里保存的 Token 原值。 |
| fontFamilyMedium | FontFamily? | - | 中等字重字体栈。 |


### TFontMetrics
#### 简介
独立字号与行高 Token，用于组合字体样式。

#### 声明

```dart
extension TFontMetrics on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fontSize | double | - | 读取 `fontSize` 的字号 Token，单位为逻辑像素；未配置时回退为 10 逻辑像素。 |
| fontSizeBase | double | - | 读取 `fontSizeBase` 的字号 Token，单位为逻辑像素；未配置时回退为 `fontSizeTitleSmall`。 |
| fontSizeBodyExtraSmall | double | - | 读取 `fontSizeBodyExtraSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 10 逻辑像素。 |
| fontSizeBodyLarge | double | - | 读取 `fontSizeBodyLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。 |
| fontSizeBodyMedium | double | - | 读取 `fontSizeBodyMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。 |
| fontSizeBodySmall | double | - | 读取 `fontSizeBodySmall` 的字号 Token，单位为逻辑像素；未配置时回退为 12 逻辑像素。 |
| fontSizeDisplayLarge | double | - | 读取 `fontSizeDisplayLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 64 逻辑像素。 |
| fontSizeDisplayMedium | double | - | 读取 `fontSizeDisplayMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 48 逻辑像素。 |
| fontSizeHeadlineLarge | double | - | 读取 `fontSizeHeadlineLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 36 逻辑像素。 |
| fontSizeHeadlineMedium | double | - | 读取 `fontSizeHeadlineMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 28 逻辑像素。 |
| fontSizeHeadlineSmall | double | - | 读取 `fontSizeHeadlineSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。 |
| fontSizeL | double | - | 读取 `fontSizeL` 的字号 Token，单位为逻辑像素；未配置时回退为 `fontSizeTitleLarge`。 |
| fontSizeLinkLarge | double | - | 读取 `fontSizeLinkLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。 |
| fontSizeLinkMedium | double | - | 读取 `fontSizeLinkMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。 |
| fontSizeLinkSmall | double | - | 读取 `fontSizeLinkSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 12 逻辑像素。 |
| fontSizeM | double | - | 读取 `fontSizeM` 的字号 Token，单位为逻辑像素；未配置时回退为 `fontSizeTitleMedium`。 |
| fontSizeMarkExtraSmall | double | - | 读取 `fontSizeMarkExtraSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 10 逻辑像素。 |
| fontSizeMarkLarge | double | - | 读取 `fontSizeMarkLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。 |
| fontSizeMarkMedium | double | - | 读取 `fontSizeMarkMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。 |
| fontSizeMarkSmall | double | - | 读取 `fontSizeMarkSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 12 逻辑像素。 |
| fontSizeS | double | - | 读取 `fontSizeS` 的字号 Token，单位为逻辑像素；未配置时回退为 `fontSizeBodySmall`。 |
| fontSizeTitleExtraLarge | double | - | 读取 `fontSizeTitleExtraLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。 |
| fontSizeTitleLarge | double | - | 读取 `fontSizeTitleLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 18 逻辑像素。 |
| fontSizeTitleMedium | double | - | 读取 `fontSizeTitleMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。 |
| fontSizeTitleSmall | double | - | 读取 `fontSizeTitleSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。 |
| fontSizeXl | double | - | 读取 `fontSizeXl` 的字号 Token，单位为逻辑像素；未配置时回退为 `fontSizeTitleExtraLarge`。 |
| fontSizeXs | double | - | 读取 `fontSizeXs` 的字号 Token，单位为逻辑像素；未配置时回退为 `fontSizeBodyExtraSmall`。 |
| fontSizeXxl | double | - | 读取 `fontSizeXxl` 的字号 Token，单位为逻辑像素；未配置时回退为 `fontSizeHeadlineLarge`。 |
| lineHeightBodyExtraSmall | double | - | 读取 `lineHeightBodyExtraSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。 |
| lineHeightBodyLarge | double | - | 读取 `lineHeightBodyLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。 |
| lineHeightBodyMedium | double | - | 读取 `lineHeightBodyMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。 |
| lineHeightBodySmall | double | - | 读取 `lineHeightBodySmall` 的行高 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。 |
| lineHeightDisplayLarge | double | - | 读取 `lineHeightDisplayLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 72 逻辑像素。 |
| lineHeightDisplayMedium | double | - | 读取 `lineHeightDisplayMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 56 逻辑像素。 |
| lineHeightHeadlineLarge | double | - | 读取 `lineHeightHeadlineLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 44 逻辑像素。 |
| lineHeightHeadlineMedium | double | - | 读取 `lineHeightHeadlineMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 36 逻辑像素。 |
| lineHeightHeadlineSmall | double | - | 读取 `lineHeightHeadlineSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 32 逻辑像素。 |
| lineHeightLinkLarge | double | - | 读取 `lineHeightLinkLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。 |
| lineHeightLinkMedium | double | - | 读取 `lineHeightLinkMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。 |
| lineHeightLinkSmall | double | - | 读取 `lineHeightLinkSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。 |
| lineHeightMarkExtraSmall | double | - | 读取 `lineHeightMarkExtraSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。 |
| lineHeightMarkLarge | double | - | 读取 `lineHeightMarkLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。 |
| lineHeightMarkMedium | double | - | 读取 `lineHeightMarkMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。 |
| lineHeightMarkSmall | double | - | 读取 `lineHeightMarkSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。 |
| lineHeightTitleExtraLarge | double | - | 读取 `lineHeightTitleExtraLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 28 逻辑像素。 |
| lineHeightTitleLarge | double | - | 读取 `lineHeightTitleLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 26 逻辑像素。 |
| lineHeightTitleMedium | double | - | 读取 `lineHeightTitleMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。 |
| lineHeightTitleSmall | double | - | 读取 `lineHeightTitleSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。 |


### TFonts
#### 简介
复合字体 Token。显式覆盖复合 `Font` 时以它为准；否则随独立字号和行高变化。

#### 声明

```dart
extension TFonts on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fontBodyExtraSmall | Font? | - | 读取 `fontBodyExtraSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontBodyLarge | Font? | - | 读取 `fontBodyLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontBodyMedium | Font? | - | 读取 `fontBodyMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontBodySmall | Font? | - | 读取 `fontBodySmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontDisplayLarge | Font? | - | 读取 `fontDisplayLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontDisplayMedium | Font? | - | 读取 `fontDisplayMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontHeadlineLarge | Font? | - | 读取 `fontHeadlineLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontHeadlineMedium | Font? | - | 读取 `fontHeadlineMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontHeadlineSmall | Font? | - | 读取 `fontHeadlineSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontLinkLarge | Font? | - | 读取 `fontLinkLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontLinkMedium | Font? | - | 读取 `fontLinkMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontLinkSmall | Font? | - | 读取 `fontLinkSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontMarkExtraSmall | Font? | - | 读取 `fontMarkExtraSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontMarkLarge | Font? | - | 读取 `fontMarkLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontMarkMedium | Font? | - | 读取 `fontMarkMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontMarkSmall | Font? | - | 读取 `fontMarkSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontTitleExtraLarge | Font? | - | 读取 `fontTitleExtraLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontTitleLarge | Font? | - | 读取 `fontTitleLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontTitleMedium | Font? | - | 读取 `fontTitleMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |
| fontTitleSmall | Font? | - | 读取 `fontTitleSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。 |


### TRadius
#### 简介
内置圆角数据

#### 声明

```dart
extension TRadius on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| radiusCircle | double | - | Flutter 固定逻辑像素圆角，默认 9999。 自定义值仍按逻辑像素解释，不按宽高比例解释。 |
| radiusDefault | double | - | 默认圆角，默认 6 逻辑像素。 |
| radiusExtraLarge | double | - | 特大圆角，默认 12 逻辑像素。 |
| radiusLarge | double | - | 大圆角，默认 9 逻辑像素。 |
| radiusRound | double | - | 胶囊圆角，默认 999 逻辑像素。 |
| radiusSmall | double | - | 小圆角，默认 3 逻辑像素。 |


### TBoxShadows
#### 简介
全局外投影 Token，使用 Flutter `BoxShadow` 表达。

#### 声明

```dart
extension TBoxShadows on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| shadow1 | List&lt;BoxShadow&gt;? | - | 基础投影。 |
| shadow2 | List&lt;BoxShadow&gt;? | - | 中层投影。 |
| shadow3 | List&lt;BoxShadow&gt;? | - | 上层投影。 |
| shadow4 | List&lt;BoxShadow&gt;? | - | 轻投影。 |


### TInsetShadows
#### 简介
四个方向的内投影使用定向内侧边线表达。
使用方应把对应 `BorderSide` 放入 `Border.top` / right / bottom / left。

#### 声明

```dart
extension TInsetShadows on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| shadowInsetBottom | BorderSide? | - | 底部内投影对应的边线 Token；未配置时返回 null。 |
| shadowInsetLeft | BorderSide? | - | 左侧内投影对应的边线 Token；未配置时返回 null。 |
| shadowInsetRight | BorderSide? | - | 右侧内投影对应的边线 Token；未配置时返回 null。 |
| shadowInsetTop | BorderSide? | - | 顶部内投影对应的边线 Token；未配置时返回 null。 |


### TSpacers
#### 简介
全局间距 Token，单位为 Flutter 逻辑像素。

#### 声明

```dart
extension TSpacers on TThemeData
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| spacer | double | - | 间距 Token，未配置时回退为 8 逻辑像素。 |
| spacer1 | double | - | 间距 Token，未配置时回退为 12 逻辑像素。 |
| spacer2 | double | - | 间距 Token，未配置时回退为 16 逻辑像素。 |
| spacer3 | double | - | 间距 Token，未配置时回退为 24 逻辑像素。 |
| spacer4 | double | - | 间距 Token，未配置时回退为 32 逻辑像素。 |
| spacer5 | double | - | 间距 Token，未配置时回退为 48 逻辑像素。 |
| spacer6 | double | - | 间距 Token，未配置时回退为 80 逻辑像素。 |


### TThemeContextExtension
#### 简介
BuildContext 扩展：便捷获取全局 TThemeData Token
统一走 Material 的 `Theme.of(context)`。
全库读取全局 Token（色板/间距/圆角/字体）统一用 `context.tTheme`。

#### 声明

```dart
extension TThemeContextExtension on BuildContext
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tTheme | TThemeData | - | 获取当前主题中的全局 Token；未配置时回退默认主题。 |


### TThemeDataMergeExtension
#### 简介
ThemeData 扩展：在子树中替换一个组件 ThemeExtension，同时保留其他扩展。
子树覆盖统一用 `mergeExtension(...)`；直接使用 `copyWith(extensions: [...])` 时，
调用方需要自行保留未修改的其他扩展。

#### 声明

```dart
extension TThemeDataMergeExtension on ThemeData
```


#### 实例方法

##### TThemeDataMergeExtension.mergeExtension

```dart
ThemeData mergeExtension<T extends ThemeExtension<T>>(T extension)
```


合并指定类型的主题扩展。
## 返回值
保留当前其他主题配置与扩展、仅替换指定类型扩展的新 ThemeData。
示例：
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TTagThemeData(squareBorderRadius: 6),
  ),
  child: const TTag('局部圆角'),
)
```

返回类型：`ThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| extension | T | - | 要安装到主题中的扩展；仅替换同类型扩展，其他扩展保持不变。 | 是 |


### setTResourceBuilder
#### 顶层函数

设置全局资源代理。
`needAlwaysBuild`=true: 每次都会走 build 方法；如果全局有多个 Delegate，
需要区分情况去获取，则可以设置 needAlwaysBuild 为 true，业务自己判断返回哪个 delegate。
`needAlwaysBuild`=false: 返回 delegate 为 null，则每次都会走 build 方法。

返回类型：`void`

```dart
void setTResourceBuilder( TResourceBuilder delegate, { bool needAlwaysBuild = false, })
```


#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| delegate | TResourceBuilder | - | 根据构建上下文提供资源代理的回调。 | 是 |
| needAlwaysBuild | bool | false | 是否每次读取资源时调用构建器；false 时复用首次成功构建的缓存，返回 null 时继续尝试构建。 | 否 |


### TResourceBuilder
#### 简介
根据当前构建上下文提供资源代理；返回 null 时使用默认文案。
`context` 当前资源查询的构建上下文。
## 返回值
资源代理；返回 null 时使用默认资源文案。
#### 类型定义

```dart
typedef TResourceBuilder = TResourceDelegate? Function(BuildContext context);
```


### DefaultMapFactory
#### 简介
创建默认 Token 映射的回调；返回 null 时不提供默认值。
## 返回值
默认 Token 映射；返回 null 时不提供默认映射。
#### 类型定义

```dart
typedef DefaultMapFactory = TMap? Function();
```
