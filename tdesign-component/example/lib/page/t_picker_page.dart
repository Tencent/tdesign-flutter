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
            ExampleItem(
              desc: '基础选择器',
              builder: _buildBase,
              methodName: '_cell',
            ),
            ExampleItem(builder: _buildTime, methodName: '_cell'),
            ExampleItem(builder: _buildArea, methodName: '_cell'),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '是否带标题',
              builder: _buildTitle,
              methodName: '_cell',
            ),
          ],
        ),
      ],
    );
  }

  /// 核心组合片段：放入调用方 Widget，导入 flutter/material.dart 和
  /// tdesign_flutter/tdesign_flutter.dart。数据与状态由调用方提供：
  /// value 是 State 持有的不可变列表，onConfirm 用 setState 保存新列表；
  /// 取消不调用 onConfirm，弹层内 onChanged 只更新草稿。
  ///
  /// 本页城市为 TPickerColumns，初始值 ['shenzhen']；时间为两列，
  /// 初始值 [2020, 'autumn']；地区为 TPickerLinked，初始值
  /// ['guangdong', 'shenzhen', 'futian']。带标题与无标题共用城市数据，
  /// popupTitle 分别传 '选择地区' 与 null。id 仅用于示例定位 Key。
  @ExampleCode(group: 'picker')
  TCell _cell(
    BuildContext context,
    String id,
    String title,
    TPickerItems items, {
    required List<Object?> value,
    required ValueChanged<List<Object?>> onConfirm,
    String? popupTitle,
  }) {
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
      required BuildContext context,
      required TPickerItems items,
      required List<Object?> value,
      required ValueChanged<List<Object?>> onConfirm,
      Key? pickerKey,
      String? title,
    }) {
      var draft = List<Object?>.of(value);
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
                onConfirm(List<Object?>.of(draft));
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
              key: pickerKey,
              items: items,
              value: draft,
              onChanged: (value) => setPopupState(() => draft = value.values),
            ),
          ),
        ),
      );
    }

    return TCell(
      key: ValueKey('picker-$id-trigger'),
      title: TText(title),
      note: TText(_label(items, value)),
      arrow: true,
      onTap: () => _showPicker(
        context: context,
        items: items,
        value: value,
        onConfirm: onConfirm,
        pickerKey: ValueKey('picker-$id-panel'),
        title: popupTitle,
      ),
    );
  }

  Widget _buildBase(BuildContext context) => TCellGroup(
    cells: [
      _cell(
        this.context,
        'city',
        '选择地区',
        _cities,
        value: _values['city']!,
        onConfirm: (value) => setState(() => _values['city'] = value),
        popupTitle: '选择地区',
      ),
    ],
  );

  Widget _buildTime(BuildContext context) => TCellGroup(
    cells: [
      _cell(
        this.context,
        'time',
        '选择时间',
        _time,
        value: _values['time']!,
        onConfirm: (value) => setState(() => _values['time'] = value),
        popupTitle: '选择时间',
      ),
    ],
  );

  Widget _buildArea(BuildContext context) => TCellGroup(
    cells: [
      _cell(
        this.context,
        'area',
        '选择地区',
        _area,
        value: _values['area']!,
        onConfirm: (value) => setState(() => _values['area'] = value),
        popupTitle: '选择地区',
      ),
    ],
  );

  Widget _buildTitle(BuildContext context) => Column(
    children: [
      TCellGroup(
        cells: [
          _cell(
            this.context,
            'title',
            '带标题选择器',
            _cities,
            value: _values['title']!,
            onConfirm: (value) => setState(() => _values['title'] = value),
            popupTitle: '选择地区',
          ),
        ],
      ),
      SizedBox(height: context.tTheme.spacer16),
      TCellGroup(
        cells: [
          _cell(
            this.context,
            'without-title',
            '无标题选择器',
            _cities,
            value: _values['without-title']!,
            onConfirm: (value) =>
                setState(() => _values['without-title'] = value),
          ),
        ],
      ),
    ],
  );
}
