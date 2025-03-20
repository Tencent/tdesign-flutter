## API
### TDSwitch
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| enable | bool | true | 是否可点击 |
| isOn | bool | false | 是否打开 |
| size | TDSwitchSize? | TDSwitchSize.medium | 尺寸：大、中、小 |
| type | TDSwitchType? | TDSwitchType.fill | 类型：填充、文本、加载 |
| trackOnColor | Color? | - | 开启时轨道颜色 |
| trackOffColor | Color? | - | 关闭时轨道颜色 |
| thumbContentOnColor | Color? | - | 开启时ThumbView的颜色 |
| thumbContentOffColor | Color? | - | 关闭时ThumbView的颜色 |
| thumbContentOnFont | TextStyle? | - | 开启时ThumbView的字体样式 |
| thumbContentOffFont | TextStyle? | - | 关闭时ThumbView的字体样式 |
| onChanged | OnSwitchChanged? | - | 改变事件 |
| openText | String? | - | 打开文案 |
| closeText | String? | - | 关闭文案 |
