import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class BreathingAnimation extends StatefulWidget {
  final double size;
  final Duration duration;
  final Color? color;

  const BreathingAnimation({
    Key? key,
    this.size = 200.0,
    this.duration = const Duration(seconds: 4),
    this.color,
  }) : super(key: key);

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _glowController;
  late Animation<double> _breathAnimation;
  late Animation<double> _glowAnimation;
  
  bool _isInhaling = true;

  @override
  void initState() {
    super.initState();
    
    _breathController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _breathAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _breathController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isInhaling = false);
        _breathController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _isInhaling = true);
        _breathController.forward();
      }
    });

    _breathController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathAnimation, _glowAnimation]),
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (widget.color ?? AppColors.accent).withOpacity(0.8),
                    (widget.color ?? AppColors.accent).withOpacity(0.3),
                    (widget.color ?? AppColors.accent).withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.color ?? AppColors.accentLight)
                        .withOpacity(_glowAnimation.value),
                    blurRadius: 30 * _breathAnimation.value,
                    spreadRadius: 10 * _breathAnimation.value,
                  ),
                ],
              ),
              child: Transform.scale(
                scale: _breathAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color ?? AppColors.accent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _isInhaling ? 'Вдохни...' : 'Выдохни...',
                key: ValueKey(_isInhaling),
                style: AppTextStyles.breathingText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PulsingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulsingWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}