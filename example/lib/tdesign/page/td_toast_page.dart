import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_base.dart';


class TDToastPage extends StatefulWidget {
  const TDToastPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDToastPageState();
}

class _TDToastPageState extends State<TDToastPage> {

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(title: '轻提示 Toast', children: [
      ElevatedButton(
          onPressed: (){
            TDToast.showText('我是Toast', context: context);
          },
          child: const Text('普通toast')),

      ElevatedButton(
          onPressed: (){
            TDToast.showIconText('带图标横向', icon: TDIcons.check_circle, context: context);
          },
          child: const Text('带图标横向')),

      ElevatedButton(
          onPressed: (){
            TDToast.showIconText('带图标竖向', icon: TDIcons.check_circle, direction: IconTextDirection.vertical, context: context);
          },
          child: const Text('带图标竖向')),

      ElevatedButton(
          onPressed: (){
            TDToast.showSuccess('成功文案', direction: IconTextDirection.vertical, context: context);
          },
          child: const Text('成功文案')),

      ElevatedButton(
          onPressed: (){
            TDToast.showWarning('警告文案', direction: IconTextDirection.horizontal, context: context);
          },
          child: const Text('警告文案')),

      ElevatedButton(
          onPressed: (){
            TDToast.showLoading(context: context);
          },
          child: const Text('加载中...')),

      const ElevatedButton(
          onPressed: TDToast.dismissLoading,
          child: Text('停止loading')),


      ElevatedButton(
          onPressed: (){
            var sb = StringBuffer('我是');
            for(var i = 0; i < 20; i++){
              sb.write('很长$i');
            }
            sb.write('toast');
            TDToast.showText(sb.toString(), context: context);
          },
          child: const Text('超长toast')),

      ElevatedButton(
          onPressed: (){
            var sb = StringBuffer('我是');
            for(var i = 0; i < 20; i++){
              sb.write('很长$i');
            }
            sb.write('toast');
            TDToast.showText(sb.toString(), context:  context, duration: const Duration(seconds: 10));
          },
          child: const Text('10秒再消失toast')),

    ]);
  }
}
