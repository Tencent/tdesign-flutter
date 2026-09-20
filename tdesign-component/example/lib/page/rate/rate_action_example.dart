import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'rate')
class RateActionExample extends StatelessWidget {
  const RateActionExample({super.key});

  Widget _buildAction(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RateActionExampleRateGroupLabel('只可选全星时'),
      TCell(
        title: Text('点击或滑动'),
        note: RateActionExampleStatefulRate(initialValue: 3),
      ),
      RateActionExampleRateGroupLabel('只可选半星时', top: 24),
      TCell(
        title: Text('点击或滑动'),
        note: RateActionExampleStatefulRate(initialValue: 3, allowHalf: true),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return _buildAction(context);
  }
}

class RateActionExampleRateGroupLabel extends StatelessWidget {
  const RateActionExampleRateGroupLabel(this.text, {super.key, this.top = 8});
  final String text;
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(16, top, 16, 16),
    child: TText(
      text,
      font: context.tTheme.fontBodyMedium,
      textColor: context.tTheme.textColorSecondary,
    ),
  );
}

class RateActionExampleStatefulRate extends StatefulWidget {
  const RateActionExampleStatefulRate({
    super.key,
    required this.initialValue,
    this.count = 5,
    this.allowHalf = false,
    this.icon,
    this.texts,
  });
  final double initialValue;
  final int count;
  final bool allowHalf;
  final TRateIconBuilder? icon;
  final List<String>? texts;

  @override
  State<RateActionExampleStatefulRate> createState() =>
      RateActionExampleStatefulRateState();
}

class RateActionExampleStatefulRateState
    extends State<RateActionExampleStatefulRate> {
  late double value = widget.initialValue;

  @override
  Widget build(BuildContext context) => TRate(
    value: value,
    count: widget.count,
    allowHalf: widget.allowHalf,
    icon: widget.icon,
    texts: widget.texts,
    onChanged: (next) => setState(() => value = next),
  );
}
