import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'calendar')
class CalendarInlineExample extends StatefulWidget {
  const CalendarInlineExample({super.key, this.referenceDate});

  final DateTime? referenceDate;

  @override
  State<CalendarInlineExample> createState() => _CalendarInlineExampleState();
}

class _CalendarInlineExampleState extends State<CalendarInlineExample> {
  Widget _buildInline(BuildContext context) => ColoredBox(
    color: context.tTheme.bgColorContainer,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(context.tTheme.spacer16),
          child: TText('日历标题', font: context.tTheme.fontTitleLarge),
        ),
        TCalendar(
          key: const ValueKey('calendar-inline-panel'),
          value: _inlineValue,
          variant: TCalendarVariant.multiple,
          minDate: DateTime(2021, 3),
          maxDate: DateTime(2030, 3, 2),
          onChanged: (value) => setState(() => _inlineValue = value),
        ),
        Padding(
          padding: EdgeInsets.all(context.tTheme.spacer16),
          child: SizedBox(
            width: double.infinity,
            child: TButton(
              colorScheme: TButtonColorScheme.primary,
              size: TButtonSize.large,
              onPressed: _inlineValue.isEmpty
                  ? null
                  : () => TToast.showText(
                      _formatDates(_inlineValue),
                      context: context,
                    ),
              child: const Text('确定'),
            ),
          ),
        ),
      ],
    ),
  );

  late List<DateTime> _inlineValue;

  String _formatDates(List<DateTime> dates) => dates.map(_formatDate).join('、');

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  void initState() {
    super.initState();
    final now = widget.referenceDate ?? DateTime(2023, 3, 10);
    _referenceDate = DateTime(now.year, now.month, now.day);
    _inlineValue = [_referenceDate];
  }

  late final DateTime _referenceDate;

  @override
  Widget build(BuildContext context) {
    return _buildInline(context);
  }
}
