import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'popover')
class PopoverBottomPlacementsExample extends StatefulWidget {
  const PopoverBottomPlacementsExample({super.key});

  @override
  State<PopoverBottomPlacementsExample> createState() =>
      _PopoverBottomPlacementsExampleState();
}

class _PopoverBottomPlacementsExampleState
    extends State<PopoverBottomPlacementsExample> {
  Widget _buildBottomLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('底部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.bottomLeft,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('底部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.bottom,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('底部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.bottomRight,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

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
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(child: Builder(builder: _buildBottomLeftPopover)),
          Expanded(child: Builder(builder: _buildBottomPopover)),
          Expanded(child: Builder(builder: _buildBottomRightPopover)),
        ],
      ),
    );
  }
}
