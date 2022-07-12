import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_base.dart';

class TdTagPage extends StatelessWidget {
  const TdTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(title: '标签',
        // padding: EdgeInsets.zero,
        children: [
          ExampleItem(
              desc: '展示标签',
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    const TDTag(
                      '标签',
                    ),
                    const TDTag('成功',
                        style: RoundRectTagStyle(type: TDTagType.success)),
                    const TDTag('警告',
                        style: RoundRectTagStyle(type: TDTagType.warning)),
                    const TDTag('危险',
                        style: RoundRectTagStyle(type: TDTagType.error)),
                    const TDTag('信息',
                        style: RoundRectTagStyle(type: TDTagType.message)),
                    const TDTag('浅色', style: RoundRectTagStyle(isLight: true)),
                    const TDTag('描边', style: WireframeRoundRectTagStyle()),
                    const TDTag('浅色描边',
                        style: WireframeRoundRectTagStyle(isLight: true)),
                    const TDTag(
                      'English',
                    ),
                    const TDTag('English',
                        style: WireframeRoundRectTagStyle(isLight: true)),
                    const TDTag(
                      'ABC',
                    ),
                    const TDTag('ABC',
                        style: WireframeRoundRectTagStyle(isLight: true)),
                    const TDTag(
                      '中English混合',
                    ),
                    const TDTag('中English混合',
                        style: WireframeRoundRectTagStyle(isLight: true)),
                    TDTag(
                      '圆角',
                      style: CircleRectTagStyle(),
                    ),
                    TDTag(
                      '半圆',
                      style: SemicircleRectTagStyle(),
                    ),
                    TDTag(
                      '标签',
                      needCloseIcon: true,
                      onCloseTap: () {
                        TDToast.showText(context, '点击了关闭图标');
                      },
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '点击控件',
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    TDSelectTag(
                      '标签',
                      isSelected: true,
                      onSelectChanged: (isSelect) {
                        TDToast.showText(context, '标签选中:$isSelect');
                      },
                    ),
                    TDSelectTag(
                      '标签',
                      onSelectChanged: (isSelect) {
                        TDToast.showText(context, '标签选中:$isSelect');
                      },
                    ),
                    TDSelectTag(
                      '标签',
                      style: CircleRectTagStyle(),
                      unSelectStyle: CircleRectTagStyle(
                        textColor: TDTheme.of(context).fontGyColor1,
                        backgroundColor: TDTheme.of(context).grayColor3,
                      ),
                      onSelectChanged: (isSelect) {
                        TDToast.showText(context, '标签选中:$isSelect');
                      },
                    ),
                    TDSelectTag(
                      '标签',
                      style: SemicircleRectTagStyle(),
                      unSelectStyle: SemicircleRectTagStyle(
                        textColor: TDTheme.of(context).fontGyColor1,
                        backgroundColor: TDTheme.of(context).grayColor3,
                      ),
                      onSelectChanged: (isSelect) {
                        TDToast.showText(context, '标签选中:$isSelect');
                      },
                    ),
                    TDSelectTag(
                      '标签',
                      onSelectChanged: (isSelect) {
                        TDToast.showText(context, '标签选中:$isSelect');
                      },
                      enableSelect: false,
                    ),
                    TDSelectTag(
                      '标签',
                      style: CircleRectTagStyle(),
                      unSelectStyle: CircleRectTagStyle(
                        textColor: TDTheme.of(context).fontGyColor1,
                        backgroundColor: TDTheme.of(context).grayColor3,
                      ),
                      unEnableSelectStyle: CircleRectTagStyle(
                        textColor: TDTheme.of(context).fontGyColor4,
                        backgroundColor: TDTheme.of(context).grayColor3,
                      ),
                      enableSelect: false,
                    ),

                    TDSelectTag(
                      '标签',
                      onSelectChanged: (isSelect) {
                        TDToast.showText(context, '标签选中:$isSelect');
                      },
                      needCloseIcon: true,
                      onCloseTap: (){
                        TDToast.showText(context, '点击关闭标签');
                      },
                    ),
                    TDSelectTag(
                      '标签',
                      style: CircleRectTagStyle(),
                      unSelectStyle: CircleRectTagStyle(
                        textColor: TDTheme.of(context).fontGyColor1,
                        backgroundColor: TDTheme.of(context).grayColor3,
                      ),
                      unEnableSelectStyle: CircleRectTagStyle(
                        textColor: TDTheme.of(context).fontGyColor4,
                        backgroundColor: TDTheme.of(context).grayColor3,
                      ),
                      needCloseIcon: true,
                      onCloseTap: (){
                        TDToast.showText(context, '点击关闭标签');
                      },
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '尺寸规格-大，正常，小',
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
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
              desc: '圆角尺寸规格-大，正常，小',
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    TDTag(
                      '圆角',
                      style: CircleRectTagStyle(),
                      size: TDTagSize.large,
                    ),
                    TDTag(
                      '圆角',
                      style: CircleRectTagStyle(),
                    ),
                    TDTag(
                      '圆角',
                      style: CircleRectTagStyle(),
                      size: TDTagSize.small,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '半圆尺寸规格-大，正常，小',
              builder: (context) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    TDTag(
                      '半圆',
                      style: SemicircleRectTagStyle(),
                      size: TDTagSize.large,
                    ),
                    TDTag(
                      '半圆',
                      style: SemicircleRectTagStyle(),
                    ),
                    TDTag(
                      '半圆',
                      style: SemicircleRectTagStyle(),
                      size: TDTagSize.small,
                    ),
                  ],
                );
              }),
        ]);
  }
}
