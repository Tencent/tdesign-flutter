import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/long_press.dart';

import '../../../tdesign_flutter.dart';

typedef OnChange = void Function(double);

enum Variant { outline, filled }

///
/// TDRate component
///
class TDRate extends StatefulWidget {
  final bool allowHalf;
  final dynamic color;
  final int count;
  final bool disabled;
  final double gap;
  final bool showText;
  final double size;
  final List<String> texts;
  final double defaultValue;
  final Variant variant;
  final OnChange onChange;
  final IconData filledIcon;
  final IconData outlineIcon;
  final IconData halfFilledIcon;
  final IconData halfOutlineIcon;

  const TDRate({
    super.key,
    this.allowHalf = false,
    this.color = const Color(0xFFED7B2F),
    this.count = 5,
    this.disabled = false,
    this.gap = 2.0,
    this.showText = false,
    this.size = 20.0,
    this.texts = const ['极差', '失望', '一般', '满意', '惊喜'],
    this.defaultValue = 0,
    this.variant = Variant.outline,
    required this.onChange,
    this.filledIcon = Icons.star,
    this.outlineIcon = Icons.star_border,
    this.halfFilledIcon = Icons.star_half,
    this.halfOutlineIcon = Icons.star_border_outlined,
  });

  @override
  _TDRateState createState() => _TDRateState();
}

class _TDRateState extends State<TDRate> {
  double _value = 0;
  // late OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
    if (widget.texts.length != widget.count) {
      throw ArgumentError('The length of texts array must be equal to count.');
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.disabled) return;
    // overlayEntry.remove(); // 立即移除 OverlayEntry
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset local = box.globalToLocal(details.globalPosition);

    final double starWidth = widget.size;
    final double gapWidth = widget.gap;

    // Calculate which star was clicked
    final int starIndex = (local.dx / (starWidth + gapWidth)).floor();

    // Calculate the position within the star
    final double positionInStar = local.dx - starIndex * (starWidth + gapWidth);

    double newValue;
    if (positionInStar <= starWidth) {
      // If the click was within the star, check if it was in the first half or the second half
      newValue = widget.allowHalf && positionInStar < starWidth / 2
          ? starIndex + 0.5
          : starIndex + 1;
    } else {
      // weather change the value or not??
      return;
    }

    if (newValue > widget.count) {
      newValue = widget.count.toDouble();
    }

    // if value is not changed, set value to 0
    setState(() {
      _value = newValue == _value ? 0 : newValue;
    });
    widget.onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTapUp: _handleTapUp,
          // onTapDown: _handleTapDown,
          // onTapCancel: () => overlayEntry.remove(),
          child: Row(
            children: List.generate(
              widget.count,
              (index) {
                if (_value >= index + 1) {
                  return Icon(
                    widget.variant == Variant.filled
                        ? widget.filledIcon
                        : widget.outlineIcon,
                    color: widget.color,
                    size: widget.size,
                  );
                } else if (_value > index &&
                    _value < index + 1 &&
                    widget.allowHalf) {
                  return Icon(
                    widget.variant == Variant.filled
                        ? widget.halfFilledIcon
                        : widget.halfOutlineIcon,
                    color: widget.color,
                    size: widget.size,
                  );
                } else {
                  return Icon(
                    widget.variant == Variant.filled
                        ? widget.filledIcon
                        : widget.outlineIcon,
                    color: Colors.grey,
                    size: widget.size,
                  );
                }
              },
            ).expand((icon) => [icon, SizedBox(width: widget.gap)]).toList()
              ..removeLast(),
          ),
        ),
        if (widget.showText)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              _value == 0 ? '未评分' : widget.texts[_safeIndex(_value)],
              style: TextStyle(
                color: widget.color,
                fontSize: widget.size / 2,
              ),
            ),
          ),
      ],
    );
  }

  _safeIndex(double value) {
    // 饥饿模式
    if (value.floor() == widget.texts.length) {
      return widget.texts.length - 1;
    }
    var index = value.floor().clamp(0, widget.texts.length - 1);
    if (index >= 1) {
      return index - 1;
    }
    return index;
  }
  // void _handleTapDown(TapDownDetails details) {
  //   if (widget.disabled) return;
  //   final RenderBox box = context.findRenderObject() as RenderBox;
  //   final Offset local = box.globalToLocal(details.globalPosition);

  //   final double starWidth = widget.size;
  //   final double gapWidth = widget.gap;

  //   // Calculate which star was clicked
  //   final int starIndex = (local.dx / (starWidth + gapWidth)).floor();

  //   // Calculate the position within the star
  //   final double positionInStar = local.dx - starIndex * (starWidth + gapWidth);

  //   if (positionInStar <= starWidth && widget.allowHalf) {
  //     // If the click was within the star and allowHalf is true, show the tooltip
  //     final overlay = Overlay.of(context);
  //     var overlayEntry = OverlayEntry(
  //       // 显示在当前点击的正中间上方
  //       builder: (context) => Positioned(
  //         left: details.globalPosition.dx - 20,
  //         top: details.globalPosition.dy - 40,
  //         child: Container(
  //           padding: const EdgeInsets.all(4),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.8),
  //             borderRadius: const BorderRadius.all(Radius.circular(4)),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.only(right: 4),
  //                 child: Column(
  //                   children: [
  //                     Icon(
  //                       widget.variant == Variant.filled
  //                           ? widget.halfFilledIcon
  //                           : widget.halfOutlineIcon,
  //                       color: widget.color,
  //                       size: 12,
  //                     ),
  //                     Text(
  //                       '${starIndex + 0.5}',
  //                       style: const TextStyle(
  //                         fontSize: 8,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                 padding: const EdgeInsets.only(right: 4),
  //                 child: Column(
  //                   children: [
  //                     Icon(
  //                       widget.variant == Variant.filled
  //                           ? widget.filledIcon
  //                           : widget.outlineIcon,
  //                       color: widget.color,
  //                       size: 12,
  //                     ),
  //                     Text(
  //                       '${starIndex + 1}',
  //                       style: const TextStyle(
  //                         fontSize: 8,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //     overlay.insert(overlayEntry);
  //   }
  // }
}
