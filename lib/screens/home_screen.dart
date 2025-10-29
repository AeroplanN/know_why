import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/breathing_animation.dart';
import 'now_screen.dart';
import 'meaning_screen.dart';
import 'diary_screen.dart';
import 'support_screen.dart';
import 'strength_screen.dart';
import 'calm_mode_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _greetingAnimationController;
  late AnimationController _cardsAnimationController;
  late Animation<double> _greetingAnimation;
  late Animation<double> _cardsAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _greetingAnimationController = AnimationController(
      duration: AppDimensions.animationSlow,
      vsync: this,
    );
    
    _cardsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _greetingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _greetingAnimationController,
      curve: Curves.easeOut,
    ));
    
    _cardsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardsAnimationController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() {
    _greetingAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _cardsAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _greetingAnimationController.dispose();
    _cardsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: AppDimensions.paddingXLarge),
                _buildMenuGrid(),
                const SizedBox(height: AppDimensions.paddingXLarge),
                _buildBreathingSection(),
                const SizedBox(height: AppDimensions.paddingMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _greetingAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _greetingAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _greetingAnimation.value)),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: AppTextStyles.heading1.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingSmall),
                          Text(
                            _getMotivationalMessage(),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => _navigateToScreen(const SettingsScreen()),
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: AppColors.textPrimary,
                        ),
                        tooltip: 'Настройки',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                // Подсказка времени суток
                _buildTimeHint(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeHint() {
    final hour = DateTime.now().hour;
    String timeMessage;
    IconData timeIcon;
    Color timeColor;

    if (hour >= 5 && hour < 12) {
      timeMessage = "Доброе утро! Новый день — новые возможности";
      timeIcon = Icons.wb_sunny;
      timeColor = AppColors.warning;
    } else if (hour >= 12 && hour < 17) {
      timeMessage = "Добрый день! Помни делать паузы";
      timeIcon = Icons.wb_sunny;
      timeColor = AppColors.accent;
    } else if (hour >= 17 && hour < 22) {
      timeMessage = "Добрый вечер! Время для себя";
      timeIcon = Icons.wb_twilight;
      timeColor = AppColors.accentLight;
    } else {
      timeMessage = "Доброй ночи! Отдых тоже важен";
      timeIcon = Icons.bedtime;
      timeColor = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: timeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        border: Border.all(
          color: timeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            timeIcon,
            color: timeColor,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Expanded(
            child: Text(
              timeMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menuItems = [
      MenuItemData(
        title: "Мне тяжело",
        subtitle: "Поддержка сейчас",
        icon: Icons.favorite_outline,
        screen: const NowScreen(),
        color: AppColors.error,
      ),
      MenuItemData(
        title: "Мой смысл",
        subtitle: "Зачем я живу",
        icon: Icons.lightbulb_outline,
        screen: const MeaningScreen(),
        color: AppColors.accent,
      ),
      MenuItemData(
        title: "Дневник",
        subtitle: "Мои мысли",
        icon: Icons.edit_outlined,
        screen: const DiaryScreen(),
        color: AppColors.info,
      ),
      MenuItemData(
        title: "Поддержка",
        subtitle: "Получить помощь",
        icon: Icons.phone_outlined,
        screen: const SupportScreen(),
        color: AppColors.warning,
      ),
      MenuItemData(
        title: "Дни силы",
        subtitle: "Мои победы",
        icon: Icons.calendar_today_outlined,
        screen: const StrengthScreen(),
        color: AppColors.success,
      ),
      MenuItemData(
        title: "Тихий режим",
        subtitle: "Время покоя",
        icon: Icons.spa_outlined,
        screen: const CalmModeScreen(),
        color: AppColors.accentLight,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingMedium,
        mainAxisSpacing: AppDimensions.paddingMedium,
        childAspectRatio: 1.1,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        
        return MenuCard(
          title: item.title,
          subtitle: item.subtitle,
          icon: item.icon,
          borderColor: item.color.withOpacity(0.3),
          iconColor: item.color,
          onTap: () => _navigateToScreen(item.screen),
        );
      },
    );
  }

  Widget _buildBreathingSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: AppColors.accentLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: AppThemeUtils.getGlowShadow(
          color: AppColors.accentLight,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                decoration: BoxDecoration(
                  color: AppColors.accentLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                ),
                child: const Icon(
                  Icons.self_improvement,
                  color: AppColors.accentLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Остановись и подыши",
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      "Несколько минут для себя",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          const PulsingWidget(
            duration: Duration(seconds: 3),
            child: Icon(
              Icons.spa,
              size: 48,
              color: AppColors.accentLight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          GlowingButton(
            text: "Дыхательная практика",
            backgroundColor: AppColors.accentLight,
            width: double.infinity,
            icon: Icons.play_arrow,
            onPressed: () => _navigateToScreen(const NowScreen()),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          var fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
          ));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: AppDimensions.animationMedium,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Доброе утро";
    } else if (hour >= 12 && hour < 17) {
      return "Добрый день";
    } else if (hour >= 17 && hour < 22) {
      return "Добрый вечер";
    } else {
      return "Привет";
    }
  }

  String _getMotivationalMessage() {
    final messages = [
      "Сегодня просто живи",
      "Ты важен и ценен",
      "Каждый день — это новая возможность",
      "Помни: ты не один",
      "Твои чувства важны",
      "Забота о себе — не эгоизм",
      "Маленькие шаги тоже важны",
      "Ты справляешься лучше, чем думаешь",
    ];
    
    final today = DateTime.now().day;
    return messages[today % messages.length];
  }
}

class MenuItemData {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget screen;
  final Color color;

  MenuItemData({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.screen,
    required this.color,
  });
}