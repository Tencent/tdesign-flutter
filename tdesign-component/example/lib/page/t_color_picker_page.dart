import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TColorPicker 示例页。
class TColorPickerPage extends StatefulWidget {
  const TColorPickerPage({super.key});

  @override
  State<TColorPickerPage> createState() => _TColorPickerPageState();
}

class _TColorPickerPageState extends State<TColorPickerPage> {
  /// 基础类型当前色值。
  String baseValue = '#0052D9';

  /// 带色板当前色值。
  String multipleValue = '#0052D9';

  /// 弹窗形式当前色值。
  String popupValue = '#07C160';

  /// 格式切换当前值。
  String formatValue = '#0052D9';

  /// 当前选择格式。
  TColorPickerFormat curFormat = TColorPickerFormat.rgb;

  static const List<TColorPickerFormat> _formatList = [
    TColorPickerFormat.css,
    TColorPickerFormat.hex,
    TColorPickerFormat.rgb,
    TColorPickerFormat.hsl,
    TColorPickerFormat.hsv,
    TColorPickerFormat.cmyk,
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'colorPicker',
      desc: '用于颜色选择，支持多种格式。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础颜色选择器', builder: _buildBase),
            ExampleItem(desc: '带色板的颜色选择器', builder: _buildMultiple),
            ExampleItem(desc: '弹窗形式的颜色选择器', builder: _buildPopup),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '格式切换', builder: _buildFormat),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'colorPicker')
  Widget _buildBase(BuildContext context) => TColorPicker(
        value: baseValue,
        onChanged: (result) {
          final (value, _) = result;
          setState(() => baseValue = value);
        },
      );

  @ExampleCode(group: 'colorPicker')
  Widget _buildMultiple(BuildContext context) => TColorPicker(
        value: multipleValue,
        type: TColorPickerType.multiple,
        enableAlpha: true,
        onChanged: (result) {
          final (value, _) = result;
          setState(() => multipleValue = value);
        },
        onPaletteBarChange: (color) {
          debugPrint('palette bar change: ${color.hex}');
        },
      );

  @ExampleCode(group: 'colorPicker')
  Widget _buildPopup(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TButton(
            size: TButtonSize.large,
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            child: const Text('展示'),
            onPressed: () => _showPopupPicker(context),
          ),
          const SizedBox(height: 12),
          Text('当前颜色：$popupValue'),
        ],
      );

  void _showPopupPicker(BuildContext context) {
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        titleWidget: const Text('选择颜色'),
        child: TColorPicker(
          value: popupValue,
          type: TColorPickerType.multiple,
          enableAlpha: true,
          onChanged: (result) {
            final (value, _) = result;
            setState(() => popupValue = value);
          },
        ),
      ),
    );
  }

  @ExampleCode(group: 'colorPicker')
  Widget _buildFormat(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (final item in _formatList)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FormatChip(
                    label: item.name.toUpperCase(),
                    selected: curFormat == item,
                    onTap: () => setState(() => curFormat = item),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TColorPicker(
            value: formatValue,
            type: TColorPickerType.multiple,
            enableAlpha: true,
            format: curFormat,
            onChanged: (result) {
              final (value, _) = result;
              setState(() => formatValue = value);
            },
          ),
        ],
      );
}

/// 格式选择小块。
class _FormatChip extends StatelessWidget {
  const _FormatChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selected ? primary : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
