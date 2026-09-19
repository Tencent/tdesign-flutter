part of 'radio_page.dart';

extension _RadioTypeModule on _TRadioPageState {
  ExampleModule get _radioTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '纵向单选框', builder: _verticalRadios),
      ExampleItem(desc: '横向单选框', builder: _horizontalRadios, center: false),
    ],
  );
}
