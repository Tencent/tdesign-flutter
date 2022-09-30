import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

///
/// TdPopup掩饰
///
class TdPopupPage extends StatefulWidget {
  const TdPopupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TdPopupPageState();
  }
}

class TdPopupPageState extends State<TdPopupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Column(
      children: [
        TDButton(
          content: '顶部Popup',
          onTap: () {
            Navigator.of(context).push(TdSlidePopupRoute(
                slideTransitionFrom: SlideTransitionFrom.top,
                builder: (context) {
                  return Container(
                    color: Colors.white,
                    height: 300,
                  );
                }));
          },
        ),

        const SizedBox(height: 10,),

        TDButton(
          content: '底部Popup',
          onTap: () {
            Navigator.of(context).push(TdSlidePopupRoute(
                slideTransitionFrom: SlideTransitionFrom.bottom,
                builder: (context) {
                  return Container(
                    color: Colors.white,
                    height: 300,
                  );
                }));
          },
        ),

        const SizedBox(height: 10,),

        TDButton(
          content: '左侧Popup',
          onTap: () {
            Navigator.of(context).push(TdSlidePopupRoute(
                slideTransitionFrom: SlideTransitionFrom.left,
                builder: (context) {
                  return Container(
                    color: Colors.white,
                    width: 300,
                  );
                }));
          },
        ),


        const SizedBox(height: 10,),

        TDButton(
          content: '右侧Popup',
          onTap: () {
            Navigator.of(context).push(TdSlidePopupRoute(
                slideTransitionFrom: SlideTransitionFrom.right,
                builder: (context) {
                  return Container(
                    color: Colors.white,
                    width: 300,
                  );
                }));
          },
        ),
      ],
    );

    current = Padding(
      padding: const EdgeInsets.all(20),
      child: current,
    );

    current = Scaffold(
      appBar: AppBar(
        title: const Text('CheckBox演示'),
      ),
      body: current,
    );
    return current;
  }
}
