import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDCountDownPage extends StatelessWidget {
  const TDCountDownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).grayColor2,
      child: ExamplePage(
        title: tdTitle(context),
        desc: '用于实时展示倒计时数值。',
        exampleCodeGroup: 'countDown',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
              ignoreCode: true,
              desc: '时分秒',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildSimple);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '带毫秒',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildMillisecondSimple);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '带方形底',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildSquareSimple);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '带圆形底',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildRoundSimple);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '带单位',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildUnitSimple);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '无底色带单位',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildCustomUnitSimple);
              },
            ),
          ]),
          ExampleModule(title: '组件尺寸', children: [
            ExampleItem(
              ignoreCode: true,
              desc: '纯数字',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(spacing: 8, direction: Axis.vertical, children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('小'),
                        ),
                        CodeWrapper(builder: _buildSmallSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('中'),
                        ),
                        CodeWrapper(builder: _buildMediumSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('大'),
                        ),
                        CodeWrapper(builder: _buildLargeSize),
                      ],
                    ),
                  ]),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '带方形底',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(spacing: 8, direction: Axis.vertical, children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('小'),
                        ),
                        CodeWrapper(builder: _buildSquareSmallSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('中'),
                        ),
                        CodeWrapper(builder: _buildSquareMediumSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('大'),
                        ),
                        CodeWrapper(builder: _buildSquareLargeSize),
                      ],
                    ),
                  ]),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '带圆形底',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(spacing: 8, direction: Axis.vertical, children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('小'),
                        ),
                        CodeWrapper(builder: _buildRoundSmallSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('中'),
                        ),
                        CodeWrapper(builder: _buildRoundMediumSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('大'),
                        ),
                        CodeWrapper(builder: _buildRoundLargeSize),
                      ],
                    ),
                  ]),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '带单位',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(spacing: 8, direction: Axis.vertical, children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('小'),
                        ),
                        CodeWrapper(builder: _buildUnitSmallSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('中'),
                        ),
                        CodeWrapper(builder: _buildUnitMediumSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('大'),
                        ),
                        CodeWrapper(builder: _buildUnitLargeSize),
                      ],
                    ),
                  ]),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '无底色带单位',
              center: false,
              padding: const EdgeInsets.only(left: 16),
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(spacing: 8, direction: Axis.vertical, children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('小'),
                        ),
                        CodeWrapper(builder: _buildCustomUnitSmallSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('中'),
                        ),
                        CodeWrapper(builder: _buildCustomUnitMediumSize),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Text('大'),
                        ),
                        CodeWrapper(builder: _buildCustomUnitLargeSize),
                      ],
                    ),
                  ]),
                );
              },
            ),
          ]),
        ],
        test: [
          ExampleItem(
            ignoreCode: true,
            desc: '控制倒计时',
            center: false,
            padding: const EdgeInsets.only(left: 16),
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildControl);
            },
          ),
        ],
      ),
    );
  }
}

@Demo(group: 'countDown')
TDCountDown _buildSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000);
}

@Demo(group: 'countDown')
TDCountDown _buildMillisecondSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000, millisecond: true);
}

@Demo(group: 'countDown')
TDCountDown _buildSquareSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000, theme: TDCountDownTheme.square);
}

@Demo(group: 'countDown')
TDCountDown _buildRoundSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000, theme: TDCountDownTheme.round);
}

@Demo(group: 'countDown')
TDCountDown _buildUnitSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000, theme: TDCountDownTheme.square, splitWithUnit: true);
}

@Demo(group: 'countDown')
TDCountDown _buildCustomUnitSimple(BuildContext context) {
  var style = TDCountDownStyle.generateStyle(context);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(time: 60 * 60 * 1000, splitWithUnit: true, style: style);
}

@Demo(group: 'countDown')
TDCountDown _buildSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildSquareSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.square,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildSquareMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.square,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildSquareLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.square,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildRoundSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.round,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildRoundMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.round,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildRoundLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.round,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildUnitSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildUnitMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildUnitLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildCustomUnitSmallSize(BuildContext context) {
  var style = TDCountDownStyle.generateStyle(context, size: TDCountDownSize.small);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildCustomUnitMediumSize(BuildContext context) {
  var style = TDCountDownStyle.generateStyle(context, size: TDCountDownSize.medium);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'countDown')
TDCountDown _buildCustomUnitLargeSize(BuildContext context) {
  var style = TDCountDownStyle.generateStyle(context, size: TDCountDownSize.large);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}

@Demo(group: 'countDown')
Widget _buildControl(BuildContext context) {
  var controller = TDCountDownController();
  return Wrap(
    direction: Axis.vertical,
    spacing: 8,
    children: [
      Wrap(
        spacing: 8,
        children: [
          TDButton(
            text: '开始',
            size: TDButtonSize.extraSmall,
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.start();
            },
          ),
          TDButton(
            text: '结束',
            size: TDButtonSize.extraSmall,
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.reset(0);
            },
          ),
          TDButton(
            text: '重置',
            size: TDButtonSize.extraSmall,
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.reset();
            },
          ),
          TDButton(
            text: '暂停',
            size: TDButtonSize.extraSmall,
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.pause();
            },
          ),
          TDButton(
            text: '继续',
            size: TDButtonSize.extraSmall,
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.resume();
            },
          ),
        ],
      ),
      TDCountDown(
        time: 60 * 60 * 1000,
        controller: controller,
        autoStart: false,
      ),
    ],
  );
}
