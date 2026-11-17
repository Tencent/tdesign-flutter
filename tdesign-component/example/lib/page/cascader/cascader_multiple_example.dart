import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

/// 多选级联：叶子选项带勾选框，可在多个分支间累积选择。
@ExampleCode(group: 'cascader', includes: [])
class CascaderMultipleExample extends StatelessWidget {
  const CascaderMultipleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CascaderMultipleExample();
  }
}

class _CascaderMultipleExample extends StatefulWidget {
  const _CascaderMultipleExample();

  @override
  State<_CascaderMultipleExample> createState() => _CascaderMultipleExampleState();
}

class _CascaderMultipleExampleState extends State<_CascaderMultipleExample> {
  static const _options = [
    TCascaderOption(
      label: '广东',
      value: 'guangdong',
      children: [
        TCascaderOption(
          label: '深圳',
          value: 'shenzhen',
          children: [
            TCascaderOption(label: '南山区', value: 'nanshan'),
            TCascaderOption(label: '福田区', value: 'futian'),
          ],
        ),
        TCascaderOption(
          label: '广州',
          value: 'guangzhou',
          children: [
            TCascaderOption(label: '天河区', value: 'tianhe'),
            TCascaderOption(label: '越秀区', value: 'yuexiu'),
          ],
        ),
      ],
    ),
    TCascaderOption(
      label: '浙江',
      value: 'zhejiang',
      children: [
        TCascaderOption(
          label: '杭州',
          value: 'hangzhou',
          children: [
            TCascaderOption(label: '西湖区', value: 'xihu'),
            TCascaderOption(label: '余杭区', value: 'yuhang'),
          ],
        ),
      ],
    ),
  ];

  static const _subtitles = ['请选择省份', '请选择城市', '勾选目标区域'];

  List<Object?> _navigationValue = const [];
  List<List<Object?>> _multipleValue = const [];

  static List<String> _labelsFor(List<List<Object?>> paths) {
    final labels = <String>[];
    for (final path in paths) {
      final pathLabels = <String>[];
      var current = _options;
      for (final value in path) {
        final index = current.indexWhere((option) => option.value == value);
        if (index < 0) {
          break;
        }
        pathLabels.add(current[index].label);
        current = current[index].children;
      }
      if (pathLabels.isNotEmpty) {
        labels.add(pathLabels.join('/'));
      }
    }
    return labels;
  }

  void _showCascader() {
    var navigationValue = List<Object?>.of(_navigationValue);
    var multipleValue = List<List<Object?>>.of(_multipleValue);
    final handle = TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: 580,
        headerBuilder: (_, close) => TPopupHeader(
          title: const TText('多选地区'),
          confirmButton: TToolbarPressable(
            onTap: close,
            child: TText(
              '完成',
              style: TextStyle(color: context.tTheme.brandColor),
            ),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setPopupState) => TCascader(
            key: const ValueKey('cascader-multiple-popup-panel'),
            options: _options,
            value: navigationValue,
            multiple: true,
            multipleValue: multipleValue,
            subtitles: _subtitles,
            onChanged: (next) =>
                setPopupState(() => navigationValue = List<Object?>.of(next)),
            onMultipleChanged: (next) => setPopupState(
              () => multipleValue = [
                for (final path in next) List<Object?>.of(path),
              ],
            ),
          ),
        ),
      ),
    );
    handle.result.then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _navigationValue = List<Object?>.unmodifiable(navigationValue);
        _multipleValue = List<List<Object?>>.unmodifiable([
          for (final path in multipleValue) List<Object?>.unmodifiable(path),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = _labelsFor(_multipleValue);
    return TCellGroup(
      cells: [
        TCell(
          key: const ValueKey('cascader-multiple-trigger'),
          title: const TText('多选地区'),
          note: TText(
            labels.isEmpty ? '已选 ${labels.length} 项' : labels.join('、'),
          ),
          arrow: true,
          onTap: _showCascader,
        ),
      ],
    );
  }
}
