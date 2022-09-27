import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_base.dart';

// ignore: use_key_in_widget_constructors
class TdDatePickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdDatePickerPageState();
}

class _TdDatePickerPageState extends State<TdDatePickerPage> {
  String selected_1 = '';
  String selected_2 = '';
  String selected_3 = '';
  String selected_4 = '';
  String selected_5 = '';
  String selected_6 = '';

  @override
  void initState() {
    var list = <String>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(
      title: 'Datepicker组件',
      children: [
        ExampleItem(desc: '年月日', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择日期',
                  click: () => TDPicker.showDatePicker(context, title: '选择时间',
                      onConfirm: (selected) {
                        setState(() {
                          selected_1 = '日期: $selected';
                        });
                      },
                      dateStart: [2010, 12, 20],
                      dateEnd: [2022, 2, 28],
                      initialDate: [2012, 1, 1]),
                ),
                TDText(
                  selected_1,
                ),
              ]);
        }),
        ExampleItem(desc: '年月', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择日期',
                  click: () => TDPicker.showDatePicker(context, title: '选择时间',
                      onConfirm: (selected) {
                        setState(() {
                          selected_2 = '日期: $selected';
                        });
                      },
                      useDay: false,
                      dateStart: [2010, 12, 20],
                      dateEnd: [2022, 2, 28],
                      initialDate: [2012, 1, 1]),
                ),
                TDText(
                  selected_2,
                ),
              ]);
        }),
        ExampleItem(desc: '月日', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择日期',
                  click: () => TDPicker.showDatePicker(context, title: '选择时间',
                      onConfirm: (selected) {
                        setState(() {
                          selected_3 = '日期: $selected';
                        });
                      },
                      useYear: false,
                      dateStart: [2010, 12, 20],
                      dateEnd: [2022, 2, 28],
                      initialDate: [2012, 1, 1]),
                ),
                TDText(
                  selected_3,
                ),
              ]);
        }),
        ExampleItem(desc: '时分秒', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择日期',
                  click: () => TDPicker.showDatePicker(context, title: '选择时间',
                      onConfirm: (selected) {
                        setState(() {
                          selected_4 = '日期: $selected';
                        });
                      },
                      useYear: false,
                      useMonth: false,
                      useDay: false,
                      useHour: true,
                      useMinute: true,
                      useSecond: true,
                      dateStart: [2010, 12, 20],
                      dateEnd: [2022, 2, 28],
                      initialDate: [2012, 1, 1]),
                ),
                TDText(
                  selected_4,
                ),
              ]);
        }),
        ExampleItem(desc: '年月日时分秒', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择日期',
                  click: () => TDPicker.showDatePicker(context, title: '选择时间',
                      onConfirm: (selected) {
                        setState(() {
                          selected_5 = '日期: $selected';
                        });
                      },
                      useHour: true,
                      useMinute: true,
                      useSecond: true,
                      dateStart: [2010, 12, 20],
                      dateEnd: [2022, 2, 28],
                      initialDate: [2012, 1, 1]),
                ),
                TDText(
                  selected_5,
                ),
              ]);
        }),
      ],
    );
  }
}
