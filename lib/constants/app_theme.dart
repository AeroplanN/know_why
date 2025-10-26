import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета согласно дизайну
  static const Color background = Color(0xFFB0BEC5); // Серо-голубой фон
  static const Color backgroundDark = Color(0xFFA7B8C8); // Альтернативный фон
  
  static const Color textPrimary = Color(0xFF1E1E1E); // Глубокий графитовый
  static const Color textSecondary = Color(0xFF212121); // Мягкий чёрный
  
  static const Color accent = Color(0xFF4A90E2); // Приглушённый небесно-голубой
  static const Color accentLight = Color(0xFF5DADEC); // Светлый акцент
  
  static const Color surface = Color(0xFFE0E0E0); // Светло-серый
  static const Color surfaceLight = Color(0xFFF5F5F5); // Серебристый
  
  static const Color supportText = Color(0xFFFAFAFA); // Белый с лёгкой голубизной
  static const Color supportTextAlt = Color(0xFFF2F7FA); // Альтернативный белый
  
  // Специальные цвета для разных экранов
  static const Color nowScreenBg = Color(0xFF2A3A4A); // Глубокий тёмно-синий
  static const Color calmModeBg = Color(0xFF1A2A3A); // Тёмно-синий для тихого режима
  
  // Градиенты
  static const LinearGradient onboardingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFB0BEC5),
      Color(0xFFA7B8C8),
    ],
  );
  
  static const LinearGradient breathingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4A90E2),
      Color(0xFF5DADEC),
    ],
  );
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.supportText,
    fontFamily: 'Inter',
  );
  
  static const TextStyle supportText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.supportText,
    fontFamily: 'Inter',
  );
  
  static const TextStyle breathingText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.supportText,
    fontFamily: 'Inter',
  );
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  
  static const double buttonHeight = 48.0;
  static const double cardElevation = 2.0;
}