import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TDropdownMenuPage extends StatelessWidget {
  const TDropdownMenuPage({super.key});

  static const statusOptions = <TDropdownMenuOption<String>>[
    TDropdownMenuOption(value: 'all', label: '全部商品'),
    TDropdownMenuOption(value: 'selling', label: '在售'),
    TDropdownMenuOption(value: 'sold_out', label: '已售罄'),
  ];

  static const categoryOptions = <TDropdownMenuOption<String>>[
    TDropdownMenuOption(value: 'phone', label: '手机', group: '数码'),
    TDropdownMenuOption(value: 'computer', label: '电脑', group: '数码'),
    TDropdownMenuOption(value: 'audio', label: '影音', group: '数码'),
    TDropdownMenuOption(value: 'clothes', label: '服饰', group: '生活'),
    TDropdownMenuOption(value: 'food', label: '食品', group: '生活'),
    TDropdownMenuOption(
      value: 'limited',
      label: '限量',
      group: '生活',
      disabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于商品列表等页面的排序和多维筛选；表单选择请使用 Picker。',
      exampleCodeGroup: 'dropdown_menu',
      children: [
        ExampleModule(title: '真实筛选场景', children: [
          ExampleItem(desc: '商品排序与状态', builder: _sorting),
          ExampleItem(desc: '分类多选（确认后生效）', builder: _multiple),
          ExampleItem(desc: '自定义价格区间', builder: _customPanel),
        ]),
        ExampleModule(title: '布局与主题', children: [
          ExampleItem(desc: '横向滚动与禁用项', builder: _scrollable),
          ExampleItem(desc: '局部主题与自动方向', builder: _themed),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _sorting(BuildContext context) {
    var sort = 'default';
    var status = 'all';
    return StatefulBuilder(
      builder: (context, setState) {
        return TDropdownMenu(
          items: [
            TDropdownMenuItem(
              label: switch (sort) {
                'price_asc' => '价格升序',
                'sales' => '销量优先',
                _ => '默认排序',
              },
              panelBuilder: (context, controller) =>
                  TDropdownSingleSelectPanel<String>(
                controller: controller,
                value: sort,
                options: const [
                  TDropdownMenuOption(value: 'default', label: '默认排序'),
                  TDropdownMenuOption(value: 'price_asc', label: '价格从低到高'),
                  TDropdownMenuOption(value: 'sales', label: '销量优先'),
                ],
                onChanged: (value) => setState(() => sort = value),
              ),
            ),
            TDropdownMenuItem(
              label: status == 'all' ? '商品状态' : '已筛选状态',
              panelBuilder: (context, controller) =>
                  TDropdownSingleSelectPanel<String>(
                controller: controller,
                value: status,
                options: statusOptions,
                onChanged: (value) => setState(() => status = value),
              ),
            ),
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _multiple(BuildContext context) {
    var selected = <String>{'phone'};
    return StatefulBuilder(
      builder: (context, setState) {
        return TDropdownMenu(
          items: [
            TDropdownMenuItem(
              label: selected.isEmpty ? '全部分类' : '已选 ${selected.length} 项',
              panelBuilder: (context, controller) =>
                  TDropdownMultiSelectPanel<String>(
                controller: controller,
                options: categoryOptions,
                values: selected,
                columns: 3,
                onConfirm: (values) => setState(() => selected = values),
              ),
            ),
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _customPanel(BuildContext context) {
    var range = const RangeValues(100, 500);
    RangeValues? draft;
    return StatefulBuilder(
      builder: (context, setState) {
        return TDropdownMenu(
          onClosed: (_, __) => setState(() => draft = null),
          items: [
            TDropdownMenuItem(
              label: '¥${range.start.round()}–${range.end.round()}',
              panelBuilder: (context, controller) {
                draft ??= range;
                return StatefulBuilder(
                  builder: (context, setPanelState) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '价格区间：¥${draft!.start.round()}–${draft!.end.round()}',
                        ),
                        RangeSlider(
                          values: draft!,
                          min: 0,
                          max: 1000,
                          divisions: 20,
                          labels: RangeLabels(
                            '¥${draft!.start.round()}',
                            '¥${draft!.end.round()}',
                          ),
                          onChanged: (value) =>
                              setPanelState(() => draft = value),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TButton(
                                variant: TButtonVariant.outline,
                                child: const Text('取消'),
                                onPressed: () => controller.close(
                                  TDropdownMenuCloseReason.cancel,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TButton(
                                child: const Text('应用价格'),
                                onPressed: () {
                                  setState(() => range = draft!);
                                  controller.close(
                                    TDropdownMenuCloseReason.confirm,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _scrollable(BuildContext context) {
    return TDropdownMenu(
      scrollable: true,
      items: [
        for (final label in ['综合', '品牌', '发货地', '服务', '促销'])
          TDropdownMenuItem(
            label: label,
            width: 96,
            panelBuilder: (context, controller) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text('$label筛选内容'),
            ),
          ),
        TDropdownMenuItem(
          label: '暂不可用',
          width: 112,
          enabled: false,
          panelBuilder: (context, controller) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _themed(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        extensions: [
          ...theme.extensions.values.where(
            (extension) => extension is! TDropdownThemeData,
          ),
          const TDropdownThemeData(
            barHeight: 52,
            activeIconColor: Colors.deepOrange,
            activeTextStyle: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w600,
            ),
            selectedOptionColor: Color(0xFFFFE9DE),
          ),
        ],
      ),
      child: TDropdownMenu(
        placement: TDropdownMenuPlacement.auto,
        items: [
          TDropdownMenuItem(
            label: '主题筛选',
            panelBuilder: (context, controller) =>
                TDropdownSingleSelectPanel<String>(
              controller: controller,
              options: statusOptions,
              value: 'all',
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
