part of 'radio_page.dart';

extension _RadioStyleModule on _TRadioPageState {
  ExampleModule get _radioStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '勾选样式', builder: _themes),
      ExampleItem(desc: '勾选显示位置', builder: _positions),
      ExampleItem(desc: '非通栏单选样式', builder: _verticalCardRadios),
    ],
  );
}
