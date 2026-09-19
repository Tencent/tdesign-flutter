part of 'calendar_page.dart';

extension _CalendarStyleModule on _TCalendarPageState {
  ExampleModule get _calendarStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '国际化', builder: _buildLocalized),
      ExampleItem(desc: '含不可选的日历', builder: _buildLimited),
      ExampleItem(desc: '不使用 Popup', builder: _buildInline),
    ],
  );
}
