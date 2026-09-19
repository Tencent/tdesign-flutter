part of 'date_time_picker_page.dart';

extension _DateTimePickerTypeModule on _TDateTimePickerPageState {
  ExampleModule get _dateTimePickerTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '年月日选择器', builder: _buildDate, methodName: '_cell'),
      ExampleItem(desc: '年月选择器', builder: _buildMonth, methodName: '_cell'),
      ExampleItem(desc: '月日选择器', builder: _buildMonthDay, methodName: '_cell'),
      ExampleItem(desc: '时分秒选择器', builder: _buildSecond, methodName: '_cell'),
      ExampleItem(desc: '时分选择器', builder: _buildMinute, methodName: '_cell'),
      ExampleItem(
        desc: '年月日时分秒选择器',
        builder: _buildDateTime,
        methodName: '_cell',
      ),
      ExampleItem(desc: '年月日带星期选择器', builder: _buildWeek, methodName: '_cell'),
    ],
  );
}
