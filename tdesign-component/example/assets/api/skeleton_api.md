## API
### TDSkeletonRowColStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowSpacing | double Function(BuildContext) | _defaultRowSpacing | 行间距 |

```
```
 ### TDSkeletonRowCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| objects | List<List<TDSkeletonRowColObj>> | - | 行列对象 |
| style | TDSkeletonRowColStyle | const TDSkeletonRowColStyle() | 样式 |

```
```
 ### TDSkeletonRowColObjStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | Color Function(BuildContext) | _defaultBackground | 背景颜色 |
| borderRadius | double Function(BuildContext) | _textBorderRadius | 圆角 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDSkeletonRowColObjStyle.circle  | 圆形 |
| TDSkeletonRowColObjStyle.rect  | 矩形 |
| TDSkeletonRowColObjStyle.text  | 文本 |
| TDSkeletonRowColObjStyle.spacer  | 空白占位符 |

```
```
 ### TDSkeletonRowColObj
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度 |
| height | double? | 16 | 高度 |
| flex | int? | 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TDSkeletonRowColObjStyle | const TDSkeletonRowColObjStyle() | 样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDSkeletonRowColObj.circle  | 圆形 |
| TDSkeletonRowColObj.rect  | 矩形 |
| TDSkeletonRowColObj.text  | 文本 |
| TDSkeletonRowColObj.spacer  | 空白占位符 |

```
```
 ### TDSkeleton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| animation | TDSkeletonAnimation? | - | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| theme |  | TDSkeletonTheme.text |  |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDSkeleton.fromRowCol  | 从行列框架创建骨架屏 |
