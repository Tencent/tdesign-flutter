import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class DarkShowTagsExample extends StatelessWidget {
  const DarkShowTagsExample({super.key});

  Widget _buildDarkShowTags(BuildContext context) {
    // 非浅色填充各主题
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', colorScheme: TTagColorScheme.defaultTheme),
        TTag('主要', colorScheme: TTagColorScheme.primary),
        TTag('警告', colorScheme: TTagColorScheme.warning),
        TTag('危险', colorScheme: TTagColorScheme.danger),
        TTag('成功', colorScheme: TTagColorScheme.success),
      ],
    );
  }

  Widget _buildLightShowTags(BuildContext context) {
    // 浅色填充各主题
    return const Wrap(
      spacing: 8,
      children: [
        TTag(
          '默认',
          colorScheme: TTagColorScheme.defaultTheme,
          variant: TTagVariant.light,
        ),
        TTag(
          '主要',
          colorScheme: TTagColorScheme.primary,
          variant: TTagVariant.light,
        ),
        TTag(
          '警告',
          colorScheme: TTagColorScheme.warning,
          variant: TTagVariant.light,
        ),
        TTag(
          '危险',
          colorScheme: TTagColorScheme.danger,
          variant: TTagVariant.light,
        ),
        TTag(
          '成功',
          colorScheme: TTagColorScheme.success,
          variant: TTagVariant.light,
        ),
      ],
    );
  }

  Widget _buildOutlineShowTags(BuildContext context) {
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
        spacing: 24,
        runSpacing: 8,
        direction: Axis.vertical,
        children: [
          Builder(builder: _buildLightShowTags),
          Builder(builder: _buildDarkShowTags),
          Builder(builder: _buildOutlineShowTags),
          Builder(builder: _buildLightOutlineShowTags),
        ],
      ),
    );
  }
}
