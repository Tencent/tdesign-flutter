import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'loading')
class PureIconLoadingExample extends StatelessWidget {
  const PureIconLoadingExample({super.key});

  /// 纯图标
  Widget _buildPureIconLoading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TLoading(icon: TLoadingIcon.circle),
        const SizedBox(width: 40),
        const TLoading(icon: TLoadingIcon.activity),
        const SizedBox(width: 40),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(iconColor: context.tTheme.brandNormalColor),
          ),
          child: const TLoading(size: 40, icon: TLoadingIcon.point),
        ),
        const SizedBox(width: 40),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(iconColor: context.tTheme.brandNormalColor),
          ),
          child: const TLoading(
            customIcon: Image(
              image: AssetImage('assets/img/loading-logo2.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPureIconLoading(context);
  }
}
