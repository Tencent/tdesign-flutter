part of 'date_time_picker_page.dart';

extension _DateTimePickerStyleModule on _TDateTimePickerPageState {
  ExampleModule get _dateTimePickerStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '是否带标题', builder: _buildTitle, methodName: '_cell'),
      ExampleItem(builder: _buildWithoutTitle, methodName: '_cell'),
    ],
  );
}
