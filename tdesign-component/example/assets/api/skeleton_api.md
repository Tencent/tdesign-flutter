## API
### TSkeleton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animation | TSkeletonAnimation? | - | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| theme | TSkeletonTheme | TSkeletonTheme.text | - |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowCol | TSkeletonRowCol | - | 自定义行列数量、宽度高度、间距等 |


#### 工厂构造方法

##### TSkeleton.fromRowCol

从行列框架创建骨架屏

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| animation | TSkeletonAnimation? | - | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| rowCol | TSkeletonRowCol | - | 自定义行列数量、宽度高度、间距等 |


### TSkeletonRowColStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowSpacing | double Function(BuildContext) | _defaultRowSpacing | 行间距 |


### TSkeletonRowCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| objects | List<List<TSkeletonRowColObj>> | - | 行列对象 |
| style | TSkeletonRowColStyle | const TSkeletonRowColStyle() | 样式 |


### TSkeletonRowColObjStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | Color Function(BuildContext) | _defaultBackground | 背景颜色 |
| borderRadius | double Function(BuildContext) | _textBorderRadius | 圆角 |


#### 工厂构造方法

##### TSkeletonRowColObjStyle.circle

圆形

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | Color Function(BuildContext) | _defaultBackground | 背景颜色 |


##### TSkeletonRowColObjStyle.rect

矩形

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | Color Function(BuildContext) | _defaultBackground | 背景颜色 |


##### TSkeletonRowColObjStyle.spacer

空白占位符

##### TSkeletonRowColObjStyle.text

文本

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| background | Color Function(BuildContext) | _defaultBackground | 背景颜色 |


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

##### TSkeletonRowColObj.circle

圆形

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | 48 | 宽度 |
| height | double? | 48 | 高度 |
| flex | int? | - | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle.circle() | 样式 |


##### TSkeletonRowColObj.rect

矩形

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度 |
| height | double? | 16 | 高度 |
| flex | int? | 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle.rect() | 样式 |


##### TSkeletonRowColObj.spacer

空白占位符

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度 |
| height | double? | - | 高度 |
| flex | int? | - | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |


##### TSkeletonRowColObj.text

文本

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度 |
| height | double? | 16 | 高度 |
| flex | int? | 1 | 弹性因子 |
| margin | EdgeInsets | EdgeInsets.zero | 间距 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle.text() | 样式 |


### TSkeletonAnimation
#### 简介
骨架图动画
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| gradient | 渐变 |
| flashed | 闪烁 |


### TSkeletonTheme
#### 简介
骨架图风格
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| avatar | 头像 |
| image | 图片 |
| text | 文本 |
| paragraph | 段落 |
