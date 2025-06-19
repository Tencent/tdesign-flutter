import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDDatePickerPage extends StatefulWidget {
  const TDDatePickerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDDatePickerPageState();
}

class _TDDatePickerPageState extends State<TDDatePickerPage> {
  String selected_1 = '';
  String selected_2 = '';
  String selected_3 = '';
  String selected_4 = '';
  String selected_5 = '';
  String selected_6 = '';
  String selected_7 = '';
  String selected_8 = '';
  String selected_9 = '';

  var weekDayList = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于选择一个时间点或者一个时间段。',
      exampleCodeGroup: 'datetimePicker',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '年月日选择器', builder: buildYearMonthDay),
            ExampleItem(desc: '年月选择器', builder: buildYearMonth),
            ExampleItem(desc: '月日选择器', builder: buildMonthDay),
            ExampleItem(desc: '时分秒选择器', builder: buildHourMinuteSecond),
            ExampleItem(desc: '年月日时分秒选择器', builder: buildAll),
            ExampleItem(desc: '年月日带星期选择器', builder: buildWeekDay),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '是否带标题', builder: buildWithTitle),
            ExampleItem(desc: '不带标题', builder: buildWithoutTitle),
          ],
        )
      ],
      test: [
        ExampleItem(desc: '指定开始时间', builder: _customStartTime),
        ExampleItem(desc: '限制时分秒时间', builder: _customLimitTime),
        ExampleItem(desc: '自定义时间选项', builder: _customItems),
        ExampleItem(desc: '自定义选中选项', builder: _customSelectWidget),
        ExampleItem(desc: '只有时分限制时间', builder: _customItemsOnlyHour),
      ],
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildYearMonthDay(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_1 =
                '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_1, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildYearMonth(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_2 = '${selected['year'].toString().padLeft(4, '0')}-'
                '${selected['month'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            useDay: false,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_2, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildMonthDay(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_3 = '${selected['month'].toString().padLeft(2, '0')}-'
                '${selected['day'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            useYear: false,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_3, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildHourMinuteSecond(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_4 = '${selected['hour'].toString().padLeft(2, '0')}:'
                '${selected['minute'].toString().padLeft(2, '0')}:'
                '${selected['second'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            useYear: false,
            useMonth: false,
            useDay: false,
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31, 4, 12, 20],
            initialDate: [2023, 12, 31]);
      },
      child: buildSelectRow(context, selected_4, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildAll(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_5 = '${selected['year'].toString().padLeft(4, '0')}-'
                '${selected['month'].toString().padLeft(2, '0')}-'
                '${selected['day'].toString().padLeft(2, '0')} '
                '${selected['hour'].toString().padLeft(2, '0')}:'
                '${selected['minute'].toString().padLeft(2, '0')}:'
                '${selected['second'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_5, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildWeekDay(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_6 = '${selected['year'].toString().padLeft(4, '0')}-'
                '${selected['month'].toString().padLeft(2, '0')}-'
                '${selected['day'].toString().padLeft(2, '0')} '
                '${weekDayList[selected['weekDay']! - 1]}';
          });
          Navigator.of(context).pop();
        },
            useWeekDay: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_6, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildWithTitle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_7 = '${selected['year'].toString().padLeft(4, '0')}-'
                '${selected['month'].toString().padLeft(2, '0')}-'
                '${selected['day'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_7, '带标题时间选择器'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildWithoutTitle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '', onConfirm: (selected) {
          setState(() {
            selected_8 = '${selected['year'].toString().padLeft(4, '0')}-'
                '${selected['month'].toString().padLeft(2, '0')}-'
                '${selected['day'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_8, '无标题时间选择器'),
    );
  }

  Widget buildSelectRow(BuildContext context, String output, String title) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: TDText(
                  title,
                  font: TDTheme.of(context).fontBodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    TDText(
                      output,
                      font: TDTheme.of(context).fontBodyLarge,
                      textColor:
                          TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        TDIcons.chevron_right,
                        color:
                            TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const TDDivider(
            margin: EdgeInsets.only(
              left: 16,
            ),
          )
        ],
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget _customStartTime(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_5 = '${selected['year'].toString().padLeft(4, '0')}-'
                '${selected['month'].toString().padLeft(2, '0')}-'
                '${selected['day'].toString().padLeft(2, '0')} '
                '${selected['hour'].toString().padLeft(2, '0')}:'
                '${selected['minute'].toString().padLeft(2, '0')}:'
                '${selected['second'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            useYear: true,
            useMonth: true,
            useDay: true,
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [2012, 1, 15, 12, 28, 11],
            dateEnd: [2012, 6, 15, 12, 48, 32],
            initialDate: [2012, 1, 15, 13, 20]);
      },
      child: buildSelectRow(context, selected_5, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget _customLimitTime(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_4 = '${selected['hour'].toString().padLeft(2, '0')}:'
                '${selected['minute'].toString().padLeft(2, '0')}:'
                '${selected['second'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            useYear: false,
            useMonth: false,
            useDay: false,
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [2023, 12, 31],
            dateEnd: [2023, 12, 31, 4, 12, 20],
            initialDate: [2023, 12, 31, 3, 02, 03]);
      },
      child: buildSelectRow(context, selected_4, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget _customItems(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
          onConfirm: (selected) {
            setState(() {
              selected_9 = '${selected['year'].toString().padLeft(4, '0')}-'
                  '${selected['month'].toString().padLeft(2, '0')}-'
                  '${selected['day'].toString().padLeft(2, '0')} '
                  '${selected['hour'].toString().padLeft(2, '0')}:'
                  '${selected['minute'].toString().padLeft(2, '0')}:'
                  '${selected['second'].toString().padLeft(2, '0')}';
            });
            Navigator.of(context).pop();
          },
          useHour: true,
          useMinute: true,
          useSecond: true,
          dateStart: [1999, 01, 01],
          dateEnd: [2023, 12, 31],
          initialDate: [2012, 1, 1],
          filterItems: (key, nums) {
            if (key == DateTypeKey.minute) {
              return [0, 15, 30];
            }
            return nums;
          },
          itemBuilder: (context, content, colIndex, index,
              itemDistanceCalculator, distance) {
            return colIndex == 5
                ? TDText(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: itemDistanceCalculator.calculateFontWeight(
                          context, distance),
                      fontSize: index % 2 == 0 ? 20 : 10,
                      color: index % 2 == 1
                          ? TDTheme.of(context).fontGyColor1
                          : TDTheme.of(context).successColor6,
                    ),
                  )
                : null;
          },
        );
      },
      child: buildSelectRow(context, selected_9, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget _customItemsOnlyHour(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(
          context,
          title: '只有时分',
          onConfirm: (selected) {
            Navigator.of(context).pop();
          },
          useYear: false,
          useMonth: false,
          useDay: false,
          useSecond: false,
          useHour: true,
          useMinute: true,
          dateStart: [2025, 1, 1, 20, 0, 0],
          dateEnd: [2025, 1, 1, 23, 59, 0],
          initialDate: [2025, 1, 1, 22, 46, 0],
        );
      },
      child: buildSelectRow(context, selected_9, '选择时间'),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget _customSelectWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDPicker.showDatePicker(context, title: '选择时间', onConfirm: (selected) {
          setState(() {
            selected_9 = '${selected['year'].toString().padLeft(4, '0')}-'
                '${selected['month'].toString().padLeft(2, '0')}-'
                '${selected['day'].toString().padLeft(2, '0')} '
                '${selected['hour'].toString().padLeft(2, '0')}:'
                '${selected['minute'].toString().padLeft(2, '0')}:'
                '${selected['second'].toString().padLeft(2, '0')}';
          });
          Navigator.of(context).pop();
        },
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1],
            customSelectWidget: Container(
              height: 40,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
            ));
      },
      child: buildSelectRow(context, selected_9, '选择时间'),
    );
  }
}
