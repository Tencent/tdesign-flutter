import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TBackTopPage extends StatefulWidget {
  const TBackTopPage({Key? key}) : super(key: key);

  @override
  State<TBackTopPage> createState() => _TBackTopPageState();
}

class _TBackTopPageState extends State<TBackTopPage> {
  final ScrollController controller = ScrollController();
  TBackTopShape shape = TBackTopShape.circle;

  Future<void> _selectShape(TBackTopShape value) async {
    setState(() => shape = value);
    if (!controller.hasClients) {
      return;
    }
    await controller.animateTo(
      controller.position.maxScrollExtent.clamp(0, 1000),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      scrollController: controller,
      title: tTitle(),
      desc: '用于当页面过长往下滑动时，帮助用户快速回到页面顶部。',
      exampleCodeGroup: 'backtop',
      compactDemo: true,
      showTestModule: false,
      floatingActionButton: TBackTop(
        key: const Key('backtop-demo-floating'),
        controller: controller,
        showText: true,
        shape: shape,
        colorScheme: shape == TBackTopShape.circle
            ? TBackTopColorScheme.light
            : TBackTopColorScheme.dark,
      ),
      floatingActionButtonLocation: shape == TBackTopShape.halfCircle
          ? const _BackTopEdgeLocation()
          : FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '圆形返回顶部',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildCircleTrigger,
            ),
            ExampleItem(
              desc: '半圆形返回顶部',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildHalfRoundTrigger,
            ),
            ExampleItem(
              center: false,
              ignoreCode: true,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              builder: _buildSkeletonContent,
            ),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'backtop')
  Widget _buildCircleTrigger(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        key: const Key('backtop-demo-circle-trigger'),
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        size: TButtonSize.large,
        onPressed: () => _selectShape(TBackTopShape.circle),
        child: const TText('圆形返回顶部'),
      ),
    );
  }

  @ExampleCode(group: 'backtop')
  Widget _buildHalfRoundTrigger(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        key: const Key('backtop-demo-half-round-trigger'),
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        size: TButtonSize.large,
        onPressed: () => _selectShape(TBackTopShape.halfCircle),
        child: const TText('半圆形返回顶部'),
      ),
    );
  }

  Widget _buildSkeletonContent(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final itemWidth = (constraints.maxWidth - 16) / 2;
      return Wrap(
        spacing: 16,
        runSpacing: 24,
        children: List.generate(
          8,
          (_) => SizedBox(
            width: itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: itemWidth,
                  height: itemWidth,
                  decoration: BoxDecoration(
                    color: context.tTheme.bgColorComponent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
                _buildSkeletonLine(context, itemWidth),
                const SizedBox(height: 10),
                _buildSkeletonLine(context, itemWidth * 0.61),
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _buildSkeletonLine(BuildContext context, double width) => Container(
    width: width,
    height: 16,
    decoration: BoxDecoration(
      color: context.tTheme.bgColorComponent,
      borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
    ),
  );
}

/// 半圆形 BackTop 的直边属于贴屏结构，宿主只负责把组件放到屏幕右边缘。
///
/// 这里不改变组件的尺寸、颜色、边框或圆角；圆形仍使用 Scaffold 标准悬浮位置。
class _BackTopEdgeLocation extends FloatingActionButtonLocation {
  const _BackTopEdgeLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final standardOffset = FloatingActionButtonLocation.endFloat.getOffset(
      scaffoldGeometry,
    );
    return Offset(
      scaffoldGeometry.scaffoldSize.width -
          scaffoldGeometry.floatingActionButtonSize.width,
      standardOffset.dy,
    );
  }
}
