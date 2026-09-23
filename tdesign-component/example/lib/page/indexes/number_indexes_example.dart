import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'indexes')
class NumberIndexesExample extends StatelessWidget {
  const NumberIndexesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildNumberIndexes(context);
  }
}

Widget _buildNumberIndexes(BuildContext context) {
  const indexList = ['1', '3', '5', '7', '8', '10', '#'];
  return SizedBox(
    width: double.infinity,
    child: TButton(
      key: const ValueKey('indexes-number-trigger'),
      child: const TText('数字索引'),
      size: TButtonSize.large,
      colorScheme: TButtonColorScheme.primary,
      variant: TButtonVariant.outline,
      onPressed: () {
        TPopup.show(
          context,
          options: TPopupOptions.right(
            inset: const TPopupRightInset(top: 0),
            child: TIndexes(
              key: const ValueKey('indexes-number-panel'),
              indexList: indexList,
              capsuleTheme: false,
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
