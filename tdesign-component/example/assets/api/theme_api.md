## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TThemeData
#### 简介
主题数据

#### 静态方法

##### TThemeData.defaultData

获取默认Data，一个App里只有一个，用于没有context的地方

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 | 否 |


##### TThemeData.fromJson

解析配置的json文件为主题数据

返回类型：`TThemeData?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 主题名称，目前只支持一级键 | 是 |
| themeJson | String | - | 主题json字符串，要求json配置必须正确 | 是 |
| darkName | String? | - | 暗色主题名称；为空时使用 `${name}Dark`。 | 否 |
| recoverDefault | bool | false | 是否恢复为默认主题数据 | 否 |
| extraThemeData | TExtraThemeData? | - | 额外扩展的主题数据 | 否 |


##### TThemeData.parseThemeData

从已解析的 `themeConfig` 读取 `name` 对应的主题；不存在或为空时返回空主题。

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 名称 | 是 |
| themeConfig | dynamic | - | 已解析的主题 JSON 配置。 | 是 |
| extraThemeData | TExtraThemeData? | - | 非空时参与扩展数据解析。 | 是 |

#### 默认构造方法

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

##### TThemeData.copyWithTThemeData

从父类拷贝

返回类型：`TThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 名称 | 是 |
| colorMap | Map&lt;String, Color&gt;? | - | 颜色 | 否 |
| fontMap | Map&lt;String, Font&gt;? | - | 字体尺寸 | 否 |
| fontMetricMap | Map&lt;String, double&gt;? | - | 小程序独立字号与行高 Token，单位为 Flutter 逻辑像素。 | 否 |
| radiusMap | Map&lt;String, double&gt;? | - | 圆角 | 否 |
| fontFamilyMap | Map&lt;String, FontFamily&gt;? | - | 字体样式 | 否 |
| shadowMap | Map&lt;String, List&lt;BoxShadow&gt;&gt;? | - | 阴影 | 否 |
| insetShadowMap | Map&lt;String, BorderSide&gt;? | - | 小程序 blur=0 的内投影在 Flutter 中对应的内侧边线。 | 否 |
| marginMap | Map&lt;String, double&gt;? | - | 间距 Token 的增量配置；沿用 marginMap 参数名，合并到 spacerMap。 | 否 |
| extraThemeData | TExtraThemeData? | - | 额外定义的结构 | 否 |


##### TThemeData.ofColor

按 `key` 读取颜色 Token；没有本地配置且无法解析引用或默认映射时返回 null。

返回类型：`Color?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | String? | - | 组件标识，用于区分或保留组件状态。 | 是 |


##### TThemeData.ofCorner

按 `key` 读取圆角 Token，单位为逻辑像素；找不到时返回 null。

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | String? | - | 组件标识，用于区分或保留组件状态。 | 是 |


##### TThemeData.ofExtra

读取指定 TExtraThemeData 子类型的扩展数据；未配置或类型不匹配时返回 null。

返回类型：`T?`

##### TThemeData.ofFont

按 `key` 读取复合字体 Token；没有本地配置且无法解析引用或默认映射时返回 null。

返回类型：`Font?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | String? | - | 组件标识，用于区分或保留组件状态。 | 是 |


##### TThemeData.ofFontFamily

按 `key` 读取字体栈 Token；找不到时返回 null。

返回类型：`FontFamily?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | String? | - | 组件标识，用于区分或保留组件状态。 | 是 |


##### TThemeData.ofShadow

按 `key` 读取外投影列表；找不到时返回 null。

返回类型：`List<BoxShadow>?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | String? | - | 组件标识，用于区分或保留组件状态。 | 是 |


### Font
#### 简介
字体宽高数据

#### 工厂构造方法

##### Font.fromJson

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| map | Map&lt;String, dynamic&gt; | - | 字体 JSON 配置，包含 size、lineHeight 和可选的 fontWeight（1 至 9，默认 4）。 | 是 |

#### 默认构造方法

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

#### 工厂构造方法

##### FontFamily.fromJson

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| map | Map&lt;String, dynamic&gt; | - | 字体栈 JSON 配置，包含 fontFamily、可选 package 和 fallback。 | 是 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| fallback | List&lt;String&gt;? | - | 主字体不可用时按顺序尝试的备用字体名称。 | 否 |
| fontFamily | String | - | 主字体名称。 | 是 |
| package | String? | - | 字体所在资源包；为空时从应用或系统字体解析。 | 否 |


