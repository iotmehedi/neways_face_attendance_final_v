import 'dart:math';
import 'package:flutter/material.dart';

class WaveDotsAnimation extends StatefulWidget {
  final double? dotSize;
  final int? padding;
  const WaveDotsAnimation({super.key, this.dotSize, this.padding});
  @override
  _WaveDotsAnimationState createState() => _WaveDotsAnimationState();
}

class _WaveDotsAnimationState extends State<WaveDotsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust speed
    )..repeat(); // Infinite loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of colors to cycle through
    List<Color> dotColors = [
      Colors.green,
      Colors.yellow,
      Colors.blue,
      Colors.lightBlue,
    ];

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              double waveHeight =
                  10 * sin(_controller.value * 2 * pi + index * pi / 5);
              return Transform.translate(
                offset: Offset(0, waveHeight),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal:
                      widget.padding?.toDouble() ?? 3), // Dot spacing
                  height: widget.dotSize ?? 10, // Dot size
                  width: widget.dotSize ?? 10, // Dot size
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColors[index % dotColors.length],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}