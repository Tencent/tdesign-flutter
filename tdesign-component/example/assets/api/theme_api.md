## API
### TDTheme
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 子控件 |
| data | TDThemeData | - | 主题数据 |
| key |  | - |  |
| systemData | ThemeData? | - | Flutter系统主题数据 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| defaultData |  |  | 获取默认主题数据，全局唯一 |
| needMultiTheme |  |   bool value, | 开启多套主题功能 |
| of |  |   BuildContext? context, | 获取主题数据，如果未传context则获取全局唯一的默认数据,   传了context，则获取最近的主题，取不到则会获取全局唯一默认数据 |
| ofNullable |  |   BuildContext? context, | 获取主题数据，取不到则可空   传了context，则获取最近的主题，取不到或未传context则返回null, |
| setResourceBuilder |  |   required TDTDResourceBuilder delegate,  bool needAlwaysBuild, | 设置资源代理,   needAlwaysBuild=true:每次都会走build方法;如果全局有多个Delegate,需要区分情况去获取,则可以设置needAlwaysBuild为true,业务自己判断返回哪个delegate   needAlwaysBuild=false:返回delegate为null,则每次都会走build方法,返回了 |

```
```
 ### TDThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| colorMap | TDMap<String, Color> | - | 颜色 |
| extraThemeData | TDExtraThemeData? | - | 额外定义的结构 |
| fontFamilyMap | TDMap<String, FontFamily> | - | 字体样式 |
| fontMap | TDMap<String, Font> | - | 字体尺寸 |
| name | String | - | 名称 |
| radiusMap | TDMap<String, double> | - | 圆角 |
| refMap | TDMap<String, String> | - | 映射关系 |
| shadowMap | TDMap<String, List<BoxShadow>> | - | 阴影 |
| spacerMap | TDMap<String, double> | - | 间隔 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| defaultData |  |   TDExtraThemeData? extraThemeData, | 获取默认Data，一个App里只有一个，用于没有context的地方 |
| fromJson |  |   required String name,  required String themeJson,  String? darkName,  null recoverDefault,  TDExtraThemeData? extraThemeData, | 解析配置的json文件为主题数据     [name] 主题名称，目前只支持一级键     [themeJson] 主题json字符串，要求json配置必须正确     [recoverDefault] 是否恢复为默认主题数据     [extraThemeData] 额外扩展的主题数据 |
| parseThemeData |  |   required String name,  required null themeConfig,  required TDExtraThemeData? extraThemeData, |  |
