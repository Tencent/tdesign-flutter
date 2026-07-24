import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../base/example_widget.dart';

class TResultPage extends StatelessWidget {
  const TResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Result 结果',
      desc: '用于反馈一系列操作任务的处理结果',
      exampleCodeGroup: 'result',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '默认', builder: (ctx) => const TResult(title: '默认结果', subtitle: '描述信息')),
          ExampleItem(desc: '成功', builder: (ctx) => const TResult(variant: TResultVariant.success, title: '操作成功', subtitle: '描述信息')),
          ExampleItem(desc: '警告', builder: (ctx) => const TResult(variant: TResultVariant.warning, title: '请注意', subtitle: '描述信息')),
          ExampleItem(desc: '错误', builder: (ctx) => const TResult(variant: TResultVariant.error, title: '操作失败', subtitle: '描述信息')),
        ]),
      ],
    );
  }
}
