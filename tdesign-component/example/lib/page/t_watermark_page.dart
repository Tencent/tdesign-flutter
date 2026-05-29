import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TWatermarkPage extends StatelessWidget {
  const TWatermarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: '水印 Watermark',
      exampleCodeGroup: 'watermark',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '单行文本水印:', builder: _buildSingleLine),
          ExampleItem(desc: '多行文本水印:', builder: _buildMultiLine),
        ]),
        ExampleModule(title: '排列方式', children: [
          ExampleItem(desc: '水平排列:', builder: _buildHorizontalLayout),
          ExampleItem(desc: '垂直排列:', builder: _buildVerticalLayout),
          ExampleItem(desc: '网格排列:', builder: _buildGridLayout),
        ]),
        ExampleModule(title: '自定义样式', children: [
          ExampleItem(desc: '自定义颜色和透明度:', builder: _buildCustomColor),
          ExampleItem(desc: '自定义字体大小:', builder: _buildCustomSize),
          ExampleItem(desc: '自定义旋转角度:', builder: _buildCustomRotate),
          ExampleItem(desc: '自定义间距:', builder: _buildCustomGap),
        ]),
        ExampleModule(title: '带内容的水印', children: [
          ExampleItem(desc: '图片上的水印:', builder: _buildImageWatermark),
          ExampleItem(desc: '列表上的水印:', builder: _buildListWatermark),
          ExampleItem(desc: '表单上的水印:', builder: _buildFormWatermark),
        ]),
      ],
    );
  }

  @Demo(group: 'watermark')
  Widget _buildSingleLine(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: 'TDesign Flutter',
        type: TWatermarkType.singleLine,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildMultiLine(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: 'TDesign\nFlutter',
        type: TWatermarkType.multiLine,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildHorizontalLayout(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '内部资料',
        layout: TWatermarkLayout.horizontal,
        gapX: 150,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildVerticalLayout(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '机密',
        layout: TWatermarkLayout.vertical,
        gapY: 80,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildGridLayout(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: 'TDesign',
        layout: TWatermarkLayout.grid,
        gapX: 120,
        gapY: 80,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildCustomColor(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '保密文档',
        textColor: TTheme.of(context).errorNormalColor,
        opacity: 0.2,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildCustomSize(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '大字体水印',
        textSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildCustomRotate(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '旋转45度',
        rotate: -45,
        gapX: 150,
        gapY: 100,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildCustomGap(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '密集',
        gapX: 60,
        gapY: 40,
        textSize: 12,
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildImageWatermark(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '仅供查看',
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: TTheme.of(context).brandFocusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              TIcons.image,
              size: 80,
              color: TTheme.of(context).brandNormalColor,
            ),
          ),
        ),
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildListWatermark(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '内部数据',
        opacity: 0.1,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TTheme.of(context).componentStrokeColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: TTheme.of(context).brandLightColor,
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TText(
                          '列表项 ${index + 1}',
                          font: TTheme.of(context).fontBodyMedium,
                        ),
                        const SizedBox(height: 4),
                        TText(
                          '这是第 ${index + 1} 条数据的描述信息',
                          font: TTheme.of(context).fontBodySmall,
                          textColor: TTheme.of(context).textColorSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @Demo(group: 'watermark')
  Widget _buildFormWatermark(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TWatermark(
        text: '草稿',
        opacity: 0.08,
        textSize: 48,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TInput(
                leftLabel: '姓名',
                hintText: '请输入姓名',
              ),
              const SizedBox(height: 16),
              TInput(
                leftLabel: '邮箱',
                hintText: '请输入邮箱',
              ),
              const SizedBox(height: 16),
              TInput(
                leftLabel: '电话',
                hintText: '请输入电话号码',
              ),
              const SizedBox(height: 16),
              TButton(
                text: '提交',
                theme: TButtonTheme.primary,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
