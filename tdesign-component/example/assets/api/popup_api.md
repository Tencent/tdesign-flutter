## API
### TDSlidePopupRoute
#### 简介
从屏幕的某个方向滑动弹出的Dialog框的路由，比如从顶部、底部、左、右滑出页面
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builder | WidgetBuilder | - | 控件构建器 |
| barrierLabel |  | - |  |
| modalBarrierColor | Color? | Colors.black54 | 蒙层颜色 |
| isDismissible | bool | true | 点击蒙层能否关闭 |
| modalBarrierFull | bool | false | 是否全屏显示蒙层 |
| slideTransitionFrom | SlideTransitionFrom | SlideTransitionFrom.bottom | 设置从屏幕的哪个方向滑出 |
| modalWidth | double? | - | 弹出框宽度 |
| modalHeight | double? | - | 弹出框高度 |
| modalTop | double? | 0 | 弹出框顶部距离 |
| modalLeft | double? | 0 | 弹出框左侧距离 |
| open | VoidCallback? | - | 打开前事件 |
| opened | VoidCallback? | - | 打开后事件 |

```
```
 ### TDPopupBottomDisplayPanel
#### 简介
右上角带关闭的底部浮层面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 子控件 |
| title | String? | - | 标题 |
| titleColor | Color? | - | 标题颜色 |
| titleLeft | bool | false | 标题是否靠左 |
| hideClose | bool | false | 是否隐藏关闭按钮 |
| closeColor | Color? | - | 关闭按钮颜色 |
| closeClick | PopupClick? | - | 关闭按钮点击回调 |
| backgroundColor | Color? | - | 背景颜色 |
| radius | double? | - | 圆角 |
| key |  | - |  |

```
```
 ### TDPopupBottomConfirmPanel
#### 简介
带确认的底部浮层面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 子控件 |
| title | String? | - | 标题 |
| titleColor | Color? | - | 标题颜色 |
| leftText | String? | - | 左边文本 |
| leftTextColor | Color? | - | 左边文本颜色 |
| leftClick | PopupClick? | - | 左边文本点击回调 |
| rightText | String? | - | 右边文本 |
| rightTextColor | Color? | - | 右边文本颜色 |
| rightClick | PopupClick? | - | 右边文本点击回调 |
| backgroundColor | Color? | - | 背景颜色 |
| radius | double? | - | 圆角 |
| key |  | - |  |

```
```
 ### TDPopupCenterPanel
#### 简介
居中浮层面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 子控件 |
| closeUnderBottom | bool | false | 关闭按钮是否在视图框下方 |
| closeColor | Color? | - | 关闭按钮颜色 |
| closeClick | PopupClick? | - | 关闭按钮点击回调 |
| backgroundColor | Color? | - | 背景颜色 |
| radius | double? | - | 圆角 |
| key |  | - |  |
