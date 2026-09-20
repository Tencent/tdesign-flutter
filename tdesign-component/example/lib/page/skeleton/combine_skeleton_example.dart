import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'skeleton')
class CombineSkeletonExample extends StatelessWidget {
  const CombineSkeletonExample({super.key});

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

  Widget _buildCombineSkeleton(BuildContext context) {
    Widget buildRowCols() {
      return Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) => TSkeleton.custom(
            layout: TSkeletonLayout(
              rows: [
                [
                  TSkeletonBlock(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                    flex: null,
                    style: TSkeletonBlockStyle(
                      borderRadius: context.tTheme.radiusExtraLarge,
                    ),
                  ),
                ],
                [TSkeletonBlock.line(width: constraints.maxWidth)],
                const [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        buildRowCols(),
        SizedBox(width: context.tTheme.spacer16),
        buildRowCols(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_wrapper(_buildCombineSkeleton))(context);
  }
}
