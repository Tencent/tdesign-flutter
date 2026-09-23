import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'popover')
class PopoverColorSchemesExample extends StatelessWidget {
  const PopoverColorSchemesExample({super.key});

  Widget _buildDarkPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('深色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('浅色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.light,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPrimaryPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('品牌色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.primary,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSuccessPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('成功色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.success,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWarningPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('警告色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.warning,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDangerPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.large,
            child: const Text('错误色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: const Text('弹出气泡内容'),
                colorScheme: TPopoverColorScheme.danger,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(child: Builder(builder: _buildDarkPopover)),
              Expanded(child: Builder(builder: _buildLightPopover)),
              Expanded(child: Builder(builder: _buildPrimaryPopover)),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(child: Builder(builder: _buildSuccessPopover)),
              Expanded(child: Builder(builder: _buildWarningPopover)),
              Expanded(child: Builder(builder: _buildDangerPopover)),
            ],
          ),
        ],
      ),
    );
  }
}
