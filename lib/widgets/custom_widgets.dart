import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class GlowingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? glowColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const GlowingButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.glowColor,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onPressed,
          child: Container(
            width: widget.width,
            height: widget.height ?? AppDimensions.buttonHeight,
            padding: widget.padding ?? const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? AppColors.accent,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: (widget.glowColor ?? AppColors.accentLight)
                      .withOpacity(_glowAnimation.value * (_isPressed ? 1.2 : 1.0)),
                  blurRadius: _isPressed ? 20 : 15,
                  spreadRadius: _isPressed ? 5 : 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: AppTextStyles.buttonText.copyWith(
                  color: widget.textColor ?? AppColors.supportText,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  const MenuCard({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.cardElevation,
      color: backgroundColor ?? AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        side: BorderSide(
          color: borderColor ?? AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: AppColors.accent,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                title,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeaningCard extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MeaningCard({
    Key? key,
    required this.title,
    this.description,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.cardElevation,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (description != null && description!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}