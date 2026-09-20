import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'navbar')
class BaseH5NavbarExample extends StatelessWidget {
  const BaseH5NavbarExample({super.key});

  Widget _baseH5Navbar(BuildContext context) {
    return const TNavBar(
      key: Key('navbar-demo-base'),
      title: Text('标题文字'),
      useDefaultBack: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _baseH5Navbar(context);
  }
}
