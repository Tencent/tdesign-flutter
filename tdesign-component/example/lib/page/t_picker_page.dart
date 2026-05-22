import 'package:flutter/material.dart';

import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TPickerPage extends StatefulWidget {
  const TPickerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TPickerPageState();
}

class _TPickerPageState extends State<TPickerPage> {
  // ========== 数据定义 ==========

  final cityItems = const TPickerColumns([
    [
      TPickerOption(label: '广州市', value: 'GZ'),
      TPickerOption(label: '韶关市', value: 'SG'),
      TPickerOption(label: '深圳市', value: 'SZ'),
      TPickerOption(label: '珠海市', value: 'ZH'),
      TPickerOption(label: '汕头市', value: 'ST'),
      TPickerOption(label: '佛山市', value: 'FS'),
      TPickerOption(label: '东莞市', value: 'DG'),
      TPickerOption(label: '惠州市', value: 'HZ'),
    ],
  ]);

  String selectedCity = '广州市';

  // ========== 时分秒数据 ==========

  final timeItems = TPickerColumns([
    [
      for (int i = 0; i < 24; i++)
        TPickerOption(label: '${i.toString().padLeft(2, '0')}时', value: i),
    ],
    [
      for (int i = 0; i < 60; i++)
        TPickerOption(label: '${i.toString().padLeft(2, '0')}分', value: i),
    ],
    [
      for (int i = 0; i < 60; i++)
        TPickerOption(label: '${i.toString().padLeft(2, '0')}秒', value: i),
    ],
  ]);

  String selectedTime = '0:00:00';

  // ========== 联动数据（省市区）==========

  final linkedItems = TPickerLinked({
    const TPickerOption(label: '广东省', value: 'GD'): {
      const TPickerOption(label: '深圳市', value: 'SZ'): [
        const TPickerOption(label: '南山区', value: 'NS'),
        const TPickerOption(label: '福田区', value: 'FT'),
        const TPickerOption(label: '宝安区', value: 'BA'),
        const TPickerOption(label: '罗湖区', value: 'LH'),
        const TPickerOption(label: '龙岗区', value: 'LG'),
      ],
      const TPickerOption(label: '广州市', value: 'GZ'): [
        const TPickerOption(label: '天河区', value: 'TH'),
        const TPickerOption(label: '越秀区', value: 'YX'),
        const TPickerOption(label: '白云区', value: 'BY'),
        const TPickerOption(label: '花都区', value: 'HD'),
      ],
      const TPickerOption(label: '佛山市', value: 'FS'): [
        const TPickerOption(label: '顺德区', value: 'SD'),
        const TPickerOption(label: '南海区', value: 'NH'),
        const TPickerOption(label: '禅城区', value: 'CC'),
      ],
    },
    const TPickerOption(label: '浙江省', value: 'ZJ'): {
      const TPickerOption(label: '杭州市', value: 'HZ'): [
        const TPickerOption(label: '西湖区', value: 'XH'),
        const TPickerOption(label: '余杭区', value: 'YH'),
        const TPickerOption(label: '萧山区', value: 'XS'),
      ],
      const TPickerOption(label: '宁波市', value: 'NB'): [
        const TPickerOption(label: '江东区', value: 'JD'),
        const TPickerOption(label: '北仑区', value: 'BL'),
      ],
    },
    // 直辖市（只有 2 级：市 → 区），用于测试"3 列 ↔ 2 列"切换
    const TPickerOption(label: '重庆市', value: 'CQ'): [
      const TPickerOption(label: '渝中区', value: 'YZ'),
      const TPickerOption(label: '江北区', value: 'JB'),
      const TPickerOption(label: '渝北区', value: 'YB'),
      const TPickerOption(label: '南岸区', value: 'NA'),
    ],
  });

  String selectedLinked = '广东省 / 深圳市 / 南山区';

  // ========== 项级 disabled 数据（覆盖开头/中间/结尾禁用）==========

