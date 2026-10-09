## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TDivider

#### 声明

```dart
class TDivider extends StatelessWidget
```

#### 默认构造方法


```dart
const TDivider({super.key, this.layout, this.align, this.dashed, this.child})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| align | TDividerAlign? | - | 中间内容在线条中的位置，默认 `TDividerAlign.center` 仅 `TDividerLayout.horizontal` 生效 | 否 |
| child | Widget? | - | 中间子元素 纯文案用 `child: Text('……')` | 否 |
| dashed | bool? | - | 是否为虚线，默认 false 仅 `TDividerLayout.horizontal` 生效 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TDividerLayout? | - | 横/竖分割线，默认 `TDividerLayout.horizontal` | 否 |


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
