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

  /// 当前选择格式（默认 CSS，对齐 mobile-vue format 示例）。
  TColorPickerFormat curFormat = TColorPickerFormat.css;

  /// 格式选项，两行布局，对齐 mobile-vue `format.vue` 的 `lineList`。
  static const List<List<TColorPickerFormat>> _formatLines = [
    [
      TColorPickerFormat.css,
      TColorPickerFormat.hex,
      TColorPickerFormat.rgb,
    ],
    [
      TColorPickerFormat.hsl,
      TColorPickerFormat.hsv,
      TColorPickerFormat.cmyk,
    ],
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
            ExampleItem(desc: '组件模式选择', builder: _buildFormat),
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
    // multiple + enableAlpha 的完整形态约需 460 高度（含头部），
    // 未传高度时 TPopup bottom 默认 240 会裁剪内容，故按屏高比例显式指定。
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: MediaQuery.sizeOf(context).height * 0.72,
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
          for (final line in _formatLines) _buildFormatLine(line),
          const SizedBox(height: 8),
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

  /// 构建一行格式选项，项间等分、块间留 12px 间距，对齐 mobile-vue `format-line`。
  Widget _buildFormatLine(List<TColorPickerFormat> items) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: _FormatChip(
                  label: items[i].name.toUpperCase(),
                  selected: curFormat == items[i],
                  onTap: () => setState(() => curFormat = items[i]),
                ),
              ),
            ],
          ],
        ),
      );
}

/// 格式选择小块，对齐 mobile-vue `format-item`：圆角矩形块，选中态显示
/// 蓝色边框、左上角三角标记与白色勾选图标。
class _FormatChip extends StatelessWidget {
  const _FormatChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  /// 选中态边框 / 三角颜色，对齐 mobile-vue `#0052d9`。
  static const Color _activeColor = Color(0xFF0052D9);

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? _activeColor : (DividerTheme.of(context).color ?? colorScheme.outlineVariant),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? _activeColor : colorScheme.onSurface,
                ),
              ),
            ),
            if (selected) ...[
              // 左上角三角标记，对齐 mobile-vue `.active::after`。
              Positioned(
                left: -0.2,
                top: -0.2,
                child: _CornerTriangle(),
              ),
              // 三角内的白色勾选图标。
              const Positioned(
                left: 3,
                top: 3,
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 左上角直角三角，对齐 mobile-vue `format-item.active::after`（28px 三角）。
class _CornerTriangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: _CornerTrianglePainter(),
    );
  }
}

class _CornerTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()..color = _FormatChip._activeColor,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerTrianglePainter oldDelegate) => false;
}
