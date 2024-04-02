import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TDRadio演示
///
class TDRatePage extends StatefulWidget {
  const TDRatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDRatePageState();
  }
}

class TDRatePageState extends State<TDRatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        exampleCodeGroup: 'rate',
        backgroundColor: const Color(0xfff6f6f6),
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '实心评分', builder: _buildFilledRate),
            ExampleItem(desc: '自定义评分图标', builder: _buildCustomRateWithIcon),
            ExampleItem(desc: '自定义评分数量', builder: _buildCustomRateWithCount),
            ExampleItem(desc: '带描述评分', builder: _buildCustomRateWithText),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '未评分状态', builder: _buildNoRateStatus),
            ExampleItem(desc: '禁用评分状态', builder: _buildDisabledRate),
            ExampleItem(desc: '满分状态', builder: _buildFullRateStatus),
            ExampleItem(desc: '半星状态', builder: _buildHalfRateStatus),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '评分大小', builder: _buildLargeSizeRate),
          ]),
          ExampleModule(title: '特殊样式', children: [
            ExampleItem(desc: '竖向描述评分', builder: _buildVerticalTextRate),
          ]),
        ]);
  }

  @Demo(group: 'rate')
  Widget _buildFilledRate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
              variant: Variant.filled,
              defaultValue: 2,
              onChange: (value) {
                print('value: $value');
              })
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildCustomRateWithIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
            allowHalf: false,
            onChange: (value) {
              print('value: $value');
            },
            filledIcon: Icons.thumb_up,
            outlineIcon: Icons.thumb_up_off_alt_outlined,
            count: 5,
            size: 20,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildCustomRateWithCount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
            allowHalf: false,
            onChange: (value) {
              print('value: $value');
            },
            filledIcon: Icons.star,
            outlineIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            halfOutlineIcon: Icons.star_half,
            count: 3,
            texts: const ['差', '一般', '好'],
            size: 20,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildCustomRateWithText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          const SizedBox(
            width: 20,
          ),
          TDRate(
            allowHalf: false,
            variant: Variant.filled,
            onChange: (value) {
              print('value: $value');
            },
            showText: true,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildDisabledRate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('无法点击评分'),
          TDRate(
            allowHalf: false,
            onChange: (value) {
            },
            filledIcon: Icons.star,
            outlineIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            halfOutlineIcon: Icons.star_half,
            count: 5,
            size: 30,
            defaultValue: 3.5,
            color: Colors.orange,
            disabled: true,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildVerticalTextRate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('评分满分'),
          const SizedBox(width: 8),
          TDRate(
            allowHalf: false,
            variant: Variant.filled,
            onChange: (value) {
              print('value: $value');
            },
            count: 5,
            size: 20,
            color: Colors.orange,
            defaultValue: 5,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildNoRateStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('请点击评分'),
          TDRate(
            allowHalf: false,
            onChange: (value) {
              print('value: $value');
            },
            filledIcon: Icons.star,
            outlineIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            halfOutlineIcon: Icons.star_half,
            count: 5,
            size: 30,
            color: Colors.orange,
            defaultValue: 0,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildFullRateStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('评分满分'),
          const SizedBox(width: 8),
          TDRate(
            allowHalf: false,
            variant: Variant.filled,
            onChange: (value) {
              print('value: $value');
            },
            count: 5,
            size: 20,
            color: Colors.orange,
            defaultValue: 5,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildHalfRateStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('评分带半星'),
          const SizedBox(width: 8),
          TDRate(
            allowHalf: true,
            variant: Variant.filled,
            onChange: (value) {
              print('value: $value');
            },
            size: 20,
            defaultValue: 3.5,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildLargeSizeRate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const TDText('大号评分'),
          const SizedBox(width: 8),
          TDRate(
            allowHalf: false,
            onChange: (value) {
              print('value: $value');
            },
            count: 5,
            size: 25,
            color: Colors.orange,
            defaultValue: 3,
          ),
        ],
      ),
    );
  }
}
