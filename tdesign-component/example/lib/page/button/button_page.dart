import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'block_fill_button_example.dart';
import 'combination_buttons_example.dart';
import 'default_fill_button_example.dart';
import 'disable_primary_fill_button_example.dart';
import 'large_button_example.dart';
import 'primary_fill_button_example.dart';
import 'primary_ghost_button_example.dart';
import 'rectangle_icon_button_example.dart';
import 'rectangle_shape_button_example.dart';

@ExampleCodeManifest()
class TButtonPage extends StatefulWidget {
  const TButtonPage({super.key});

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
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础按钮',
              methodName: 'PrimaryFillButtonExample',
              builder: (_) => const PrimaryFillButtonExample(),
            ),
            ExampleItem(
              desc: '图标按钮',
              center: false,
              methodName: 'RectangleIconButtonExample',
              builder: (_) => const RectangleIconButtonExample(),
            ),
            ExampleItem(
              desc: '幽灵按钮',
              methodName: 'PrimaryGhostButtonExample',
              builder: (_) => const PrimaryGhostButtonExample(),
            ),
            ExampleItem(
              desc: '组合按钮',
              methodName: 'CombinationButtonsExample',
              builder: (_) => const CombinationButtonsExample(),
            ),
            ExampleItem(
              desc: '通栏按钮',
              methodName: 'BlockFillButtonExample',
              builder: (_) => const BlockFillButtonExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '按钮禁用态',
              center: false,
              methodName: 'DisablePrimaryFillButtonExample',
              builder: (_) => const DisablePrimaryFillButtonExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '按钮尺寸',
              center: false,
              methodName: 'LargeButtonExample',
              builder: (_) => const LargeButtonExample(),
            ),
            ExampleItem(
              desc: '按钮形状',
              center: false,
              methodName: 'RectangleShapeButtonExample',
              builder: (_) => const RectangleShapeButtonExample(),
            ),
            ExampleItem(
              desc: '按钮主题',
              methodName: 'DefaultFillButtonExample',
              builder: (_) => const DefaultFillButtonExample(),
            ),
          ],
        ),
      ],
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
                      colorPreset: TButtonColorPreset.primary,
                      onPressed: _onTap,
                      child: const Text('填充通栏按钮'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TButton(
                      variant: TButtonVariant.outline,
                      colorPreset: TButtonColorPreset.primary,
                      onPressed: _onTap,
                      child: const Text('描边通栏按钮'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TButton(
                      variant: TButtonVariant.text,
                      colorPreset: TButtonColorPreset.primary,
                      onPressed: _onTap,
                      child: const Text('文字通栏按钮'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TButton(
                      variant: TButtonVariant.ghost,
                      colorPreset: TButtonColorPreset.primary,
                      onPressed: _onTap,
                      child: const Text('幽灵通栏按钮'),
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
              size: TButtonSize.large,
              onPressed: () async {
                var result = await Navigator.of(context)
                    .pushNamedAndRemoveUntil('divider', (router) {
                      return true;
                    });
                debugPrint('pushNamedAndRemoveUntil result: $result');
              },
              child: const Text('点击跳转'),
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

  Widget _buildChildTestButton(BuildContext context) {
    return TButton(onPressed: null, child: Container());
  }

  Widget _buildRightIconButton(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        TButton(
          icon: const Icon(TIcons.app),
          size: TButtonSize.large,
          variant: TButtonVariant.fill,
          colorPreset: TButtonColorPreset.primary,
          iconPosition: TButtonIconPosition.right,
          onPressed: _onTap,
          child: const Text('填充按钮'),
        ),
        TButton(
          icon: const Icon(TIcons.app),
          size: TButtonSize.large,
          variant: TButtonVariant.fill,
          colorPreset: TButtonColorPreset.primary,
          iconPosition: TButtonIconPosition.right,
          onPressed: _onTap,
        ),
        TButton(
          icon: const Icon(TIcons.app),
          size: TButtonSize.large,
          variant: TButtonVariant.fill,
          colorPreset: TButtonColorPreset.primary,
          iconPosition: TButtonIconPosition.right,
          onPressed: _onTap,
          child: const Text('间距20'),
        ),
      ],
    );
  }

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
            icon: const Icon(TIcons.app),
            size: TButtonSize.large,
            variant: TButtonVariant.fill,
            colorPreset: TButtonColorPreset.primary,
            iconPosition: TButtonIconPosition.right,
            onPressed: _onTap,
            child: const Text('填充按钮'),
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
            colorPreset: TButtonColorPreset.primary,
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
            icon: const Icon(TIcons.app),
            size: TButtonSize.large,
            variant: TButtonVariant.fill,
            colorPreset: TButtonColorPreset.primary,
            iconPosition: TButtonIconPosition.right,
            onPressed: _onTap,
            child: const Text('间距20'),
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
            variant: TButtonVariant.fill,
            colorPreset: TButtonColorPreset.primary,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.fill,
            colorPreset: TButtonColorPreset.light,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.fill,
            colorPreset: TButtonColorPreset.defaultTheme,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.fill,
            colorPreset: TButtonColorPreset.danger,
            child: Text('Button'),
          ),
          context,
        ),

        // outline 变体
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.outline,
            colorPreset: TButtonColorPreset.primary,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.outline,
            colorPreset: TButtonColorPreset.light,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.outline,
            colorPreset: TButtonColorPreset.defaultTheme,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.outline,
            colorPreset: TButtonColorPreset.danger,
            child: Text('Button'),
          ),
          context,
        ),

        // text 变体
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.text,
            colorPreset: TButtonColorPreset.primary,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.text,
            colorPreset: TButtonColorPreset.light,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.text,
            colorPreset: TButtonColorPreset.defaultTheme,
            child: Text('Button'),
          ),
          context,
        ),
        _buildStatusRow(
          const TButton(
            icon: Icon(TIcons.app),
            variant: TButtonVariant.text,
            colorPreset: TButtonColorPreset.danger,
            child: Text('Button'),
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
            variant: template.variant,
            colorPreset: template.colorPreset,
            size: template.size,
            onPressed: _onTap,
            child: template.child,
          ),

          // 可交互态（按压由 Material WidgetState 自动处理）
          TButton(
            icon: template.icon,
            variant: template.variant,
            colorPreset: template.colorPreset,
            size: template.size,
            onPressed: _onTap,
            child: template.child,
          ),
          // 禁用态
          TButton(
            icon: template.icon,
            variant: template.variant,
            colorPreset: template.colorPreset,
            size: template.size,
            onPressed: null,
            child: template.child,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGhostStatusRows(BuildContext context) {
    final themes = [
      TButtonColorPreset.primary,
      TButtonColorPreset.light,
      TButtonColorPreset.defaultTheme,
      TButtonColorPreset.danger,
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
              variant: TButtonVariant.ghost,
              child: Text('Button'),
            ).copyWithColorPreset(scheme, onPressed: _onTap),
            const TButton(
              icon: Icon(TIcons.app),
              variant: TButtonVariant.ghost,
              child: Text('Button'),
            ).copyWithColorPreset(scheme, onPressed: _onTap),
            const TButton(
              icon: Icon(TIcons.app),
              variant: TButtonVariant.ghost,
              child: Text('Button'),
            ).copyWithColorPreset(scheme, onPressed: null),
          ],
        ),
      );
    }).toList();
  }
}

extension _TButtonCopy on TButton {
  TButton copyWithColorPreset(
    TButtonColorPreset scheme, {
    VoidCallback? onPressed,
  }) {
    return TButton(
      icon: icon,
      variant: variant,
      colorPreset: scheme,
      size: size,
      iconPosition: iconPosition,
      onPressed: onPressed,
      child: child,
    );
  }
}
