import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TCascader 演示。
class TCascaderPage extends StatefulWidget {
  const TCascaderPage({super.key});

  @override
  State<TCascaderPage> createState() => _TCascaderPageState();
}

class _TCascaderPageState extends State<TCascaderPage> {
  static const _options = [
    TCascaderOption(
      label: '北京市',
      value: 'beijing',
      children: [
        TCascaderOption(
          label: '北京市',
          value: 'beijing-city',
          children: [
            TCascaderOption(label: '东城区', value: 'dongcheng'),
            TCascaderOption(label: '西城区', value: 'xicheng'),
            TCascaderOption(label: '朝阳区', value: 'chaoyang'),
          ],
        ),
      ],
    ),
    TCascaderOption(
      label: '天津市',
      value: 'tianjin',
      children: [
        TCascaderOption(
          label: '天津市',
          value: 'tianjin-city',
          children: [
            TCascaderOption(label: '和平区', value: 'peace-district'),
            TCascaderOption(label: '蓟州区', value: 'jizhou'),
          ],
        ),
      ],
    ),
    TCascaderOption(
      label: '广东省',
      value: 'guangdong',
      children: [
        TCascaderOption(
          label: '深圳市',
          value: 'shenzhen',
          children: [
            TCascaderOption(label: '南山区', value: 'nanshan'),
            TCascaderOption(label: '福田区', value: 'futian'),
          ],
        ),
      ],
    ),
  ];

  static const _rawOptions = [
    _RawArea(
      name: '北京市',
      id: 'beijing',
      sub: [
        _RawArea(
          name: '北京市',
          id: 'beijing-city',
          sub: [_RawArea(name: '东城区', id: 'dongcheng')],
        ),
      ],
    ),
    _RawArea(
      name: '天津市',
      id: 'tianjin',
      sub: [
        _RawArea(
          name: '天津市',
          id: 'tianjin-city',
          sub: [_RawArea(name: '蓟州区', id: 'jizhou')],
        ),
      ],
    ),
  ];

  final Map<String, List<Object?>> _values = {
    'base': const [],
    'tab': const [],
    'initial': const ['tianjin', 'tianjin-city', 'jizhou'],
    'keys': const [],
    'subtitle': const [],
    'any': const [],
    'search': const [],
  };