### TResourceManager
#### 简介
资源管理器
#### 默认构造方法
`TResourceManager()`

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| instance | TResourceManager | - | 单例对象 |


#### 实例方法

##### TResourceManager.delegate

获取资源

返回类型：`TResourceDelegate`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |


##### TResourceManager.setResourceBuilder

设置资源代理

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| delegate | TResourceBuilder | - | 根据构建上下文提供资源代理的回调。 | 是 |
| needAlwaysBuild | dynamic | - | 是否每次读取资源时调用构建器；false 时复用首次成功构建的缓存，返回 null 时继续尝试构建。 | 是 |


### TResourceDelegate
#### 简介
资源管理器，允许外部重写，设计成抽象类，防止有新增字段时，用户没有感知
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

`TPicker` 第 `colIndex` 列（1-based）的无障碍 label

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| colIndex | int | - | 从 1 开始的滚轮列序号。 | 是 |


### TStyleResolver
#### 简介
TDesign 样式解析器。
实例显式样式、组件 Theme 和全局 Token 是单向样式链。
用法：

#### 静态方法

##### TStyleResolver.of

创建解析器实例

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

组件 ThemeExtension。

返回类型：`E?`

### TMaterialThemeBuilder
#### 简介
Token → 完整 ThemeData 的构建器
四层架构的 L2 层：接收 `TThemeData` token，产出完整 `ThemeData`。
内部完成 Token → ColorScheme 映射、Token Font → TextTheme、
Token 颜色 → M3 子主题，同时将 `TThemeData` 自身作为 Extension 注入。
通常不直接使用，通过 `TThemeBuilder.light` / `TThemeBuilder.dark` 入口。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| token | TThemeData | - | Token 数据源 | 是 |


#### 实例方法

##### TMaterialThemeBuilder.buildDark

构建暗色 ThemeData

返回类型：`ThemeData`

##### TMaterialThemeBuilder.buildLight

构建亮色 ThemeData

返回类型：`ThemeData`

### TThemeBuilder
#### 简介
应用入口：Token → 完整 ThemeData
对齐 `MaterialApp.theme` / `darkTheme` / `themeMode` 三参数模式。
用法：

#### 静态方法

##### TThemeBuilder.dark

暗色主题

返回类型：`ThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| token | TThemeData | - | 用于构建完整 Material 主题的 Token 数据源。 | 是 |


##### TThemeBuilder.light

亮色主题

返回类型：`ThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| token | TThemeData | - | 用于构建完整 Material 主题的 Token 数据源。 | 是 |


### TExtraThemeData
#### 简介
扩展主题数据

#### 实例方法

##### TExtraThemeData.parse

解析json

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 待解析主题的名称。 | 是 |
| curThemeMap | Map&lt;String, dynamic&gt; | - | 当前主题对应的已解析 JSON 映射。 | 是 |


### TMap
#### 简介
自定义Map
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| factory | DefaultMapFactory? | - | 查不到本地值或引用值时获取默认映射的回调；为空时不使用默认映射。 | 否 |
| refs | TMap? | - | Token 名称到引用名称的映射；本地显式值优先于引用，循环引用会中止该引用链的解析。 | 否 |


#### 实例方法

##### TMap.get

仅读取 `key` 的本地存储值，不解析引用或默认映射。