  final itemDisabledItems = const TPickerColumns([
    // 第1列：结尾禁用
    [
      TPickerOption(label: '男', value: 'M'),
      TPickerOption(label: '女', value: 'F'),
      TPickerOption(label: '保密', value: 'N', disabled: true),
    ],
    // 第2列：开头 + 中间 + 结尾 各 1 个禁用（稀疏分布，留足操作空间）
    [
      TPickerOption(label: 'A排1座', value: 'A1', disabled: true), // 开头禁用
      TPickerOption(label: 'A排2座', value: 'A2'),
      TPickerOption(label: 'A排3座', value: 'A3'),
      TPickerOption(label: 'A排4座', value: 'A4'),
      TPickerOption(label: 'A排5座', value: 'A5'),
      TPickerOption(label: 'A排6座', value: 'A6', disabled: true),
      TPickerOption(label: 'A排7座', value: 'A7', disabled: true), // 中间偏后禁用
      TPickerOption(label: 'A排8座', value: 'A8', disabled: true), // 新增禁用
      TPickerOption(label: 'A排9座', value: 'A9'),
      TPickerOption(label: 'A排10座', value: 'A10'),
      TPickerOption(label: 'A排11座', value: 'A11'),
      TPickerOption(label: 'A排12座', value: 'A12', disabled: true), // 结尾禁用
    ],
  ]);

  String selectedItemDisabled = '男 A排5座';

  // ========== 全局 disabled 开关 ==========

  bool globalDisabled = false;

  // ========== 性别+偏好数据（弹窗专用）==========

