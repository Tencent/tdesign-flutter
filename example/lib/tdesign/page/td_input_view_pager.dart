import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

class TdInputViewPage extends StatefulWidget {
  const TdInputViewPage({Key? key}) : super(key: key);

  @override
  _TdInputViewPageState createState() => _TdInputViewPageState();
}

class _TdInputViewPageState extends State<TdInputViewPage> {
  String inputText = '请输入...';
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('inputView组件'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: TDTheme.of(context).fontGyColor4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 48,
              child: TDInput(
                leftLabel: 'QQ登录',
                controller: controller,
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                  color: TDTheme.of(context).fontGyColor1,
                  fontSize: TDTheme.of(context).fontS?.size,
                ),
                hitText: '说点什么吧',
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
                rightBtn: GestureDetector(
                    onTap: () => controller.clear(),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              inputText,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
