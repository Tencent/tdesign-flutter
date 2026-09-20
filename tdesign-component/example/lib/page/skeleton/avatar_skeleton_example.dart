import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'skeleton')
class AvatarSkeletonExample extends StatelessWidget {
  const AvatarSkeletonExample({super.key});

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

  Widget _buildAvatarSkeleton(BuildContext context) {
    return const TSkeleton(variant: TSkeletonVariant.avatar);
  }

  @override
  Widget build(BuildContext context) {
    return (_wrapper(_buildAvatarSkeleton))(context);
  }
}
