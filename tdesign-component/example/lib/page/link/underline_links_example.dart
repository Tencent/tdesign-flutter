import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'link')
class UnderlineLinksExample extends StatelessWidget {
  const UnderlineLinksExample({super.key});
  Widget _buildUnderlineLinks(BuildContext context) {
    return _exampleRow(context, [
      _link(context, colorScheme: TLinkColorScheme.primary, underline: true),
      _link(context, underline: true),
    ]);
  }

  Widget _exampleRow(BuildContext context, List<Widget> children) {
    return Container(
      height: 48,
      color: context.tTheme.bgColorContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  TLink _link(
    BuildContext context, {
    String label = '跳转链接',
    TLinkColorScheme? colorScheme,
    TLinkSize size = TLinkSize.small,
    bool? underline,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return TLink(
      child: Text(label),
      colorScheme: colorScheme,
      size: size,
      underline: underline,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onPressed: disabled ? null : () => _onLinkPressed(context),
    );
  }

  void _onLinkPressed(BuildContext context) {
    TToast.showText('点击了链接', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildUnderlineLinks(context);
  }
}
