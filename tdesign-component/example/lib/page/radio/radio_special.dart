part of 'radio_page.dart';

extension _RadioSpecialModule on _TRadioPageState {
  ExampleModule get _radioSpecialModule => ExampleModule(
    title: '特殊样式',
    children: [ExampleItem(desc: '纵向卡片单选框', builder: _specialRadios)],
  );
}
