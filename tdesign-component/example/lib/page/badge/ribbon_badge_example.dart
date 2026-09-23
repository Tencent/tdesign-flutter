import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class RibbonBadgeExample extends StatelessWidget {
  const RibbonBadgeExample({super.key});

  Widget _buildRibbonBadge(BuildContext context) => TCellGroup(
    cells: const [
      TCell(title: Text('单行标题')),
      TCell(title: Text('单行标题')),
    ],
    builder: (context, cell, index) => TBadge(
      label: 'NEW',
      variant: index == 0
          ? TBadgeVariant.ribbonLeft
          : TBadgeVariant.ribbonRight,
      size: TBadgeSize.large,
      child: cell,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildRibbonBadge(context);
  }
}