返回类型：`V?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Object? | - | 组件标识，用于区分或保留组件状态。 | 是 |


### PlatformUtil
#### 简介
区分 Flutter Web 与原生宿主平台的工具。
#### 默认构造方法
`PlatformUtil()`

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
#### 默认构造方法

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

#### 实例方法

##### FontExtensions.withSize

返回使用 `newSize` 字号的字体副本，保留字重，并按当前行高比例计算新行高后取整。

返回类型：`Font`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| newSize | int | - | 字体大小，单位为逻辑像素。 | 是 |


### TColors
#### 简介
业务使用时有两种方法替换主题：
第一种：有独立设计风格的app，明确知道哪些色值用到，哪些设置没用到，有自己设计规范，则可单独配置色值。
第二种：直接接入TDesign，配置所有色值组，此时不需再自定义key-value，可以直接使用。
如果业务需要扩展，可以按以下方式定义自己的ColorData，只要key在主题中能找到对应颜色即可
TDesign主题包含的颜色，这是一个大而全的色值。业务可以选择自己需要的色值进行二次封装，方便使用。
不过有的色值是内部使用的，必传，否则可能显示异常。
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bgColorComponent | Color | - | 组件默认背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorComponentActive | Color | - | 组件按压态背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorComponentDisabled | Color | - | 组件禁用态背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorContainer | Color | - | 小程序 `--td-bg-color-container`；浅色默认引用 `fontWhite1`。 |
| bgColorContainerActive | Color | - | 容器背景的按压态颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorPage | Color | - | 组件颜色配置---------------------------------------------------- |
| bgColorSecondaryComponent | Color | - | 小程序 `--td-bg-color-secondarycomponent`，默认引用灰阶 4。 |
| bgColorSecondaryComponentActive | Color | - | 小程序 `--td-bg-color-secondarycomponent-active`，默认引用灰阶 6。 |
| bgColorSecondaryContainer | Color | - | 次级容器背景色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorSecondaryContainerActive | Color | - | 次级容器背景的按压态颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| bgColorSpecialComponent | Color | - | 小程序 `--td-bg-color-specialcomponent`；暗色主题默认透明。 |
| borderLevel1Color | Color | - | 小程序一级分割线颜色，默认与 `componentStroke` 使用同一色阶。 |
| borderLevel2Color | Color | - | 小程序二级边框颜色，默认与 `componentBorder` 使用同一色阶。 |
| brandColor | Color | - | #0052D9 |
| brandColor1 | Color | - | #F2F3FF |
| brandColor10 | Color | - | #001A57 |
| brandColor2 | Color | - | #D9E1FF |
| brandColor3 | Color | - | #B5C7FF |
| brandColor4 | Color | - | #8EABFF |
| brandColor5 | Color | - | #618DFF |
| brandColor6 | Color | - | #366EF4 |
| brandColor7 | Color | - | #0052D9 |
| brandColor8 | Color | - | #003CAB |
| brandColor9 | Color | - | #002A7C |
| brandColorActive | Color | - | #003CAB |
| brandColorDisabled | Color | - | #B5C7FF |
| brandColorFocus | Color | - | #F2F3FF |
| brandColorLight | Color | - | #F2F3FF |
| brandColorLightActive | Color | - | 浅色品牌色点击态，默认使用品牌色阶 2。 |
| componentBorder | Color | - | 组件边框颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| componentStroke | Color | - | 组件分隔线颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| errorColor | Color | - | #D54941 |
| errorColor1 | Color | - | 错误色组---------------------------------------------------- #FFF0ED |
| errorColor10 | Color | - | #490002 |
| errorColor2 | Color | - | #FFD8D2 |
| errorColor3 | Color | - | #FFB9B0 |
| errorColor4 | Color | - | #FF9285 |
| errorColor5 | Color | - | #F6685D |
| errorColor6 | Color | - | #D54941 |
| errorColor7 | Color | - | #AD352F |
| errorColor8 | Color | - | #881F1C |
| errorColor9 | Color | - | #68070A |
| errorColorActive | Color | - | #AD352F |
| errorColorDisabled | Color | - | #FFB9B0 |
| errorColorFocus | Color | - | #FFD8D2 |
| errorColorLight | Color | - | #FFF0ED |
| errorColorLightActive | Color | - | 浅色错误色点击态，默认使用错误色阶 2。 |
| fontGray1 | Color | - | 文字色组---------------------------------------------------- #e6000000 |
| fontGray2 | Color | - | #99000000 |
| fontGray3 | Color | - | #66000000 |
| fontGray4 | Color | - | #42000000 |
| fontWhite1 | Color | - | #FFFFFFFF |
| fontWhite2 | Color | - | #8CFFFFFF |
| fontWhite3 | Color | - | #59FFFFFF |
| fontWhite4 | Color | - | #38FFFFFF |
| grayColor1 | Color | - | #F3F3F3 |
| grayColor10 | Color | - | #4B4B4B |
| grayColor11 | Color | - | #383838 |
| grayColor12 | Color | - | #2C2C2C |
| grayColor13 | Color | - | #242424 |
| grayColor14 | Color | - | #181818 |
| grayColor2 | Color | - | #EEEEEE |
| grayColor3 | Color | - | #E8E8E8 |
| grayColor4 | Color | - | #DCDCDC |
| grayColor5 | Color | - | #C5C5C5 |
| grayColor6 | Color | - | #A6A6A6 |
| grayColor7 | Color | - | #8B8B8B |
| grayColor8 | Color | - | #777777 |
| grayColor9 | Color | - | #5E5E5E |
| maskActive | Color | - | 弹层遮罩色。 |
| maskBackground | Color | - | 二维码等背景遮罩色。 |
| maskDisabled | Color | - | 禁用态遮罩色。 |
| primaryColor1 | Color | - | 功能色组---------------------------------------------------- 小程序 `--td-primary-color-*` 色阶；默认分别引用同级品牌色阶。 |
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
| successColor | Color | - | #2BA471 |
| successColor1 | Color | - | 成功色组---------------------------------------------------- #E3F9E9 |
| successColor10 | Color | - | #002515 |
| successColor2 | Color | - | #C6F3D7 |
| successColor3 | Color | - | #92DAB2 |
| successColor4 | Color | - | #56C08D |
| successColor5 | Color | - | #2BA471 |
| successColor6 | Color | - | #008858 |
| successColor7 | Color | - | #006C45 |
| successColor8 | Color | - | #005334 |
| successColor9 | Color | - | #003B23 |
| successColorActive | Color | - | #008858 |
| successColorDisabled | Color | - | #92DAB2 |
| successColorFocus | Color | - | #C6F3D7 |
| successColorLight | Color | - | #E3F9E9 |
| successColorLightActive | Color | - | 浅色成功色点击态，默认使用成功色阶 2。 |
| tableShadowColor | Color | - | 表格专用阴影色。 |
| textColorAnti | Color | - | 小程序 `--td-text-color-anti`，默认引用 `fontWhite1`。 |
| textColorBrand | Color | - | 品牌文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorDisabled | Color | - | 禁用文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorLink | Color | - | 链接文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorPlaceholder | Color | - | 占位文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| textColorPrimary | Color | - | 文字颜色配置---------------------------------------------------- |
| textColorSecondary | Color | - | 次要文字颜色；优先读取同名颜色 Token，否则使用内置回退色。 |
| warningColor | Color | - | #E37318 |
| warningColor1 | Color | - | 警告色组---------------------------------------------------- #FFF1E9 |
| warningColor10 | Color | - | #3B1700 |
| warningColor2 | Color | - | #FFD9C2 |
| warningColor3 | Color | - | #FFB98C |
| warningColor4 | Color | - | #FA9550 |
| warningColor5 | Color | - | #E37318 |
| warningColor6 | Color | - | #BE5A00 |
| warningColor7 | Color | - | #954500 |
| warningColor8 | Color | - | #713300 |
| warningColor9 | Color | - | #532300 |
| warningColorActive | Color | - | #BE5A00 |
| warningColorDisabled | Color | - | #FFB98C |
| warningColorFocus | Color | - | #FFD9C2 |
| warningColorLight | Color | - | #FFF1E9 |
| warningColorLightActive | Color | - | 浅色警告色点击态，默认使用警告色阶 2。 |
| whiteColor1 | Color | - | 中性面板色组---------------------------------------------------- #FFFFFF |


### TResolvedFontFamily
#### 简介
将小程序的 CSS 字体栈转换为当前 Flutter 平台可绘制的字体选择。
保留 Token 原值；非 Apple 平台对默认栈使用 Roboto 作为主字体。
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| flutterFontFamily | String | - | Flutter 使用的主字体；非 Apple 平台的默认中文字体栈回退为 Roboto，其他配置保持原值。 |
| flutterFontFamilyFallback | List&lt;String&gt;? | - | Flutter 的备用字体栈；PingFang SC 栈未包含 Roboto 时追加它，其他配置保持原值。 |


### TFontFamilies
#### 简介
按主题 Token 读取主字体与中等字重字体栈。
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fontFamily | FontFamily? | - | 小程序 `--td-font-family`；可用于 Flutter `TextStyle.fontFamily` 和 `fontFamilyFallback`。`TText` 在非 Apple 平台会为默认字体栈选择 Flutter 可用的主字体，不改变这里保存的小程序原始值。 |
| fontFamilyMedium | FontFamily? | - | 小程序 `--td-font-family-medium`。 |


### TFontMetrics
#### 简介
小程序独立字号与行高 Token。CSS 中 `--td-font-*` 由这些变量组合而成。
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
小程序复合字体 Token。显式覆盖复合 `Font` 时以它为准；否则随独立字号和行高变化。
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
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| radiusCircle | double | - | Flutter 固定逻辑像素圆角，默认 9999。 小程序 `--td-radius-circle` 为 CSS `50%`；这里是明确的跨端几何例外。 自定义值仍按逻辑像素解释，不按宽高比例解释。 |
| radiusDefault | double | - | 默认圆角，默认 6 逻辑像素。 |
| radiusExtraLarge | double | - | 特大圆角，默认 12 逻辑像素。 |
| radiusLarge | double | - | 大圆角，默认 9 逻辑像素。 |
| radiusRound | double | - | 小程序 `--td-radius-round: 999px`，Flutter 默认 999 逻辑像素。 |
| radiusSmall | double | - | 小圆角，默认 3 逻辑像素。 |


### TBoxShadows
#### 简介
小程序全局外投影 Token；CSS 内投影不能直接由 Flutter `BoxShadow` 表达。
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| shadow1 | List&lt;BoxShadow&gt;? | - | `--td-shadow-1` 基础投影。 |
| shadow2 | List&lt;BoxShadow&gt;? | - | `--td-shadow-2` 中层投影。 |
| shadow3 | List&lt;BoxShadow&gt;? | - | `--td-shadow-3` 上层投影。 |
| shadow4 | List&lt;BoxShadow&gt;? | - | `--td-shadow-4` 轻投影。 |


### TInsetShadows
#### 简介
小程序当前的四个 blur=0 的 inset 阴影在 Flutter 中用定向内侧边线表达。
使用方应把对应 `BorderSide` 放入 `Border.top` / right / bottom / left。
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| shadowInsetBottom | BorderSide? | - | 底部内投影对应的边线 Token；未配置时返回 null。 |
| shadowInsetLeft | BorderSide? | - | 左侧内投影对应的边线 Token；未配置时返回 null。 |
| shadowInsetRight | BorderSide? | - | 右侧内投影对应的边线 Token；未配置时返回 null。 |
| shadowInsetTop | BorderSide? | - | 顶部内投影对应的边线 Token；未配置时返回 null。 |


### TSpacers
#### 简介
小程序全局间距 Token；375 逻辑像素宽下按 2rpx = 1dp 转换。
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| spacer | double | - | `--td-spacer`: 16rpx。 |
| spacer1 | double | - | `--td-spacer-1`: 24rpx。 |
| spacer2 | double | - | `--td-spacer-2`: 32rpx。 |
| spacer3 | double | - | `--td-spacer-3`: 48rpx。 |
| spacer4 | double | - | `--td-spacer-4`: 64rpx。旧 Flutter `spacer4` 的 4dp 语义已移除。 |
| spacer5 | double | - | `--td-spacer-5`: 96rpx。 |
| spacer6 | double | - | `--td-spacer-6`: 160rpx。 |


### TThemeContextExtension
#### 简介
BuildContext 扩展：便捷获取全局 TThemeData Token
统一走 Material 的 `Theme.of(context)`。
全库读取全局 Token（色板/间距/圆角/字体）统一用 `context.tTheme`。
#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tTheme | TThemeData | - | 获取全局 TThemeData（P4 Token），取不到则回退默认值 |


### TThemeDataMergeExtension
#### 简介
ThemeData 扩展：子树 merge Extension（禁用 copyWith(extensions:) 覆盖）
子树覆盖统一用 `mergeExtension(...)`，
禁止 `copyWith(extensions: [...])`（会覆盖其它 Extension）。

#### 实例方法

##### TThemeDataMergeExtension.mergeExtension

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

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| delegate | TResourceBuilder | - | 根据构建上下文提供资源代理的回调。 | 是 |
| needAlwaysBuild | bool | false | 是否每次读取资源时调用构建器；false 时复用首次成功构建的缓存，返回 null 时继续尝试构建。 | 否 |


### TResourceBuilder
#### 简介
根据当前构建上下文提供资源代理；返回 null 时使用默认文案。
#### 类型定义

```dart
typedef TResourceBuilder = TResourceDelegate? Function(BuildContext context);
```


### DefaultMapFactory
#### 简介
创建默认 Token 映射的回调；返回 null 时不提供默认值。
#### 类型定义

```dart
typedef DefaultMapFactory = TMap? Function();
```
