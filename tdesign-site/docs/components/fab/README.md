---
title: Fab 悬浮按钮
description: 当功能使用图标即可表意清楚时，可使用纯图标悬浮按钮，例如添加、发布。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_fab_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_fab_page.dart)

默认动作层固定使用 large / fill / primary 规格。需要自定义尺寸、颜色、形状或投影时，
请通过 `child` 组合完整动作层。

### 1 组件类型

纯图标悬浮按钮

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPureIconFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(onPressed: _onFabPressed, semanticLabel: '增加'),
    );
  }</pre>

</td-code-block>
                                  

图标加文字悬浮按钮

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(
        icon: const Icon(TIcons.share),
        text: '分享给朋友',
        onPressed: _onFabPressed,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 2 组件样式

可移动悬浮按钮

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDraggableFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(
        icon: const Icon(TIcons.gesture_press),
        text: '拖我',
        draggable: TFabDragAxis.all,
        yBounds: const TFabBounds(start: 0, end: 32),
        onPressed: _onFabPressed,
      ),
    );
  }</pre>

</td-code-block>
                                  

带自动收缩功能

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCollapsibleFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(
        right: _scrolling ? 0 : 16,
        bottom: _scrolling ? 64 : 24,
        onPressed: _onFabPressed,
        child: _scrolling
            ? const _CollapsedFabContent()
            : const _ExpandedFabContent(),
      ),
    );
  }</pre>

</td-code-block>
                                  

## API
### TFab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bottom | double? | - | 距父级 Stack 内容区底部偏移（默认 32） |
| child | Widget? | - | 自定义内容；有则替代默认内嵌 TButton。自定义内容自行负责尺寸、形状、颜色和投影。 |
| draggable | TFabDragAxis? | - | 拖拽轴向；null 表示不启用拖拽 |
| icon | Widget? | - | 图标；未传时使用 TDesign add 图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| magnet | TFabMagnet? | - | 拖拽结束吸附方向；null 表示不吸附 |
| onDragEnd | TFabDragCallback? | - | 拖拽结束回调 |
| onDragStart | TFabDragCallback? | - | 拖拽开始回调 |
| onPressed | VoidCallback? | - | 点击回调，null 时禁用 |
| right | double? | - | 距父级 Stack 内容区右侧偏移（默认 16） |
| semanticLabel | String? | - | 读屏标签 |
| text | String | '' | 图标 + 文字形态；非空时为胶囊形 |
| tooltip | String? | - | 纯图标 Fab 的 tooltip 提示 |
| useSafeArea | bool | true | 是否避让系统安全区 |
| xBounds | TFabBounds? | - | 水平拖拽边界限制 |
| yBounds | TFabBounds? | - | 垂直拖拽边界限制 |
