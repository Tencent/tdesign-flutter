import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TEmptyPage extends StatelessWidget {
  const TEmptyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'empty',
      desc: '用于空状态时的占位提示。',
      children: [
        ExampleModule(
          title: '01 类型',
          children: [
            ExampleItem(desc: '图标空状态', builder: _iconEmpty),
            ExampleItem(desc: '自定义图片空状态', builder: _imageEmpty),
            ExampleItem(desc: '带操作空状态', builder: _operationEmpty),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'empty')
  Widget _iconEmpty(BuildContext context) {
    return const TEmpty(emptyText: '描述文字');
  }

  @ExampleCode(group: 'empty')
  Widget _imageEmpty(BuildContext context) {
    return TEmpty(
      image: Container(
        decoration: BoxDecoration(
          color: context.tTheme.bgColorComponent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const TImage(src: 'assets/img/empty.png', fit: BoxFit.contain),
      ),
      emptyText: '描述文字',
    );
  }

  @ExampleCode(group: 'empty')
  Widget _operationEmpty(BuildContext context) {
    return TEmpty(
      emptyText: '描述文字',
      operation: TButton(
        size: TButtonSize.large,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {},
        child: const Text('操作按钮'),
      ),
    );
  }
}
