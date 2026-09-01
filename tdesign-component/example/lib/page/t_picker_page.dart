import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

class TPickerPage extends StatefulWidget {
  const TPickerPage({super.key});

  @override
  State<TPickerPage> createState() => _TPickerPageState();
}

class _TPickerPageState extends State<TPickerPage> {
  static const _cities = TPickerColumns([
    [
      TPickerOption(label: '北京市', value: 'beijing'),
      TPickerOption(label: '上海市', value: 'shanghai'),
      TPickerOption(label: '广州市', value: 'guangzhou'),
      TPickerOption(label: '深圳市', value: 'shenzhen'),
    ],
  ]);
  static const _time = TPickerColumns([
    [
      TPickerOption(label: '2025年', value: 2025),
      TPickerOption(label: '2026年', value: 2026),
      TPickerOption(label: '2027年', value: 2027),
    ],
    [
      TPickerOption(label: '春', value: 'spring'),
      TPickerOption(label: '夏', value: 'summer'),
      TPickerOption(label: '秋', value: 'autumn'),
      TPickerOption(label: '冬', value: 'winter'),
    ],
  ]);
  static const _area = TPickerLinked([
    TPickerOption(
      label: '广东省',
      value: 'guangdong',
      children: [
        TPickerOption(
          label: '深圳市',
          value: 'shenzhen',
          children: [
            TPickerOption(label: '南山区', value: 'nanshan'),
            TPickerOption(label: '福田区', value: 'futian'),
          ],
        ),
        TPickerOption(
          label: '广州市',
          value: 'guangzhou',
          children: [
            TPickerOption(label: '天河区', value: 'tianhe'),
            TPickerOption(label: '越秀区', value: 'yuexiu'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '浙江省',
      value: 'zhejiang',
      children: [
        TPickerOption(
          label: '杭州市',
          value: 'hangzhou',
          children: [TPickerOption(label: '西湖区', value: 'xihu')],
        ),
      ],
    ),
  ]);

  final Map<String, List<Object?>> _values = {
    'city': const ['beijing'],
    'time': const [2026, 'spring'],
    'area': const ['guangdong', 'shenzhen', 'nanshan'],
    'title': const ['beijing'],
    'without-title': const ['shanghai'],
  };

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于一组预设数据中的选择。',
      exampleCodeGroup: 'picker',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础选择器', builder: _buildBase),
            ExampleItem(builder: _buildArea),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [ExampleItem(desc: '是否带标题', builder: _buildTitle)],
        ),
      ],
    );
  }

  String _label(TPickerItems items, List<Object?> values) {
    if (items is TPickerColumns) {
      final labels = <String>[];
      for (var index = 0; index < items.columns.length; index++) {
        if (index >= values.length) {
          break;
        }
        final matches = items.columns[index].where(
          (option) => option.value == values[index],
        );
        if (matches.isNotEmpty) {
          labels.add(matches.first.label);
        }
      }
      return labels.join(' ');
    }
    var options = (items as TPickerLinked).options;
    final labels = <String>[];
    for (final value in values) {
      final matches = options.where((option) => option.value == value);
      if (matches.isEmpty) {
        break;
      }
      labels.add(matches.first.label);
      options = matches.first.children;
    }
    return labels.join(' / ');
  }

  void _showPicker({
    required String id,
    required TPickerItems items,
    String? title,
  }) {
    var draft = List<Object?>.of(_values[id] ?? const []);
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        headerBuilder: (_, close) => TPopupHeader(
          cancelButton: TToolbarPressable(
            onTap: close,
            child: const TText('取消'),
          ),
          title: title == null ? null : TText(title),
          confirmButton: TToolbarPressable(
            onTap: () {
              setState(() => _values[id] = List<Object?>.of(draft));
              close();
            },
            child: const TText('确定'),
          ),
        ),
        child: Material(
          color: context.tTheme.bgColorContainer,
          child: StatefulBuilder(
            builder: (_, setPopupState) => TPicker(
              key: ValueKey('picker-$id-panel'),
              items: items,
              value: draft,
              onChanged: (value) => setPopupState(() => draft = value.values),
            ),
          ),
        ),
      ),
    );
  }

  TCell _cell(
    String id,
    String title,
    TPickerItems items, {
    String? popupTitle,
  }) {
    return TCell(
      key: ValueKey('picker-$id-trigger'),
      title: TText(title),
      note: TText(_label(items, _values[id] ?? const [])),
      arrow: true,
      onTap: () => _showPicker(id: id, items: items, title: popupTitle),
    );
  }

  @ExampleCode(group: 'picker')
  Widget _buildBase(BuildContext context) => TCellGroup(
    cells: [
      _cell('city', '选择城市', _cities, popupTitle: '选择城市'),
      _cell('time', '选择时间', _time, popupTitle: '选择时间'),
    ],
  );

  @ExampleCode(group: 'picker')
  Widget _buildArea(BuildContext context) =>
      TCellGroup(cells: [_cell('area', '选择地区', _area, popupTitle: '选择地区')]);

  @ExampleCode(group: 'picker')
  Widget _buildTitle(BuildContext context) => TCellGroup(
    cells: [
      _cell('title', '带标题选择器', _cities, popupTitle: '选择城市'),
      _cell('without-title', '无标题选择器', _cities),
    ],
  );
}
