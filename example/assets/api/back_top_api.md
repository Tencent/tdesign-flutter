## API
### TDBadge
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | ScrollController? | - | 页面滚动的控制器 |
| theme | TDBackTopTheme | TDBackTopTheme.light | 主题 |
| style | TDBackTopStyle | TDBackTopStyle.circle | 样式，圆形和半圆 |
| showText | bool | false | 是否展示文字 |
| onClick | VoidCallback? | - | 按钮点击事件 |

#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDBackTopTheme.light | 明亮主题 |
| TDBackTopTheme.dark  | 暗黑主题 |
| TDBackTopStyle.circle  | 圆形 |
| TDBackTopStyle.halfCircle  | 半圆形 |