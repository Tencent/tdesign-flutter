part of 'empty_page.dart';

extension _EmptyTypeModule on TEmptyPage {
  ExampleModule get _emptyTypeModule => ExampleModule(
    title: '01 类型',
    children: [
      ExampleItem(desc: '图标空状态', builder: _iconEmpty),
      ExampleItem(desc: '自定义图片空状态', builder: _imageEmpty),
      ExampleItem(desc: '带操作空状态', builder: _operationEmpty),
    ],
  );
}
