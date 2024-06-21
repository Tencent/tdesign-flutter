///
///  Created by arvinwli@tencent.com on 4/24/23.
///
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDSliderPage extends StatefulWidget {
  const TDSliderPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDSliderPageState();
}

class _TDSliderPageState extends State<TDSliderPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于选择横轴上的数值、区间、档位。',
        exampleCodeGroup: 'slider',
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '单游标滑块', builder: _buildSingleHandle),
            ExampleItem(desc: '双游标滑块', builder: _buildDoubleHandle),
            ExampleItem(desc: '带数值单游标滑块 ', builder: _buildSingleHandleWithNumber),
            ExampleItem(desc: '带数值双游标滑块', builder: _buildDoubleHandleWithNumber),
            ExampleItem(desc: '带刻度单游标滑块', builder: _buildSingleHandleWithScale),
            ExampleItem(desc: '带刻度双游标滑块', builder: _buildDoubleHandleWithScale),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '禁用状态', builder: _buildDisable),
          ]),
          ExampleModule(title: '特殊样式', children: [
            ExampleItem(desc: '胶囊型滑块', builder: _buildCapsule),
            ExampleItem(desc: '自定义盒子样式', builder: _buildCustomDecoration),
          ]),
        ]);
  }

  @Demo(group: 'slider')
  Widget _buildSingleHandle(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData(
        min: 0,
        max: 100,
      ),
      value: 10,
      // divisions: 5,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildDoubleHandle(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        min: 0,
        max: 100,
      ),
      value: const RangeValues(10, 60),
      // divisions: 5,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildSingleHandleWithNumber(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData(
        showThumbValue: true,
        scaleFormatter: (value) => value.toInt().toString(),
        min: 0,
        max: 100,
      ),
      value: 10,
      leftLabel: '0',
      rightLabel: '100',
      // divisions: 5,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildDoubleHandleWithNumber(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.round().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(40, 60),
      // divisions: 5,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildSingleHandleWithScale(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData(
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: 60,
      // divisions: 5,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildDoubleHandleWithScale(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(40, 70),
      // divisions: 5,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildDisable(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData(
            min: 0,
            max: 100,
          ),
          value: 40,
          leftLabel: '0',
          rightLabel: '100',
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData(
            min: 0,
            max: 100,
            showThumbValue: true,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          leftLabel: '0',
          rightLabel: '100',
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData(
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
        ),
      ],
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsule(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            showThumbValue: true,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          leftLabel: '0',
          rightLabel: '100',
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            min: 0,
            max: 100,
            showThumbValue: true,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          leftLabel: '0',
          rightLabel: '100',
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          )..updateSliderThemeData((data) => data.copyWith(
                activeTickMarkColor: const Color(0xFFE7E7E7),
                inactiveTickMarkColor: const Color(0xFFE7E7E7),
              )),
          value: 60,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          )
            ..updateSliderThemeData((data) =>
                data.copyWith(
                  activeTickMarkColor: const Color(0xFFE7E7E7),
                  inactiveTickMarkColor: const Color(0xFFE7E7E7),
                )),
          value: const RangeValues(20, 60),
          // divisions: 5,
          onChanged: (value) {},
        )
      ],
    );
  }

  @Demo(group: 'slider')
  Widget _buildCustomDecoration(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData(
            min: 0,
            max: 100,
          ),
          value: 40,
          boxDecoration: BoxDecoration(
             color: Colors.amber
          ),
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          boxDecoration: BoxDecoration(
              color: Colors.deepOrangeAccent
          ),
          value: const RangeValues(20, 60),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
