import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета в стиле calm_mode_screen - тёмная палитра
  static const Color background = Color(0xFF1A2A3A); // Тёмно-синий как в calm mode
  static const Color backgroundDark = Color(0xFF0F1F2F); // Ещё темнее для глубины
  static const Color backgroundLight = Color(0xFF2A3A4A); // Светлее для контраста
  
  // Текст
  static const Color textPrimary = Color(0xFFFAFAFA); // Белый с лёгкой голубизной
  static const Color textSecondary = Color(0xFFE0E6ED); // Мягкий светло-серый
  static const Color textTertiary = Color(0xFFB0BEC5); // Приглушённый серо-голубой
  
  // Акценты - сохраняем голубую гамму, но делаем более приглушённой
  static const Color accent = Color(0xFF4A90E2); // Приглушённый небесно-голубой
  static const Color accentLight = Color(0xFF5DADEC); // Светлый акцент
  static const Color accentDark = Color(0xFF3A7BC8); // Тёмный акцент
  
  // Поверхности
  static const Color surface = Color(0xFF263544); // Тёмная поверхность
  static const Color surfaceLight = Color(0xFF324052); // Светлая поверхность
  static const Color surfaceDark = Color(0xFF1C2B3A); // Самая тёмная поверхность
  
  // Поддерживающие цвета
  static const Color supportText = Color(0xFFFAFAFA); // Белый текст на акцентах
  static const Color supportTextAlt = Color(0xFFF2F7FA); // Альтернативный белый
  
  // Специальные цвета для разных состояний
  static const Color nowScreenBg = Color(0xFF0F1F2F); // Экран "Мне тяжело"
  static const Color calmModeBg = Color(0xFF1A2A3A); // Тихий режим
  
  // Состояния
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF42A5F5);
  
  // Прозрачности для наложений
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // Градиенты
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A2A3A),
      Color(0xFF0F1F2F),
    ],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A90E2),
      Color(0xFF5DADEC),
    ],
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF324052),
      Color(0xFF263544),
    ],
  );
  
  // Специальные эффекты
  static Color shimmer = Colors.white.withOpacity(0.1);
  static Color glow = const Color(0xFF5DADEC).withOpacity(0.5);
}

class AppTextStyles {
  // Базовые стили с улучшенной типографикой
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.3,
    letterSpacing: -0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Inter',
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    fontFamily: 'Inter',
    height: 1.4,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.supportText,
    fontFamily: 'Inter',
    letterSpacing: 0.1,
  );
  
  static const TextStyle supportText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.supportText,
    fontFamily: 'Inter',
    height: 1.4,
  );
  
  static const TextStyle breathingText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.supportText,
    fontFamily: 'Inter',
    height: 1.3,
    letterSpacing: 0.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    fontFamily: 'Inter',
    height: 1.3,
  );
  
  // Специальные стили
  static const TextStyle accent = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    fontFamily: 'Inter',
    height: 1.4,
  );
  
  static const TextStyle accentLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    fontFamily: 'Inter',
    height: 1.3,
  );
}

class AppDimensions {
  // Отступы
  static const double paddingXS = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  static const double paddingXXLarge = 40.0;
  
  // Радиусы скругления
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  static const double borderRadiusCircle = 100.0;
  
  // Размеры элементов
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  // Эффекты
  static const double cardElevation = 4.0;
  static const double cardElevationHigh = 8.0;
  static const double glowBlurRadius = 20.0;
  static const double glowSpreadRadius = 4.0;
  
  // Анимации
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Размеры экрана
  static const double maxWidthMobile = 480.0;
  static const double maxWidthTablet = 768.0;
}

// Дополнительные утилиты для работы с темой
class AppThemeUtils {
  // Получить цвет для настроения (1-10)
  static Color getMoodColor(int mood) {
    if (mood <= 3) {
      return AppColors.error;
    } else if (mood <= 6) {
      return AppColors.warning;
    } else if (mood <= 8) {
      return AppColors.info;
    } else {
      return AppColors.success;
    }
  }
  
  // Получить BoxShadow с эффектом свечения
  static List<BoxShadow> getGlowShadow({
    Color? color,
    double blurRadius = AppDimensions.glowBlurRadius,
    double spreadRadius = AppDimensions.glowSpreadRadius,
    double opacity = 0.3,
  }) {
    return [
      BoxShadow(
        color: (color ?? AppColors.accent).withOpacity(opacity),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: const Offset(0, 2),
      ),
    ];
  }
  
  // Получить декорацию карточки
  static BoxDecoration getCardDecoration({
    Color? backgroundColor,
    Color? borderColor,
    bool withGlow = false,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
      border: borderColor != null
          ? Border.all(color: borderColor, width: 1)
          : null,
      boxShadow: withGlow
          ? getGlowShadow()
          : [
              BoxShadow(
                color: AppColors.backgroundDark.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }
  
  // Получить декорацию кнопки
  static BoxDecoration getButtonDecoration({
    Color? backgroundColor,
    bool isPressed = false,
    bool withGlow = true,
  }) {
    final color = backgroundColor ?? AppColors.accent;
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      boxShadow: withGlow
          ? [
              BoxShadow(
                color: color.withOpacity(isPressed ? 0.6 : 0.4),
                blurRadius: isPressed ? 25 : 15,
                spreadRadius: isPressed ? 6 : 3,
                offset: Offset(0, isPressed ? 1 : 2),
              ),
            ]
          : null,
    );
  }
}