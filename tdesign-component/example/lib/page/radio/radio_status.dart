part of 'radio_page.dart';

extension _RadioStatusModule on _TRadioPageState {
  ExampleModule get _radioStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(desc: '单选框状态', builder: _disabledRadios)],
  );
}
