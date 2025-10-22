## API
### TDDrawer
#### 简介
抽屉组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 组件背景颜色 |
| bordered | bool? | true | 是否显示边框 |
| closeOnOverlayClick | bool? | true | 点击蒙层时是否关闭抽屉 |
| contentWidget | Widget? | - | 自定义内容，优先级高于[items]/[footer]/[title] |
| context | BuildContext | context | 上下文 |
| drawerTop | double? | - | 距离顶部的距离 |
| footer | Widget? | - | 抽屉的底部 |
| hover | bool? | true | 是否开启点击反馈 |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线 |
| items | List<TDDrawerItem>? | - | 抽屉里的列表项 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onItemClick | TDDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| placement | TDDrawerPlacement? | TDDrawerPlacement.right | 抽屉方向 |
| showOverlay | bool? | true | 是否显示遮罩层 |
| style | TDCellStyle? | - | 列表自定义样式 |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| visible | bool? | - | 组件是否可见 |
| width | double? | 280 | 宽度 |

```
```
 ### TDDrawerWidget
#### 简介
抽屉内容组件
 可用于 Scaffold 中的 drawer 属性
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 组件背景颜色 |
| bordered | bool? | true | 是否显示边框 |
| contentWidget | Widget? | - | 自定义内容，优先级高于[items]/[footer]/[title] |
| footer | Widget? | - | 抽屉的底部 |
| hover | bool? | true | 是否开启点击反馈 |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线 |
| items | List<TDDrawerItem>? | - | 抽屉里的列表项 |
| key |  | - |  |
| onItemClick | TDDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| style | TDCellStyle? | - | 列表自定义样式 |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| width | double? | 280 | 宽度 |

```
```
 ### TDDrawerItem
#### 简介
抽屉里的列表项
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | Widget? | - | 完全自定义 |
| icon | Widget? | - | 每列图标 |
| title | String? | - | 每列标题 |
