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
            TCascaderOption(label: '和平区', value: 'heping'),
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
            ExampleItem(builder: _buildBase),
            ExampleItem(desc: '选项卡风格', builder: _buildTab),
          ],
        ),
        ExampleModule(
          title: '进阶',
          children: [
            ExampleItem(desc: '带初始值', builder: _buildInitial),
            ExampleItem(desc: '自定义 keys', builder: _buildKeys),
            ExampleItem(desc: '使用次级标题', builder: _buildSubtitle),
            ExampleItem(desc: '选择任意一项', builder: _buildAny),
            ExampleItem(desc: '支持搜索', builder: _buildSearch),
          ],
        ),
      ],
    );
  }

  List<String> _labels(List<TCascaderOption> options, List<Object?> value) {
    final labels = <String>[];
    var current = options;
    for (final item in value) {
      final index = current.indexWhere((option) => option.value == item);
      if (index < 0) {
        break;
      }
      labels.add(current[index].label);
      current = current[index].children;
    }
    return labels;
  }

  List<_CascaderPath> _paths(
    List<TCascaderOption> options, [
    List<Object?> values = const [],
    List<String> labels = const [],
  ]) {
    final result = <_CascaderPath>[];
    for (final option in options) {
      final nextValues = [...values, option.value];
      final nextLabels = [...labels, option.label];
      if (option.children.isEmpty) {
        result.add(_CascaderPath(nextValues, nextLabels));
      } else {
        result.addAll(_paths(option.children, nextValues, nextLabels));
      }
    }
    return result;
  }

  void _showCascader({
    required String id,
    List<TCascaderOption> options = _options,
    TCascaderVariant variant = TCascaderVariant.step,
    List<String> subtitles = const [],
    bool searchable = false,
  }) {
    var draft = List<Object?>.of(_values[id] ?? const []);
    var query = '';
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: MediaQuery.sizeOf(context).height * 0.7,
        headerBuilder: (_, close) => TPopupHeader(
          cancelButton: TToolbarPressable(
            onTap: close,
            child: const TText('取消'),
          ),
          title: const TText('请选择地址'),
          confirmButton: TToolbarPressable(
            onTap: () {
              setState(() => _values[id] = List<Object?>.of(draft));
              close();
            },
            child: const TText('确定'),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setPopupState) {
            final level = subtitles.isEmpty
                ? 0
                : draft.length >= subtitles.length
                ? subtitles.length - 1
                : draft.length;
            final matches = searchable && query.isNotEmpty
                ? _paths(
                    options,
                  ).where((path) => path.labels.join().contains(query)).toList()
                : const <_CascaderPath>[];
            return Material(
              color: Colors.transparent,
              child: Column(
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
                  if (subtitles.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.tTheme.spacer16,
                        vertical: context.tTheme.spacer8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TText(
                          subtitles[level],
                          key: const ValueKey('cascader-level-subtitle'),
                        ),
                      ),
                    ),
                  Expanded(
                    child: query.isNotEmpty
                        ? ListView(
                            children: [
                              for (final path in matches)
                                TCell(
                                  title: TText(path.labels.join(' / ')),
                                  onTap: () => setPopupState(() {
                                    draft = List<Object?>.of(path.values);
                                    query = '';
                                  }),
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
                            onChanged: (value) =>
                                setPopupState(() => draft = value),
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

  Widget _trigger(
    String id, {
    List<TCascaderOption> options = _options,
    TCascaderVariant variant = TCascaderVariant.step,
    List<String> subtitles = const [],
    bool searchable = false,
  }) {
    final labels = _labels(options, _values[id] ?? const []);
    return TCellGroup(
      cells: [
        TCell(
          key: ValueKey('cascader-$id-trigger'),
          title: const TText('地址'),
          note: TText(labels.isEmpty ? '请选择地址' : labels.join('/')),
          arrow: true,
          onTap: () => _showCascader(
            id: id,
            options: options,
            variant: variant,
            subtitles: subtitles,
            searchable: searchable,
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildBase(BuildContext context) => _trigger('base');

  @ExampleCode(group: 'cascader')
  Widget _buildTab(BuildContext context) =>
      _trigger('tab', variant: TCascaderVariant.tab);

  @ExampleCode(group: 'cascader')
  Widget _buildInitial(BuildContext context) => _trigger('initial');

  @ExampleCode(group: 'cascader')
  Widget _buildKeys(BuildContext context) =>
      _trigger('keys', options: _mappedOptions);

  @ExampleCode(group: 'cascader')
  Widget _buildSubtitle(BuildContext context) =>
      _trigger('subtitle', subtitles: const ['请选择省份', '请选择城市', '请选择区/县']);

  @ExampleCode(group: 'cascader')
  Widget _buildAny(BuildContext context) => _trigger('any');

  @ExampleCode(group: 'cascader')
  Widget _buildSearch(BuildContext context) =>
      _trigger('search', searchable: true);
}

class _RawArea {
  const _RawArea({required this.name, required this.id, this.sub = const []});

  final String name;
  final String id;
  final List<_RawArea> sub;
}

class _CascaderPath {
  const _CascaderPath(this.values, this.labels);

  final List<Object?> values;
  final List<String> labels;
}
