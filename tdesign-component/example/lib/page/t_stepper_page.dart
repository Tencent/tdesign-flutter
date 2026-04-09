import 'package:flutter/material.dart';

import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TStepperPage extends StatefulWidget {
  const TStepperPage({Key? key}) : super(key: key);

  @override
  State<TStepperPage> createState() => _TStepperPageState();
}

class _TStepperPageState extends State<TStepperPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: ExamplePage(
        title: tdTitle(),
        desc: '用于数量的增减。',
        exampleCodeGroup: 'stepper',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '基础步进器', builder: _buildStepperWithBase),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '最大最小状态', builder: _buildStepperWithMaxMinStatus),
            ExampleItem(desc: '禁用状态', builder: _buildStepperWithDisableStatus)
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '步进器样式', builder: _buildStepperWithTheme),
            ExampleItem(desc: '步进器尺寸', builder: _buildStepperWithSize)
          ]),
        ],
        test: [
          ExampleItem(desc: '自定义stepValue', builder: _customStepperValue),
        ],
      ),
    );
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithBase(BuildContext context) {
    return _buildRow(context, [
      const TStepper(
        theme: TStepperTheme.filled,
      )
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithMaxMinStatus(BuildContext context) {
    return _buildRow(context, [
      const TStepper(theme: TStepperTheme.filled, value: 0, min: 0),
      const TStepper(theme: TStepperTheme.filled, value: 999, max: 999),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithDisableStatus(BuildContext context) {
    return _buildRow(context, [
      const TStepper(
        theme: TStepperTheme.filled,
        disabled: true,
      ),
      const TStepper(
        theme: TStepperTheme.outline,
        disabled: true,
      ),
      const TStepper(
        theme: TStepperTheme.normal,
        disabled: true,
      ),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithTheme(BuildContext context) {
    return _buildRow(context, [
      const TStepper(theme: TStepperTheme.filled, value: 3),
      const TStepper(theme: TStepperTheme.outline, value: 3),
      const TStepper(theme: TStepperTheme.normal, value: 3),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithSize(BuildContext context) {
    return _buildRow(context, [
      const TStepper(
          size: TStepperSize.large, theme: TStepperTheme.filled, value: 3),
      const TStepper(
          size: TStepperSize.medium, theme: TStepperTheme.filled, value: 3),
      const TStepper(
          size: TStepperSize.small, theme: TStepperTheme.filled, value: 3),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildRow(BuildContext context, List<Widget> stepperItems) {
    final theme = TTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.bgColorContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: stepperItems
              .map((item) => SizedBox(
                    width: (MediaQuery.of(context).size.width - 32) / 3,
                    child: item,
                  ))
              .toList(),
        ),
      ),
    );
  }

  var controller = TStepperController()..value = 1;

  @Demo(group: 'stepper')
  Widget _customStepperValue(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TStepper(
            theme: TStepperTheme.filled,
            controller: controller,
          ),
          TButton(
            text: 'value * 2',
            onTap: () {
              controller.value *= 2;
            },
          )
        ],
      ),
    );
  }
}
