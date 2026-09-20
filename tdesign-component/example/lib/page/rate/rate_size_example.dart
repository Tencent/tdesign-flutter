import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'rate')
class RateSizeExample extends StatelessWidget {
  const RateSizeExample({super.key});

  Widget _buildSize(BuildContext context) => Column(
    children: [
      TCell(
        title: const Text('大尺寸 24'),
        note: Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TRateThemeData(iconSize: 24)),
          child: const RateSizeExampleStatefulRate(initialValue: 3),
        ),
      ),
      SizedBox(height: context.tTheme.spacer16),
      TCell(
        title: const Text('小尺寸 20'),
        note: Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TRateThemeData(iconSize: 20)),
          child: const RateSizeExampleStatefulRate(initialValue: 3),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return _buildSize(context);
  }
}

class RateSizeExampleStatefulRate extends StatefulWidget {
  const RateSizeExampleStatefulRate({
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
  State<RateSizeExampleStatefulRate> createState() =>
      RateSizeExampleStatefulRateState();
}

class RateSizeExampleStatefulRateState
    extends State<RateSizeExampleStatefulRate> {
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
