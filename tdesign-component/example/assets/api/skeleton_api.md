## API
### TSkeleton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animation | TSkeletonAnimation? | - | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| key |  | - |  |
| theme |  | TSkeletonTheme.text |  |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TSkeleton.fromRowCol  | 从行列框架创建骨架屏 |

```
```

### TSkeletonRowColStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowSpacing | double Function(BuildContext) | _defaultRowSpacing | 行间距 |

```
```

### TSkeletonRowCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| objects | List<List<TSkeletonRowColObj>> | - | 行列对象 |
| style | TSkeletonRowColStyle | const TSkeletonRowColStyle() | 样式 |

```
```

### TSkeletonRowColObjStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | Color Function(BuildContext) | _defaultBackground | 背景颜色 |
| borderRadius | double Function(BuildContext) | _textBorderRadius | 圆角 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TSkeletonRowColObjStyle.circle  | 圆形 |
| TSkeletonRowColObjStyle.rect  | 矩形 |
| TSkeletonRowColObjStyle.spacer  | 空白占位符 |
| TSkeletonRowColObjStyle.text  | 文本 |

```
```

### TSkeletonRowColObj
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| flex | int? | 1 | 弹性因子 |
| height | double? | 16 | 高度 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle() | 样式 |
| width | double? | - | 宽度 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TSkeletonRowColObj.circle  | 圆形 |
| TSkeletonRowColObj.rect  | 矩形 |
| TSkeletonRowColObj.spacer  | 空白占位符 |
| TSkeletonRowColObj.text  | 文本 |
