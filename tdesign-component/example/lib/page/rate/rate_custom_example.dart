import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'rate')
class RateCustomExample extends StatelessWidget {
  const RateCustomExample({super.key});

  Widget _buildCustom(BuildContext context) => TCell(
    title: const Text('自定义评分'),
    note: RateCustomExampleStatefulRate(
      initialValue: 3,
      icon: (filled) => Icon(
        TIcons.thumb_up,
        color: filled
            ? context.tTheme.warningColor5
            : context.tTheme.bgColorComponent,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildCustom(context);
  }
}

class RateCustomExampleStatefulRate extends StatefulWidget {
  const RateCustomExampleStatefulRate({
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
  State<RateCustomExampleStatefulRate> createState() =>
      RateCustomExampleStatefulRateState();
}

class RateCustomExampleStatefulRateState
    extends State<RateCustomExampleStatefulRate> {
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
