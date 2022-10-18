import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tdesign_flutter/td_export.dart';

class CodeWidget extends StatefulWidget {
  const CodeWidget({Key? key, this.codePath}) : super(key: key);

  final String? codePath;

  @override
  State<CodeWidget> createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {

  String? result;
  String? lastApiName;


  @override
  void initState() {
    super.initState();
    getCodeData();
  }

  Future<String> getCodeData() async {
    const defaultResult = '加载失败';
    if(widget.codePath == lastApiName && result != null && result != defaultResult){
      return result!;
    }
    try {
      var url = 'https://raw.githubusercontent.com/TDesignOteam/tdesign-flutter/main/example/lib/tdesign/page/td_${widget.codePath}_page.dart';

      print('getCodeData url:$url');
      var resp =  await http.get(Uri.parse(url));
      result = String.fromCharCodes(resp.body.codeUnits);
      lastApiName = widget.codePath;
    } catch (e) {
      print('getCodeData error: $e');
    }
    return result ?? defaultResult;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getCodeData(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: SelectableText(snapshot.data ?? '',),
            );
          } else {
            return  Container(
              alignment: Alignment.topLeft,
              child: const TDText('加载中…'),
            );
          }
        },
      )
    );
  }
}
