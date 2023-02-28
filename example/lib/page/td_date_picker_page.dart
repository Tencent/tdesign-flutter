import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

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

  var weekDayList = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: 'DatetimePicker 时间选择器 ',
        desc: '用于选择一个时间点或者一个时间段。',
        exampleCodeGroup: 'datetimePicker',
        children: [
          ExampleModule(title: '组件类型',
            children: [
              ExampleItem(desc: '年月日选择器', builder: buildYearMonthDay),
              ExampleItem(desc: '年月选择器', builder: buildYearMonth),
              ExampleItem(desc: '月日选择器', builder: buildMonthDay),
              ExampleItem(desc: '时分秒选择器', builder: buildHourMinuteSecond),
              ExampleItem(desc: '年月日时分秒选择器', builder: buildAll),
              ExampleItem(desc: '年月日带星期选择器', builder: buildWeekDay),
            ],
          ),
          ExampleModule(title: '组件样式',
            children: [
              ExampleItem(desc: '是否带标题', builder: buildWithTitle),
              ExampleItem(desc: '不带标题', builder: buildWithoutTitle),
            ],
          )
        ]);
  }

  @Demo(group: 'datetimePicker')
  Widget buildYearMonthDay(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_1 = '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
              });
            },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('选择时间', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(selected_1, font: TDTheme.of(context).fontBodyLarge, textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      Padding(padding: const EdgeInsets.only(left: 2), child: Icon(TDIcons.chevron_right, color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildYearMonth(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_2 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}';
              });
            },
            useDay: false,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('选择时间', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(
                        selected_2,
                        font: TDTheme.of(context).fontBodyLarge,
                        textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildMonthDay(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_3 = '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')}';
              });
            },
            useYear: false,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('选择时间', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(
                        selected_3,
                        font: TDTheme.of(context).fontBodyLarge,
                        textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildHourMinuteSecond(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_4 = '${selected['hour'].toString().padLeft(2, '0')}:'
                    '${selected['minute'].toString().padLeft(2, '0')}:'
                    '${selected['second'].toString().padLeft(2, '0')}';
              });
            },
            useYear: false,
            useMonth: false,
            useDay: false,
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('选择时间', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(
                        selected_4,
                        font: TDTheme.of(context).fontBodyLarge,
                        textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildAll(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_5 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')} '
                    '${selected['hour'].toString().padLeft(2, '0')}:'
                    '${selected['minute'].toString().padLeft(2, '0')}:'
                    '${selected['second'].toString().padLeft(2, '0')}';
              });
            },
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('选择时间', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(
                        selected_5,
                        font: TDTheme.of(context).fontBodyLarge,
                        textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildWeekDay(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_6 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')} '
                    '${weekDayList[selected['weekDay']! - 1]}';
              });
            },
            useWeekDay: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('选择时间', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(
                        selected_6,
                        font: TDTheme.of(context).fontBodyLarge,
                        textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildWithTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_7 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')}';
              });
            },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('带标题时间选择器', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(
                        selected_7,
                        font: TDTheme.of(context).fontBodyLarge,
                        textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }

  @Demo(group: 'datetimePicker')
  Widget buildWithoutTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '',
            onConfirm: (selected) {
              setState(() {
                selected_8 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')}';
              });
            },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: Container(
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
                  child: TDText('无标题时间选择器', font: TDTheme.of(context).fontBodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      TDText(
                        selected_8,
                        font: TDTheme.of(context).fontBodyLarge,
                        textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TDDivider(margin: EdgeInsets.only(left: 16, ),)
          ],
        ),
      ),
    );
  }
}
