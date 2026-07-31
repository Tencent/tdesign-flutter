## API
### TDivider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TDividerAlign? | - | 中间内容在线条中的位置，默认 `TDividerAlign.center` 仅 `TDividerLayout.horizontal` 生效 |
| child | Widget? | - | 中间子元素 纯文案用 `child: Text('……')` |
| dashed | bool? | - | 是否为虚线，默认 false 仅 `TDividerLayout.horizontal` 生效 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| layout | TDividerLayout? | - | 横/竖分割线，默认 `TDividerLayout.horizontal` |


### TDividerLayout
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 水平分割线 |
| vertical | 垂直分割线 |


### TDividerAlign
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 内容靠左 |
| center | 内容居中 |
| right | 内容靠右 |
