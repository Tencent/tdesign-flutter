import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter/src/util/string_util.dart';
import 'package:tdesign_flutter_example/tdesign/example_base.dart';

class TdTagPage extends StatelessWidget {
  const TdTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(title: '标签',
        // padding: EdgeInsets.zero,
        children: const[
      TDTag('标签', type: TDTagType.NORMAL),
      TDTag('成功', type: TDTagType.SUCCESS),
      TDTag('警告', type: TDTagType.WARNING),
      TDTag('危险', type: TDTagType.ERROR),
      TDTag('信息', type: TDTagType.MESSAGE),
      TDTag('描边', type: TDTagType.WIREFRAME),
      TDTag('浅色', type: TDTagType.LIGHT_BACKGROUND),
      TDTag('描边浅色', type: TDTagType.WIREFRAME_LIGHT_BACKGROUND),
      TDTag('English', type: TDTagType.LIGHT_BACKGROUND),
      TDTag('English', type: TDTagType.WIREFRAME_LIGHT_BACKGROUND),
      TDTag('ABC', type: TDTagType.LIGHT_BACKGROUND),
      TDTag('ABC', type: TDTagType.WIREFRAME_LIGHT_BACKGROUND),
      TDTag('中English混合', type: TDTagType.LIGHT_BACKGROUND),
      TDTag('中English混合', type: TDTagType.WIREFRAME_LIGHT_BACKGROUND),
      TDTag('标签', size: TDTagSize.LARGE,),
      TDTag('标签', size: TDTagSize.SMALL,),

    ]);
  }
}
