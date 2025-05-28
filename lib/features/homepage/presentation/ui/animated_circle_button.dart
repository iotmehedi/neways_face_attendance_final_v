import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';


import '../../../../core/utils/common_toast/custom_toast.dart';
import '../../../../core/utils/consts/app_colors.dart';
import '../../../../core/utils/consts/app_sizes.dart';
import '../../../../main.dart';
import '../../../widgets/circular_dot_animation/circular_dot_animation.dart';
import '../../../widgets/custom_elevatedButton/custom_text.dart';
import '../controller/get_employee_face_controller.dart';
import 'camera_page.dart';

class CircleProgressButton extends StatefulWidget {
  final double size;
  final Color buttonColor;
  final Color progressColor;
  final Duration duration;
  final VoidCallback? onCompleted; // 👈 New Callback
  final VoidCallback? onTap; // 👈 New Callback

  const CircleProgressButton({
    Key? key,
    this.size = 80,
    this.buttonColor = Colors.blue,
    this.progressColor = Colors.white,
    this.duration = const Duration(milliseconds: 500),
    this.onCompleted,
    this.onTap,
  }) : super(key: key);

  @override
  _CircleProgressButtonState createState() => _CircleProgressButtonState();
}

class _CircleProgressButtonState extends State<CircleProgressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isCompleted = true;
        print('done');
        _controller.reset();
        widget.onCompleted?.call(); // 👈 Call the function
        setState(() {
          _isPressed = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePressStart() {
    _isCompleted = false;
    setState(() => _isPressed = true);
    _controller.forward();
    widget.onTap?.call();
  }

  void _handlePressEnd() {
    if (!_isCompleted) {
      print('not done');
      _controller.reset();
    }
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onLongPressStart: (_) => _handlePressStart(),
      // onLongPressEnd: (_) => _handlePressEnd(),
      onTap: widget.onTap,
      onTapDown: (_) => _handlePressStart(),
      onTapUp: (_) => _handlePressEnd(),
      onTapCancel: _handlePressEnd,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _CircleProgressPainter(
          progress: _controller.value,
          isPressed: _isPressed,
          buttonColor: widget.buttonColor,
          progressColor: widget.progressColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 130),
          child: Center(
            child: Icon(
              Icons.touch_app,
              color: Colors.white,
              size: widget.size * 0.25,
            ),
          ),
        ),
      ),
    );
  }
}


class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final bool isPressed;
  final Color buttonColor;
  final Color progressColor;

  _CircleProgressPainter({
    required this.progress,
    required this.isPressed,
    required this.buttonColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw main button
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = buttonColor
        ..style = PaintingStyle.fill,
    );

    // Draw progress indicator
    if (isPressed) {
      final paint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10.0
        ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: center, radius: radius - 2);
      canvas.drawArc(
        rect,
        -0.5 * 3.14, // Start from top
        2 * 3.14 * progress, // Progress arc
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        isPressed != oldDelegate.isPressed ||
        buttonColor != oldDelegate.buttonColor ||
        progressColor != oldDelegate.progressColor;
  }
}