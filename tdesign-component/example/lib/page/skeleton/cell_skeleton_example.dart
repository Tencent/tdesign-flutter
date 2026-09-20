import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'skeleton')
class CellSkeletonExample extends StatefulWidget {
  const CellSkeletonExample({super.key});

  @override
  State<CellSkeletonExample> createState() => _CellSkeletonExampleState();
}

class _CellSkeletonExampleState extends State<CellSkeletonExample> {
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

  Widget _buildCellSkeleton(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const TSkeleton(variant: TSkeletonVariant.avatar),
            SizedBox(width: context.tTheme.spacer12),
            const Expanded(
              child: TSkeleton.custom(
                layout: TSkeletonLayout(
                  rows: [
                    [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
                    [TSkeletonBlock.line()],
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.tTheme.spacer16),
        Row(
          children: <Widget>[
            TSkeleton.custom(
              layout: TSkeletonLayout(
                rows: [
                  [
                    TSkeletonBlock(
                      width: 48,
                      height: 48,
                      style: TSkeletonBlockStyle(
                        borderRadius: context.tTheme.radiusDefault,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: context.tTheme.spacer12),
            const Expanded(
              child: TSkeleton.custom(
                layout: TSkeletonLayout(
                  rows: [
                    [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
                    [TSkeletonBlock.line()],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_wrapper(_buildCellSkeleton))(context);
  }
}
