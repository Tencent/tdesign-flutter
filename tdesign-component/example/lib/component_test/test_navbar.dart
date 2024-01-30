import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main(){
  runApp( MaterialApp(
    home: Builder(builder: (context){
      return Scaffold(
        // appBar: TDNavBar(),
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height + MediaQuery.of(context).padding.top),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: TDNavBar(
                useDefaultBack: false,
                // screenAdaptation: false,
                centerTitle: false,
                titleMargin: 0,
                titleWidget:  TDSearchBar(
                  needCancel: false,
                  autoHeight: true,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  placeHolder: '搜索预设文案',
                  mediumStyle: true,
                  style: TDSearchStyle.round,
                  onTextChanged: (String text) {
                    print('input：$text');
                  },
                ),
                rightBarItems: [
                  TDNavBarItem(icon: TDIcons.home,iconSize: 24),
                  TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
                ]
            ),
          ),
        ),
        body: Center(
          child: TDText("测试文案"),
        ),
      );
    },),
  ));
}