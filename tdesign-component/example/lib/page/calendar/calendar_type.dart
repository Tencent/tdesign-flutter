part of 'calendar_page.dart';

extension _CalendarTypeModule on _TCalendarPageState {
  ExampleModule get _calendarTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础日历', builder: _buildSingle),
      ExampleItem(builder: _buildMultiple),
      ExampleItem(desc: '带单行描述的日历', builder: _buildDescribed),
      ExampleItem(desc: '带双行描述的日历', builder: _buildDoubleDescribed),
      ExampleItem(desc: '带翻页功能的日历', builder: _buildSwitchMode),
      ExampleItem(desc: '可选择区间日期的日历', builder: _buildRange),
    ],
  );
}
