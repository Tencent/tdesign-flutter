/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../example_base.dart';

class TdPullDownRefreshPage extends StatefulWidget {

  const TdPullDownRefreshPage({Key? key}):super(key: key);

  @override
  State<StatefulWidget> createState() => _TdPullDownRefreshPageState();
}

class _TdPullDownRefreshPageState extends State<TdPullDownRefreshPage> {
  var itemCount = 10;

  var datas = List.generate(10, (index) => '首页$index');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('下拉刷新'),),
      body: EasyRefresh(
        // 下拉样式
        header: TDRefreshHeader(),
        child: ListView.builder(itemBuilder: (context,index)=>Text("${datas[index]}"),itemCount: datas.length,),
        // 下拉刷新回调
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            datas.addAll(List.generate(10, (index) => ' 下拉添加的第$index个item'));
            setState(() {});
          });
        },
      ),
    );
  }

}

