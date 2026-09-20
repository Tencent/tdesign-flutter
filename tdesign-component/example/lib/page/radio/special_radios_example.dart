import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radio')
class SpecialRadiosExample extends StatefulWidget {
  const SpecialRadiosExample({super.key});

  @override
  State<SpecialRadiosExample> createState() => _SpecialRadiosExampleState();
}

class _SpecialRadiosExampleState extends State<SpecialRadiosExample> {
  Widget _specialRadios(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRadioGroup<int>.options(
          key: const ValueKey('radio-vertical-card-layout'),
          value: _verticalSpecialCardValue,
          options: _specialVerticalOptions,
          variant: TRadioVariant.card,
          subTitleMaxLines: 1,
          onChanged: (value) =>
              setState(() => _verticalSpecialCardValue = value),
        ),
        SizedBox(height: context.tTheme.spacer24),
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.tTheme.spacer16,
            0,
            context.tTheme.spacer16,
            context.tTheme.spacer16,
          ),
          child: TText('横向卡片单选框', textColor: context.tTheme.textColorSecondary),
        ),
        TRadioGroup<int>.options(
          key: const ValueKey('radio-horizontal-card-layout'),
          value: _horizontalCardValue,
          options: _specialHorizontalOptions,
          direction: Axis.horizontal,
          columns: 3,
          variant: TRadioVariant.card,
          onChanged: (value) => setState(() => _horizontalCardValue = value),
        ),
      ],
    );
  }

  int? _verticalSpecialCardValue = 0;

  static const _specialVerticalOptions = [
    TRadioOption(value: 0, label: '单选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
    TRadioOption(value: 1, label: '单选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
    TRadioOption(value: 2, label: '单选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
  ];

  int? _horizontalCardValue = 0;

  static const _specialHorizontalOptions = [
    TRadioOption(value: 0, label: '单选'),
    TRadioOption(value: 1, label: '单选'),
    TRadioOption(value: 2, label: '单选'),
  ];

  @override
  Widget build(BuildContext context) {
    return _specialRadios(context);
  }
}
