import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_widget.dart';

///
/// TDPopup掩饰
///
class TDPopupPage extends StatefulWidget {
  const TDPopupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDPopupPageState();
  }
}

class TDPopupPageState extends State<TDPopupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var current = ExamplePage(title: '弹出层 PopUp',
        padding: const EdgeInsets.only(top: 16),
        children: [
      ExampleModule(
        title: '默认',
        children: [
          ExampleItem(
              builder: (_) => TDButton(
                    content: '顶部Popup',
                    onTap: () {
                      Navigator.of(context).push(TDSlidePopupRoute(
                          slideTransitionFrom: SlideTransitionFrom.top,
                          builder: (context) {
                            return Container(
                              color: Colors.white,
                              height: 300,
                            );
                          }));
                    },
                  )),
          ExampleItem(
              builder: (_) => TDButton(
                    content: '底部Popup',
                    onTap: () {
                      Navigator.of(context).push(TDSlidePopupRoute(
                          slideTransitionFrom: SlideTransitionFrom.bottom,
                          builder: (context) {
                            return Container(
                              color: Colors.white,
                              height: 300,
                            );
                          }));
                    },
                  )),
          ExampleItem(
              builder: (_) => TDButton(
                    content: '左侧Popup',
                    onTap: () {
                      Navigator.of(context).push(TDSlidePopupRoute(
                          slideTransitionFrom: SlideTransitionFrom.left,
                          builder: (context) {
                            return Container(
                              color: Colors.white,
                              width: 300,
                            );
                          }));
                    },
                  )),
          ExampleItem(
              builder: (_) => TDButton(
                    content: '右侧Popup',
                    onTap: () {
                      Navigator.of(context).push(TDSlidePopupRoute(
                          slideTransitionFrom: SlideTransitionFrom.right,
                          builder: (context) {
                            return Container(
                              color: Colors.white,
                              width: 300,
                            );
                          }));
                    },
                  )),
        ],
      )
    ]);
    return current;
  }
}
