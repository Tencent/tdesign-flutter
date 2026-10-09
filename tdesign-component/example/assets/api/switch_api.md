## API

### TSwitch

#### 构造方法

##### TSwitch

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

#### 构造方法

##### TSwitchThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


#### 实例方法

##### TSwitchThemeData.copyWith

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| trackOnColor | Color? | - | 字段含义：开启时轨道颜色 调用时的空值行为见方法说明。 | 否 |
| trackOffColor | Color? | - | 字段含义：关闭时轨道颜色 调用时的空值行为见方法说明。 | 否 |
| disabledTrackOnColor | Color? | - | 字段含义：禁用时开启态轨道颜色；未设置时使用全局禁用品牌色。 调用时的空值行为见方法说明。 | 否 |
| disabledTrackOffColor | Color? | - | 字段含义：禁用时关闭态轨道颜色；未设置时使用全局禁用组件背景色。 调用时的空值行为见方法说明。 | 否 |
| thumbColor | Color? | - | 字段含义：可交互时滑块填充色；未设置时使用全局反色文字 Token。 与滑块内图标或文字的颜色无关。 调用时的空值行为见方法说明。 | 否 |
| disabledThumbColor | Color? | - | 字段含义：禁用或加载时滑块填充色；未设置时随明暗模式取白色层级。 调用时的空值行为见方法说明。 | 否 |
| loadingColor | Color? | - | 字段含义：加载指示器颜色；未设置时浅色为品牌色、深色为最高层级白色。 调用时的空值行为见方法说明。 | 否 |
| thumbContentOnColor | Color? | - | 字段含义：开启时ThumbView的颜色 调用时的空值行为见方法说明。 | 否 |
| thumbContentOffColor | Color? | - | 字段含义：关闭时ThumbView的颜色 调用时的空值行为见方法说明。 | 否 |
| thumbContentOnFont | TextStyle? | - | 字段含义：开启时ThumbView的字体样式 调用时的空值行为见方法说明。 | 否 |
| thumbContentOffFont | TextStyle? | - | 字段含义：关闭时ThumbView的字体样式 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSwitchThemeData | - | - | - |


##### TSwitchThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSwitchThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSwitchThemeData | - | - | - |
