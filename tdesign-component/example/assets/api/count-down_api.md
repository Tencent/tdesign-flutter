## API
### TDCountDown
#### 简介
倒计时组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| autoStart | bool | true | 是否自动开始倒计时 |
| content | dynamic | 'default' | 'default'/Widget Function(int time)/Widget |
| format | String | 'HH:mm:ss' | 时间格式，DD-日，HH-时，mm-分，ss-秒，SSS-毫秒 |
| millisecond | bool | false | 是否开启毫秒级渲染 |
| size | TDCountDownSize | TDCountDownSize.medium | 倒计时尺寸 |
| splitWithUnit | bool | false | 使用时间单位分割 |
| theme | TDCountDownTheme | TDCountDownTheme.defaultTheme | 倒计时风格 |
| time | int | - | 必需；倒计时时长，单位毫秒 |
| style | TDCountDownStyle? | - | 自定义样式，有则优先用它，没有则根据size和theme选取 |
| onChange |  Function(int time)? | - | 时间变化时触发回调 |
| onFinish | VoidCallback? | - | 倒计时结束时触发回调 |

```
```
 ### TDCountDownStyle
#### 简介
倒计时组件样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| timeWidth | double? | - | 时间容器宽度 |
| timeHeight | double? | - | 时间容器高度 |
| timePadding | EdgeInsets? | - | 时间容器内边距 |
| timeMargin | EdgeInsets? | - | 时间容器外边距 |
| timeBox | BoxDecoration? | - | 时间容器装饰 |
| timeFontFamily | FontFamily? | - | 时间字体 |
| timeFontSize | double? | - | 时间字体尺寸 |
| timeFontHeight | double? | - | 时间字体行高 |
| timeFontWeight | FontWeight? | - | 时间字体粗细 |
| timeColor | Color? | - | 时间字体颜色 |
| splitFontSize | double? | - | 分隔符字体尺寸 |
| splitFontHeight | double? | - | 分隔符字体行高 |
| splitFontWeight | FontWeight? | - | 分隔符字体粗细 |
| splitColor | Color? | - | 分隔符字体颜色 |
| space | double? | - | 时间与分隔符的间隔 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDCountDownStyle.generateStyle  | 生成默认样式 |
