import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'footer')
class FooterExample extends StatelessWidget {
  const FooterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildFooter(context);
  }
}

Widget _buildFooter(BuildContext context) {
  return const TFooter(text: 'Copyright © 2021-2031 TD.All Rights Reserved.');
}
