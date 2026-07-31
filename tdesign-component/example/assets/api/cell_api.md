## API
### TCell
#### 简介
单元格组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TCellAlign? | - | 内容垂直对齐方式。 |
| arrow | bool | false | 是否显示右箭头。 |
| enableFeedback | bool | true | 点击时是否显示背景反馈。 |
| image | Widget? | - | 单元格左侧图片区。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| note | Widget? | - | 右侧说明内容。 |
| onLongPress | GestureLongPressCallback? | - | 长按回调。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击行为。 |
| prefix | Widget? | - | 标题左侧内容。 |
| required | bool | false | 是否显示必填标记。 |
| subtitle | Widget? | - | 副标题区。 |
| title | Widget? | - | 标题区。 |
| trailing | Widget? | - | 最右侧内容。 |


### TCellGroup
#### 简介
单元格组。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builder | TCellGroupBuilder? | - | 自定义单元格外层构建器。 |
| cells | List<TCell> | - | 单元格列表。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| scrollable | bool | false | 是否使用可滚动列表。 |
| title | Widget? | - | 组标题。 |
| variant | TCellGroupVariant? | - | 组视觉形态；未设置时读取 Theme。 |


### TCellAlign
#### 简介
单元格内容垂直对齐方式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 顶部对齐。 |
| center | 居中对齐。 |
| bottom | 底部对齐。 |


### TCellGroupBuilder
#### 简介
单元格包装构建器。
#### 类型定义

```dart
typedef TCellGroupBuilder = Widget Function(BuildContext context, TCell cell, int index);
```
