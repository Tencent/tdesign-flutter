import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TEmptyPage extends StatefulWidget {
  const TEmptyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TEmptyPageState();
}

class _TEmptyPageState extends State<TEmptyPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(),
        exampleCodeGroup: 'empty',
        desc: '用于空状态时的占位提示。',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '图标空状态', builder: _iconEmpty),
            ExampleItem(desc: '自定义图标空状态', builder: _iconEmptyCustom),
            ExampleItem(desc: '自定义图片空状态', builder: _imageEmpty),
            ExampleItem(desc: '带操作空状态', builder: _operationEmpty),
            ExampleItem(desc: '自定义带操作空状态', builder: _operationCustomEmpty),
          ]),
        ]);
  }

  @Demo(group: 'empty')
  Widget _iconEmpty(BuildContext context) {
    return const TEmpty(
      type: TEmptyType.plain,
      emptychild: Text('描述文字'),
    );
  }

  @Demo(group: 'empty')
  Widget _iconEmptyCustom(BuildContext context) {
    return const TEmpty(
      type: TEmptyType.plain,
      icon: Icons.hourglass_empty_sharp,
      emptychild: Text('描述文字'),
    );
  }

  @Demo(group: 'empty')
  Widget _imageEmpty(BuildContext context) {
    return TEmpty(
      type: TEmptyType.plain,
      emptychild: Text('描述文字'),
      image: Container(
        decoration: BoxDecoration(
          color: TTheme.of(context).bgColorComponent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const TImage(
          width: 120,
          assetUrl: 'assets/img/empty.png',
          type: TImageType.fitWidth,
        ),
      ),
    );
  }

  @Demo(group: 'empty')
  Widget _operationEmpty(BuildContext context) {
    return const TEmpty(
      type: TEmptyType.operation,
      operationchild: Text('操作按钮'),
      emptychild: Text('描述文字'),
    );
  }

  @Demo(group: 'empty')
  Widget _operationCustomEmpty(BuildContext context) {
    return TEmpty(
      type: TEmptyType.operation,
      emptychild: Text('描述文字'),
      customOperationWidget: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: TButton(
          child: Text('自定义操作按钮'),
          size: TButtonSize.medium,
          colorScheme: TButtonColorScheme.danger,
          width: 160,
          onPressed: () {},
        ),
      ),
    );
  }
}
