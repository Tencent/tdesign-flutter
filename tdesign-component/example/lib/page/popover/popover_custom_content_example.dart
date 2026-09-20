import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'popover')
class PopoverCustomContentExample extends StatefulWidget {
  const PopoverCustomContentExample({super.key});

  @override
  State<PopoverCustomContentExample> createState() =>
      _PopoverCustomContentExampleState();
}

class _PopoverCustomContentExampleState
    extends State<PopoverCustomContentExample> {
  Widget _buildNCustomPopover(BuildContext context) {
    void selectOption(String option) {
      _customContentPopoverController.close();
      TToast.showText('已选择：$option', context: context);
    }

    final textStyle = TextStyle(
      color: theme == TPopoverColorScheme.light
          ? context.tTheme.fontGyColor1
          : context.tTheme.fontWhColor1,
    );
    final dividerColor = textStyle.color;
    return TPopoverAnchor(
      controller: _customContentPopoverController,
      padding: EdgeInsets.zero,
      colorScheme: theme,
      width: 150,
      height: 146,
      content: Column(
        children: [
          GestureDetector(
            key: const Key('popover-custom-option-1'),
            behavior: HitTestBehavior.opaque,
            onTap: () => selectOption('选项1'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: TText('选项1', style: textStyle),
            ),
          ),
          Container(height: 1, color: dividerColor),
          GestureDetector(
            key: const Key('popover-custom-option-2'),
            behavior: HitTestBehavior.opaque,
            onTap: () => selectOption('选项2'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: TText('选项2', style: textStyle),
            ),
          ),
          Container(height: 1, color: dividerColor),
          GestureDetector(
            key: const Key('popover-custom-option-3'),
            behavior: HitTestBehavior.opaque,
            onTap: () => selectOption('选项3'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: TText('选项3', style: textStyle),
            ),
          ),
        ],
      ),
      builder: (popoverContext, controller, child) {
        return TButton(
          key: const Key('popover-custom-content-trigger'),
          size: TButtonSize.large,
          child: const Text('自定义内容'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: controller.open,
        );
      },
    );
  }

  final _customContentPopoverController = TPopoverController();

  TPopoverColorScheme theme = TPopoverColorScheme.light;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        theme = Theme.of(context).brightness == Brightness.dark
            ? TPopoverColorScheme.light
            : TPopoverColorScheme.defaultTheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildNCustomPopover(context);
  }
}
