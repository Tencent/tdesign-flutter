/*
 * Created by dorayhong@tencent.com on 6/8/23.
 */
import 'package:flutter/material.dart';

import '../../../td_export.dart';
import 'td_collapse_salted_key.dart';
import 'td_nonanimated_expand_icon.dart';

typedef PressCallback = void Function(int panelIndex, bool isExpanded);
typedef TDCollapseIconTextBuilder = String Function(
    BuildContext context, bool isExpanded);

class TDCollapsePanelHeader extends StatelessWidget {
  const TDCollapsePanelHeader({
    required this.index,
    required this.animationDuration,
    required this.borderRadius,
    required this.onPress,
    required this.isExpanded,
    required this.headerBuilder,
    this.expandIconTextBuilder,
    Key? key,
  }) : super(key: key);

  final int index;
  final Duration animationDuration;
  final BorderRadius borderRadius;
  final PressCallback onPress;
  final bool isExpanded;
  final ExpansionPanelHeaderBuilder headerBuilder;
  final TDCollapseIconTextBuilder? expandIconTextBuilder;

  @override
  Widget build(BuildContext context) {
    final titleWidget = _buildTitleWidget(context);
    final expandIconWidget = _buildExpandIconWidget(context);

    Widget headerWidget = Row(children: [
      Expanded(
        child: AnimatedContainer(
          key: TDCollapseSaltedKey<BuildContext, int>(context, index * 2),
          duration: animationDuration,
          curve: Curves.fastOutSlowIn,
          margin: EdgeInsets.zero,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            child: titleWidget,
          ),
        ),
      ),
      expandIconWidget,
    ]);

    headerWidget = MergeSemantics(
      child: InkWell(
        borderRadius: borderRadius,
        child: headerWidget,
        onTap: () => onPress(index, isExpanded),
      ),
    );

    return headerWidget;
  }

  Widget _buildTitleWidget(BuildContext context) {
    final titleWidget = headerBuilder(context, isExpanded);
    return ListTile(
      title: titleWidget,
    );
  }

  Widget _buildExpandIconWidget(BuildContext context) {
    Widget expandedIcon = Container(
      key: TDCollapseSaltedKey<BuildContext, int>(context, index * 2),
      margin: const EdgeInsetsDirectional.all(0.0),
      child: TdNonAnimatedExpandIcon(
        isExpanded: isExpanded,
        padding: expandIconTextBuilder != null
            ? EdgeInsets.only(
                right: TDTheme.of(context).spacer16,
                top: TDTheme.of(context).spacer16,
                bottom: TDTheme.of(context).spacer16,
                left: 0,
              )
            : EdgeInsets.all(TDTheme.of(context).spacer16),
      ),
    );

    return Row(
      children: [
        if (expandIconTextBuilder != null)
          Text(expandIconTextBuilder!(context, isExpanded),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
              )),
        expandedIcon,
      ],
    );
  }
}
