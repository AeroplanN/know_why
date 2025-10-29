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
  final IconData? icon;
  final bool isLoading;
  final bool disabled;

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
    this.icon,
    this.isLoading = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
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
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    if (!widget.disabled && !widget.isLoading) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GlowingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.disabled || widget.isLoading) {
      _animationController.stop();
    } else if (!oldWidget.disabled && !oldWidget.isLoading) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColors.accent;
    final textColor = widget.textColor ?? AppColors.supportText;
    final glowColor = widget.glowColor ?? backgroundColor;
    final isDisabled = widget.disabled || widget.onPressed == null;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
          onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
          onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
          onTap: isDisabled ? null : widget.onPressed,
          child: Transform.scale(
            scale: _isPressed ? _scaleAnimation.value : 1.0,
            child: Container(
              width: widget.width,
              height: widget.height ?? AppDimensions.buttonHeight,
              padding: widget.padding ?? const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isDisabled 
                    ? backgroundColor.withOpacity(0.5)
                    : backgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                boxShadow: isDisabled 
                    ? null
                    : [
                        BoxShadow(
                          color: glowColor.withOpacity(
                            _glowAnimation.value * (_isPressed ? 1.2 : 1.0)
                          ),
                          blurRadius: _isPressed ? 25 : 20,
                          spreadRadius: _isPressed ? 6 : 3,
                          offset: Offset(0, _isPressed ? 1 : 2),
                        ),
                      ],
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: textColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: textColor,
                              size: 20,
                            ),
                            const SizedBox(width: AppDimensions.paddingSmall),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style: AppTextStyles.buttonText.copyWith(
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;

  const MenuCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
  }) : super(key: key);

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppDimensions.animationFast,
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: AppDimensions.cardElevation,
      end: AppDimensions.cardElevationHigh,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _elevationAnimation,
      builder: (context, child) {
        return Container(
          decoration: AppThemeUtils.getCardDecoration(
            backgroundColor: widget.backgroundColor,
            borderColor: widget.borderColor,
            withGlow: _isHovered,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onHover: (hovered) {
                setState(() => _isHovered = hovered);
                if (hovered) {
                  _hoverController.forward();
                } else {
                  _hoverController.reverse();
                }
              },
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: AppDimensions.iconSizeLarge,
                      color: widget.iconColor ?? AppColors.accent,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      widget.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        widget.subtitle!,
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MeaningCard extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const MeaningCard({
    Key? key,
    required this.title,
    this.description,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppThemeUtils.getCardDecoration(
        backgroundColor: isSelected 
            ? AppColors.accent.withOpacity(0.1)
            : AppColors.surface,
        borderColor: isSelected 
            ? AppColors.accent
            : AppColors.surface,
        withGlow: isSelected,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected 
                              ? AppColors.accent
                              : AppTextStyles.bodyLarge.color,
                        ),
                      ),
                    ),
                  ],
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.accent;
    
    return Container(
      decoration: AppThemeUtils.getCardDecoration(
        backgroundColor: cardColor.withOpacity(0.1),
        borderColor: cardColor.withOpacity(0.3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: cardColor,
                  size: AppDimensions.iconSizeLarge,
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  value,
                  style: AppTextStyles.heading1.copyWith(
                    color: cardColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppDimensions.paddingXLarge),
              GlowingButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                backgroundColor: AppColors.accent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: color ?? AppColors.accent,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}