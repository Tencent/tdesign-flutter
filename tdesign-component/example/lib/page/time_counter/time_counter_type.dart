part of 'time_counter_page.dart';

extension _TimeCounterTypeModule on TTimeCounterPage {
  ExampleModule get _timeCounterTypeModule => const ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '时分秒',
        builder: _buildSimple,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带毫秒',
        builder: _buildMillisecondSimple,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带方形底',
        builder: _buildSquareSimple,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带圆形底',
        builder: _buildRoundSimple,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带单位',
        builder: _buildUnitSimple,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '无底色带单位',
        builder: _buildCustomUnitSimple,
        center: false,
        padding: _counterPadding,
      ),
    ],
  );
}
