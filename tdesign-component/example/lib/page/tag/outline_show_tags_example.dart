import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class OutlineShowTagsExample extends StatelessWidget {
  const OutlineShowTagsExample({super.key});

  Widget _buildOutlineShowTags(BuildContext context) {
    // 非浅色描边各主题
    return const Wrap(
      spacing: 8,
      children: [
        TTag(
          '默认',
          colorScheme: TTagColorScheme.defaultTheme,
          variant: TTagVariant.outline,
        ),
        TTag(
          '主要',
          colorScheme: TTagColorScheme.primary,
          variant: TTagVariant.outline,
        ),
        TTag(
          '警告',
          colorScheme: TTagColorScheme.warning,
          variant: TTagVariant.outline,
        ),
        TTag(
          '危险',
          colorScheme: TTagColorScheme.danger,
          variant: TTagVariant.outline,
        ),
        TTag(
          '成功',
          colorScheme: TTagColorScheme.success,
          variant: TTagVariant.outline,
        ),
      ],
    );
  }

  Widget _buildLightOutlineShowTags(BuildContext context) {
    // 浅色描边各主题
    return const Wrap(
      spacing: 8,
      children: [
        TTag(
          '默认',
          colorScheme: TTagColorScheme.defaultTheme,
          variant: TTagVariant.lightOutline,
        ),
        TTag(
          '主要',
          colorScheme: TTagColorScheme.primary,
          variant: TTagVariant.lightOutline,
        ),
        TTag(
          '警告',
          colorScheme: TTagColorScheme.warning,
          variant: TTagVariant.lightOutline,
        ),
        TTag(
          '危险',
          colorScheme: TTagColorScheme.danger,
          variant: TTagVariant.lightOutline,
        ),
        TTag(
          '成功',
          colorScheme: TTagColorScheme.success,
          variant: TTagVariant.lightOutline,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 16),
      child: Wrap(
        spacing: 8,
        direction: Axis.vertical,
        children: [
          Builder(builder: _buildOutlineShowTags),
          Builder(builder: _buildLightOutlineShowTags),
        ],
      ),
    );
  }
}
