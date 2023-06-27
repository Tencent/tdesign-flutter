## API
### TdSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| value | int | - | 当前值 |
| defaultValue | int | - | 默认值 |
| children | List<TDSideBarItem> | [] | 单项列表 |
| onChanged | ValueChanged<int> | - | 值发生变化（Controller控制） |
| onSelected | ValueChanged<int> | - | 值发生变化（点击事件） |
| style | TDSideBarStyle | TDSideBarStyle.normal | 样式风格，可选normal和outline |
| height | double | - | 高度 |
| controller | TDSideBarController | - | 控制器 |

### TDSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| value | int | -1 | 单项值 |
| label | String | '' | 标签 |
| disabled | bool | false | 是否禁用 |
| icon | IconData | - | 图标 |
| badge | TDBadge | - | 徽标 |

### TDSideBarController
#### 方法

使用controller.selectTo(value)跳转到对应的单项