  static List<TCascaderOption> get _mappedOptions => _rawOptions
      .map(
        (area) => TCascaderOption(
          label: area.name,
          value: area.id,
          children: area.sub
              .map(
                (city) => TCascaderOption(
                  label: city.name,
                  value: city.id,
                  children: city.sub
                      .map(
                        (district) => TCascaderOption(
                          label: district.name,
                          value: district.id,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于多层级数据的逐级选择。',
      exampleCodeGroup: 'cascader',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '类型',
          children: [
            ExampleItem(builder: _buildBase, methodName: '_cell'),
            ExampleItem(desc: '选项卡风格', builder: _buildTab, methodName: '_cell'),
          ],
        ),
        ExampleModule(
          title: '进阶',
          children: [
            ExampleItem(
              desc: '带初始值',
              builder: _buildInitial,
              methodName: '_cell',
            ),
            ExampleItem(
              desc: '自定义 keys',
              builder: _buildKeys,
              methodName: '_cell',
            ),
            ExampleItem(
              desc: '使用次级标题',
              builder: _buildSubtitle,
              methodName: '_cell',
            ),
            ExampleItem(
              desc: '选择任意一项',
              builder: _buildAny,
              methodName: '_cell',
            ),
            ExampleItem(
              desc: '支持搜索',
              builder: _buildSearch,
              methodName: '_cell',
            ),
          ],
        ),
      ],
    );
  }

  /// 核心组合片段：放入调用方 StatefulWidget，导入 flutter/material.dart 和
  /// tdesign_flutter/tdesign_flutter.dart。value 是父级持有的已提交路径，
  /// onChanged 用 setState 保存新路径；TCascader 本身保持平铺和严格受控。
  ///
  /// 默认数据覆盖省/市/区三级；自定义字段先转换为 TCascaderOption 再传
  /// sourceOptions。基础、tab、初始值、字段映射和次级标题在末级选择后提交并关闭；
  /// allowIntermediateSelection 仅用于“选择任意一项”，关闭按钮提交当前草稿；
  /// searchable 在 Popup 组合层提供搜索，命中末级后直接提交并关闭。
  ///
  /// 七个公开示例通过同一受控组合传入各自配置：基础示例使用默认 step；
  /// 选项卡传 `variant: TCascaderVariant.tab`；初始值由父级 `_values` 提供；
  /// 自定义 keys 先转换后传 `sourceOptions: _mappedOptions`；次级标题传
  /// `subtitles`；任意层选择传 `allowIntermediateSelection: true`；搜索传
  /// `searchable: true`。每个实例都通过
  /// `onChanged: (next) => setState(() => _values[id] = next)` 回写受控值。
  @ExampleCode(group: 'cascader')
  TCell _cell(
    BuildContext context,
    String id, {
    required List<Object?> value,
    required ValueChanged<List<Object?>> onChanged,
    List<TCascaderOption>? sourceOptions,
    TCascaderVariant variant = TCascaderVariant.step,
    List<String> subtitles = const [],
    bool allowIntermediateSelection = false,
    bool searchable = false,
  }) {
    const defaultOptions = [
      TCascaderOption(
        label: '北京市',
        value: 'beijing',
        children: [
          TCascaderOption(
            label: '北京市',
            value: 'beijing-city',
            children: [
              TCascaderOption(label: '东城区', value: 'dongcheng'),
              TCascaderOption(label: '西城区', value: 'xicheng'),
            ],
          ),
        ],
      ),
      TCascaderOption(
        label: '广东省',
        value: 'guangdong',
        children: [
          TCascaderOption(
            label: '深圳市',
            value: 'shenzhen',
            children: [
              TCascaderOption(label: '南山区', value: 'nanshan'),
              TCascaderOption(label: '福田区', value: 'futian'),
            ],
          ),
        ],
      ),
    ];
    final options = sourceOptions ?? defaultOptions;

    List<String> labelsFor(List<Object?> selectedValue) {
      final labels = <String>[];
      var current = options;
      for (final item in selectedValue) {
        final index = current.indexWhere((option) => option.value == item);
        if (index < 0) {
          break;
        }
        labels.add(current[index].label);
        current = current[index].children;
      }
      return labels;
    }

    bool isComplete(List<Object?> selectedValue) {
      var current = options;
      for (var index = 0; index < selectedValue.length; index++) {
        final matches = current.where(
          (option) => option.value == selectedValue[index],
        );
        if (matches.isEmpty) {
          return false;
        }
        final option = matches.first;
        if (index == selectedValue.length - 1) {
          return option.children.isEmpty;
        }
        current = option.children;
      }
      return false;
    }

    List<({List<Object?> values, List<String> labels})> paths(
      List<TCascaderOption> current, [
      List<Object?> values = const [],
      List<String> labels = const [],
    ]) {
      final result = <({List<Object?> values, List<String> labels})>[];
      for (final option in current) {
        final nextValues = [...values, option.value];
        final nextLabels = [...labels, option.label];
        if (option.children.isEmpty) {
          result.add((values: nextValues, labels: nextLabels));
        } else {
          result.addAll(paths(option.children, nextValues, nextLabels));
        }
      }
      return result;
    }

    void showCascader() {
      var draft = List<Object?>.of(value);
      var query = '';
      late VoidCallback closePopup;
      TPopup.show(
        context,
        options: TPopupOptions.bottom(
          height: MediaQuery.sizeOf(context).height * 0.85,
          headerBuilder: (_, close) {
            closePopup = close;
            return TPopupHeader(
              title: const TText('请选择地址'),
              confirmButton: TToolbarPressable(
                onTap: () {
                  if (allowIntermediateSelection) {
                    onChanged(List<Object?>.unmodifiable(draft));
                  }
                  close();
                },
                child: TIcon(
                  TIcons.close,
                  size: 24,
                  color: context.tTheme.textColorPrimary,
                ),
              ),
            );
          },
          child: StatefulBuilder(
            builder: (context, setPopupState) {
              final matches = searchable && query.isNotEmpty
                  ? paths(options)
                        .where((path) => path.labels.join().contains(query))
                        .toList()
                  : const <({List<Object?> values, List<String> labels})>[];
              return Column(
                children: [
                  if (searchable)
                    Padding(
                      padding: EdgeInsets.all(context.tTheme.spacer16),
                      child: TSearchBar(
                        key: const ValueKey('cascader-search-field'),
                        hintText: '搜索省/市/区',
                        onChanged: (value) =>
                            setPopupState(() => query = value.trim()),
                      ),
                    ),
                  Expanded(
                    child: query.isNotEmpty
                        ? ListView(
                            children: [
                              for (final path in matches)
                                TCell(
                                  title: TText(path.labels.join(' / ')),
                                  onTap: () {
                                    onChanged(
                                      List<Object?>.unmodifiable(path.values),
                                    );
                                    closePopup();
                                  },
                                ),
                              if (matches.isEmpty)
                                const Center(child: TText('暂无数据')),
                            ],
                          )
                        : TCascader(
                            key: const ValueKey('cascader-popup-panel'),
                            options: options,
                            value: draft,
                            variant: variant,
                            subtitles: subtitles,
                            onChanged: (next) {
                              setPopupState(
                                () => draft = List<Object?>.of(next),
                              );
                              if (!allowIntermediateSelection &&
                                  isComplete(next)) {
                                onChanged(List<Object?>.unmodifiable(next));
                                closePopup();
                              }
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    final labels = labelsFor(value);
    return TCell(
      key: ValueKey('cascader-$id-trigger'),
      title: const TText('地址'),
      note: TText(labels.isEmpty ? '请选择地址' : labels.join('/')),
      arrow: true,
      onTap: showCascader,
    );
  }

  Widget _trigger(
    BuildContext context,
    String id, {
    List<TCascaderOption>? options,
    TCascaderVariant variant = TCascaderVariant.step,
    List<String> subtitles = const [],
    bool allowIntermediateSelection = false,
    bool searchable = false,
  }) {
    return TCellGroup(
      cells: [
        _cell(
          context,
          id,
          value: _values[id] ?? const [],
          onChanged: (next) => setState(() => _values[id] = next),
          sourceOptions: options ?? _options,
          variant: variant,
          subtitles: subtitles,
          allowIntermediateSelection: allowIntermediateSelection,
          searchable: searchable,
        ),
      ],
    );
  }

  Widget _buildBase(BuildContext context) => _trigger(context, 'base');

  Widget _buildTab(BuildContext context) =>
      _trigger(context, 'tab', variant: TCascaderVariant.tab);

  Widget _buildInitial(BuildContext context) => _trigger(context, 'initial');

  Widget _buildKeys(BuildContext context) =>
      _trigger(context, 'keys', options: _mappedOptions);

  Widget _buildSubtitle(BuildContext context) => _trigger(
    context,
    'subtitle',
    subtitles: const ['请选择省份', '请选择城市', '请选择区/县'],
  );

  Widget _buildAny(BuildContext context) =>
      _trigger(context, 'any', allowIntermediateSelection: true);

  Widget _buildSearch(BuildContext context) =>
      _trigger(context, 'search', searchable: true);
}

class _RawArea {
  const _RawArea({required this.name, required this.id, this.sub = const []});

  final String name;
  final String id;
  final List<_RawArea> sub;
}
