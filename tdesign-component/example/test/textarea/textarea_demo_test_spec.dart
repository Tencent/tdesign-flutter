import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/textarea/textarea_page.dart';

import '../demo_page_test_utils.dart';

enum TextareaGoldenPolicy { page, postAction }

class TextareaPublicScenario {
  const TextareaPublicScenario({
    required this.id,
    required this.module,
    required this.description,
    required this.hintText,
    required this.layout,
    required this.enabled,
    required this.minLines,
    required this.indicator,
    required this.bordered,
    required this.goldenPolicy,
    this.label,
    this.initialValue,
    this.maxLength,
    this.maxCharacter,
    this.postActionText,
  }) : assert(
         (goldenPolicy == TextareaGoldenPolicy.postAction) ==
             (postActionText != null),
       );

  final String id;
  final String module;
  final String description;
  final String? label;
  final String hintText;
  final TTextareaLayout layout;
  final bool enabled;
  final int? minLines;
  final String? initialValue;
  final int? maxLength;
  final int? maxCharacter;
  final bool indicator;
  final bool bordered;
  final TextareaGoldenPolicy goldenPolicy;
  final String? postActionText;
}

const textareaPublicScenarios = [
  TextareaPublicScenario(
    id: 'basic',
    module: '组件类型',
    description: '基础多行文本框',
    hintText: '请输入文字',
    layout: TTextareaLayout.horizontal,
    enabled: true,
    minLines: null,
    indicator: false,
    bordered: false,
    goldenPolicy: TextareaGoldenPolicy.postAction,
    postActionText: '基础输入',
  ),
  TextareaPublicScenario(
    id: 'label',
    module: '组件类型',
    description: '带标题多行文本框',
    label: '标签文字',
    hintText: '请输入文字',
    layout: TTextareaLayout.horizontal,
    enabled: true,
    minLines: 2,
    indicator: false,
    bordered: false,
    goldenPolicy: TextareaGoldenPolicy.postAction,
    postActionText: '标题输入',
  ),
  TextareaPublicScenario(
    id: 'autosize',
    module: '组件类型',
    description: '自动增高多行文本框',
    label: '标签文字',
    hintText: '请输入文字',
    layout: TTextareaLayout.horizontal,
    enabled: true,
    minLines: 1,
    indicator: false,
    bordered: false,
    goldenPolicy: TextareaGoldenPolicy.postAction,
    postActionText: '第一行\n第二行\n第三行',
  ),
  TextareaPublicScenario(
    id: 'max_length',
    module: '组件类型',
    description: '设置字符数限制',
    label: '标签文字',
    hintText: '请输入文字',
    layout: TTextareaLayout.horizontal,
    enabled: true,
    minLines: 2,
    maxLength: 500,
    indicator: true,
    bordered: false,
    goldenPolicy: TextareaGoldenPolicy.postAction,
    postActionText: 'length',
  ),
  TextareaPublicScenario(
    id: 'disabled',
    module: '组件状态',
    description: '禁用状态',
    label: '标签文字',
    hintText: '请输入文字',
    layout: TTextareaLayout.horizontal,
    enabled: false,
    minLines: 2,
    initialValue: '不可编辑文字',
    indicator: false,
    bordered: false,
    goldenPolicy: TextareaGoldenPolicy.page,
  ),
  TextareaPublicScenario(
    id: 'vertical',
    module: '组件样式',
    description: '竖排样式',
    label: '标签文字',
    hintText: '预设长文本预设长文本',
    layout: TTextareaLayout.vertical,
    enabled: true,
    minLines: 2,
    maxLength: 500,
    indicator: true,
    bordered: false,
    goldenPolicy: TextareaGoldenPolicy.postAction,
    postActionText: '竖排输入',
  ),
  TextareaPublicScenario(
    id: 'card',
    module: '组件样式',
    description: '卡片样式',
    label: '标签文字',
    hintText: '请输入文字',
    layout: TTextareaLayout.horizontal,
    enabled: true,
    minLines: 2,
    maxLength: 500,
    indicator: true,
    bordered: false,
    goldenPolicy: TextareaGoldenPolicy.postAction,
    postActionText: 'card',
  ),
  TextareaPublicScenario(
    id: 'custom',
    module: '特殊样式',
    description: '标签外置输入框',
    hintText: '请输入文字',
    layout: TTextareaLayout.horizontal,
    enabled: true,
    minLines: 2,
    maxLength: 100,
    indicator: true,
    bordered: true,
    goldenPolicy: TextareaGoldenPolicy.postAction,
    postActionText: 'custom',
  ),
];

final textareaDemoPageTestSpec = DemoPageTestSpec(
  name: 'textarea',
  title: 'Textarea 多行文本框',
  page: const TTextareaPage(),
  expectedTexts: [
    '01 组件类型',
    '02 组件状态',
    '03 组件样式',
    '04 特殊样式',
    ...textareaPublicScenarios.map((scenario) => scenario.description),
  ],
  componentType: TTextarea,
  expectedComponentCount: textareaPublicScenarios.length,
);
