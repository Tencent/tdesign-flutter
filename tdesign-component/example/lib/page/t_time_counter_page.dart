import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TTimeCounterPage extends StatelessWidget {
  const TTimeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
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

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildSimple(BuildContext context) {
  return const TTimeCounter(time: 60 * 60 * 1000);
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildMillisecondSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    showMillisecond: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildUpSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    showMillisecond: true,
    direction: TTimeCounterDirection.up,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildSquareSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    variant: TTimeCounterVariant.square,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildRoundSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    variant: TTimeCounterVariant.round,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildUnitSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    variant: TTimeCounterVariant.square,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildCustomUnitSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildSquareSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    variant: TTimeCounterVariant.square,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildSquareMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    variant: TTimeCounterVariant.square,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildSquareLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    variant: TTimeCounterVariant.square,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildRoundSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    variant: TTimeCounterVariant.round,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildRoundMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    variant: TTimeCounterVariant.round,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildRoundLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    variant: TTimeCounterVariant.round,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildUnitSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    variant: TTimeCounterVariant.square,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildUnitMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    variant: TTimeCounterVariant.square,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildUnitLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    variant: TTimeCounterVariant.square,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildCustomUnitSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildCustomUnitMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildCustomUnitLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
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
            child: const Text('开始'),
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => controller.start(),
          ),
          TButton(
            child: const Text('结束'),
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => controller.reset(0),
          ),
          TButton(
            child: const Text('重置'),
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => controller.reset(),
          ),
          TButton(
            child: const Text('暂停'),
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => controller.pause(),
          ),
          TButton(
            child: const Text('继续'),
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => controller.resume(),
          ),
        ],
      )
    ],
  );
}

@ExampleCode(group: 'timeCounter')
TTimeCounter _buildCustomNum(BuildContext context) {
  return const TTimeCounter(
    time: 2000 * 60 * 1000,
    format: 'mmmmmmm分sss秒',
  );
}
