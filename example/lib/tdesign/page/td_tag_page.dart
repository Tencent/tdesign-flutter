import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter/src/util/string_util.dart';

class TdTagPage extends StatelessWidget {
  const TdTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('标签'),
      ),
      body: Container(
        color: toColor("#f8f8f8"),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            TDTag("标签", type: TDTagType.NORMAL),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag("成功", type: TDTagType.SUCCESS),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag("警告", type: TDTagType.WARNING),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag("危险", type: TDTagType.ERROR),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag("信息", type: TDTagType.MESSAGE),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag("描边", type: TDTagType.WIREFRAME),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag("浅色", type: TDTagType.LIGHT_BACKGROUND),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag("描边浅色", type: TDTagType.WIREFRAME_LIGHT_BACKGROUND),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag(
              "标签",
              size: TDTagSize.LARGE,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TDTag(
              "标签",
              size: TDTagSize.SMALL,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }
}
