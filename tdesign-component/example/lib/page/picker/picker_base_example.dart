import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'picker')
class PickerBaseExample extends StatefulWidget {
  const PickerBaseExample({super.key});

  @override
  State<PickerBaseExample> createState() => _PickerBaseExampleState();
}

class _PickerBaseExampleState extends State<PickerBaseExample> {
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

  /// 核心组合片段：放入调用方 Widget，导入 flutter/material.dart 和
  /// tdesign_flutter/tdesign_flutter.dart。数据与状态由调用方提供：
  /// value 是 State 持有的不可变列表，onConfirm 用 setState 保存新列表；
  /// 取消不调用 onConfirm，弹层内 onChanged 只更新草稿。
  ///
  /// 本页城市为 TPickerColumns，初始值 ['shenzhen']；时间为两列，
  /// 初始值 [2020, 'autumn']；地区为 TPickerLinked，初始值
  /// ['guangdong', 'shenzhen', 'futian']。带标题与无标题共用城市数据，
  /// popupTitle 分别传 '选择地区' 与 null。id 仅用于示例定位 Key。
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
      TPickerPopup.show(
        context,
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

  final Map<String, List<Object?>> _values = {
    'city': const ['shenzhen'],
    'time': const [2020, 'autumn'],
    'area': const ['guangdong', 'shenzhen', 'futian'],
    'title': const ['shenzhen'],
    'without-title': const ['shenzhen'],
  };

  @override
  Widget build(BuildContext context) {
    return _buildBase(context);
  }
}
