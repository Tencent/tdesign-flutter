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
