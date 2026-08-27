import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TRate 演示。
class TRatePage extends StatelessWidget {
  const TRatePage({super.key});

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(context),
    desc: '用于对某行为/事物进行打分。',
    exampleCodeGroup: 'rate',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(desc: '实心评分', builder: _buildBasic, center: false),
          ExampleItem(desc: '自定义评分', builder: _buildCustom, center: false),
          ExampleItem(
            desc: '第三方图标评分',
            builder: _buildThirdPartyIcon,
            center: false,
          ),
          ExampleItem(desc: '自定义评分数量', builder: _buildCount, center: false),
          ExampleItem(desc: '带描述评分', builder: _buildShowText, center: false),
        ],
      ),
      ExampleModule(
        title: '组件状态',
        children: [ExampleItem(builder: _buildAction, center: false)],
      ),
      ExampleModule(
        title: '组件样式',
        children: [
          ExampleItem(desc: '评分大小', builder: _buildSize, center: false),
          ExampleItem(desc: '设置评分颜色', builder: _buildColor, center: false),
        ],
      ),
      ExampleModule(
        title: '特殊样式',
        children: [
          ExampleItem(desc: '竖向带描述评分', builder: _buildVertical, center: false),
        ],
      ),
    ],
  );

  @ExampleCode(group: 'rate')
  Widget _buildBasic(BuildContext context) =>
      const TCell(title: Text('实心评分'), note: _StatefulRate(initialValue: 3));

  @ExampleCode(group: 'rate')
  Widget _buildCustom(BuildContext context) => TCell(
    title: const Text('自定义评分'),
    note: _StatefulRate(
      initialValue: 3,
      icon: (filled) => Icon(
        filled ? Icons.thumb_up : Icons.thumb_up_outlined,
        color: filled
            ? context.tTheme.warningColor5
            : context.tTheme.bgColorComponent,
      ),
    ),
  );

  @ExampleCode(group: 'rate')
  Widget _buildThirdPartyIcon(BuildContext context) => TCell(
    title: const Text('第三方图标'),
    note: _StatefulRate(
      initialValue: 3,
      icon: (filled) => Icon(
        filled ? Icons.favorite : Icons.favorite_border,
        color: filled
            ? context.tTheme.warningColor5
            : context.tTheme.bgColorComponent,
      ),
    ),
  );

  @ExampleCode(group: 'rate')
  Widget _buildCount(BuildContext context) => const TCell(
    title: Text('自定义评分数量'),
    note: _StatefulRate(initialValue: 2, count: 3),
  );

  @ExampleCode(group: 'rate')
  Widget _buildShowText(BuildContext context) => Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TRateThemeData(showText: true, textWidth: 40)),
    child: const Column(
      children: [
        _RateRow(
          title: '带描述评分',
          rate: _StatefulRate(
            initialValue: 3,
            texts: ['1分', '2分', '3分', '4分', '5分'],
          ),
        ),
        _RateRow(
          title: '带描述评分',
          rate: _StatefulRate(
            initialValue: 3,
            texts: ['极差', '失望', '一般', '满意', '惊喜'],
          ),
        ),
        _RateRow(title: '带描述评分', rate: _StatefulRate(initialValue: 0)),
      ],
    ),
  );

  @ExampleCode(group: 'rate')
  Widget _buildAction(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _RateGroupLabel('只可选全星时'),
      TCell(title: Text('点击或滑动'), note: _StatefulRate(initialValue: 3.5)),
      _RateGroupLabel('只可选半星时', top: 24),
      TCell(
        title: Text('点击或滑动'),
        note: _StatefulRate(initialValue: 3, allowHalf: true),
      ),
    ],
  );

  @ExampleCode(group: 'rate')
  Widget _buildSize(BuildContext context) => Column(
    children: [
      TCell(
        title: const Text('大尺寸 24'),
        note: Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TRateThemeData(iconSize: 24)),
          child: const _StatefulRate(initialValue: 3),
        ),
      ),
      TCell(
        title: const Text('小尺寸 20'),
        note: Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TRateThemeData(iconSize: 20)),
          child: const _StatefulRate(initialValue: 3),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'rate')
  Widget _buildColor(BuildContext context) => Column(
    children: [
      TCell(
        title: const Text('填充评分'),
        note: Theme(
          data: Theme.of(context).mergeExtension(
            const TRateThemeData(
              starColor: Color(0xFFF96102),
              inactiveStarColor: Color(0xFFBBBBBB),
            ),
          ),
          child: const _StatefulRate(initialValue: 3, allowHalf: true),
        ),
      ),
      TCell(
        title: const Text('线描评分'),
        note: Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TRateThemeData(starColor: Color(0xFF00A870))),
          child: _StatefulRate(
            initialValue: 3,
            icon: (filled) => Icon(
              filled ? Icons.star : Icons.star_border,
              color: filled
                  ? const Color(0xFF00A870)
                  : context.tTheme.bgColorComponent,
            ),
          ),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'rate')
  Widget _buildVertical(BuildContext context) => const Padding(
    padding: EdgeInsets.all(16),
    child: Center(child: _VerticalRate()),
  );
}

class _RateGroupLabel extends StatelessWidget {
  const _RateGroupLabel(this.text, {this.top = 8});
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

class _RateRow extends StatelessWidget {
  const _RateRow({required this.title, required this.rate});

  final String title;
  final Widget rate;

  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: context.tTheme.bgColorContainer,
    child: Row(
      children: [
        SizedBox(width: 100, child: TText(title)),
        const Spacer(),
        rate,
      ],
    ),
  );
}

class _StatefulRate extends StatefulWidget {
  const _StatefulRate({
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
  State<_StatefulRate> createState() => _StatefulRateState();
}

class _StatefulRateState extends State<_StatefulRate> {
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

class _VerticalRate extends StatefulWidget {
  const _VerticalRate();
  @override
  State<_VerticalRate> createState() => _VerticalRateState();
}

class _VerticalRateState extends State<_VerticalRate> {
  static const _texts = ['非常糟糕', '有些糟糕', '可以尝试', '可以前往', '推荐前往'];
  double value = 4;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Theme(
        data: Theme.of(
          context,
        ).mergeExtension(const TRateThemeData(iconSize: 30)),
        child: TRate(
          value: value,
          onChanged: (next) => setState(() => value = next),
        ),
      ),
      const SizedBox(height: 12),
      TText(
        _texts[value.ceil().clamp(1, _texts.length) - 1],
        font: value > 3 ? context.tTheme.fontBodyLarge : null,
        textColor: value > 3 ? context.tTheme.warningColor5 : null,
      ),
    ],
  );
}
