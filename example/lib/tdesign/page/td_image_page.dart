import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class ImagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    var url =
        'https://pic.dmjnb.com/pic/100dc4c31a4cfa4c6d3def642fb2efaf?imageMogr2/thumbnail/x320/quality/90!';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image组件'),
        ),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDImage(
                imgUrl: url,
                errorText: '加载失败',
                loadingText: '加载中',
                type: TDImageType.square,
              ),
              TDImage(
                width: 50,
                height: 25,
                imgUrl: url,
                errorText: '加载失败',
                loadingText: '...',
              ),
              TDImage(
                imgUrl: url,
                errorText: '加载失败',
                loadingText: '...',
              ),
              TDImage(
                imgUrl: url,
                errorText: '加载失败',
                loadingText: '加载中',
                type: TDImageType.circle,
              ),
              const TDImage(
                imgUrl: '',
                errorText: '加载失败',
                loadingText: '加载中',
                type: TDImageType.stretch,
              ),
              TDImage(
                imgUrl: url,
                errorText: '加载失败',
                loadingText: '加载中',
                type: TDImageType.fitHeight,
              ),
            ],
          ),
        ));
  }
}
