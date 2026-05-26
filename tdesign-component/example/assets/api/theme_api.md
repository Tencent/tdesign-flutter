## API
### TTheme
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 子控件 |
| data | TThemeData | - | 主题数据 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| systemData | ThemeData? | - | Flutter系统主题数据 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| defaultData | TThemeData | - | 获取默认主题数据，全局唯一 |
| needMultiTheme | void | bool value | 开启多套主题功能 |
| of | TThemeData | BuildContext? context | 获取主题数据，如果未传context则获取全局唯一的默认数据, 传了context，则获取最近的主题，取不到则会获取全局唯一默认数据 |
| ofNullable | TThemeData? | BuildContext? context | 获取主题数据，取不到则可空 传了context，则获取最近的主题，取不到或未传context则返回null, |
| setResourceBuilder | void | required TResourceBuilder delegate, bool needAlwaysBuild | 设置资源代理, needAlwaysBuild=true:每次都会走build方法;如果全局有多个Delegate,需要区分情况去获取,则可以设置needAlwaysBuild为true,业务自己判断返回哪个delegate needAlwaysBuild=false:返回delegate为null,则每次都会走build方法,返回了 |


### TThemeData
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


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| defaultData | TThemeData | TExtraThemeData? extraThemeData | 获取默认Data，一个App里只有一个，用于没有context的地方 |
| fromJson | TThemeData? | required String name, required String themeJson, String? darkName, recoverDefault, TExtraThemeData? extraThemeData | 解析配置的json文件为主题数据 [name] 主题名称，目前只支持一级键 [themeJson] 主题json字符串，要求json配置必须正确 [recoverDefault] 是否恢复为默认主题数据 [extraThemeData] 额外扩展的主题数据 |
| parseThemeData | TThemeData | required String name, required themeConfig, required TExtraThemeData? extraThemeData | - |


### DefaultMapFactory
#### 类型定义

```dart
typedef DefaultMapFactory = TMap? Function();
```
