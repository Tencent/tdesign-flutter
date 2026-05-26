## API
### TImageViewer

#### 静态方法

##### TImageViewer.showImageViewer

显示图片预览

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| images | List<dynamic> | - | 图片数组 |
| labels | List<String>? | - | 图片描述 |
| closeBtn | bool? | true | 是否展示关闭按钮 |
| deleteBtn | bool? | false | 是否显示删除操作 |
| showIndex | bool? | false | 是否显示页码 |
| loop | bool? | false | 图片是否循环 |
| autoplay | bool? | false | 图片轮播是否自动播放 |
| duration | int? | - | 自动播放间隔 |
| bgColor | Color? | - | 背景色 |
| navBarBgColor | Color? | - | 导航栏背景色 |
| iconColor | Color? | - | 图标颜色 |
| labelStyle | TextStyle? | - | label文字样式 |
| indexStyle | TextStyle? | - | 页码样式 |
| modalBarrierColor | Color? | - | - |
| barrierDismissible | bool? | - | - |
| defaultIndex | int? | - | 默认预览图片所在的下标 |
| width | double? | - | 图片宽度 |
| height | double? | - | 图片高度 |
| onIndexChange | OnIndexChange? | - | 预览图片切换回调 |
| onClose | OnClose? | - | 关闭点击 |
| onDelete | OnDelete? | - | 删除点击 |
| ignoreDeleteError | bool? | - | 是否忽略单张图片删除错误提示 |
| onTap | OnImageTap? | - | 点击图片 |
| onLongPress | OnLongPress? | - | 长按图片 |
| leftItemBuilder | LeftItemBuilder? | - | 左侧自定义操作 |
| rightItemBuilder | RightItemBuilder? | - | 右侧自定义操作 |


### TImageViewerWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoplay | bool? | - | 图片轮播是否自动播放 |
| bgColor | Color? | - | 背景色 |
| closeBtn | bool? | - | 是否展示关闭按钮 |
| defaultIndex | int? | - | 默认预览图片所在的下标 |
| deleteBtn | bool? | - | 是否显示删除操作 |
| duration | int? | - | 自动播放间隔 |
| height | double? | - | 图片高度 |
| iconColor | Color? | - | 图标颜色 |
| ignoreDeleteError | bool? | false | 是否忽略单张图片删除错误提示 |
| images | List<dynamic> | - | 图片数组 |
| indexStyle | TextStyle? | - | 页码样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| labels | List<String>? | - | 图片描述 |
| labelStyle | TextStyle? | - | label文字样式 |
| leftItemBuilder | LeftItemBuilder? | - | 左侧自定义操作 |
| loop | bool? | - | 图片是否循环 |
| navBarBgColor | Color? | - | 导航栏背景色 |
| onClose | OnClose? | - | 关闭点击 |
| onDelete | OnDelete? | - | 删除点击 |
| onIndexChange | OnIndexChange? | - | 预览图片切换回调 |
| onLongPress | OnLongPress? | - | 长按图片 |
| onTap | OnImageTap? | - | 点击图片 |
| rightItemBuilder | RightItemBuilder? | - | 右侧自定义操作 |
| showIndex | bool? | - | 是否显示页码 |
| width | double? | - | 图片宽度 |


### OnIndexChange
#### 类型定义

```dart
typedef OnIndexChange =  Function(int index);
```


### OnClose
#### 类型定义

```dart
typedef OnClose =  Function(int index);
```


### OnDelete
#### 类型定义

```dart
typedef OnDelete =  Function(int index);
```


### OnImageTap
#### 类型定义

```dart
typedef OnImageTap =  Function(int index);
```


### OnLongPress
#### 类型定义

```dart
typedef OnLongPress =  Function(int index);
```


### LeftItemBuilder
#### 类型定义

```dart
typedef LeftItemBuilder = Widget Function(BuildContext context, int index);
```


### RightItemBuilder
#### 类型定义

```dart
typedef RightItemBuilder = Widget Function(BuildContext context, int index);
```
