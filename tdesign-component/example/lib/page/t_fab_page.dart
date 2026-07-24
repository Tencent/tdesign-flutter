import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TFabPage extends StatefulWidget {
  const TFabPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TFabPageState();
}

class _TFabPageState extends State<TFabPage> {
  void _onFabPressed() {
    TToast.showText('点击了悬浮按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(title: tTitle(), exampleCodeGroup: 'fab', children: [
      ExampleModule(title: '组件类型', children: [
        ExampleItem(desc: '纯图标悬浮按钮（圆形）', builder: _buildPureIconFab),
        ExampleItem(desc: '图标加文字悬浮按钮（胶囊形）', builder: _buildTextFab),
      ]),
      ExampleModule(title: '组件状态', children: [
        ExampleItem(desc: '配色方案', builder: _buildColorSchemeFab),
        ExampleItem(desc: '悬浮按钮尺寸', builder: _buildSizeFab),
      ]),
      ExampleModule(title: '交互能力', children: [
        ExampleItem(desc: '可拖拽悬浮按钮（在卡片内拖动试试）', builder: _buildDraggableFab),
      ]),
    ]);
  }

  /// 横排对比 demo 容器：多个 TFab 在各自的 Stack 小卡片中横向排列
  ///
  /// 每个 TFab 必须放在 Stack 内（TFab 自带 Positioned 定位，见 fab.md §1.5）
  Widget _buildRowDemo(List<Widget> fabs, {double cardSize = 96}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: fabs
              .map((fab) => Container(
                    width: cardSize,
                    height: cardSize,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: context.tTheme.bgColorSecondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // TFab 返回 Positioned，必须放在 Stack 内
                    child: Stack(
                      fit: StackFit.expand,
                      children: [fab],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  /// 真实页面 demo 容器：大 Stack 模拟页面悬浮效果
  ///
  /// TFab 自带 Positioned 定位，放在 Stack 顶层即可悬浮在右下角
  Widget _buildPageDemo({
    required Widget fab,
    double height = 180,
  }) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorSecondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 占位内容，表示这是一个"页面"
          Center(
            child: TText(
              '页面内容区域',
              textColor: context.tTheme.textColorPlaceholder,
            ),
          ),
          // TFab 悬浮在右下角
          fab,
        ],
      ),
    );
  }

  @Demo(group: 'fab')
  Widget _buildPureIconFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(right: 16, bottom: 16, onPressed: _onFabPressed),
    );
  }

  @Demo(group: 'fab')
  Widget _buildTextFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(
        text: 'Floating',
        right: 16,
        bottom: 16,
        onPressed: _onFabPressed,
      ),
    );
  }

  @Demo(group: 'fab')
  Widget _buildColorSchemeFab(BuildContext context) {
    return _buildRowDemo([
      TFab(right: 8, bottom: 8, onPressed: _onFabPressed),
      TFab(
        right: 8,
        bottom: 8,
        buttonProps: const TButtonProps(
          colorScheme: TButtonColorScheme.defaultTheme,
        ),
        onPressed: _onFabPressed,
      ),
      TFab(
        right: 8,
        bottom: 8,
        buttonProps: const TButtonProps(
          colorScheme: TButtonColorScheme.light,
        ),
        onPressed: _onFabPressed,
      ),
      TFab(
        right: 8,
        bottom: 8,
        buttonProps: const TButtonProps(
          colorScheme: TButtonColorScheme.danger,
        ),
        onPressed: _onFabPressed,
      ),
    ]);
  }

  @Demo(group: 'fab')
  Widget _buildSizeFab(BuildContext context) {
    return _buildRowDemo([
      TFab(
        right: 8,
        bottom: 8,
        buttonProps: const TButtonProps(size: TButtonSize.large),
        onPressed: _onFabPressed,
      ),
      TFab(
        right: 8,
        bottom: 8,
        buttonProps: const TButtonProps(size: TButtonSize.medium),
        onPressed: _onFabPressed,
      ),
      TFab(
        right: 8,
        bottom: 8,
        buttonProps: const TButtonProps(size: TButtonSize.small),
        onPressed: _onFabPressed,
      ),
      TFab(
        right: 8,
        bottom: 8,
        buttonProps: const TButtonProps(size: TButtonSize.extraSmall),
        onPressed: _onFabPressed,
      ),
    ]);
  }

  @Demo(group: 'fab')
  Widget _buildDraggableFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(
        right: 16,
        bottom: 16,
        draggable: TFabDragAxis.all,
        magnet: TFabMagnet.right,
        onPressed: _onFabPressed,
      ),
    );
  }
}
