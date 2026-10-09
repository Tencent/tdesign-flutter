## API

### TThemeData

#### 构造方法

##### TThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| dark | TThemeData? | - | 暗色主题 | - |
| light | TThemeData | - | 亮色主题 | - |


#### 静态方法

##### TThemeData.defaultData

获取默认Data，一个App里只有一个，用于没有context的地方

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| extraThemeData | TExtraThemeData? | - | - | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TThemeData | - | - | - |


##### TThemeData.fromJson

位置参数：`name, themeJson`


解析配置的json文件为主题数据

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| name | String | - | 主题名称，目前只支持一级键 | 是 |
| themeJson | String | - | 主题json字符串，要求json配置必须正确 | 是 |
| darkName | String? | - | 暗色主题名称；为空时使用 `${name}Dark`。 | 否 |
| recoverDefault | bool | false | 是否恢复为默认主题数据 | 否 |
| extraThemeData | TExtraThemeData? | - | 额外扩展的主题数据 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TThemeData? | - | - | - |


#### 实例方法

##### TThemeData.copyWith

复制 Token 主题并合并非空映射，返回具体的 `TThemeData`。
未传入的映射值、名称和扩展数据保留。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| name | String? | - | 字段含义：名称 调用时的空值行为见方法说明。 | 否 |
| colorMap | Map&lt;String, Color&gt;? | - | 字段含义：颜色 调用时的空值行为见方法说明。 | 否 |
| fontMap | Map&lt;String, Font&gt;? | - | 字段含义：字体尺寸 调用时的空值行为见方法说明。 | 否 |
| fontMetricMap | Map&lt;String, double&gt;? | - | 字段含义：小程序独立字号与行高 Token，单位为 Flutter 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| radiusMap | Map&lt;String, double&gt;? | - | 字段含义：圆角 调用时的空值行为见方法说明。 | 否 |
| fontFamilyMap | Map&lt;String, FontFamily&gt;? | - | 字段含义：字体样式 调用时的空值行为见方法说明。 | 否 |
| shadowMap | Map&lt;String, List&lt;BoxShadow&gt;&gt;? | - | 字段含义：阴影 调用时的空值行为见方法说明。 | 否 |
| insetShadowMap | Map&lt;String, BorderSide&gt;? | - | 字段含义：小程序 blur=0 的内投影在 Flutter 中对应的内侧边线。 调用时的空值行为见方法说明。 | 否 |
| spacerMap | Map&lt;String, double&gt;? | - | 间距 Token 的增量映射；非空值覆盖同名 Token，其他间距沿用当前配置。 | 否 |
| extraThemeData | TExtraThemeData? | - | 字段含义：额外定义的结构 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TThemeData | - | - | - |


##### TThemeData.lerp

位置参数：`other, t`


在当前主题与目标主题间生成过渡配置。

t 为 0 或 1 时返回对应端点；目标为空时返回当前主题。
颜色、字号、行高、圆角、阴影和间距按有效 Token 值插值，
单侧存在的 Token 保留；名称、字体族、业务扩展和明暗关联在 t=0.5 切换。
相同且未显式覆盖的 Token 引用继续沿用，其他值保存在新的映射中。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TThemeData&gt;? | - | 目标主题；为空或类型不匹配时返回当前主题。 | 是 |
| t | double | - | 过渡进度；0 为当前主题，1 为目标主题，离散配置在 0.5 切换。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TThemeData | - | 两端之间的 Token 主题；端点返回原主题，中间值返回独立映射。 | - |


### DefaultMapFactory

#### 回调参数

无参数。


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TMap? | - | - | - |
