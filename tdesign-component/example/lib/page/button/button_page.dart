import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'button_type.dart';
part 'button_status.dart';
part 'button_theme.dart';

class TButtonPage extends StatefulWidget {
  const TButtonPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TButtonPageState();
}

class _TButtonPageState extends State<TButtonPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于开启一个闭环的操作任务，如"删除"对象、"购买"商品等。',
      exampleCodeGroup: 'button',
      children: [_buttonTypeModule, _buttonStatusModule, _buttonThemeModule],
      test: [
        ExampleItem(
          ignoreCode: true,
          desc: '测试child',
          builder: (context) {
            return CodeWrapper(builder: _buildChildTestButton);
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '通栏按钮测试（外包布局）',
          builder: (context) {
            return Container(
              color: context.tTheme.bgColorContainer,
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TButton(
                      child: const Text('填充通栏按钮'),
                      colorScheme: TButtonColorScheme.primary,
                      onPressed: _onTap,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TButton(
                      child: const Text('描边通栏按钮'),
                      variant: TButtonVariant.outline,
                      colorScheme: TButtonColorScheme.primary,
                      onPressed: _onTap,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TButton(
                      child: const Text('文字通栏按钮'),
                      variant: TButtonVariant.text,
                      colorScheme: TButtonColorScheme.primary,
                      onPressed: _onTap,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TButton(
                      child: const Text('幽灵通栏按钮'),
                      variant: TButtonVariant.ghost,
                      colorScheme: TButtonColorScheme.primary,
                      onPressed: _onTap,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '各种按钮状态测试',
          builder: _buildStatusDisplay,
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '按钮中路由跳转',
          builder: (context) {
            return TButton(
              child: const Text('点击跳转'),
              size: TButtonSize.large,
              onPressed: () async {
                var result = await Navigator.of(context)
                    .pushNamedAndRemoveUntil('divider', (router) {
                      return true;
                    });
                print('pushNamedAndRemoveUntil result: $result');
              },
            );
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '图标在文字右侧',
          builder: (context) {
            return CodeWrapper(builder: _buildRightIconButton);
          },
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '渐变色背景按钮',
          builder: (context) {
            return CodeWrapper(builder: _buildGradientButton);
          },
        ),
      ],
    );
  }

  void _onTap() {
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

  @ExampleCode(group: 'button')
  TButton _buildLightTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.light,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildLightStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.light,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDangerTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDangerStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDangerFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDefaultTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDefaultStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildRectangleShapeButton(BuildContext context) {
    return _withButtonShape(
      context,
      TButtonShape.rectangle,
      TButton(
        child: const Text('矩形'),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: _onTap,
      ),
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildCircleButton(BuildContext context) {
    return _withButtonShape(
      context,
      TButtonShape.circle,
      TButton(
        icon: const Icon(TIcons.app),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: _onTap,
      ),
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildRoundButton(BuildContext context) {
    return _withButtonShape(
      context,
      TButtonShape.round,
      TButton(
        child: const Text('填充按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: _onTap,
      ),
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildExtraSmallButton(BuildContext context) {
    return TButton(
      child: const Text('按钮28'),
      size: TButtonSize.extraSmall,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildSmallButton(BuildContext context) {
    return TButton(
      child: const Text('按钮32'),
      size: TButtonSize.small,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildMediumButton(BuildContext context) {
    return TButton(
      child: const Text('按钮40'),
      size: TButtonSize.medium,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildLargeButton(BuildContext context) {
    return TButton(
      child: const Text('按钮48'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const TButton(
      child: Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const TButton(
      child: Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDisableDefaultFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: null,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDisableLightFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.light,
      onPressed: null,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const TButton(
      child: Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: null,
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildBlockFillButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('填充按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: _onTap,
      ),
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDefaultGhostButton(BuildContext context) {
    return TButton(
      child: const Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDangerGhostButton(BuildContext context) {
    return TButton(
      child: const Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildPrimaryGhostButton(BuildContext context) {
    return TButton(
      child: const Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildSquareIconButton(BuildContext context) {
    return _withButtonShape(
      context,
      TButtonShape.square,
      TButton(
        icon: const Icon(TIcons.app),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: _onTap,
      ),
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildLoadingIconButton(BuildContext context) {
    return TButton(
      child: const Text('加载中'),
      icon: Theme(
        // TLoading 已移除 themeData 构造参数，改用 mergeExtension 注入子树主题
        data: Theme.of(context).mergeExtension(
          TLoadingThemeData(iconColor: context.tTheme.whiteColor1),
        ),
        child: const TLoading(icon: TLoadingIcon.circle),
      ),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildRectangleIconButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      icon: const Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildPrimaryTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildPrimaryStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildDefaultFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildPrimaryFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  TButton _buildLightFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.light,
      onPressed: _onTap,
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildCombinationButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TButton(
              child: const Text('填充按钮'),
              size: TButtonSize.large,
              variant: TButtonVariant.fill,
              colorScheme: TButtonColorScheme.light,
              onPressed: _onTap,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TButton(
              child: const Text('填充按钮'),
              size: TButtonSize.large,
              variant: TButtonVariant.fill,
              colorScheme: TButtonColorScheme.primary,
              onPressed: _onTap,
            ),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildChildTestButton(BuildContext context) {
    return TButton(child: Container(), onPressed: null);
  }

  @ExampleCode(group: 'button')
  Widget _buildRightIconButton(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        TButton(
          child: const Text('填充按钮'),
          icon: const Icon(TIcons.app),
          size: TButtonSize.large,
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          iconPosition: TButtonIconPosition.right,
          onPressed: _onTap,
        ),
        TButton(
          icon: const Icon(TIcons.app),
          size: TButtonSize.large,
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          iconPosition: TButtonIconPosition.right,
          onPressed: _onTap,
        ),
        TButton(
          child: const Text('间距20'),
          icon: const Icon(TIcons.app),
          size: TButtonSize.large,
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          iconPosition: TButtonIconPosition.right,
          onPressed: _onTap,
        ),
      ],
    );
  }

  @ExampleCode(group: 'button')
  Widget _buildGradientButton(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        Theme(
          data: _mergeButtonTheme(
            context,
            const TButtonThemeData(
              gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
            ),
          ),
          child: TButton(
            child: const Text('填充按钮'),
            icon: const Icon(TIcons.app),
            size: TButtonSize.large,
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            iconPosition: TButtonIconPosition.right,
            onPressed: _onTap,
          ),
        ),
        Theme(
          data: _mergeButtonTheme(
            context,
            const TButtonThemeData(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          child: TButton(
            icon: const Icon(TIcons.app),
            size: TButtonSize.large,
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            iconPosition: TButtonIconPosition.right,
            onPressed: _onTap,
          ),
        ),
        Theme(
          data: _mergeButtonTheme(
            context,
            const TButtonThemeData(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          child: TButton(
            child: const Text('间距20'),
            icon: const Icon(TIcons.app),
            size: TButtonSize.large,
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            iconPosition: TButtonIconPosition.right,
            onPressed: _onTap,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDisplay(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        // fill 变体
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.light,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.defaultTheme,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.danger,
          ),
          context,
        ),

        // outline 变体
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.light,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.defaultTheme,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.danger,
          ),
          context,
        ),

        // text 变体
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.text,
            colorScheme: TButtonColorScheme.primary,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.text,
            colorScheme: TButtonColorScheme.light,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.text,
            colorScheme: TButtonColorScheme.defaultTheme,
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            child: Text('Button'),
            variant: TButtonVariant.text,
            colorScheme: TButtonColorScheme.danger,
          ),
          context,
        ),

        // ghost 变体（深色背景）
        ..._buildGhostStatusRows(context),
      ],
    );
  }

  Widget _buildStatusRow(TButton template, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          // 默认启用态
          TButton(
            icon: template.icon,
            child: template.child,
            variant: template.variant,
            colorScheme: template.colorScheme,
            size: template.size,
            onPressed: _onTap,
          ),

          // 可交互态（按压由 Material WidgetState 自动处理）
          TButton(
            icon: template.icon,
            child: template.child,
            variant: template.variant,
            colorScheme: template.colorScheme,
            size: template.size,
            onPressed: _onTap,
          ),
          // 禁用态
          TButton(
            icon: template.icon,
            child: template.child,
            variant: template.variant,
            colorScheme: template.colorScheme,
            size: template.size,
            onPressed: null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGhostStatusRows(BuildContext context) {
    final themes = [
      TButtonColorScheme.primary,
      TButtonColorScheme.light,
      TButtonColorScheme.defaultTheme,
      TButtonColorScheme.danger,
    ];
    return themes.map((scheme) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            const TButton(
              icon: Icon(TIcons.app),
              child: Text('Button'),
              variant: TButtonVariant.ghost,
            ).copyWithColorScheme(scheme, onPressed: _onTap),
            const TButton(
              icon: Icon(TIcons.app),
              child: Text('Button'),
              variant: TButtonVariant.ghost,
            ).copyWithColorScheme(scheme, onPressed: _onTap),
            const TButton(
              icon: Icon(TIcons.app),
              child: Text('Button'),
              variant: TButtonVariant.ghost,
            ).copyWithColorScheme(scheme, onPressed: null),
          ],
        ),
      );
    }).toList();
  }
}

extension _TButtonCopy on TButton {
  TButton copyWithColorScheme(
    TButtonColorScheme scheme, {
    VoidCallback? onPressed,
  }) {
    return TButton(
      icon: icon,
      child: child,
      variant: variant,
      colorScheme: scheme,
      size: size,
      iconPosition: iconPosition,
      onPressed: onPressed,
    );
  }
}
