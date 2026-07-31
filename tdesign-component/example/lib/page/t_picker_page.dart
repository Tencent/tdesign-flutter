import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

/// TPicker 演示。
class TPickerPage extends StatefulWidget {
  const TPickerPage({super.key});

  @override
  State<TPickerPage> createState() => _TPickerPageState();
}

class _TPickerPageState extends State<TPickerPage> {
  static const _columns = TPickerColumns([
    [
      TPickerOption(label: '广东', value: 'gd'),
      TPickerOption(label: '浙江', value: 'zj'),
      TPickerOption(label: '江苏', value: 'js'),
      TPickerOption(label: '四川', value: 'sc'),
      TPickerOption(label: '湖北', value: 'hb'),
      TPickerOption(label: '福建', value: 'fj'),
      TPickerOption(label: '北京', value: 'bj'),
    ],
    [
      TPickerOption(label: '深圳', value: 1),
      TPickerOption(label: '杭州', value: 2),
      TPickerOption(label: '南京', value: 3),
      TPickerOption(label: '成都', value: 4),
      TPickerOption(label: '武汉', value: 5),
      TPickerOption(label: '厦门', value: 6),
      TPickerOption(label: '北京', value: 7, disabled: true),
    ],
    [
      TPickerOption(label: '南山', value: 'nanshan'),
      TPickerOption(label: '西湖', value: 'xihu'),
      TPickerOption(label: '鼓楼', value: 'gulou'),
      TPickerOption(label: '锦江', value: 'jinjiang'),
      TPickerOption(label: '武昌', value: 'wuchang'),
      TPickerOption(label: '思明', value: 'siming'),
      TPickerOption(label: '朝阳', value: 'chaoyang'),
    ],
  ]);
  static const _linked = TPickerLinked([
    TPickerOption(
      label: '广东',
      value: '广东',
      children: [
        TPickerOption(
          label: '深圳',
          value: '深圳',
          children: [
            TPickerOption(label: '南山', value: '南山'),
            TPickerOption(label: '福田', value: '福田'),
          ],
        ),
        TPickerOption(
          label: '广州',
          value: '广州',
          children: [
            TPickerOption(label: '天河', value: '天河'),
            TPickerOption(label: '越秀', value: '越秀'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '浙江',
      value: '浙江',
      children: [
        TPickerOption(
          label: '杭州',
          value: '杭州',
          children: [
            TPickerOption(label: '西湖', value: '西湖'),
            TPickerOption(label: '余杭', value: '余杭'),
            TPickerOption(label: '滨江', value: '滨江'),
          ],
        ),
        TPickerOption(
          label: '宁波',
          value: '宁波',
          children: [
            TPickerOption(label: '海曙', value: '海曙'),
            TPickerOption(label: '鄞州', value: '鄞州'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '江苏',
      value: '江苏',
      children: [
        TPickerOption(
          label: '南京',
          value: '南京',
          children: [
            TPickerOption(label: '鼓楼', value: '鼓楼'),
            TPickerOption(label: '玄武', value: '玄武'),
          ],
        ),
        TPickerOption(
          label: '苏州',
          value: '苏州',
          children: [
            TPickerOption(label: '姑苏', value: '姑苏'),
            TPickerOption(label: '吴中', value: '吴中'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '四川',
      value: '四川',
      children: [
        TPickerOption(
          label: '成都',
          value: '成都',
          children: [
            TPickerOption(label: '锦江', value: '锦江'),
            TPickerOption(label: '武侯', value: '武侯'),
          ],
        ),
        TPickerOption(
          label: '绵阳',
          value: '绵阳',
          children: [
            TPickerOption(label: '涪城', value: '涪城'),
            TPickerOption(label: '游仙', value: '游仙'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '福建',
      value: '福建',
      children: [
        TPickerOption(
          label: '厦门',
          value: '厦门',
          children: [
            TPickerOption(label: '思明', value: '思明'),
            TPickerOption(label: '湖里', value: '湖里'),
          ],
        ),
        TPickerOption(
          label: '福州',
          value: '福州',
          children: [
            TPickerOption(label: '鼓楼', value: '鼓楼区'),
            TPickerOption(label: '仓山', value: '仓山'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '湖北',
      value: '湖北',
      children: [
        TPickerOption(
          label: '武汉',
          value: '武汉',
          children: [
            TPickerOption(label: '武昌', value: '武昌'),
            TPickerOption(label: '江汉', value: '江汉'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '北京',
      value: '北京',
      children: [
        TPickerOption(
          label: '北京',
          value: '北京',
          children: [
            TPickerOption(label: '朝阳', value: '朝阳'),
            TPickerOption(label: '海淀', value: '海淀'),
          ],
        ),
      ],
    ),
  ]);

  List<dynamic> _columnValue = ['gd', 1, 'nanshan'];
  List<dynamic> _linkedValue = ['广东', '深圳', '南山'];
  List<dynamic> _popupValue = ['浙江', '杭州', '西湖'];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于从独立列或联动数据中选择值。',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(title: '弹出层用法', children: [
          ExampleItem(desc: '底部弹出选择', builder: _buildPopup),
        ]),
        ExampleModule(title: '基础能力', children: [
          ExampleItem(desc: '多列选择', builder: _buildColumns),
          ExampleItem(desc: '多级联动', builder: _buildLinked),
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
          ExampleItem(desc: '主题尺寸', builder: _buildThemed),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'picker')
  Widget _buildColumns(BuildContext context) {
    return TPicker(
      items: _columns,
      value: _columnValue,
      onChanged: (value) => setState(() => _columnValue = value.values),
    );
  }

  @ExampleCode(group: 'picker')
  Widget _buildLinked(BuildContext context) {
    return TPicker(
      items: _linked,
      value: _linkedValue,
      onChanged: (value) => setState(() => _linkedValue = value.values),
    );
  }

  @ExampleCode(group: 'picker')
  Widget _buildDisabled(BuildContext context) {
    return TPicker(items: _columns, value: _columnValue);
  }

  @ExampleCode(group: 'picker')
  Widget _buildThemed(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TPickerThemeData(height: 160, itemCount: 3),
      ),
      child: TPicker(
        items: _columns,
        value: _columnValue,
        onChanged: (value) => setState(() => _columnValue = value.values),
      ),
    );
  }

  @ExampleCode(group: 'picker')
  Widget _buildPopup(BuildContext context) {
    return TCell(
      title: const TText('选择地区'),
      note: TText(_popupValue.join(' / ')),
      arrow: true,
      onTap: () {
        var draft = List<dynamic>.of(_popupValue);
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
            titleWidget: const TText('选择地区'),
            child: StatefulBuilder(
              builder: (context, setPopupState) => TPicker(
                items: _linked,
                value: draft,
                onChanged: (value) {
                  setPopupState(() => draft = value.values);
                },
              ),
            ),
            onVisibleChange: (visible, trigger) {
              if (!visible && trigger == TPopupTrigger.confirm) {
                setState(() => _popupValue = List<dynamic>.of(draft));
              }
            },
          ),
        );
      },
    );
  }
}
