## API
### TDTheme
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | TDThemeData | - | 主题数据 |
| child | Widget | - | 子控件 |
| systemData | ThemeData? | - | Flutter系统主题数据 |
| key |  | - |  |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| needMultiTheme |  |   bool value, | 开启多套主题功能 |
| setResourceBuilder |  |   required TDTDResourceBuilder delegate,  bool needAlwaysBuild, | 设置资源代理,   needAlwaysBuild=true:每次都会走build方法;如果全局有多个Delegate,需要区分情况去获取,则可以设置needAlwaysBuild为true,业务自己判断返回哪个delegate   needAlwaysBuild=false:返回delegate为null,则每次都会走build方法,返回了 |
| defaultData |  |  | 获取默认主题数据，全局唯一 |
| of |  |   BuildContext? context, | 获取主题数据，如果未传context则获取全局唯一的默认数据,   传了context，则获取最近的主题，取不到则会获取全局唯一默认数据 |
| ofNullable |  |   BuildContext? context, | 获取主题数据，取不到则可空   传了context，则获取最近的主题，取不到或未传context则返回null, |

```
```
 ### TDThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 名称 |
| colorMap | TDMap<String, Color> | - | 颜色 |
| fontMap | TDMap<String, Font> | - | 字体尺寸 |
| radiusMap | TDMap<String, double> | - | 圆角 |
| fontFamilyMap | TDMap<String, FontFamily> | - | 字体样式 |
| shadowMap | TDMap<String, List<BoxShadow>> | - | 阴影 |
| spacerMap | TDMap<String, double> | - | 间隔 |
| refMap | TDMap<String, String> | - | 映射关系 |
| extraThemeData | TDExtraThemeData? | - | 额外定义的结构 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| defaultData |  |   TDExtraThemeData? extraThemeData, | 获取默认Data，一个App里只有一个，用于没有context的地方 |
| fromJson |  |   required String name,  required String themeJson,  null recoverDefault,  TDExtraThemeData? extraThemeData, | 解析配置的json文件为主题数据 |
