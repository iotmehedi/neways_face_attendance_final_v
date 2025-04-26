import 'dart:math';
import 'package:flutter/material.dart';

class CircularDotsAnimation extends StatefulWidget {
  final double? dotSize;
  final int? padding;
  final double? radius;
  const CircularDotsAnimation({
    super.key,
    this.dotSize,
    this.padding,
    this.radius = 20.0, // Default circular radius
  });

  @override
  _CircularDotsAnimationState createState() => _CircularDotsAnimationState();
}

class _CircularDotsAnimationState extends State<CircularDotsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColors = [
      Colors.green,
      Colors.yellow,
      Colors.blue,
      Colors.lightBlue,
    ];

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            width: (widget.radius! * 2) + (widget.dotSize ?? 10),
            height: (widget.radius! * 2) + (widget.dotSize ?? 10),
            child: Stack(
              children: List.generate(5, (index) {
                // Calculate circular position
                final angle = 2 * pi * index / 5 + _controller.value * 2 * pi;
                final x = widget.radius! * cos(angle);
                final y = widget.radius! * sin(angle);

                return Positioned(
                  left: x + widget.radius!,
                  top: y + widget.radius!,
                  child: Container(
                    width: widget.dotSize ?? 10,
                    height: widget.dotSize ?? 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColors[index % dotColors.length],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}