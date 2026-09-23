import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'cell')
class CellCardGroupExample extends StatelessWidget {
  const CellCardGroupExample({super.key});

  Widget _buildCardGroup(BuildContext context) {
    return TCellGroup(
      variant: TCellGroupVariant.card,
      cells: [
        TCell(
          prefix: Icon(
            TIcons.service,
            size: 24,
            color: context.tTheme.brandNormalColor,
          ),
          title: const Text('单行标题'),
          arrow: true,
          onTap: () {},
        ),
        TCell(
          prefix: Icon(
            TIcons.internet,
            size: 24,
            color: context.tTheme.brandNormalColor,
          ),
          title: const Text('单行标题'),
          arrow: true,
          onTap: () {},
        ),
        TCell(
          prefix: Icon(
            TIcons.lock_on,
            size: 24,
            color: context.tTheme.brandNormalColor,
          ),
          title: const Text('单行标题'),
          arrow: true,
          onTap: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardGroup(context);
  }
}
