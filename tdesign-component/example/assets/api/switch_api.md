## API

### TSwitch

严格受控的开关组件。

`value` 由父级持有；`onChanged` 为 null 时禁用；`loading` 为 true 时
显示加载指示器并禁用交互。支持开关文字、图标与加载内容配置。

#### 构造方法

##### TSwitch

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| closeText | String? | - | text 形态的关闭文案。 null 时显示“关”；仅关闭态文本内容形态使用。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loading | bool | false | 是否处于加载状态；加载时显示指示器并禁用交互。 | 否 |
| onChanged | ValueChanged&lt;bool&gt;? | - | 开关状态变更回调；为 null 时禁用。 | 否 |
| openText | String? | - | text 形态的开启文案。 null 时显示“开”；仅开启态文本内容形态使用。 | 否 |
| size | TSwitchSize? | - | 开关尺寸；未传时为 `TSwitchSize.medium`。 | 否 |
| value | bool | - | 受控开关状态。 | 是 |
| variant | TSwitchVariant? | - | 开关内容形态；未传时为 `TSwitchVariant.filled`。 | 否 |


### TSwitchSize

开关尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| large | TSwitchSize | - | 大尺寸。 | - |
| medium | TSwitchSize | - | 中尺寸。 | - |
| small | TSwitchSize | - | 小尺寸。 | - |


### TSwitchVariant

开关内容形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| filled | TSwitchVariant | - | 无滑块内容的填充开关。 | - |
| text | TSwitchVariant | - | 滑块内显示开关文案。 | - |
| icon | TSwitchVariant | - | 滑块内显示开关图标。 | - |


### TSwitchThemeData

TSwitch 组件级 ThemeExtension

通过 Theme 子树注入，控制子树默认样式。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| disabledThumbColor | Color? | - | 禁用或加载时滑块填充色；未设置时随明暗模式取白色层级。 | 否 |
| disabledTrackOffColor | Color? | - | 禁用时关闭态轨道颜色；未设置时使用全局禁用组件背景色。 | 否 |
| disabledTrackOnColor | Color? | - | 禁用时开启态轨道颜色；未设置时使用全局禁用品牌色。 | 否 |
| loadingColor | Color? | - | 加载指示器颜色；未设置时浅色为品牌色、深色为最高层级白色。 | 否 |
| thumbColor | Color? | - | 可交互时滑块填充色；未设置时使用全局反色文字 Token。 与滑块内图标或文字的颜色无关。 | 否 |
| thumbContentOffColor | Color? | - | 关闭态滑块内容颜色。 未配置时使用 textColorDisabled Token。 | 否 |
| thumbContentOffFont | TextStyle? | - | 关闭态滑块内容文本样式。 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。 | 否 |
| thumbContentOnColor | Color? | - | 开启态滑块内容颜色。 未配置时使用 brandColor Token。 | 否 |
| thumbContentOnFont | TextStyle? | - | 开启态滑块内容文本样式。 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。 | 否 |
| trackOffColor | Color? | - | 关闭态轨道颜色。 未配置时使用 bgColorSecondaryContainerActive Token。 | 否 |
| trackOnColor | Color? | - | 开启态轨道颜色。 未配置时使用 brandColor Token。 | 否 |
