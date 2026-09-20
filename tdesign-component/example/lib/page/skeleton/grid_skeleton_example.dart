import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'skeleton')
class GridSkeletonExample extends StatelessWidget {
  const GridSkeletonExample({super.key});

  Widget Function(BuildContext) _wrapper(
    Function(BuildContext) builder, {
    bool isFlexible = false,
  }) =>
      (context) => Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(
          context.tTheme.spacer16,
          0,
          context.tTheme.spacer16,
          0,
        ),
        child: isFlexible
            ? Row(children: [Expanded(child: builder(context))])
            : builder(context),
      );

  Widget _buildGridSkeleton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return TSkeleton.custom(
          layout: TSkeletonLayout(
            rows: [
              [
                TSkeletonBlock(
                  width: 48,
                  height: 48,
                  flex: null,
                  style: TSkeletonBlockStyle(
                    borderRadius: context.tTheme.radiusDefault,
                  ),
                ),
              ],
              const [TSkeletonBlock.line(width: 48, flex: null)],
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_wrapper(_buildGridSkeleton))(context);
  }
}
