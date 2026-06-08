import 'package:flutter/material.dart';

import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';
import 'linked_lazy_picker_policy.dart';
import 'linked_lazy_picker_scope.dart';

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

  // ========== 月日联动（模拟平年：2 月 28 天，大小月 30/31 天）==========

  /// 平年各月天数（demo 不做闰年，2 月固定 28 天）
  static int _daysInMonth(int month) {
    const thirtyOneMonths = {1, 3, 5, 7, 8, 10, 12};
    if (month == 2) {
      return 28;
    }
    if (thirtyOneMonths.contains(month)) {
      return 31;
    }
    return 30;
  }

  /// 月 → 日联动树：滚月后日列由 [TPickerLinked] 内部自动刷新
  final _monthDayItems = TPickerLinked({
    for (int month = 1; month <= 12; month++)
      TPickerOption(label: '$month月', value: month): [
        for (int day = 1; day <= _daysInMonth(month); day++)
          TPickerOption(label: '$day日', value: day),
      ],
  });

  String selectedMonthDay = '1月 / 1日';

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

  // ========== 五级联动（大区 → 省份 → 城市 → 区县 → 街道）==========
  static const _kFiveLevelNames = ['大区', '省份', '城市', '区县', '街道'];

  /// 五级联动 mock 树：前 4 级为 Map，第 5 级为叶子 List
  ///
  /// label 采用层级编号（1 → 1.1 → 1.1.1 …），便于在窄列中完整展示；
  /// 切换第 1 级后下游各列数据均与新区间绑定且互不相同。
  final _fiveLevelItems = TPickerLinked(_fiveLevelNode(1));

  static dynamic _fiveLevelNode(int depth, [String codePrefix = '']) {
    if (depth == 5) {
      return [
        for (int i = 1; i <= 5; i++)
          TPickerOption(
            label: '$codePrefix.$i',
            value: '$codePrefix.$i',
          ),
      ];
    }
    final branchCount = depth <= 2 ? 2 : 3;
    return {
      for (int i = 1; i <= branchCount; i++)
        TPickerOption(
          label: codePrefix.isEmpty ? '$i' : '$codePrefix.$i',
          value: codePrefix.isEmpty ? '$i' : '$codePrefix.$i',
        ): _fiveLevelNode(
            depth + 1, codePrefix.isEmpty ? '$i' : '$codePrefix.$i'),
    };
  }

  String selectedFiveLevel = '1 / 1.1 / 1.1.1 / 1.1.1.1 / 1.1.1.1.1';

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

  // ========== 全局 disabled 开关 ==========
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '纯滚轮选择器组件，支持多列独立和联动两种模式',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '单列选择', builder: buildSingleColumn),
          ExampleItem(desc: '时间选择(时分秒)', builder: buildTimeSelect),
          ExampleItem(desc: '月日选择(联动)', builder: buildMonthDaySelect),
          ExampleItem(desc: '五级联动选择', builder: buildLinkedFiveLevel),
        ]),
        ExampleModule(title: '按需请求', children: [
          ExampleItem(
              desc: '滚近底部自动分页（主列 + 联动子列）',
              builder: buildLazyLoad),
        ]),
        ExampleModule(title: '禁用状态', children: [
          ExampleItem(desc: '项级 disabled（部分选项不可选）', builder: buildItemDisabled),
          ExampleItem(
              desc: '全局 disabled（整组不可操作）', builder: buildGlobalDisabled),
        ]),
        ExampleModule(title: '弹窗模式(TPopup)', children: [
          ExampleItem(desc: '弹窗-联动选择(省市区)', builder: buildPopupLinked),
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

  /// 弹窗工具方法：TPopup 提供头部，TPicker 仅负责滚轮与 onChange
  ///
  /// [onConfirm] 在用户点击弹窗「确认」时触发（关闭前），用于提交 draft 值。
  void _showPickerPopup(
    BuildContext context, {
    required String title,
    required Widget picker,
    required VoidCallback onConfirm,
  }) {
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        titleWidget: TText(title, font: TTheme.of(context).fontTitleMedium),
        onVisibleChange: (visible, trigger) {
          if (!visible && trigger == TPopupTrigger.confirm) {
            onConfirm();
          }
        },
        child: Material(
          color: TTheme.of(context).bgColorContainer,
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  /// 联动：按 value 路径解析为 [TPickerValue]（用户未滚动直接确认时使用）
  TPickerValue _linkedValueFromPath(
    Map<TPickerOption, dynamic> tree,
    List<dynamic> path,
  ) {
    final selectedOptions = <TPickerOption>[];
    final indexes = <int>[];
    var currentMap = tree;
    for (var depth = 0; depth < path.length; depth++) {
      final options = currentMap.keys.toList();
      final idx = options.indexWhere((o) => o.value == path[depth]);
      if (idx < 0) {
        break;
      }
      final selected = options[idx];
      indexes.add(idx);
      selectedOptions.add(selected);
      final child = currentMap[selected];
      if (child is Map<TPickerOption, dynamic>) {
        currentMap = child;
      } else {
        break;
      }
    }
    return TPickerValue(selectedOptions: selectedOptions, indexes: indexes);
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
              onChange: (_, v) => setState(() => selectedCity = v.labels.first)),
        ),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildMonthDaySelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TPickerLinked：切换月份后日列自动变为 28 / 30 / 31 天（demo 平年，2 月固定 28 天）',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '选中: ${selectedMonthDay.isEmpty ? "未选择" : selectedMonthDay}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: _monthDayItems,
            initialValue: const [1, 1],
            onChange: (_, v) =>
                setState(() => selectedMonthDay = v.labels.join(' / ')),
          ),
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
              onChange: (_, v) => setState(() => selectedTime =
                  '${v.values[0]}:${v.values[1].toString().padLeft(2, '0')}:${v.values[2].toString().padLeft(2, '0')}')),
        ),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildLinkedFiveLevel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '五级联动：${_kFiveLevelNames.join(' → ')}（切换第 1 级后，第 2–5 级数据全部刷新）',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '适用 TPickerLinked 静态树：整树在内存、每级项数可控；label 用 1 / 1.1 / 1.1.1 便于窄列展示',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '选中: ${selectedFiveLevel.isEmpty ? "未选择" : selectedFiveLevel}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: _fiveLevelItems,
            initialValue: const [
              '1',
              '1.1',
              '1.1.1',
              '1.1.1.1',
              '1.1.1.1.1',
            ],
            onChange: (_, v) =>
                setState(() => selectedFiveLevel = v.labels.join(' / ')),
          ),
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
              onChange: (_, v) => setState(() =>
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
              onChange: (_, v) => debugPrint('选中: $v'),
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
        TPickerValue? draft;
        final initial =
            _popupLinkedValue?.values ?? List<dynamic>.from(_popupLinkedInitial);
        _showPickerPopup(
          context,
          title: '请选择地区',
          onConfirm: () {
            setState(() {
              _popupLinkedValue = draft ??
                  _popupLinkedValue ??
                  _linkedValueFromPath(linkedItems.tree, initial);
            });
          },
          picker: TPicker(
            items: linkedItems,
            initialValue: initial,
            onChange: (_, value) => draft = value,
          ),
        );
      },
    );
  }

  static const _kLazyDemoPageSize = 10;
  static const _kLazyDemoLoadDelay = Duration(milliseconds: 350);

  int _lazyCategoryNumber(dynamic categoryValue) {
    final raw = categoryValue.toString().replaceFirst('cat_', '');
    return int.tryParse(raw) ?? 0;
  }

  List<TPickerOption> _mockLazyCategories(int start, int count) {
    return [
      for (int i = start; i < start + count; i++)
        TPickerOption(label: '分类 $i', value: 'cat_$i'),
    ];
  }

  /// 模拟主列分页：每页固定 [_kLazyDemoPageSize] 条，无总量上限
  Future<LazyLoadPage> _mockLazyPrimaryPage(int nextStart) async {
    await Future.delayed(_kLazyDemoLoadDelay);
    return LazyLoadPage(
      items: _mockLazyCategories(nextStart, _kLazyDemoPageSize),
      hasMore: true,
    );
  }

  /// 模拟子列分页：每页固定 [_kLazyDemoPageSize] 条，无总量上限
  Future<LazyLoadPage> _mockLazyLinkedPage(
    dynamic categoryValue,
    int nextStart,
  ) async {
    await Future.delayed(_kLazyDemoLoadDelay);
    final catNum = _lazyCategoryNumber(categoryValue);
    return LazyLoadPage(
      items: [
        for (int i = nextStart; i < nextStart + _kLazyDemoPageSize; i++)
          TPickerOption(
            label: '分类$catNum · 条目 $i',
            value: '${categoryValue}_item_$i',
          ),
      ],
      hasMore: true,
    );
  }

  @Demo(group: 'picker')
  Widget buildLazyLoad(BuildContext context) {
    const initialPrimaryValue = 'cat_1';
    final initialLinked = [
      for (int i = 1; i <= _kLazyDemoPageSize; i++)
        TPickerOption(
          label: '分类1 · 条目 $i',
          value: '${initialPrimaryValue}_item_$i',
        ),
    ];

    return LinkedLazyPickerScope(
      threshold: 8,
      primaryLabel: '分类',
      linkedLabel: '条目',
      initialPrimary: _mockLazyCategories(1, _kLazyDemoPageSize),
      initialPrimaryValue: initialPrimaryValue,
      initialLinked: initialLinked,
      onLoadPrimary: _mockLazyPrimaryPage,
      onLoadLinked: _mockLazyLinkedPage,
      builder: (ctx, vm) {
        final loadingHint = vm.loadingHint;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '在 onColumnScrollEnd 里判断接近列底后 append items；onChange 仅维护 draft',
              style: TextStyle(
                  fontSize: 12,
                  color: TTheme.of(context).textColorPlaceholder),
            ),
            const SizedBox(height: 4),
            Text(
              vm.statusLine,
              style: TextStyle(
                  fontSize: 14, color: TTheme.of(context).textColorSecondary),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                _pickerCard(context, child: vm.buildPicker()),
                if (loadingHint != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 8,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: TTheme.of(context)
                              .fontGyColor1
                              .withOpacity(0.72),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '加载$loadingHint…',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '滚近底部每次追加 10 条（无总量上限）；切换分类时子列读缓存或按需拉取',
              style: TextStyle(
                  fontSize: 12,
                  color: TTheme.of(context).textColorPlaceholder),
            ),
          ],
        );
      },
    );
  }

  // ========== 自定义字段映射（keys） ==========

  /// 模拟后端返回的"原始"数据：字段名是 city / code / readonly，而不是 label / value / disabled
  static const _kRawCityData = [
    [
      {'code': 'BJ', 'city': '北京', 'readonly': false},
      {'code': 'SH', 'city': '上海', 'readonly': false},
      {'code': 'GZ', 'city': '广州', 'readonly': false},
      {'code': 'SZ', 'city': '深圳', 'readonly': true}, // 演示禁用映射
      {'code': 'CD', 'city': '成都', 'readonly': false},
      {'code': 'HZ', 'city': '杭州', 'readonly': false},
    ],
  ];

  /// 后端字段映射声明：city → label, code → value, readonly → disabled
  static const _kCustomKeys = TPickerKeys(
    label: 'city',
    value: 'code',
    disabled: 'readonly',
  );

  /// 把 raw 数据归一化一次后缓存为稳定实例。
  ///
  /// 若在 build() 里调用 fromRaw，惯性滚动期间 onChange 60+ Hz 触发父级 setState，
  /// 会反复分配 6 个 TPickerOption + 嵌套 List，导致滚轮不流畅。
  /// 缓存为同一实例后，TPicker.didUpdateWidget 走 identical() 短路，连值比较都省了。
  static final _customKeysItems =
      TPickerColumns.fromRaw(_kRawCityData, keys: _kCustomKeys);

  /// 自定义字段映射场景：缓存完整 TPickerValue
  TPickerValue? _customKeysValue;
  static const _kCustomKeysInitial = <dynamic>['BJ'];

  /// 自定义字段映射：展示 city（label）与 code（value）
  String _customKeysSelectionText() {
    if (_customKeysValue != null) {
      final label = _customKeysValue!.labels.first;
      final value = _customKeysValue!.values.first;
      return 'city=$label，code=$value';
    }
    final code = _kCustomKeysInitial.first;
    for (final row in _kRawCityData[0]) {
      if (row['code'] == code) {
        return 'city=${row['city']}，code=$code';
      }
    }
    return '未选择';
  }

  @Demo(group: 'picker')
  Widget buildCustomKeys(BuildContext context) {
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
          '当前选中：${_customKeysSelectionText()}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: _customKeysItems,
            initialValue: _kCustomKeysInitial,
            onChange: (_, v) => setState(() => _customKeysValue = v),
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
          '示例：height(350) + itemCount(7)，每屏显示 7 项',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: cityItems,
            height: 350,
            itemCount: 7,
            onChange: (_, v) => debugPrint('选中: ${v.labels.first}'),
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
            onChange: (_, v) =>
                setState(() => _customItemBuilderValue = v.labels.first),
          ),
        ),
      ],
    );
  }

  }
