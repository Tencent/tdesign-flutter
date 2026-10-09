## API

### TDivider

#### 构造方法

##### TDivider

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| align | TDividerAlign? | - | 中间内容在线条中的位置，默认 `TDividerAlign.center` 仅 `TDividerLayout.horizontal` 生效 | 否 |
| child | Widget? | - | 中间子元素 纯文案用 `child: Text('……')` | 否 |
| dashed | bool? | - | 是否为虚线，默认 false 仅 `TDividerLayout.horizontal` 生效 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TDividerLayout? | - | 横/竖分割线，默认 `TDividerLayout.horizontal` | 否 |


### TDividerLayout
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| horizontal | TDividerLayout | - | 水平分割线 | - |
| vertical | TDividerLayout | - | 垂直分割线 | - |


### TDividerAlign
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TDividerAlign | - | 内容靠左 | - |
| center | TDividerAlign | - | 内容居中 | - |
| right | TDividerAlign | - | 内容靠右 | - |
