import 'dart:math';

import 'package:flutter/material.dart';

class ProcessingTextWithDots extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Color dotColor;
  final double dotSize;
  final Duration animationDuration;

  const ProcessingTextWithDots({
    super.key,
    this.text = "Processing",
    this.textStyle,
    this.dotColor = Colors.blue,
    this.dotSize = 8.0,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<ProcessingTextWithDots> createState() => _ProcessingTextWithDotsState();
}

class _ProcessingTextWithDotsState extends State<ProcessingTextWithDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.text,
          style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(4, (index) {
                // Each dot has a slightly offset animation
                final animationValue = sin(
                  _controller.value * 2 * pi + (index * pi / 4),
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Transform.translate(
                    offset: Offset(0, -animationValue * 3),
                    child: Container(
                      width: widget.dotSize,
                      height: widget.dotSize,
                      decoration: BoxDecoration(
                        color: widget.dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}