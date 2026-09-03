import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';

/// picker(多列滚轮): 中央高亮条与多列 Row 布局外壳
///
/// 供 TPicker、DateTimePickerWheel 共用 UI 壳；列内容与联动逻辑由调用方提供。
@internal
class MultiWheelLayout extends StatelessWidget {
  const MultiWheelLayout({
    super.key,
    required this.height,
    required this.itemHeight,
    required this.columns,
  });

  /// 滚轮区域总高度
  final double height;

  /// 单行选项高度（用于定位中央高亮条）
  final double itemHeight;

  /// 各列子组件（通常每列为 WheelColumn 或其 Semantics 包装）
  final List<Widget> columns;

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;
    return ColoredBox(
      color: theme.bgColorContainer,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: (height - itemHeight) / 2,
              left: theme.spacer16,
              right: theme.spacer16,
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  color: theme.bgColorSecondaryContainer,
                  borderRadius: BorderRadius.circular(theme.radiusDefault),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacer32),
              child: Row(
                children: [
                  for (final column in columns) Expanded(child: column),
                ],
              ),
            ),
            for (final top in [true, false])
              Positioned(
                top: top ? 0 : null,
                bottom: top ? null : 0,
                left: 0,
                right: 0,
                height: theme.spacer48.clamp(0, height / 2).toDouble(),
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: top
                            ? Alignment.topCenter
                            : Alignment.bottomCenter,
                        end: top ? Alignment.bottomCenter : Alignment.topCenter,
                        colors: [
                          theme.bgColorContainer,
                          theme.bgColorContainer.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
