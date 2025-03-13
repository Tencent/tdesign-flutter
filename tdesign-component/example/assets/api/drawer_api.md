## API
### TDDrawer
#### 简介
抽屉组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | context | 上下文 |
| closeOnOverlayClick | bool? | true | 点击蒙层时是否关闭抽屉 |
| footer | Widget? | - | 抽屉的底部 |
| items | List<TDDrawerItem>? | - | 抽屉里的列表项 |
| placement | TDDrawerPlacement? | TDDrawerPlacement.right | 抽屉方向 |
| showOverlay | bool? | true | 是否显示遮罩层 |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| visible | bool? | - | 组件是否可见 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onItemClick | TDDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| width | double? | 280 | 宽度 |
| drawerTop | double? | - | 距离顶部的距离 |
| style | TDCellStyle? | - | 列表自定义样式 |
| hover | bool? | true | 是否开启点击反馈 |
| backgroundColor | Color? | - | 组件背景颜色 |
| bordered | bool? | true | 是否显示边框 |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线 |
| contentWidget | Widget? | - | 自定义内容，优先级高于[items]/[footer]/[title] |

```
```
 ### TDDrawerWidget
#### 简介
抽屉内容组件
 可用于Scaffold中的drawer属性
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| footer | Widget? | - | 抽屉的底部 |
| items | List<TDDrawerItem>? | - | 抽屉里的列表项 |
| contentWidget | Widget? | - | 自定义内容，优先级高于[items]/[footer]/[title] |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| onItemClick | TDDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| width | double? | 280 | 宽度 |
| style | TDCellStyle? | - | 列表自定义样式 |
| hover | bool? | true | 是否开启点击反馈 |
| backgroundColor | Color? | - | 组件背景颜色 |
| bordered | bool? | true | 是否显示边框 |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线 |

```
```
 ### TDDrawerItem
#### 简介
抽屉里的列表项
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String? | - | 每列标题 |
| icon | Widget? | - | 每列图标 |
| content | Widget? | - | 完全自定义 |
