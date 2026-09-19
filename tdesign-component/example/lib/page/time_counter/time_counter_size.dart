part of 'time_counter_page.dart';

extension _TimeCounterSizeModule on TTimeCounterPage {
  ExampleModule get _timeCounterSizeModule => const ExampleModule(
    title: '组件尺寸',
    children: [
      ExampleItem(
        desc: '时分秒',
        builder: _buildDefaultSizes,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带毫秒',
        builder: _buildMillisecondSizes,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带方形底',
        builder: _buildSquareSizes,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带圆形底',
        builder: _buildRoundSizes,
        center: false,
        padding: _counterPadding,
      ),
      ExampleItem(
        desc: '带单位',
        builder: _buildUnitSizes,
        center: false,
        padding: _counterPadding,
      ),
    ],
  );
}
