## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TFooter
#### 简介
页面底部的版权、链接和品牌信息区域。

#### 声明

```dart
class TFooter extends StatelessWidget
```

#### 默认构造方法


```dart
const TFooter({Key? key, this.logo, this.text = '', this.links = const []})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| links | List&lt;Widget&gt; | const [] | 链接内容；多个链接之间自动绘制分隔线。 | 否 |
| logo | Widget? | - | 品牌内容；可与 `text` 组合展示，非空时不展示 `links`。 | 否 |
| text | String | '' | 文字 | 否 |


### TFooterThemeData
#### 简介
页脚组件级 ThemeExtension。
未配置 `height` 时，页脚按内容自然撑开；配置后才会约束外层高度。

#### 声明

```dart
class TFooterThemeData extends ThemeExtension<TFooterThemeData>
```

#### 默认构造方法


```dart
const TFooterThemeData({this.height})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| height | double? | - | 页脚外层高度。 默认值为 null，表示由 logo、链接或文字内容自然决定高度；这与 TDesign 小程序 Footer 的内容驱动布局一致。 | 否 |


#### 实例方法

##### TFooterThemeData.copyWith

```dart
TFooterThemeData copyWith({double? height})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TFooterThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| height | double? | - | 页脚外层高度。 默认值为 null，表示由 logo、链接或文字内容自然决定高度；这与 TDesign 小程序 Footer 的内容驱动布局一致。 | 否 |


##### TFooterThemeData.lerp

```dart
TFooterThemeData lerp(ThemeExtension<TFooterThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TFooterThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TFooterThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |
