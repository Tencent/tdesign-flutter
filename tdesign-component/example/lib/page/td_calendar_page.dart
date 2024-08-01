import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDCalendarPage extends StatelessWidget {
  const TDCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).grayColor2,
      child: ExamplePage(
        title: tdTitle(context),
        desc: '按照日历形式展示数据或日期的容器。',
        exampleCodeGroup: 'calendar',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
              ignoreCode: true,
              center: false,
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildSimple);
              },
            ),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(
              desc: '可以自由定义想要的风格',
              ignoreCode: true,
              center: false,
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildStyle);
              },
            ),
            ExampleItem(
              desc: '不使用Popup',
              ignoreCode: true,
              center: false,
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildBlock);
              },
            ),
          ]),
        ],
        test: [],
      ),
    );
  }
}

@Demo(group: 'calendar')
Widget _buildSimple(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final selected = ValueNotifier<List<int>>([DateTime.now().millisecondsSinceEpoch]);
  return ValueListenableBuilder(
    valueListenable: selected,
    builder: (context, value, child) {
      final date = DateTime.fromMillisecondsSinceEpoch(value[0]);
      return TDCellGroup(
        cells: [
          TDCell(
            title: '单个选择日历',
            arrow: true,
            note: '${date.year}-${date.month}-${date.day}',
            onClick: (cell) {
              TDCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm:$value');
                  selected.value = value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TDCalendar(
                  title: '请选择日期',
                  value: value,
                  height: size.height * 0.6 + 176,
                  onCellClick: (value, type, tdate) {
                    print('onCellClick:$value');
                  },
                  onCellLongPress: (value, type, tdate) {
                    print('onCellLongPress:$value');
                  },
                  onHeanderClick: (index, week) {
                    print('onHeanderClick:$week');
                  },
                  onChange: (value) {
                    print('onChange:$value');
                  },
                ),
              );
            },
          ),
          TDCell(
            title: '多个选择日历',
            arrow: true,
            onClick: (cell) {
              TDCalendarPopup(
                context,
                visible: true,
                child: TDCalendar(
                  title: '请选择日期',
                  type: CalendarType.multiple,
                  value: [DateTime.now().millisecondsSinceEpoch],
                  height: size.height * 0.6 + 176,
                ),
              );
            },
          ),
          TDCell(
            title: '区间选择日历',
            arrow: true,
            onClick: (cell) {
              TDCalendarPopup(
                context,
                visible: true,
                child: TDCalendar(
                  title: '请选择日期',
                  type: CalendarType.range,
                  value: [
                    DateTime.now().millisecondsSinceEpoch,
                    DateTime.now().add(const Duration(days: 6)).millisecondsSinceEpoch,
                  ],
                  height: size.height * 0.6 + 176,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

@Demo(group: 'calendar')
Widget _buildStyle(BuildContext context) {
  final size = MediaQuery.of(context).size;
  const map = {
    1: '初一',
    2: '初二',
    3: '初三',
    14: '情人节',
    15: '元宵节',
  };
  return TDCellGroup(
    cells: [
      TDCell(
        title: '自定义文案',
        arrow: true,
        onClick: (cell) {
          TDCalendarPopup(
            context,
            visible: true,
            child: TDCalendar(
              title: '请选择日期',
              height: size.height * 0.6 + 176,
              minDate: DateTime(2022, 1, 1).millisecondsSinceEpoch,
              maxDate: DateTime(2022, 2, 15).millisecondsSinceEpoch,
              format: (day) {
                day?.suffix = '¥60';
                if (day?.date.month == 2) {
                  if (map.keys.contains(day?.date.day)) {
                    day?.suffix = '¥100';
                    day?.prefix = map[day.date.day];
                    day?.style = TextStyle(
                      fontSize: TDTheme.of(context).fontTitleMedium?.size,
                      height: TDTheme.of(context).fontTitleMedium?.height,
                      fontWeight: TDTheme.of(context).fontTitleMedium?.fontWeight,
                      color: TDTheme.of(context).errorColor6,
                    );
                    if (day?.typeNotifier.value == DateSelectType.selected) {
                      day?.style = day.style?.copyWith(color: TDTheme.of(context).fontWhColor1);
                    }
                  }
                }
                return null;
              },
            ),
          );
        },
      ),
      TDCell(
        title: '自定义按钮',
        arrow: true,
        onClick: (cell) {
          late final TDCalendarPopup calendar;
          calendar = TDCalendarPopup(
            context,
            visible: true,
            confirmBtn: Padding(
              padding: EdgeInsets.symmetric(vertical: TDTheme.of(context).spacer16),
              child: TDButton(
                theme: TDButtonTheme.danger,
                shape: TDButtonShape.round,
                text: 'ok',
                isBlock: true,
                onTap: () {
                  print(calendar.selected);
                  calendar.close();
                },
              ),
            ),
            child: TDCalendar(
              title: '请选择日期',
              value: [DateTime.now().millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
      TDCell(
        title: '自定义日期区间',
        arrow: true,
        onClick: (cell) {
          TDCalendarPopup(
            context,
            visible: true,
            child: TDCalendar(
              title: '请选择日期',
              minDate: DateTime(2022, 1, 1).millisecondsSinceEpoch,
              maxDate: DateTime(2022, 1, 31).millisecondsSinceEpoch,
              value: [DateTime(2022, 1, 15).millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
    ],
  );
}

@Demo(group: 'calendar')
Widget _buildBlock(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return TDCalendar(
    title: '请选择日期',
    value: [DateTime.now().millisecondsSinceEpoch],
    height: size.height * 0.6 + 176,
  );
}
