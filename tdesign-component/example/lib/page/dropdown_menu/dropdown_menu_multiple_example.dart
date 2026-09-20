import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'dropdown_menu')
class DropdownMenuMultipleExample extends StatefulWidget {
  const DropdownMenuMultipleExample({super.key});

  @override
  State<DropdownMenuMultipleExample> createState() =>
      _DropdownMenuMultipleExampleState();
}

class _DropdownMenuMultipleExampleState
    extends State<DropdownMenuMultipleExample> {
  Widget _multiple(BuildContext context) {
    var singleColumn = <String>{'option-1'};
    var doubleColumn = <String>{'option-1'};
    var tripleColumn = <String>{'option-1'};
    return StatefulBuilder(
      builder: (context, setState) {
        TDropdownMenuItem menuItem(
          String label,
          int columns,
          Set<String> selected,
          ValueChanged<Set<String>> onConfirm,
        ) {
          return TDropdownMenuItem(
            label: label,
            panelBuilder: (context, controller) =>
                TDropdownMultiSelectPanel<String>(
                  controller: controller,
                  options: categoryOptions,
                  values: selected,
                  columns: columns,
                  onConfirm: onConfirm,
                ),
          );
        }

        return TDropdownMenu(
          items: [
            menuItem('单列多选', 1, singleColumn, (values) {
              setState(() => singleColumn = values);
            }),
            menuItem('双列多选', 2, doubleColumn, (values) {
              setState(() => doubleColumn = values);
            }),
            menuItem('三列多选', 3, tripleColumn, (values) {
              setState(() => tripleColumn = values);
            }),
          ],
        );
      },
    );
  }

  static const categoryOptions = <TDropdownMenuOption<String>>[
    TDropdownMenuOption(value: 'option-1', label: '选项名称'),
    TDropdownMenuOption(value: 'option-2', label: '选项名称'),
    TDropdownMenuOption(value: 'option-3', label: '选项名称'),
    TDropdownMenuOption(value: 'option-4', label: '选项名称'),
    TDropdownMenuOption(value: 'option-5', label: '选项名称'),
    TDropdownMenuOption(value: 'option-6', label: '选项名称'),
    TDropdownMenuOption(value: 'option-7', label: '选项名称'),
    TDropdownMenuOption(value: 'option-8', label: '选项名称'),
    TDropdownMenuOption(value: 'option-9', label: '选项名称'),
    TDropdownMenuOption(value: 'option-10', label: '选项名称'),
    TDropdownMenuOption(value: 'option-11', label: '选项名称'),
    TDropdownMenuOption(value: 'option-12', label: '选项名称'),
    TDropdownMenuOption(value: 'option-13', label: '禁用选项', disabled: true),
    TDropdownMenuOption(value: 'option-14', label: '禁用选项', disabled: true),
    TDropdownMenuOption(value: 'option-15', label: '禁用选项', disabled: true),
  ];

  @override
  Widget build(BuildContext context) {
    return _multiple(context);
  }
}
