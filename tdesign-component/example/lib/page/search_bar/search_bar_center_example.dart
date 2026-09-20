import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'search')
class SearchBarCenterExample extends StatelessWidget {
  const SearchBarCenterExample({super.key});

  Widget _buildCenter(BuildContext context) {
    return const SearchBarCenterExampleSearchDemoSurface(
      child: TSearchBar(
        hintText: '搜索预设文案',
        textAlignment: TSearchBarAlignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCenter(context);
  }
}

class SearchBarCenterExampleSearchDemoSurface extends StatelessWidget {
  const SearchBarCenterExampleSearchDemoSurface({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.tTheme.bgColorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child,
      ),
    );
  }
}
