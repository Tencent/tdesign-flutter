import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'textarea_type.dart';
part 'textarea_status.dart';
part 'textarea_style.dart';
part 'textarea_special.dart';

/// TTextarea 示例页。
class TTextareaPage extends StatelessWidget {
  const TTextareaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'textarea',
      desc: '用于多行文本信息输入。',
      compactDemo: true,
      showTestModule: false,
      children: [
        _textareaTypeModule,
        _textareaStatusModule,
        _textareaStyleModule,
        _textareaSpecialModule,
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'textarea')
  Widget _buildBasic(BuildContext context) =>
      const SizedBox(height: 128, child: TTextarea(hintText: '请输入文字'));

  @ExampleCode(group: 'textarea')
  Widget _buildLabel(BuildContext context) => const SizedBox(
    height: 128,
    child: TTextarea(label: '标签文字', hintText: '请输入文字', minLines: 2),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildAutosize(BuildContext context) =>
      const TTextarea(label: '标签文字', hintText: '请输入文字', minLines: 1);

  @ExampleCode(group: 'textarea')
  Widget _buildMaxLength(BuildContext context) => const SizedBox(
    height: 162,
    child: TTextarea(
      label: '标签文字',
      hintText: '设置最大字符个数',
      minLines: 3,
      maxLength: 200,
      indicator: true,
    ),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildDisabled(BuildContext context) => const SizedBox(
    height: 128,
    child: TTextarea(
      label: '标签文字',
      hintText: '请输入文字',
      initialValue: '不可编辑文字',
      enabled: false,
      minLines: 2,
    ),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildVertical(BuildContext context) => const SizedBox(
    height: 128,
    child: TTextarea(
      label: '标签文字',
      hintText: '请输入文字',
      layout: TTextareaLayout.vertical,
      minLines: 2,
    ),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildCard(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TInputThemeData(borderRadius: 9)),
      child: const SizedBox(
        height: 156,
        child: TTextarea(
          label: '标签文字',
          hintText: '请输入文字',
          layout: TTextareaLayout.vertical,
          minLines: 2,
          maxLength: 500,
          indicator: true,
        ),
      ),
    ),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildCustom(BuildContext context) => Theme(
    data: Theme.of(context)
        .mergeExtension(
          TFormThemeData(
            layout: TFormLayout.vertical,
            backgroundColor: context.tTheme.bgColorSecondaryContainer,
            borderColor: Colors.transparent,
            itemPadding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            labelGap: context.tTheme.spacer8,
            labelStyle: TextStyle(
              fontSize: context.tTheme.fontBodySmall?.size,
              height: context.tTheme.fontBodySmall?.height,
              fontWeight: context.tTheme.fontBodySmall?.fontWeight,
            ),
          ),
        )
        .mergeExtension(
          const TInputThemeData(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
    child: const TFormItem(
      label: '标签文字',
      child: SizedBox(
        height: 124,
        child: TTextarea(
          hintText: '请输入文字',
          bordered: true,
          minLines: 2,
          maxLength: 100,
          indicator: true,
        ),
      ),
    ),
  );
}
