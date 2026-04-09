import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TTimeCounterPage extends StatelessWidget {
  const TTimeCounterPage({super.key});

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
                  Row(
                    // spacing: 40,
                    children: [
                      Text('小'),
                      SizedBox(width: 40),
                      CodeWrapper(builder: _buildSmallSize),
                    ],
                  ),
                  Row(
                    // spacing: 40,
                    children: [
                      Text('中'),
                      SizedBox(width: 40),
                      CodeWrapper(builder: _buildMediumSize)
                    ],
                  ),
                  Row(
                    // spacing: 40,
                    children: [
                      Text('大'),
                      SizedBox(width: 40),
                      CodeWrapper(builder: _buildLargeSize),
                    ],
                  ),
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
                    Row(
                      // spacing: 40,
                      children: [
                        Text('小'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildSquareSmallSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('中'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildSquareMediumSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('大'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildSquareLargeSize),
                      ],
                    ),
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
                    Row(
                      // spacing: 40,
                      children: [
                        Text('小'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildRoundSmallSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('中'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildRoundMediumSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('大'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildRoundLargeSize),
                      ],
                    ),
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
                    Row(
                      // spacing: 40,
                      children: [
                        Text('小'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildUnitSmallSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('中'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildUnitMediumSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('大'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildUnitLargeSize),
                      ],
                    ),
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
                    Row(
                      // spacing: 40,
                      children: [
                        Text('小'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildCustomUnitSmallSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('中'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildCustomUnitMediumSize),
                      ],
                    ),
                    Row(
                      // spacing: 40,
                      children: [
                        Text('大'),
                        SizedBox(width: 40),
                        CodeWrapper(builder: _buildCustomUnitLargeSize),
                      ],
                    ),
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
TTimeCounter _buildSimple(BuildContext context) {
  return const TTimeCounter(time: 60 * 60 * 1000);
}

@Demo(group: 'timeCounter')
TTimeCounter _buildMillisecondSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildUpSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
    direction: TTimeCounterDirection.up,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildSquareSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    theme: TTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildRoundSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    theme: TTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildUnitSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildCustomUnitSimple(BuildContext context) {
  var style = TTimeCounterStyle.generateStyle(context);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildSquareSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildSquareMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildSquareLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.square,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildRoundSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildRoundMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildRoundLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.round,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildUnitSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildUnitMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildUnitLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildCustomUnitSmallSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.small);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildCustomUnitMediumSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.medium);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildCustomUnitLargeSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.large);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'timeCounter')
Widget _buildControl(BuildContext context) {
  var controller = TTimeCounterController();
  return Wrap(
    direction: Axis.vertical,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    children: [
      TTimeCounter(
        time: 60 * 60 * 1000,
        controller: controller,
        // autoStart: false,
      ),
      Wrap(
        spacing: 8,
        children: [
          TButton(
            text: '开始',
            theme: TButtonTheme.primary,
            onTap: () => controller.start(),
          ),
          TButton(
            text: '结束',
            theme: TButtonTheme.primary,
            onTap: () => controller.reset(0),
          ),
          TButton(
            text: '重置',
            theme: TButtonTheme.primary,
            onTap: () => controller.reset(),
          ),
          TButton(
            text: '暂停',
            theme: TButtonTheme.primary,
            onTap: () => controller.pause(),
          ),
          TButton(
            text: '继续',
            theme: TButtonTheme.primary,
            onTap: () => controller.resume(),
          ),
        ],
      )
    ],
  );
}

@Demo(group: 'timeCounter')
TTimeCounter _buildCustomNum(BuildContext context) {
  return const TTimeCounter(
    time: 2000 * 60 * 1000,
    format: 'mmmmmmm分sss秒',
  );
}