  final preferenceData = [
    [
      const TPickerOption(label: '男', value: 'M'),
      const TPickerOption(label: '女', value: 'F'),
      const TPickerOption(label: '其他', value: 'O'),
    ],
    [
      const TPickerOption(label: '科技', value: 'tech'),
      const TPickerOption(label: '运动', value: 'sport'),
      const TPickerOption(label: '音乐', value: 'music'),
      const TPickerOption(label: '阅读', value: 'book'),
      const TPickerOption(label: '旅行', value: 'travel'),
      const TPickerOption(label: '美食', value: 'food'),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '纯滚轮选择器组件，支持多列独立和联动两种模式',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '单列选择', builder: buildSingleColumn),
          ExampleItem(desc: '时间选择(时分秒)', builder: buildTimeSelect),
          ExampleItem(desc: '联动选择(省市区)', builder: buildLinked),
        ]),
        ExampleModule(title: '按需请求', children: [
          ExampleItem(desc: '模拟网络请求加载更多', builder: buildLazyLoad),
        ]),
        ExampleModule(title: '禁用状态', children: [
          ExampleItem(desc: '项级 disabled（部分选项不可选）', builder: buildItemDisabled),
          ExampleItem(
              desc: '全局 disabled（整组不可操作）', builder: buildGlobalDisabled),
        ]),
        ExampleModule(title: '弹窗模式(TPopup)', children: [
          ExampleItem(desc: '弹窗-联动选择(省市区)', builder: buildPopupLinked),
          ExampleItem(desc: '弹窗-多列选择(性别/偏好)', builder: buildPopupMultiColumn),
        ]),
        ExampleModule(title: '自定义按钮/标题插槽', children: [
          ExampleItem(desc: '自定义按钮（图标 / 文字）', builder: buildCustomSlot),
        ]),
        ExampleModule(title: '自定义字段映射(keys)', children: [
          ExampleItem(
              desc: '数据字段非 label/value 时，用 keys 映射', builder: buildCustomKeys),
        ]),
        ExampleModule(title: '尺寸与样式', children: [
          ExampleItem(desc: '自定义高度和每屏显示数量', builder: buildCustomSize),
          ExampleItem(
              desc: '自定义子项渲染（itemBuilder）', builder: buildCustomItemBuilder),
        ]),
      ],
    );
  }

  // ========== 弹窗工具方法 ==========

  /// 弹窗工具方法：把 TPicker（自带工具栏）从底部滑入
  ///
  /// TPicker 自带「取消 / 标题 / 确认」工具栏，业务方在 onCancel/onConfirm
  /// 中自行决定是否调用 Navigator.pop 关闭弹窗。
  void _showPickerPopup(BuildContext context, {required Widget picker}) {
    TPopup.show(
      context,
      options: TPopupOptions(
          placement: TPopupPlacement.bottom,
          cancelBuilder: null,
          confirmBuilder: null,
          child: Material(
            color: TTheme.of(context).bgColorContainer,
            child: SafeArea(
              top: false,
              child: picker,
            ),
          )),
    );
  }

  // ========== 嵌入式容器 ==========

  Widget _pickerCard(BuildContext context, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(TTheme.of(context).radiusDefault),
      ),
      child: child,
    );
  }

  // ========== 基础用法 ==========

  @Demo(group: 'picker')
  Widget buildSingleColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中城市: ${selectedCity.isEmpty ? "未选择" : selectedCity}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: cityItems,
              onChange: (v) => setState(() => selectedCity = v.labels.first)),
        ),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildTimeSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中时间: ${selectedTime.isEmpty ? "未选择" : selectedTime}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: timeItems,
              itemCount: 5,
              onChange: (v) => setState(() => selectedTime =
                  '${v.values[0]}:${v.values[1].toString().padLeft(2, '0')}:${v.values[2].toString().padLeft(2, '0')}')),
        ),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildLinked(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中地区: ${selectedLinked.isEmpty ? "未选择" : selectedLinked}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: linkedItems,
              initialValue: const ['GD', 'SZ', 'NS'],
              onChange: (v) =>
                  setState(() => selectedLinked = v.labels.join(' / '))),
        ),
      ],
    );
  }

  // ========== 禁用状态 ==========

  @Demo(group: 'picker')
  Widget buildItemDisabled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '选中: ${selectedItemDisabled.isEmpty ? "未选择" : selectedItemDisabled}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 4),
        Text('提示: 标灰的选项不可选（第1列「保密」、第2列「A排1座/A排6座/A排7座/A排8座/A排12座」）',
            style: TextStyle(
                fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: itemDisabledItems,
              initialValue: const ['M', 'A5'],
              onChange: (v) => setState(() =>
                  selectedItemDisabled = '${v.labels.first} ${v.labels.last}')),
        ),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildGlobalDisabled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Switch(
              value: globalDisabled,
              onChanged: (v) => setState(() => globalDisabled = v),
            ),
            const SizedBox(width: 8),
            Text(globalDisabled ? '已禁用' : '已启用',
                style: TextStyle(
                    fontSize: 14,
                    color: globalDisabled
                        ? TTheme.of(context).errorNormalColor
                        : TTheme.of(context).successNormalColor)),
          ],
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: cityItems,
              initialValue: const ['GZ'],
              onChange: (v) => debugPrint('选中: $v'),
              disabled: globalDisabled),
        ),
        const SizedBox(height: 4),
        Text('切换开关可控制整个选择器的禁用/启用状态',
            style: TextStyle(
                fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
      ],
    );
  }

  // ========== 弹窗模式 ==========

  /// 弹窗联动模式：缓存完整 TPickerValue，可直接取 labels 展示、取 values 回传
  TPickerValue? _popupLinkedValue;
  final List<dynamic> _popupLinkedInitial = ['GD', 'SZ', 'NS'];

  @Demo(group: 'picker')
  Widget buildPopupLinked(BuildContext context) {
    final label = _popupLinkedValue?.labels.join(' / ') ?? '';
    return TCell(
      title: '弹窗-联动选择(省市区)',
      note: label.isEmpty ? '请选择' : label,
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TPicker(
            items: linkedItems,
            initialValue: _popupLinkedValue?.values ?? _popupLinkedInitial,
            title: '请选择地区',
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (value) {
              setState(() => _popupLinkedValue = value);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @Demo(group: 'picker')
  Widget buildCustomSlot(BuildContext context) {
    final theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'cancel / confirm / titleWidget 参数类型均为 Widget，可自定义图标、文字或组合',
          style: TextStyle(fontSize: 12, color: theme.textColorPlaceholder),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: linkedItems,
            initialValue: const ['GD', 'SZ', 'NS'],
            titleWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(TIcons.location, size: 18, color: theme.brandNormalColor),
                const SizedBox(width: 4),
                Text('选择地区',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.fontGyColor1,
                    )),
              ],
            ),
            cancel: Icon(TIcons.close, size: 22, color: theme.fontGyColor2),
            confirm:
                Icon(TIcons.check, size: 22, color: theme.brandNormalColor),
          ),
        ),
      ],
    );
  }

  /// 弹窗多列独立模式：缓存完整 TPickerValue
  TPickerValue? _popupMultiColValue;
  final List<dynamic> _popupMultiColInitial = ['M', 'tech'];

  /// 按需请求：模拟网络延迟加载更多数据
  final List<TPickerOption> _lazyData = [
    for (int i = 1; i <= 20; i++)
      TPickerOption(label: '选项 $i', value: 'opt_$i'),
  ];
  bool _isLoading = false;

  @Demo(group: 'picker')
  Widget buildLazyLoad(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setInner) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _lazyData.isEmpty
                  ? '暂无数据'
                  : '已加载 ${_lazyData.length} 条（滚动到底部自动加载更多）',
              style: TextStyle(
                  fontSize: 14, color: TTheme.of(context).textColorSecondary),
            ),
            const SizedBox(height: 8),
            _pickerCard(
              context,
              child: TPicker(
                items: TPickerColumns([_lazyData]),
                onLoad: (e) async {
                  // 业务层自行判断触发时机：距底部 5 项以内 + 未在加载中
                  if (e.remaining > 5 || _isLoading) {
                    return;
                  }
                  setInner(() => _isLoading = true);
                  // 模拟网络请求延迟 1.5s
                  await Future.delayed(const Duration(milliseconds: 1500));
                  final start = _lazyData.length + 1;
                  final more = [
                    for (int i = start; i < start + 20; i++)
                      TPickerOption(label: '选项 $i', value: 'opt_$i'),
                  ];
                  setInner(() {
                    _lazyData.addAll(more);
                    _isLoading = false;
                  });
                },
                onChange: (v) => debugPrint('选中: ${v.labels.first}'),
              ),
            ),
            const SizedBox(height: 4),
            if (_isLoading)
              Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 6),
                  Text('正在加载更多数据...',
                      style: TextStyle(
                          fontSize: 12,
                          color: TTheme.of(context).textColorPlaceholder)),
                ],
              )
            else
              Text('在 onLoad 里判断 e.remaining <= 5 时加载，模拟 1.5s 网络延迟',
                  style: TextStyle(
                      fontSize: 12,
                      color: TTheme.of(context).textColorPlaceholder)),
          ],
        );
      },
    );
  }

  @Demo(group: 'picker')
  Widget buildPopupMultiColumn(BuildContext context) {
    final label = _popupMultiColValue?.labels.join(' ') ?? '';
    return TCell(
      title: '弹窗-多列选择(性别/偏好)',
      note: label.isEmpty ? '请选择' : label,
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TPicker(
            items: TPickerColumns(preferenceData),
            initialValue: _popupMultiColValue?.values ?? _popupMultiColInitial,
            title: '选择性别和偏好',
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (value) {
              setState(() => _popupMultiColValue = value);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  // ========== 自定义字段映射（keys） ==========

  /// 模拟后端返回的"原始"数据：字段名是 city / code / readonly，而不是 label / value / disabled
  final List<List<Map<String, dynamic>>> _rawCityData = [
    [
      {'code': 'BJ', 'city': '北京', 'readonly': false},
      {'code': 'SH', 'city': '上海', 'readonly': false},
      {'code': 'GZ', 'city': '广州', 'readonly': false},
      {'code': 'SZ', 'city': '深圳', 'readonly': true}, // 演示禁用映射
      {'code': 'CD', 'city': '成都', 'readonly': false},
      {'code': 'HZ', 'city': '杭州', 'readonly': false},
    ],
  ];

  /// 自定义字段映射场景：缓存完整 TPickerValue
  TPickerValue? _customKeysValue;
  final List<dynamic> _customKeysInitial = ['BJ'];

  @Demo(group: 'picker')
  Widget buildCustomKeys(BuildContext context) {
    // 用 keys 告诉组件「city 映射为 label，code 是 value，readonly 是 disabled」
    const keys =
        TPickerKeys(label: 'city', value: 'code', disabled: 'readonly');
    final label = _customKeysValue?.labels.join() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '后端原始字段：city / code / readonly。通过 keys(label: "city") 映射为 label',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '当前选中：${label.isEmpty ? "未选择" : label}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: TPickerColumns.fromRaw(_rawCityData, keys: keys),
            initialValue: _customKeysValue?.values ?? _customKeysInitial,
            onChange: (v) => setState(() => _customKeysValue = v),
          ),
        ),
      ],
    );
  }

  // ========== 尺寸与样式 ==========

  @Demo(group: 'picker')
  Widget buildCustomSize(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '示例：height(300) + itemCount(7)，每屏显示 7 项',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: cityItems,
            height: 300,
            itemCount: 7,
            onChange: (v) => debugPrint('选中: ${v.labels.first}'),
          ),
        ),
      ],
    );
  }

  String _customItemBuilderValue = '';

  @Demo(group: 'picker')
  Widget buildCustomItemBuilder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '示例：itemBuilder 自定义子项渲染，可添加图标、背景色等',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '选中: ${_customItemBuilderValue.isEmpty ? "未选择" : _customItemBuilderValue}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: cityItems,
            itemBuilder: (ctx, content, colIndex, index, calculator, distance) {
              final theme = TTheme.of(ctx);
              final selected = distance == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? theme.brandLightColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(TIcons.location, size: 20, color: theme.fontGyColor3),
                    const SizedBox(width: 8),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected
                            ? theme.brandNormalColor
                            : theme.fontGyColor1,
                      ),
                    ),
                  ],
                ),
              );
            },
            onChange: (v) =>
                setState(() => _customItemBuilderValue = v.labels.first),
          ),
        ),
      ],
    );
  }
}
