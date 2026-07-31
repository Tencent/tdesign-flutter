## API
### TThemeData

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


### DefaultMapFactory
#### 类型定义

```dart
typedef DefaultMapFactory = TMap? Function();
```
