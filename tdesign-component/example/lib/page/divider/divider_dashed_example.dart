import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'divider')
class DividerDashedExample extends StatelessWidget {
  const DividerDashedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TDivider(dashed: true),
          TDivider(
            dashed: true,
            align: TDividerAlign.left,
            child: Text('文字信息'),
          ),
          TDivider(dashed: true, child: Text('文字信息')),
          TDivider(
            dashed: true,
            align: TDividerAlign.right,
            child: Text('文字信息'),
          ),
        ],
      ),
    );
  }
}
