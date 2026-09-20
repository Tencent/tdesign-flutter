import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'popover')
class PopoverRightPlacementsExample extends StatefulWidget {
  const PopoverRightPlacementsExample({super.key});

  @override
  State<PopoverRightPlacementsExample> createState() =>
      _PopoverRightPlacementsExampleState();
}

class _PopoverRightPlacementsExampleState
    extends State<PopoverRightPlacementsExample> {
  Widget _buildRightTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('右侧上'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.rightTop,
                  colorScheme: theme,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('右侧中'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.right,
                  colorScheme: theme,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return SizedBox(
            width: 223,
            child: TButton(
              size: TButtonSize.large,
              child: const Text('右侧下'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: const Text('气泡内容'),
                  placement: TPopoverPlacement.rightBottom,
                  colorScheme: theme,
                );
              },
            ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: _buildRightTopPopover),
          Builder(builder: _buildRightPopover),
          Builder(builder: _buildRightBottomPopover),
        ],
      ),
    );
  }
}
