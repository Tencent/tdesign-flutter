import 'package:flutter/material.dart';

class DynamicProgressBar extends StatefulWidget {
  final double percentage;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final Color labelColor;
  final double labelWidth;
  final double fontSize;
  final bool showLabel;
  final Duration animationDuration;

  const DynamicProgressBar({
    Key? key,
    required this.percentage,
    this.height = 20.0,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.progressColor = Colors.blue,
    this.labelColor = Colors.black,
    this.labelWidth = 40.0,
    this.fontSize = 12.0,
    this.showLabel = true,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  DynamicProgressBarState createState() => DynamicProgressBarState();
}

class DynamicProgressBarState extends State<DynamicProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(_animationController);
    _animationController.forward();
  }

  @override
  void didUpdateWidget(DynamicProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: oldWidget.percentage,
        end: widget.percentage,
      ).animate(_animationController);
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final currentPercentage = _animation.value;
            final progressWidth = (currentPercentage / 100) * maxWidth;
            final isLessThanTen = currentPercentage < 10;

            return Stack(
              children: [
                // Background
                Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
                // Progress
                Container(
                  height: widget.height,
                  width: progressWidth,
                  decoration: BoxDecoration(
                    color: widget.progressColor,
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
                // Label
                if (widget.showLabel)
                  Positioned(
                    left: isLessThanTen ? progressWidth : progressWidth - widget.labelWidth,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: widget.labelWidth,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '${currentPercentage.toInt()}%',
                        style: TextStyle(
                          color: isLessThanTen ? widget.labelColor : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}