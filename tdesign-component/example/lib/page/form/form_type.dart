part of 'form_page.dart';

extension _FormTypeModule on TFormPage {
  ExampleModule get _formTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '基础表单',
        builder: (_) => const FormBasicDemo(),
        methodName: 'FormBasicDemo',
        center: false,
      ),
    ],
  );
}
