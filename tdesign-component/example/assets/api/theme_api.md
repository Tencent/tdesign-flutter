## API
### TThemeData
#### 简介
主题数据

#### 静态方法

##### TThemeData.defaultData

获取默认Data，一个App里只有一个，用于没有context的地方

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 |


##### TThemeData.fromJson

解析配置的json文件为主题数据

返回类型：`TThemeData?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 主题名称，目前只支持一级键 |
| themeJson | String | - | 主题json字符串，要求json配置必须正确 |
| darkName | String? | - | 暗色主题名称；为空时使用 `${name}Dark`。 |
| recoverDefault | bool | false | 是否恢复为默认主题数据 |
| extraThemeData | TExtraThemeData? | - | 额外扩展的主题数据 |


##### TThemeData.parseThemeData

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 名称 |
| themeConfig | dynamic | - | 已解析的主题 JSON 配置。 |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| colorMap | TMap<String, Color> | - | 颜色 |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 |
| fontFamilyMap | TMap<String, FontFamily> | - | 字体样式 |
| fontMap | TMap<String, Font> | - | 字体尺寸 |
| fontMetricMap | TMap<String, double>? | - | 小程序独立字号与行高 Token，单位为 Flutter 逻辑像素。 |
| insetShadowMap | TMap<String, BorderSide>? | - | 小程序 blur=0 的内投影在 Flutter 中对应的内侧边线。 |
| name | String | - | 名称 |
| radiusMap | TMap<String, double> | - | 圆角 |
| refMap | TMap<String, String> | - | 映射关系 |
| shadowMap | TMap<String, List<BoxShadow>> | - | 阴影 |
| spacerMap | TMap<String, double> | - | 间隔 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dark | TThemeData? | - | 暗色主题 |
| light | TThemeData | - | 亮色主题 |


### Font
#### 简介
字体宽高数据

#### 工厂构造方法

##### Font.fromJson

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| map | Map<String, dynamic> | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fontWeight | FontWeight | FontWeight.w400 | - |
| lineHeight | int | - | - |
| size | int | - | - |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| height | double | - | - |


### FontFamily
#### 简介
字体样式

#### 工厂构造方法

##### FontFamily.fromJson

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| map | Map<String, dynamic> | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fallback | List<String>? | - | - |
| fontFamily | String | - | - |
| package | String? | - | - |


### TResourceManager
#### 简介
资源管理器

#### 静态方法

##### TResourceManager.defaultDelegate

库内未注入 `setResourceBuilder` 时使用的默认文案（供 date-time-picker 等组件）。

返回类型：`TResourceDelegate`

##### TResourceManager.instance

单例对象

返回类型：`TResourceManager`

### TResourceDelegate
#### 简介
资源管理器，允许外部重写，设计成抽象类，防止有新增字段时，用户没有感知

#### 方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| uploading | String | - | `TUpload` 上传中。 |
| uploadSelect | String | - | `TUpload` 选择文件的无障碍标签。 |
| uploadPending | String | - | `TUpload` 待上传状态。 |
| uploadFailed | String | - | `TUpload` 上传失败。 |
| uploadRetry | String | - | `TUpload` 重新上传。 |
| uploadSuccess | String | - | `TUpload` 上传成功。 |
| open | String | - | `TSwitch`的打开状态文案 |
| close | String | - | `TSwitch`的关闭状态文案 |
| badgeZero | String | - | `TBadge`为0时的默认文案 |
| cancel | String | - | TDialog等 取消 |
| confirm | String | - | TDialog等 确认 |
| other | String | - | `TDropdownMenu` 其他 |
| reset | String | - | `TDropdownMenu` 重置 |
| loading | String | - | `TLoading` 加载中 |
| loadingWithPoint | String | - | `TToast` 加载中... |
| knew | String | - | `TConfirmDialog` 知道了 |
| refreshing | String | - | `TPullDownRefresh` 正在刷新 |
| releaseRefresh | String | - | `TPullDownRefresh` 松手刷新 |
| pullToRefresh | String | - | `TPullDownRefresh` 下拉刷新 |
| completeRefresh | String | - | `TPullDownRefresh` 刷新完成 |
| days | String | - | `TTimeCounter` 天 |
| hours | String | - | `TTimeCounter` 时 |
| minutes | String | - | `TTimeCounter` 分 |
| seconds | String | - | `TTimeCounter` 秒 |
| milliseconds | String | - | `TTimeCounter` 毫秒 |
| yearLabel | String | - | 年 |
| monthLabel | String | - | 月 |
| dateLabel | String | - | 日 |
| weeksLabel | String | - | 周 |
| sunday | String | - | `TCalendar` 星期日 |
| monday | String | - | `TCalendar` 星期一 |
| tuesday | String | - | `TCalendar` 星期二 |
| wednesday | String | - | `TCalendar` 星期三 |
| thursday | String | - | `TCalendar` 星期四 |
| friday | String | - | `TCalendar` 星期五 |
| saturday | String | - | `TCalendar` 星期六 |
| year | String | - | `TCalendar` 年 |
| january | String | - | `TCalendar` 一月 |
| february | String | - | `TCalendar` 二月 |
| march | String | - | `TCalendar` 三月 |
| april | String | - | `TCalendar` 四月 |
| may | String | - | `TCalendar` 五月 |
| june | String | - | `TCalendar` 六月 |
| july | String | - | `TCalendar` 七月 |
| august | String | - | `TCalendar` 八月 |
| september | String | - | `TCalendar` 九月 |
| october | String | - | `TCalendar` 十月 |
| november | String | - | `TCalendar` 十一月 |
| december | String | - | `TCalendar` 十二月 |
| time | String | - | `TCalendar` 时间 |
| start | String | - | `TCalendar` 开始 |
| end | String | - | `TCalendar` 结束 |
| notRated | String | - | `TRate` 未评分 |
| cascadeLabel | String | - | `TRate` 选择选项 |
| back | String | - | `TBackTop` 返回 |
| top | String | - | `TBackTop` 顶部 |
| emptyData | String | - | `TTable` 空数据 |
| picker | String | - | `TPicker` 整组无障碍容器 label |
| pickerColumn | String | required int colIndex | `TPicker` 第 `colIndex` 列（1-based）的无障碍 label |


### TStyleResolver
#### 简介
TDesign 样式解析器。
实例显式样式、组件 Theme 和全局 Token 是单向样式链。
用法：

#### 静态方法

##### TStyleResolver.of

创建解析器实例

返回类型：`TStyleResolver`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |


### TMaterialThemeBuilder
#### 简介
Token → 完整 ThemeData 的构建器
四层架构的 L2 层：接收 `TThemeData` token，产出完整 `ThemeData`。
内部完成 Token → ColorScheme 映射、Token Font → TextTheme、
Token 颜色 → M3 子主题，同时将 `TThemeData` 自身作为 Extension 注入。
通常不直接使用，通过 `TThemeBuilder.light` / `TThemeBuilder.dark` 入口。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| token | TThemeData | - | Token 数据源 |


### TThemeBuilder
#### 简介
应用入口：Token → 完整 ThemeData
对齐 `MaterialApp.theme` / `darkTheme` / `themeMode` 三参数模式。
用法：

#### 静态方法

##### TThemeBuilder.dark

暗色主题

返回类型：`ThemeData`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| token | TThemeData | - | - |


##### TThemeBuilder.light

亮色主题

返回类型：`ThemeData`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| token | TThemeData | - | - |


### TExtraThemeData
#### 简介
扩展主题数据

#### 方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| parse | void | required String name, required Map<String, dynamic> curThemeMap | 解析json |


### TMap
#### 简介
自定义Map
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| factory | DefaultMapFactory? | - | - |
| refs | TMap? | - | - |


### setTResourceBuilder
#### 顶层函数

设置全局资源代理。
`needAlwaysBuild`=true: 每次都会走 build 方法；如果全局有多个 Delegate，
需要区分情况去获取，则可以设置 needAlwaysBuild 为 true，业务自己判断返回哪个 delegate。
`needAlwaysBuild`=false: 返回 delegate 为 null，则每次都会走 build 方法。

返回类型：`void`

#### 参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| delegate | TResourceBuilder | - | - |
| needAlwaysBuild | bool | false | - |


### TResourceBuilder
#### 类型定义

```dart
typedef TResourceBuilder = TResourceDelegate? Function(BuildContext context);
```


### DefaultMapFactory
#### 类型定义

```dart
typedef DefaultMapFactory = TMap? Function();
```

## FontExtensions

Font字体宽高的扩展

`extension FontExtensions on Font`

### withSize


```dart
Font withSize(int newSize)
```


## TColors


业务使用时有两种方法替换主题：
第一种：有独立设计风格的app，明确知道哪些色值用到，哪些设置没用到，有自己设计规范，则可单独配置色值。
第二中：直接接入TDesign，配置所有色值组，此时不需再自定义key-value，可以直接使用。

如果业务需要扩展，可以按一下方式定义自己的ColorData，只要key在主题中能找到对应颜色即可
TDesign主题包含的颜色，这是一个大而全的色值。业务可以选择自己自己需要的色值进行二次封装，方便使用。
不过有的色值是内部使用的，必传，否则可能显示异常。

`extension TColors on TThemeData`

### primaryColor1

功能色组----------------------------------------------------
小程序 `--td-primary-color-*` 色阶；默认分别引用同级品牌色阶。

```dart
Color get primaryColor1
```

### primaryColor2


```dart
Color get primaryColor2
```

### primaryColor3


```dart
Color get primaryColor3
```

### primaryColor4


```dart
Color get primaryColor4
```

### primaryColor5


```dart
Color get primaryColor5
```

### primaryColor6


```dart
Color get primaryColor6
```

### primaryColor7


```dart
Color get primaryColor7
```

### primaryColor8


```dart
Color get primaryColor8
```

### primaryColor9


```dart
Color get primaryColor9
```

### primaryColor10


```dart
Color get primaryColor10
```

### brandColor1

#F2F3FF

```dart
Color get brandColor1
```

### brandColor2

#D9E1FF

```dart
Color get brandColor2
```

### brandColor3

#B5C7FF

```dart
Color get brandColor3
```

### brandColor4

#8EABFF

```dart
Color get brandColor4
```

### brandColor5

#618DFF

```dart
Color get brandColor5
```

### brandColor6

#366EF4

```dart
Color get brandColor6
```

### brandColor7

#0052D9

```dart
Color get brandColor7
```

### brandColor8

#003CAB

```dart
Color get brandColor8
```

### brandColor9

#002A7C

```dart
Color get brandColor9
```

### brandColor10

#001A57

```dart
Color get brandColor10
```

### brandColorLight

#F2F3FF

```dart
Color get brandColorLight
```

### brandColorLightActive

浅色品牌色点击态，默认使用品牌色阶 2。

```dart
Color get brandColorLightActive
```

### brandColorFocus

#F2F3FF

```dart
Color get brandColorFocus
```

### brandColorDisabled

#B5C7FF

```dart
Color get brandColorDisabled
```

### brandColor

#0052D9

```dart
Color get brandColor
```

### brandColorActive

#003CAB

```dart
Color get brandColorActive
```

### errorColor1

错误色组----------------------------------------------------
#FFF0ED

```dart
Color get errorColor1
```

### errorColor2

#FFD8D2

```dart
Color get errorColor2
```

### errorColor3

#FFB9B0

```dart
Color get errorColor3
```

### errorColor4

#FF9285

```dart
Color get errorColor4
```

### errorColor5

#F6685D

```dart
Color get errorColor5
```

### errorColor6

#D54941

```dart
Color get errorColor6
```

### errorColor7

#AD352F

```dart
Color get errorColor7
```

### errorColor8

#881F1C

```dart
Color get errorColor8
```

### errorColor9

#68070A

```dart
Color get errorColor9
```

### errorColor10

#490002

```dart
Color get errorColor10
```

### errorColorLight

#FFF0ED

```dart
Color get errorColorLight
```

### errorColorLightActive

浅色错误色点击态，默认使用错误色阶 2。

```dart
Color get errorColorLightActive
```

### errorColorFocus

#FFD8D2

```dart
Color get errorColorFocus
```

### errorColorDisabled

#FFB9B0

```dart
Color get errorColorDisabled
```

### errorColor

#D54941

```dart
Color get errorColor
```

### errorColorActive

#AD352F

```dart
Color get errorColorActive
```

### warningColor1

警告色组----------------------------------------------------
#FFF1E9

```dart
Color get warningColor1
```

### warningColor2

#FFD9C2

```dart
Color get warningColor2
```

### warningColor3

#FFB98C

```dart
Color get warningColor3
```

### warningColor4

#FA9550

```dart
Color get warningColor4
```

### warningColor5

#E37318

```dart
Color get warningColor5
```

### warningColor6

#BE5A00

```dart
Color get warningColor6
```

### warningColor7

#954500

```dart
Color get warningColor7
```

### warningColor8

#713300

```dart
Color get warningColor8
```

### warningColor9

#532300

```dart
Color get warningColor9
```

### warningColor10

#3B1700

```dart
Color get warningColor10
```

### warningColorLight

#FFF1E9

```dart
Color get warningColorLight
```

### warningColorLightActive

浅色警告色点击态，默认使用警告色阶 2。

```dart
Color get warningColorLightActive
```

### warningColorFocus

#FFD9C2

```dart
Color get warningColorFocus
```

### warningColorDisabled

#FFB98C

```dart
Color get warningColorDisabled
```

### warningColor

#E37318

```dart
Color get warningColor
```

### warningColorActive

#BE5A00

```dart
Color get warningColorActive
```

### successColor1

成功色组----------------------------------------------------
#E3F9E9

```dart
Color get successColor1
```

### successColor2

#C6F3D7

```dart
Color get successColor2
```

### successColor3

#92DAB2

```dart
Color get successColor3
```

### successColor4

#56C08D

```dart
Color get successColor4
```

### successColor5

#2BA471

```dart
Color get successColor5
```

### successColor6

#008858

```dart
Color get successColor6
```

### successColor7

#006C45

```dart
Color get successColor7
```

### successColor8

#005334

```dart
Color get successColor8
```

### successColor9

#003B23

```dart
Color get successColor9
```

### successColor10

#002515

```dart
Color get successColor10
```

### successColorLight

#E3F9E9

```dart
Color get successColorLight
```

### successColorLightActive

浅色成功色点击态，默认使用成功色阶 2。

```dart
Color get successColorLightActive
```

### successColorFocus

#C6F3D7

```dart
Color get successColorFocus
```

### successColorDisabled

#92DAB2

```dart
Color get successColorDisabled
```

### successColor

#2BA471

```dart
Color get successColor
```

### successColorActive

#008858

```dart
Color get successColorActive
```

### fontGray1

文字色组----------------------------------------------------
#e6000000

```dart
Color get fontGray1
```

### fontGray2

#99000000

```dart
Color get fontGray2
```

### fontGray3

#66000000

```dart
Color get fontGray3
```

### fontGray4

#42000000

```dart
Color get fontGray4
```

### fontWhite1

#FFFFFFFF

```dart
Color get fontWhite1
```

### fontWhite2

#8CFFFFFF

```dart
Color get fontWhite2
```

### fontWhite3

#59FFFFFF

```dart
Color get fontWhite3
```

### fontWhite4

#38FFFFFF

```dart
Color get fontWhite4
```

### whiteColor1

中性面板色组----------------------------------------------------
#FFFFFF

```dart
Color get whiteColor1
```

### grayColor1

#F3F3F3

```dart
Color get grayColor1
```

### grayColor2

#EEEEEE

```dart
Color get grayColor2
```

### grayColor3

#E8E8E8

```dart
Color get grayColor3
```

### grayColor4

#DCDCDC

```dart
Color get grayColor4
```

### grayColor5

#C5C5C5

```dart
Color get grayColor5
```

### grayColor6

#A6A6A6

```dart
Color get grayColor6
```

### grayColor7

#8B8B8B

```dart
Color get grayColor7
```

### grayColor8

#777777

```dart
Color get grayColor8
```

### grayColor9

#5E5E5E

```dart
Color get grayColor9
```

### grayColor10

#4B4B4B

```dart
Color get grayColor10
```

### grayColor11

#383838

```dart
Color get grayColor11
```

### grayColor12

#2C2C2C

```dart
Color get grayColor12
```

### grayColor13

#242424

```dart
Color get grayColor13
```

### grayColor14

#181818

```dart
Color get grayColor14
```

### bgColorPage

组件颜色配置----------------------------------------------------

```dart
Color get bgColorPage
```

### bgColorContainer

小程序 `--td-bg-color-container`；浅色默认引用 [fontWhite1]。

```dart
Color get bgColorContainer
```

### bgColorContainerActive


```dart
Color get bgColorContainerActive
```

### bgColorSecondaryContainer


```dart
Color get bgColorSecondaryContainer
```

### bgColorSecondaryContainerActive


```dart
Color get bgColorSecondaryContainerActive
```

### bgColorSecondaryComponent

小程序 `--td-bg-color-secondarycomponent`，默认引用灰阶 4。

```dart
Color get bgColorSecondaryComponent
```

### bgColorSecondaryComponentActive

小程序 `--td-bg-color-secondarycomponent-active`，默认引用灰阶 6。

```dart
Color get bgColorSecondaryComponentActive
```

### bgColorSpecialComponent

小程序 `--td-bg-color-specialcomponent`；暗色主题默认透明。

```dart
Color get bgColorSpecialComponent
```

### bgColorComponent


```dart
Color get bgColorComponent
```

### bgColorComponentActive


```dart
Color get bgColorComponentActive
```

### bgColorComponentDisabled


```dart
Color get bgColorComponentDisabled
```

### componentStroke


```dart
Color get componentStroke
```

### componentBorder


```dart
Color get componentBorder
```

### borderLevel1Color

小程序一级分割线颜色，默认与 [componentStroke] 使用同一色阶。

```dart
Color get borderLevel1Color
```

### borderLevel2Color

小程序二级边框颜色，默认与 [componentBorder] 使用同一色阶。

```dart
Color get borderLevel2Color
```

### textColorPrimary

文字颜色配置----------------------------------------------------

```dart
Color get textColorPrimary
```

### textColorSecondary


```dart
Color get textColorSecondary
```

### textColorPlaceholder


```dart
Color get textColorPlaceholder
```

### textColorDisabled


```dart
Color get textColorDisabled
```

### textColorAnti

小程序 `--td-text-color-anti`，默认引用 [fontWhite1]。

```dart
Color get textColorAnti
```

### textColorBrand


```dart
Color get textColorBrand
```

### textColorLink


```dart
Color get textColorLink
```

### maskActive

弹层遮罩色。

```dart
Color get maskActive
```

### maskDisabled

禁用态遮罩色。

```dart
Color get maskDisabled
```

### maskBackground

二维码等背景遮罩色。

```dart
Color get maskBackground
```

### tableShadowColor

表格专用阴影色。

```dart
Color get tableShadowColor
```

### scrollbarColor

滚动条颜色。

```dart
Color get scrollbarColor
```

### scrollbarHoverColor

滚动条悬停颜色。

```dart
Color get scrollbarHoverColor
```

### scrollTrackColor

滚动条轨道颜色。

```dart
Color get scrollTrackColor
```


## TResolvedFontFamily

将小程序的 CSS 字体栈转换为当前 Flutter 平台可绘制的字体选择。
保留 Token 原值；非 Apple 平台对默认栈使用 Roboto 作为主字体。

`extension TResolvedFontFamily on FontFamily`

### flutterFontFamily


```dart
String get flutterFontFamily
```

### flutterFontFamilyFallback


```dart
List<String>? get flutterFontFamilyFallback
```


## TFontFamilies


`extension TFontFamilies on TThemeData`

### fontFamily

小程序 `--td-font-family`；可用于 Flutter `TextStyle.fontFamily` 和
`fontFamilyFallback`。`TText` 在非 Apple 平台会为默认字体栈选择
Flutter 可用的主字体，不改变这里保存的小程序原始值。

```dart
FontFamily? get fontFamily
```

### fontFamilyMedium

小程序 `--td-font-family-medium`。

```dart
FontFamily? get fontFamilyMedium
```


## TFontMetrics

小程序独立字号与行高 Token。CSS 中 `--td-font-*` 由这些变量组合而成。

`extension TFontMetrics on TThemeData`

### fontSize


```dart
double get fontSize
```

### fontSizeXs


```dart
double get fontSizeXs
```

### fontSizeS


```dart
double get fontSizeS
```

### fontSizeBase


```dart
double get fontSizeBase
```

### fontSizeM


```dart
double get fontSizeM
```

### fontSizeL


```dart
double get fontSizeL
```

### fontSizeXl


```dart
double get fontSizeXl
```

### fontSizeXxl


```dart
double get fontSizeXxl
```

### fontSizeLinkSmall


```dart
double get fontSizeLinkSmall
```

### fontSizeLinkMedium


```dart
double get fontSizeLinkMedium
```

### fontSizeLinkLarge


```dart
double get fontSizeLinkLarge
```

### fontSizeMarkExtraSmall


```dart
double get fontSizeMarkExtraSmall
```

### fontSizeMarkSmall


```dart
double get fontSizeMarkSmall
```

### fontSizeMarkMedium


```dart
double get fontSizeMarkMedium
```

### fontSizeMarkLarge


```dart
double get fontSizeMarkLarge
```

### fontSizeBodyExtraSmall


```dart
double get fontSizeBodyExtraSmall
```

### fontSizeBodySmall


```dart
double get fontSizeBodySmall
```

### fontSizeBodyMedium


```dart
double get fontSizeBodyMedium
```

### fontSizeBodyLarge


```dart
double get fontSizeBodyLarge
```

### fontSizeTitleSmall


```dart
double get fontSizeTitleSmall
```

### fontSizeTitleMedium


```dart
double get fontSizeTitleMedium
```

### fontSizeTitleLarge


```dart
double get fontSizeTitleLarge
```

### fontSizeTitleExtraLarge


```dart
double get fontSizeTitleExtraLarge
```

### fontSizeHeadlineSmall


```dart
double get fontSizeHeadlineSmall
```

### fontSizeHeadlineMedium


```dart
double get fontSizeHeadlineMedium
```

### fontSizeHeadlineLarge


```dart
double get fontSizeHeadlineLarge
```

### fontSizeDisplayMedium


```dart
double get fontSizeDisplayMedium
```

### fontSizeDisplayLarge


```dart
double get fontSizeDisplayLarge
```

### lineHeightLinkSmall


```dart
double get lineHeightLinkSmall
```

### lineHeightLinkMedium


```dart
double get lineHeightLinkMedium
```

### lineHeightLinkLarge


```dart
double get lineHeightLinkLarge
```

### lineHeightMarkExtraSmall


```dart
double get lineHeightMarkExtraSmall
```

### lineHeightMarkSmall


```dart
double get lineHeightMarkSmall
```

### lineHeightMarkMedium


```dart
double get lineHeightMarkMedium
```

### lineHeightMarkLarge


```dart
double get lineHeightMarkLarge
```

### lineHeightBodyExtraSmall


```dart
double get lineHeightBodyExtraSmall
```

### lineHeightBodySmall


```dart
double get lineHeightBodySmall
```

### lineHeightBodyMedium


```dart
double get lineHeightBodyMedium
```

### lineHeightBodyLarge


```dart
double get lineHeightBodyLarge
```

### lineHeightTitleSmall


```dart
double get lineHeightTitleSmall
```

### lineHeightTitleMedium


```dart
double get lineHeightTitleMedium
```

### lineHeightTitleLarge


```dart
double get lineHeightTitleLarge
```

### lineHeightTitleExtraLarge


```dart
double get lineHeightTitleExtraLarge
```

### lineHeightHeadlineSmall


```dart
double get lineHeightHeadlineSmall
```

### lineHeightHeadlineMedium


```dart
double get lineHeightHeadlineMedium
```

### lineHeightHeadlineLarge


```dart
double get lineHeightHeadlineLarge
```

### lineHeightDisplayMedium


```dart
double get lineHeightDisplayMedium
```

### lineHeightDisplayLarge


```dart
double get lineHeightDisplayLarge
```


## TFonts

小程序复合字体 Token。显式覆盖复合 [Font] 时以它为准；否则随独立字号和行高变化。

`extension TFonts on TThemeData`

### fontDisplayLarge


```dart
Font? get fontDisplayLarge
```

### fontDisplayMedium


```dart
Font? get fontDisplayMedium
```

### fontHeadlineLarge


```dart
Font? get fontHeadlineLarge
```

### fontHeadlineMedium


```dart
Font? get fontHeadlineMedium
```

### fontHeadlineSmall


```dart
Font? get fontHeadlineSmall
```

### fontTitleExtraLarge


```dart
Font? get fontTitleExtraLarge
```

### fontTitleLarge


```dart
Font? get fontTitleLarge
```

### fontTitleMedium


```dart
Font? get fontTitleMedium
```

### fontTitleSmall


```dart
Font? get fontTitleSmall
```

### fontBodyLarge


```dart
Font? get fontBodyLarge
```

### fontBodyMedium


```dart
Font? get fontBodyMedium
```

### fontBodySmall


```dart
Font? get fontBodySmall
```

### fontBodyExtraSmall


```dart
Font? get fontBodyExtraSmall
```

### fontMarkLarge


```dart
Font? get fontMarkLarge
```

### fontMarkMedium


```dart
Font? get fontMarkMedium
```

### fontMarkSmall


```dart
Font? get fontMarkSmall
```

### fontMarkExtraSmall


```dart
Font? get fontMarkExtraSmall
```

### fontLinkLarge


```dart
Font? get fontLinkLarge
```

### fontLinkMedium


```dart
Font? get fontLinkMedium
```

### fontLinkSmall


```dart
Font? get fontLinkSmall
```


## TRadius

内置圆角数据

`extension TRadius on TThemeData`

### radiusSmall

小圆角，默认 3 逻辑像素。

```dart
double get radiusSmall
```

### radiusDefault

默认圆角，默认 6 逻辑像素。

```dart
double get radiusDefault
```

### radiusLarge

大圆角，默认 9 逻辑像素。

```dart
double get radiusLarge
```

### radiusExtraLarge

特大圆角，默认 12 逻辑像素。

```dart
double get radiusExtraLarge
```

### radiusRound

小程序 `--td-radius-round: 999px`，Flutter 默认 999 逻辑像素。

```dart
double get radiusRound
```

### radiusCircle

Flutter 固定逻辑像素圆角，默认 9999。

小程序 `--td-radius-circle` 为 CSS `50%`；这里是明确的跨端几何例外。
自定义值仍按逻辑像素解释，不按宽高比例解释。

```dart
double get radiusCircle
```


## TBoxShadows

小程序全局外投影 Token；CSS 内投影不能直接由 Flutter [BoxShadow] 表达。

`extension TBoxShadows on TThemeData`

### shadow1

`--td-shadow-1` 基础投影。

```dart
List<BoxShadow>? get shadow1
```

### shadow2

`--td-shadow-2` 中层投影。

```dart
List<BoxShadow>? get shadow2
```

### shadow3

`--td-shadow-3` 上层投影。

```dart
List<BoxShadow>? get shadow3
```

### shadow4

`--td-shadow-4` 轻投影。

```dart
List<BoxShadow>? get shadow4
```


## TInsetShadows

小程序当前的四个 blur=0 的 inset 阴影在 Flutter 中用定向内侧边线表达。
使用方应把对应 [BorderSide] 放入 [Border.top] / right / bottom / left。

`extension TInsetShadows on TThemeData`

### shadowInsetTop


```dart
BorderSide? get shadowInsetTop
```

### shadowInsetRight


```dart
BorderSide? get shadowInsetRight
```

### shadowInsetBottom


```dart
BorderSide? get shadowInsetBottom
```

### shadowInsetLeft


```dart
BorderSide? get shadowInsetLeft
```


## TSpacers

小程序全局间距 Token；375 逻辑像素宽下按 2rpx = 1dp 转换。

`extension TSpacers on TThemeData`

### spacer

`--td-spacer`: 16rpx。

```dart
double get spacer
```

### spacer1

`--td-spacer-1`: 24rpx。

```dart
double get spacer1
```

### spacer2

`--td-spacer-2`: 32rpx。

```dart
double get spacer2
```

### spacer3

`--td-spacer-3`: 48rpx。

```dart
double get spacer3
```

### spacer4

`--td-spacer-4`: 64rpx。旧 Flutter `spacer4` 的 4dp 语义已移除。

```dart
double get spacer4
```

### spacer5

`--td-spacer-5`: 96rpx。

```dart
double get spacer5
```

### spacer6

`--td-spacer-6`: 160rpx。

```dart
double get spacer6
```


## TThemeContextExtension

BuildContext 扩展：便捷获取全局 TThemeData Token

统一走 Material 的 `Theme.of(context)`。
全库读取全局 Token（色板/间距/圆角/字体）统一用 `context.tTheme`。

`extension TThemeContextExtension on BuildContext`

### tTheme

获取全局 TThemeData（P4 Token），取不到则回退默认值

```dart
TThemeData get tTheme
```


## TThemeDataMergeExtension

ThemeData 扩展：子树 merge Extension（禁用 copyWith(extensions:) 覆盖）

子树覆盖统一用 `mergeExtension(...)`，
禁止 `copyWith(extensions: [...])`（会覆盖其它 Extension）。

`extension TThemeDataMergeExtension on ThemeData`

### mergeExtension

合并 Extension：保留现有所有 Extension，仅替换指定类型

示例：
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TTagThemeData(squareBorderRadius: 6),
  ),
  child: const TTag('局部圆角'),
)
```

```dart
ThemeData mergeExtension<T extends ThemeExtension<T>>(T extension)
```
