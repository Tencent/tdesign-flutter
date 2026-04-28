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

  final cityData = [
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
  ];

  String selectedCity = '';

  // ========== 时分秒数据 ==========

  final timeData = [
    [
      for (int i = 0; i < 24; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}时', value: i),
    ],
    [
      for (int i = 0; i < 60; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}分', value: i),
    ],
    [
      for (int i = 0; i < 60; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}秒', value: i),
    ],
  ];

  String selectedTime = '';

  // ========== 联动数据（省市区）==========

  final linkedData = {
    TPickerOption(label: '广东省', value: 'GD'): {
      TPickerOption(label: '深圳市', value: 'SZ'): [
        TPickerOption(label: '南山区', value: 'NS'),
        TPickerOption(label: '福田区', value: 'FT'),
        TPickerOption(label: '宝安区', value: 'BA'),
        TPickerOption(label: '罗湖区', value: 'LH'),
        TPickerOption(label: '龙岗区', value: 'LG'),
      ],
      TPickerOption(label: '广州市', value: 'GZ'): [
        TPickerOption(label: '天河区', value: 'TH'),
        TPickerOption(label: '越秀区', value: 'YX'),
        TPickerOption(label: '白云区', value: 'BY'),
        TPickerOption(label: '花都区', value: 'HD'),
      ],
      TPickerOption(label: '佛山市', value: 'FS'): [
        TPickerOption(label: '顺德区', value: 'SD'),
        TPickerOption(label: '南海区', value: 'NH'),
        TPickerOption(label: '禅城区', value: 'CC'),
      ],
    },
    TPickerOption(label: '浙江省', value: 'ZJ'): {
      TPickerOption(label: '杭州市', value: 'HZ'): [
        TPickerOption(label: '西湖区', value: 'XH'),
        TPickerOption(label: '余杭区', value: 'YH'),
        TPickerOption(label: '萧山区', value: 'XS'),
      ],
      TPickerOption(label: '宁波市', value: 'NB'): [
        TPickerOption(label: '江东区', value: 'JD'),
        TPickerOption(label: '北仑区', value: 'BL'),
      ],
    },
  };

  String selectedLinked = '';

  // ========== 项级 disabled 数据（覆盖开头/中间/结尾禁用）==========

  final itemDisabledData = [
    // 第1列：结尾禁用
    [
      TPickerOption(label: '男', value: 'M'),
      TPickerOption(label: '女', value: 'F'),
      TPickerOption(label: '保密', value: 'N', disabled: true),
    ],
    // 第2列：开头 + 中间 + 结尾 各 1 个禁用（稀疏分布，留足操作空间）
    [
      TPickerOption(label: 'A排1座', value: 'A1', disabled: true),   // 开头禁用
      TPickerOption(label: 'A排2座', value: 'A2'),
      TPickerOption(label: 'A排3座', value: 'A3'),
      TPickerOption(label: 'A排4座', value: 'A4'),
      TPickerOption(label: 'A排5座', value: 'A5'),
      TPickerOption(label: 'A排6座', value: 'A6', disabled: true),
      TPickerOption(label: 'A排7座', value: 'A7', disabled: true),   // 中间偏后禁用
      TPickerOption(label: 'A排8座', value: 'A8', disabled: true),   // 新增禁用
      TPickerOption(label: 'A排9座', value: 'A9'),
      TPickerOption(label: 'A排10座', value: 'A10'),
      TPickerOption(label: 'A排11座', value: 'A11'),
      TPickerOption(label: 'A排12座', value: 'A12', disabled: true),  // 结尾禁用
    ],
  ];

  String selectedItemDisabled = '';

  // ========== 全局 disabled 开关 ==========

  bool globalDisabled = false;

  // ========== 性别+偏好数据（弹窗专用）==========

  final preferenceData = [
    [
      TPickerOption(label: '男', value: 'M'),
      TPickerOption(label: '女', value: 'F'),
      TPickerOption(label: '其他', value: 'O'),
    ],
    [
      TPickerOption(label: '科技', value: 'tech'),
      TPickerOption(label: '运动', value: 'sport'),
      TPickerOption(label: '音乐', value: 'music'),
      TPickerOption(label: '阅读', value: 'book'),
      TPickerOption(label: '旅行', value: 'travel'),
      TPickerOption(label: '美食', value: 'food'),
    ],
  ];

  String selectedPreference = '';

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
          ExampleItem(desc: '全局 disabled（整组不可操作）', builder: buildGlobalDisabled),
        ]),
        ExampleModule(title: '弹窗模式(TPopup)', children: [
          ExampleItem(desc: '弹窗-联动选择(省市区)', builder: buildPopupLinked),
          ExampleItem(desc: '弹窗-多列选择(性别/偏好)', builder: buildPopupMultiColumn),
        ]),
      ],
    );
  }

  // ========== 弹窗工具方法 ==========

  void _showPickerPopup(
    BuildContext context, {
    required String title,
    required Widget picker,
    VoidCallback? onConfirm,
  }) {
    Navigator.of(context).push(
      TSlidePopupRoute(
        slideTransitionFrom: SlideTransitionFrom.bottom,
        builder: (ctx) => TPopupBottomConfirmPanel(
          title: title,
          leftClick: () => Navigator.maybePop(ctx),
          rightClick: () {
            onConfirm?.call();
            Navigator.maybePop(ctx);
          },
          child: picker,
        ),
      ),
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
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: cityData,
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
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: timeData, itemCount: 5,
              onChange: (v) => setState(() =>
                  selectedTime = '${v.values[0]}:${v.values[1].toString().padLeft(2, '0')}:${v.values[2].toString().padLeft(2, '0')}')),
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
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: linkedData, initialValue: ['GD'],
              onChange: (v) => setState(() => selectedLinked = v.labels.join(' / '))),
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
        Text('选中: ${selectedItemDisabled.isEmpty ? "未选择" : selectedItemDisabled}',
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 4),
        Text('提示: 标灰的选项不可选（第1列「保密」、第2列「A排1座/A排6座/A排7座/A排8座/A排12座」）',
            style: TextStyle(fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: itemDisabledData, initialValue: ['M', 'A5'],
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
            SizedBox(width: 8),
            Text(globalDisabled ? '已禁用' : '已启用',
                style: TextStyle(
                    fontSize: 14,
                    color: globalDisabled
                        ? TTheme.of(context).errorNormalColor
                        : TTheme.of(context).successNormalColor)),
          ],
        ),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: cityData, initialValue: ['GZ'],
              onChange: (v) => debugPrint('选中: $v'),
              disabled: globalDisabled),
        ),
        SizedBox(height: 4),
        Text('切换开关可控制整个选择器的禁用/启用状态',
            style: TextStyle(fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
      ],
    );
  }

  // ========== 弹窗模式 ==========

  /// 弹窗联动模式的临时选中值（仅点击确认后才写入 selectedLinked）
  String _popupLinkedTemp = '';

  @Demo(group: 'picker')
  Widget buildPopupLinked(BuildContext context) {
    return TCell(
      title: '弹窗-联动选择(省市区)',
      note: selectedLinked.isEmpty ? '请选择' : selectedLinked,
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          title: '请选择地区',
          picker: TPicker(
            items: linkedData,
            initialValue: selectedLinked.isNotEmpty
                ? selectedLinked.split(' / ')
                : ['GD'],
            onChange: (v) => setState(() => _popupLinkedTemp = v.labels.join(' / ')),
          ),
          onConfirm: () => setState(() => selectedLinked = _popupLinkedTemp),
        );
      },
    );
  }

  /// 弹窗多列独立模式的临时选中值
  String _popupMultiColTemp = '';

  /// 按需请求：模拟网络延迟加载更多数据
  List<TPickerOption> _lazyData = [
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
                items: [_lazyData],
                preloadThreshold: 5,
                onLoad: (e) async {
                  if (_isLoading) return;
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
                onChange: (v) => setState(() =>
                    selectedPreference = v.labels.first),
              ),
            ),
            const SizedBox(height: 4),
            if (_isLoading)
              Row(
                children: [
                  SizedBox(
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
              Text('距底部 5 项时触发 onLoad，模拟 1.5s 网络延迟',
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
    return TCell(
      title: '弹窗-多列选择(性别/偏好)',
      note: selectedPreference.isEmpty ? '请选择' : selectedPreference,
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          title: '选择性别和偏好',
          picker: TPicker(
            items: preferenceData,
            initialValue: selectedPreference.isNotEmpty
                ? selectedPreference.split(' ')
                : ['M', 'tech'],
            onChange: (v) => setState(() =>
                _popupMultiColTemp = '${v.labels.first} ${v.labels.last}'),
          ),
          onConfirm: () => setState(() => selectedPreference = _popupMultiColTemp),
        );
      },
    );
  }
}
