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
        children: [
          ExampleItem(
              desc: "展示标签",
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    TDTag('标签', type: TDTagType.normal),
                    TDTag('成功', type: TDTagType.success),
                    TDTag('警告', type: TDTagType.warning),
                    TDTag('危险', type: TDTagType.error),
                    TDTag('信息', type: TDTagType.message),
                    TDTag('描边', type: TDTagType.wireframe),
                    TDTag('浅色', type: TDTagType.lightBackground),
                    TDTag('描边浅色', type: TDTagType.wireframeLightBackground),
                    TDTag('English', type: TDTagType.lightBackground),
                    TDTag('English', type: TDTagType.wireframeLightBackground),
                    TDTag('ABC', type: TDTagType.lightBackground),
                    TDTag('ABC', type: TDTagType.wireframeLightBackground),
                    TDTag('中English混合', type: TDTagType.lightBackground),
                    TDTag('中English混合',
                        type: TDTagType.wireframeLightBackground),
                    TDTag('圆角', borderRadius: 12,),
                    TDTag('半圆', customBorderRadius: BorderRadius.horizontal(right: Radius.circular(12)),),
                  ],
                );
              }),
          ExampleItem(
              desc: "尺寸规格-大，正常，小",
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    TDTag(
                      '标签',
                      size: TDTagSize.large,
                    ),
                    TDTag('标签', size: TDTagSize.middle),
                    TDTag(
                      '标签',
                      size: TDTagSize.small,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: "圆角尺寸规格-大，正常，小",
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    TDTag('圆角', borderRadius: 15,
                      size: TDTagSize.large,
                    ),
                    TDTag('圆角', borderRadius: 12,),
                    TDTag('圆角', borderRadius: 12,
                      size: TDTagSize.small,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: "半圆尺寸规格-大，正常，小",
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    TDTag('半圆', customBorderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
                      size: TDTagSize.large,
                    ),
                    TDTag('半圆', customBorderRadius: BorderRadius.horizontal(right: Radius.circular(12)),),
                    TDTag('半圆', customBorderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                      size: TDTagSize.small,
                    ),
                  ],
                );
              }),
        ]);
  }
}
