import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TWatermark 水印组件使用示例
class WatermarkDemo extends StatelessWidget {
  const WatermarkDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TWatermark 水印组件演示'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 示例1: 基础水印
            _buildSection(
              context,
              '基础水印',
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TWatermark(
                  text: 'TDesign Flutter',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 示例2: 不同布局
            _buildSection(
              context,
              '水平布局',
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TWatermark(
                  text: '内部资料',
                  layout: TWatermarkLayout.horizontal,
                  gapX: 150,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 示例3: 自定义样式
            _buildSection(
              context,
              '自定义颜色和透明度',
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TWatermark(
                  text: '保密文档',
                  textColor: TTheme.of(context).errorNormalColor,
                  opacity: 0.2,
                  textSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 示例4: 图片上的水印
            _buildSection(
              context,
              '图片水印',
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TWatermark(
                  text: '仅供查看',
                  opacity: 0.15,
                  rotate: -30,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            TTheme.of(context).brandLightColor,
                            TTheme.of(context).brandFocusColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
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
              ),
            ),

            const SizedBox(height: 24),

            // 示例5: 列表上的水印
            _buildSection(
              context,
              '列表现水印',
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TWatermark(
                  text: '内部数据',
                  opacity: 0.08,
                  child: ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(12),
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
                                    '数据项 ${index + 1}',
                                    font: TTheme.of(context).fontBodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  TText(
                                    '这是第 ${index + 1} 条数据',
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
              ),
            ),

            const SizedBox(height: 24),

            // 示例6: 表单草稿状态
            _buildSection(
              context,
              '表单草稿标识',
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TWatermark(
                  text: '草稿',
                  opacity: 0.08,
                  textSize: 48,
                  fontWeight: FontWeight.bold,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TInput(
                          leftLabel: '标题',
                          hintText: '请输入标题',
                        ),
                        const SizedBox(height: 12),
                        TInput(
                          leftLabel: '内容',
                          hintText: '请输入内容',
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          text: '保存草稿',
                          theme: TButtonTheme.primary,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TText(
          title,
          font: TTheme.of(context).fontTitleMedium,
          textColor: TTheme.of(context).textColorPrimary,
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
}
