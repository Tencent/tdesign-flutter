## API
### TSwitch
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeText | String? | - | 关闭文案 |
| enable | bool | true | 是否可点击 |
| isOn | bool | false | 是否打开 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | OnSwitchChanged? | - | 改变事件 |
| openText | String? | - | 打开文案 |
| size | TSwitchSize? | TSwitchSize.medium | 尺寸：大、中、小 |
| thumbContentOffColor | Color? | - | 关闭时ThumbView的颜色 |
| thumbContentOffFont | TextStyle? | - | 关闭时ThumbView的字体样式 |
| thumbContentOnColor | Color? | - | 开启时ThumbView的颜色 |
| thumbContentOnFont | TextStyle? | - | 开启时ThumbView的字体样式 |
| trackOffColor | Color? | - | 关闭时轨道颜色 |
| trackOnColor | Color? | - | 开启时轨道颜色 |
| type | TSwitchType? | TSwitchType.fill | 类型：填充、文本、加载 |


### TSwitchSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| medium | - |
| small | - |


### TSwitchType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| fill | - |
| text | - |
| loading | - |
| icon | - |


### OnSwitchChanged
#### 类型定义

```dart
typedef OnSwitchChanged = bool Function(bool value);
```
