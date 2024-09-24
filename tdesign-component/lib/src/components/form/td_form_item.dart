import 'package:flutter/material.dart';

class TDForm_items extends StatefulWidget {
  const TDForm_items({
    Key?key,
    this.label,
});

  /// 表格内标签 内容填充
  final String? label;

  @override
  State<TDForm_items> createState() => _TDForm_itemsState();
}

class _TDForm_itemsState extends State<TDForm_items> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}