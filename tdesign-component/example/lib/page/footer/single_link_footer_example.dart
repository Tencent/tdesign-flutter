import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'footer')
class SingleLinkFooterExample extends StatelessWidget {
  const SingleLinkFooterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSingleLinkFooter(context);
  }
}

Widget _buildSingleLinkFooter(BuildContext context) {
  TLink link(String text) => TLink(
    child: Text(text),
    colorScheme: TLinkColorScheme.primary,
    onPressed: () {},
  );
  return Column(
    children: [
      TFooter(
        links: [link('底部链接')],
        text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
      ),
      const SizedBox(height: 24),
      TFooter(
        links: [link('底部链接'), link('底部链接')],
        text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
      ),
    ],
  );
}
