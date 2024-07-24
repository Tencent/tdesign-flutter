## API
### TDImageViewerWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| closeBtn | bool? | - | 是否展示关闭按钮 |
| deleteBtn | bool? | - | 是否显示删除操作 |
| images | List<dynamic> | - | 图片数组 |
| showIndex | bool? | - | 是否显示页码 |
| defaultIndex | int? | - | 默认预览图片所在的下标 |
| onIndexChange | OnIndexChange? | - | 预览图片切换回调 |
| width | double? | - | 图片宽度 |
| height | double? | - | 图片高度 |
| onClose | OnClose? | - | 关闭点击 |
| onDelete | OnDelete? | - | 删除点击 |
| onLongPress | OnLongPress? | - | 长按图片 |

```
```
 ### TDImageViewer

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showImageViewer |  |   required BuildContext context,  required List<dynamic> images,  bool? closeBtn,  bool? deleteBtn,  bool? showIndex,  int? defaultIndex,  double? width,  double? height,  OnIndexChange? onIndexChange,  OnClose? onClose,  OnDelete? onDelete,  OnLongPress? onLongPress, | 显示图片预览 |
