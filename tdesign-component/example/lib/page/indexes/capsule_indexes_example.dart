import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'indexes')
class CapsuleIndexesExample extends StatelessWidget {
  const CapsuleIndexesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCapsuleIndexes(context);
  }
}

Widget _buildCapsuleIndexes(BuildContext context) {
  const indexList = ['1', '3', '5', '7', '8', '10', '#'];
  return SizedBox(
    width: double.infinity,
    child: TButton(
      key: const ValueKey('indexes-capsule-trigger'),
      child: const TText('胶囊索引'),
      size: TButtonSize.large,
      colorScheme: TButtonColorScheme.primary,
      variant: TButtonVariant.outline,
      onPressed: () {
        TPopup.show(
          context,
          options: TPopupOptions.right(
            inset: const TPopupRightInset(top: 0),
            child: TIndexes(
              key: const ValueKey('indexes-capsule-panel'),
              indexList: indexList,
              capsuleTheme: true,
              builderContent: (context, index) {
                return TCellGroup(
                  cells: List.generate(
                    5,
                    (position) => TCell(title: TText('列表内容 ${position + 1}')),
                  ),
                );
              },
            ),
            useSafeArea: true,
          ),
        );
      },
    ),
  );
}
