import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class FabSkeletonContent extends StatelessWidget {
  const FabSkeletonContent({super.key});
  Widget _buildSkeletonContent(BuildContext context) {
    Widget buildGroup() {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonLine(context, widthFactor: 1),
            const SizedBox(height: 16),
            _skeletonLine(context, widthFactor: 0.61),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        children: [
          Row(
            children: [buildGroup(), const SizedBox(width: 16), buildGroup()],
          ),
          const SizedBox(height: 32),
          Row(
            children: [buildGroup(), const SizedBox(width: 16), buildGroup()],
          ),
        ],
      ),
    );
  }

  Widget _skeletonLine(BuildContext context, {required double widthFactor}) =>
      FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 16,
          decoration: BoxDecoration(
            color: context.tTheme.bgColorSecondaryContainer,
            borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return _buildSkeletonContent(context);
  }
}
