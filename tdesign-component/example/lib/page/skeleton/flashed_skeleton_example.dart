import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'skeleton')
class FlashedSkeletonExample extends StatelessWidget {
  const FlashedSkeletonExample({super.key});

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

  Widget _buildFlashedSkeleton(BuildContext context) {
    return const TSkeleton(
      animation: TSkeletonAnimation.flashed,
      variant: TSkeletonVariant.paragraph,
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_wrapper(_buildFlashedSkeleton, isFlexible: true))(context);
  }
}
