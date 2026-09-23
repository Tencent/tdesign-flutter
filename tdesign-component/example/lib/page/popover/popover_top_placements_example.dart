import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'popover')
class PopoverTopPlacementsExample extends StatefulWidget {
  const PopoverTopPlacementsExample({super.key});

  @override
  State<PopoverTopPlacementsExample> createState() =>
      _PopoverTopPlacementsExampleState();
}

class _PopoverTopPlacementsExampleState
    extends State<PopoverTopPlacementsExample> {
  Widget _buildTopLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('顶部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.topLeft,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('顶部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.top,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('顶部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                placement: TPopoverPlacement.topRight,
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
          Expanded(child: Builder(builder: _buildTopLeftPopover)),
          Expanded(child: Builder(builder: _buildTopPopover)),
          Expanded(child: Builder(builder: _buildTopRightPopover)),
        ],
      ),
    );
  }
}
