import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';
import 'sticky_header/widgets/sliver_sticky_header.dart';
import 'td_indexes_anchor.dart';

/// 索引
class TDIndexesList extends StatelessWidget {
  const TDIndexesList({
    Key? key,
    required this.indexList,
    this.indexListMaxHeight = 0.8,
    required this.activeIndex,
    required this.onSelect,
    this.builderIndex,
  }) : super(key: key);

  /// 索引字符列表。不传默认 A-Z
  final List<String> indexList;

  /// 索引列表最大高度（父容器高度的百分比，默认0.8）
  final double indexListMaxHeight;

  /// 选中索引
  final ValueNotifier<String> activeIndex;

  /// 点击侧边栏时触发事件
  final void Function(String index) onSelect;

  /// 索引文本自定义构建
  final Widget Function(BuildContext context, String index, bool isActive)? builderIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: TDTheme.of(context).spacer8,
      top: 0,
      bottom: 0,
      child: Align(
        child: FractionallySizedBox(
          heightFactor: indexListMaxHeight,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              print('onVerticalDragUpdate');
            },
            onVerticalDragStart: (details) {
              print('onVerticalDragStart');
            },
            onVerticalDragDown: (details) {
              print('onVerticalDragDown');
            },
            onVerticalDragEnd: (details) {
              print('onVerticalDragEnd');
            },
            onVerticalDragCancel: () {
              print('onVerticalDragCancel');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indexList
                  .map(
                    (e) => ValueListenableBuilder(
                      valueListenable: activeIndex,
                      builder: (context, value, child) {
                        if (builderIndex != null) {
                          return builderIndex!(context, e, value == e);
                        }
                        return Container(
                          width: 20,
                          height: 20,
                          decoration: value == e
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(TDTheme.of(context).radiusCircle),
                                  color: TDTheme.of(context).brandColor7,
                                )
                              : null,
                          child: Center(
                            child: TDText(
                              e,
                              forceVerticalCenter: true,
                              font: TDTheme.of(context).fontLinkSmall,
                              textColor:
                                  value == e ? TDTheme.of(context).fontWhColor1 : TDTheme.of(context).fontGyColor1,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
