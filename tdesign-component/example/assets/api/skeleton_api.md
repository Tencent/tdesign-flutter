## API
### TDSkeleton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| animation | TDSkeletonAnimation? | null | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| theme | TDSkeletonTheme | TDSkeletonTheme.text | 风格 |


#### 命名构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| animation | TDSkeletonAnimation? | null | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| rowCol | TDSkeletonRowCol | - | 自定义行列数量、宽度高度、间距等 |

```
```
 ### TDSkeletonRowColStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowSpacing | double Function(BuildContext) | (context) => TDTheme.of(context).spacer16 | 行间距 |

```
```
 ### TDSkeletonRowCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| objects | List<List<TDSkeletonRowColObj>> | - | 行列对象 |
| style | TDSkeletonRowColStyle | TDSkeletonRowColStyle() | 样式 |

```
```
 ### TDSkeletonRowColObjStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | double Function(BuildContext) | (context) => TDTheme.of(context).grayColor1 | 背景颜色 |
| borderRadius | double Function(BuildContext) | (context) => TDTheme.of(context).radiusSmall | 圆角 |


#### 工厂构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | double Function(BuildContext) | (context) => TDTheme.of(context).grayColor1 | 背景颜色 |

```
```
 ### TDSkeletonRowColObj
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | null | 宽度 |
| height | double? | 16 | 高度 |
| flex | int? | 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TDSkeletonRowColObjStyle | TDSkeletonRowColObjStyle() | 样式 |


#### 工厂构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | 48 / null | 宽度 |
| height | double? | 48 / 16 / null | 高度 |
| flex | int? | null / 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TDSkeletonRowColObjStyle | TDSkeletonRowColObjStyle.circle() / TDSkeletonRowColObjStyle.rect() / TDSkeletonRowColObjStyle.text() / TDSkeletonRowColObjStyle.spacer() | 样式 |