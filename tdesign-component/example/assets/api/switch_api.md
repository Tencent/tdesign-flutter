## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSwitch
#### 简介
严格受控的开关组件。
`value` 由父级持有；`onChanged` 为 null 时禁用；`loading` 为 true 时
显示加载指示器并禁用交互。文字、图标和加载内容无法由 Material Switch
完整表达，因此底层保留 TDesign 自定义开关实现。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| closeText | String? | - | text 形态的关闭文案。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loading | bool | false | 是否处于加载状态；加载时显示指示器并禁用交互。 | 否 |
| onChanged | ValueChanged&lt;bool&gt;? | - | 开关状态变更回调；为 null 时禁用。 | 否 |
| openText | String? | - | text 形态的开启文案。 | 否 |
| size | TSwitchSize? | - | 开关尺寸；未传时为 `TSwitchSize.medium`。 | 否 |
| value | bool | - | 受控开关状态。 | 是 |
| variant | TSwitchVariant? | - | 开关内容形态；未传时为 `TSwitchVariant.filled`。 | 否 |


### TSwitchThemeData
#### 简介
TSwitch 组件级 ThemeExtension
通过 Theme 子树注入，控制子树默认样式。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| disabledThumbColor | Color? | - | 禁用或加载时滑块填充色。 | 否 |
| disabledTrackOffColor | Color? | - | 禁用时关闭态轨道颜色。 | 否 |
| disabledTrackOnColor | Color? | - | 禁用时开启态轨道颜色。 | 否 |
| loadingColor | Color? | - | 加载指示器颜色。 | 否 |
| thumbColor | Color? | - | 可交互时滑块填充色，不影响内部图标或文字。 | 否 |
| thumbContentOffColor | Color? | - | 关闭态滑块内容颜色。 | 否 |
| thumbContentOffFont | TextStyle? | - | 关闭态滑块内容文本样式。 | 否 |
| thumbContentOnColor | Color? | - | 开启态滑块内容颜色。 | 否 |
| thumbContentOnFont | TextStyle? | - | 开启态滑块内容文本样式。 | 否 |
| trackOffColor | Color? | - | 关闭态轨道颜色。 | 否 |
| trackOnColor | Color? | - | 开启态轨道颜色。 | 否 |


### TSwitchSize
#### 简介
开关尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大尺寸。 |
| medium | 中尺寸。 |
| small | 小尺寸。 |


### TSwitchVariant
#### 简介
开关内容形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| filled | 无滑块内容的填充开关。 |
| text | 滑块内显示开关文案。 |
| icon | 滑块内显示开关图标。 |
