import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

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
      TPickerOption(label: '成都市', value: 'chengdu'),
      TPickerOption(label: '杭州市', value: 'hangzhou'),
    ],
  ]);
  static const _time = TPickerColumns([
    [
      TPickerOption(label: '2018年', value: 2018),
      TPickerOption(label: '2019年', value: 2019),
      TPickerOption(label: '2020年', value: 2020),
      TPickerOption(label: '2021年', value: 2021),
      TPickerOption(label: '2022年', value: 2022),
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
      label: '天津',
      value: 'tianjin',
      children: [
        TPickerOption(
          label: '天津',
          value: 'tianjin',
          children: [TPickerOption(label: '和平区', value: 'heping')],
        ),
      ],
    ),
    TPickerOption(
      label: '北京',
      value: 'beijing',
      children: [
        TPickerOption(
          label: '北京',
          value: 'beijing',
          children: [TPickerOption(label: '东城区', value: 'dongcheng')],
        ),
      ],
    ),
    TPickerOption(
      label: '广东',
      value: 'guangdong',
      children: [
        TPickerOption(
          label: '潮州',
          value: 'chaozhou',
          children: [TPickerOption(label: '湘桥区', value: 'xiangqiao')],
        ),
        TPickerOption(
          label: '东莞',
          value: 'dongguan',
          children: [TPickerOption(label: '东城街道', value: 'dongcheng')],
        ),
        TPickerOption(
          label: '深圳',
          value: 'shenzhen',
          children: [
            TPickerOption(label: '罗湖区', value: 'luohu'),
            TPickerOption(label: '南山区', value: 'nanshan'),
            TPickerOption(label: '福田区', value: 'futian'),
            TPickerOption(label: '宝安区', value: 'baoan'),
            TPickerOption(label: '龙岗区', value: 'longgang'),
          ],
        ),
        TPickerOption(
          label: '广州',
          value: 'guangzhou',
          children: [
            TPickerOption(label: '天河区', value: 'tianhe'),
            TPickerOption(label: '越秀区', value: 'yuexiu'),
          ],
        ),
        TPickerOption(
          label: '汕头',
          value: 'shantou',
          children: [TPickerOption(label: '金平区', value: 'jinping')],
        ),
      ],
    ),
    TPickerOption(
      label: '浙江',
      value: 'zhejiang',
      children: [
        TPickerOption(
          label: '杭州',
          value: 'hangzhou',
          children: [TPickerOption(label: '西湖区', value: 'xihu')],
        ),
      ],
    ),
    TPickerOption(
      label: '河北',
      value: 'hebei',
      children: [
        TPickerOption(
          label: '石家庄',
          value: 'shijiazhuang',
          children: [TPickerOption(label: '长安区', value: 'changan')],
        ),
      ],
    ),
  ]);

  final Map<String, List<Object?>> _values = {
    'city': const ['shenzhen'],
    'time': const [2020, 'autumn'],
    'area': const ['guangdong', 'shenzhen', 'futian'],
    'title': const ['shenzhen'],
    'without-title': const ['shenzhen'],
  };

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于一组预设数据中的选择。',
      exampleCodeGroup: 'picker',
      compactDemo: true,
      // Figma Demo 页面底色；深色模式继续使用当前主题。
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF6F6F6)
          : context.tTheme.bgColorPage,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础选择器', builder: _buildBase),
            ExampleItem(builder: _buildTime),
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
          labels.add(matches.first.label.replaceAll('年', ''));
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
    return labels
        .map((label) => label.replaceAll('省', '').replaceAll('市', ''))
        .join(' ');
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
        height:
            (Theme.of(context).extension<TPickerThemeData>()?.height ?? 200) +
            TPopupHeader.headerHeight,
        headerBuilder: (_, close) => TPopupHeader(
          cancelButton: TToolbarPressable(
            onTap: close,
            child: TText(
              '取消',
              font: context.tTheme.fontBodyLarge,
              textColor: context.tTheme.textColorSecondary,
            ),
          ),
          title: title == null
              ? null
              : TText(title, font: context.tTheme.fontTitleLarge),
          confirmButton: TToolbarPressable(
            onTap: () {
              setState(() => _values[id] = List<Object?>.of(draft));
              close();
            },
            child: TText(
              '确定',
              font: context.tTheme.fontBodyLarge,
              textColor: context.tTheme.brandNormalColor,
            ),
          ),
        ),
        child: StatefulBuilder(
          builder: (_, setPopupState) => TPicker(
            key: ValueKey('picker-$id-panel'),
            items: items,
            value: draft,
            onChanged: (value) => setPopupState(() => draft = value.values),
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
  Widget _buildBase(BuildContext context) =>
      TCellGroup(cells: [_cell('city', '选择地区', _cities, popupTitle: '选择地区')]);

  @ExampleCode(group: 'picker')
  Widget _buildTime(BuildContext context) =>
      TCellGroup(cells: [_cell('time', '选择时间', _time, popupTitle: '选择时间')]);

  @ExampleCode(group: 'picker')
  Widget _buildArea(BuildContext context) =>
      TCellGroup(cells: [_cell('area', '选择地区', _area, popupTitle: '选择地区')]);

  @ExampleCode(group: 'picker')
  Widget _buildTitle(BuildContext context) => Column(
    children: [
      TCellGroup(
        cells: [_cell('title', '带标题选择器', _cities, popupTitle: '选择地区')],
      ),
      SizedBox(height: context.tTheme.spacer16),
      TCellGroup(cells: [_cell('without-title', '无标题选择器', _cities)]),
    ],
  );
}
