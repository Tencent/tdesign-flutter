import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'button')
class RectangleIconButtonExample extends StatelessWidget {
  const RectangleIconButtonExample({super.key});
  TButton _buildRectangleIconButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      icon: const Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () => _onTap(context),
    );
  }

  Widget _buildSquareIconButton(BuildContext context) {
    return _withButtonShape(
      context,
      TButtonShape.square,
      TButton(
        icon: const Icon(TIcons.app),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () => _onTap(context),
      ),
    );
  }

  TButton _buildLoadingIconButton(BuildContext context) {
    return TButton(
      child: const Text('加载中'),
      icon: Theme(
        // TLoading 已移除 themeData 构造参数，改用 mergeExtension 注入子树主题
        data: Theme.of(context).mergeExtension(
          TLoadingThemeData(iconColor: context.tTheme.whiteColor1),
        ),
        child: const TLoading(size: 24, icon: TLoadingIcon.circle),
      ),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    TToast.showText('点击了按钮', context: context);
  }

  /// 为子树注入 [TButtonThemeData.shape]（外形走 Theme）
  Widget _withButtonShape(
    BuildContext context,
    TButtonShape shape,
    Widget child,
  ) {
    return Theme(
      data: _mergeButtonTheme(context, TButtonThemeData(shape: shape)),
      child: child,
    );
  }

  /// 合并 TButtonThemeData 到当前 Theme 子树（替代 mergeExtension）
  static ThemeData _mergeButtonTheme(
    BuildContext context,
    TButtonThemeData buttonTheme,
  ) {
    final existingExtensions = List<ThemeExtension>.from(
      Theme.of(context).extensions.values,
    );
    // 移除旧的 TButtonThemeData（如果存在）
    existingExtensions.removeWhere((e) => e is TButtonThemeData);
    existingExtensions.add(buttonTheme);
    return Theme.of(context).copyWith(extensions: existingExtensions);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          Builder(builder: _buildRectangleIconButton),
          Builder(builder: _buildSquareIconButton),
          Builder(builder: _buildLoadingIconButton),
        ],
      ),
    );
  }
}
