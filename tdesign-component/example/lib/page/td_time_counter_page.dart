import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDTimeCounterPage extends StatelessWidget {
  const TDTimeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      desc: '用于实时展示计时数值。',
      exampleCodeGroup: 'timeCounter',
      children: [
        const ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '时分秒', builder: _buildSimple),
          ExampleItem(desc: '带毫秒', builder: _buildMillisecondSimple),
          ExampleItem(desc: '正向计时', builder: _buildUpSimple),
          ExampleItem(desc: '带方形底', builder: _buildSquareSimple),
          ExampleItem(desc: '带圆形底', builder: _buildRoundSimple),
          ExampleItem(desc: '带单位', builder: _buildUnitSimple),
          ExampleItem(desc: '无底色带单位', builder: _buildCustomUnitSimple),
        ]),
        ExampleModule(title: '组件尺寸', children: [
          ExampleItem(
            ignoreCode: true,
            desc: '纯数字',
            builder: (BuildContext context) {
              return const Wrap(
                direction: Axis.vertical,
                spacing: 16,
                children: [
                  Row(spacing: 40, children: [
                    Text('小'),
                    CodeWrapper(builder: _buildSmallSize),
                  ]),
                  Row(spacing: 40, children: [
                    Text('中'),
                    CodeWrapper(builder: _buildMediumSize)
                  ]),
                  Row(spacing: 40, children: [
                    Text('大'),
                    CodeWrapper(builder: _buildLargeSize),
                  ]),
                ],
              );
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '带方形底',
            builder: (BuildContext context) {
              return const Wrap(
                  direction: Axis.vertical,
                  spacing: 16,
                  children: [
                    Row(spacing: 40, children: [
                      Text('小'),
                      CodeWrapper(builder: _buildSquareSmallSize),
                    ]),
                    Row(spacing: 40, children: [
                      Text('中'),
                      CodeWrapper(builder: _buildSquareMediumSize),
                    ]),
                    Row(spacing: 40, children: [
                      Text('大'),
                      CodeWrapper(builder: _buildSquareLargeSize),
                    ]),
                  ]);
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '带圆形底',
            builder: (BuildContext context) {
              return const Wrap(
                  direction: Axis.vertical,
                  spacing: 16,
                  children: [
                    Row(spacing: 40, children: [
                      Text('小'),
                      CodeWrapper(builder: _buildRoundSmallSize),
                    ]),
                    Row(
                      spacing: 40,
                      children: [
                        Text('中'),
                        CodeWrapper(builder: _buildRoundMediumSize),
                      ],
                    ),
                    Row(spacing: 40, children: [
                      Text('大'),
                      CodeWrapper(builder: _buildRoundLargeSize),
                    ]),
                  ]);
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '带单位',
            builder: (BuildContext context) {
              return const Wrap(
                  direction: Axis.vertical,
                  spacing: 16,
                  children: [
                    Row(spacing: 40, children: [
                      Text('小'),
                      CodeWrapper(builder: _buildUnitSmallSize),
                    ]),
                    Row(spacing: 40, children: [
                      Text('中'),
                      CodeWrapper(builder: _buildUnitMediumSize),
                    ]),
                    Row(spacing: 40, children: [
                      Text('大'),
                      CodeWrapper(builder: _buildUnitLargeSize),
                    ]),
                  ]);
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '无底色带单位',
            builder: (BuildContext context) {
              return const Wrap(
                  spacing: 8,
                  direction: Axis.vertical,
                  children: [
                    Row(spacing: 40, children: [
                      Text('小'),
                      CodeWrapper(builder: _buildCustomUnitSmallSize),
                    ]),
                    Row(spacing: 40, children: [
                      Text('中'),
                      CodeWrapper(builder: _buildCustomUnitMediumSize),
                    ]),
                    Row(spacing: 40, children: [
                      Text('大'),
                      CodeWrapper(builder: _buildCustomUnitLargeSize),
                    ]),
                  ]);
            },
          ),
        ]),
      ],
      test: const [
        ExampleItem(desc: '控制倒计时', builder: _buildControl),
        ExampleItem(desc: '自定义显示位数', builder: _buildCustomNum),
      ],
    );
  }
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildSimple(BuildContext context) {
  return const TDTimeCounter(time: 60 * 60 * 1000);
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildMillisecondSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildUpSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
    direction: TDTimeCounterDirection.up,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildSquareSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    theme: TDTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildRoundSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    theme: TDTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildUnitSimple(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildCustomUnitSimple(BuildContext context) {
  var style = TDTimeCounterStyle.generateStyle(context);
  style.timeColor = TDTheme.of(context).errorNormalColor;
  return TDTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildSquareSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
    theme: TDTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildSquareMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
    theme: TDTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildSquareLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
    theme: TDTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildRoundSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
    theme: TDTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildRoundMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
    theme: TDTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildRoundLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
    theme: TDTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildUnitSmallSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.small,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildUnitMediumSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.medium,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildUnitLargeSize(BuildContext context) {
  return const TDTimeCounter(
    time: 60 * 60 * 1000,
    size: TDTimeCounterSize.large,
    theme: TDTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildCustomUnitSmallSize(BuildContext context) {
  var style =
      TDTimeCounterStyle.generateStyle(context, size: TDTimeCounterSize.small);
  style.timeColor = TDTheme.of(context).errorNormalColor;
  return TDTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildCustomUnitMediumSize(BuildContext context) {
  var style =
      TDTimeCounterStyle.generateStyle(context, size: TDTimeCounterSize.medium);
  style.timeColor = TDTheme.of(context).errorNormalColor;
  return TDTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildCustomUnitLargeSize(BuildContext context) {
  var style =
      TDTimeCounterStyle.generateStyle(context, size: TDTimeCounterSize.large);
  style.timeColor = TDTheme.of(context).errorNormalColor;
  return TDTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
Widget _buildControl(BuildContext context) {
  var controller = TDTimeCounterController();
  return Wrap(
    direction: Axis.vertical,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    children: [
      TDTimeCounter(
        time: 60 * 60 * 1000,
        controller: controller,
        // autoStart: false,
      ),
      Wrap(
        spacing: 8,
        children: [
          TDButton(
            text: '开始',
            theme: TDButtonTheme.primary,
            onTap: () => controller.start(),
          ),
          TDButton(
            text: '结束',
            theme: TDButtonTheme.primary,
            onTap: () => controller.reset(0),
          ),
          TDButton(
            text: '重置',
            theme: TDButtonTheme.primary,
            onTap: () => controller.reset(),
          ),
          TDButton(
            text: '暂停',
            theme: TDButtonTheme.primary,
            onTap: () => controller.pause(),
          ),
          TDButton(
            text: '继续',
            theme: TDButtonTheme.primary,
            onTap: () => controller.resume(),
          ),
        ],
      )
    ],
  );
}

@Demo(group: 'timeCounter')
TDTimeCounter _buildCustomNum(BuildContext context) {
  return const TDTimeCounter(
    time: 2000 * 60 * 1000,
    format: 'mmmmmmm分sss秒',
  );
}
