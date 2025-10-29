import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _iconAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _iconAnimation;
  late Animation<double> _backgroundAnimation;
  
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Ты не один",
      subtitle: "Это место, где можно просто быть",
      description: "Здесь нет давления быть счастливым.\nЗдесь можно проживать трудные моменты безопасно.",
      icon: Icons.cloud_outlined,
      color: AppColors.accent,
    ),
    OnboardingPage(
      title: "Записывай свои мысли",
      subtitle: "Каждое чувство важно",
      description: "Веди дневник, отмечай настроение,\nсохраняй то, что помогает тебе помнить о смысле.",
      icon: Icons.edit_outlined,
      color: AppColors.accentLight,
    ),
    OnboardingPage(
      title: "Помни, зачем ты живёшь",
      subtitle: "Твой смысл — твоя сила",
      description: "Создавай коллекцию того, что даёт тебе силы.\nВозвращайся к этому в трудные моменты.",
      icon: Icons.favorite_outline,
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _iconAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _iconAnimationController.repeat(reverse: true);
    _backgroundAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: AppDimensions.animationSlow,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background,
                      AppColors.backgroundDark.withOpacity(_backgroundAnimation.value),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: _totalPages,
                        itemBuilder: (context, index) {
                          return _buildPage(_pages[index]);
                        },
                      ),
                    ),
                    _buildBottomSection(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return AnimatedBuilder(
      animation: _iconAnimation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Анимированная иконка с эффектом свечения
              Transform.scale(
                scale: _iconAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        page.color.withOpacity(0.3),
                        page.color.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: page.color.withOpacity(_iconAnimation.value * 0.4),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    page.icon,
                    size: 80,
                    color: page.color,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXLarge),
              
              // Заголовок
              Text(
                page.title,
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              
              // Подзаголовок
              Text(
                page.subtitle,
                style: AppTextStyles.heading3.copyWith(
                  color: page.color,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              
              // Описание
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                  border: Border.all(
                    color: page.color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  page.description,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusXLarge),
        ),
      ),
      child: Column(
        children: [
          // Индикаторы страниц
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _totalPages,
              (index) => AnimatedContainer(
                duration: AppDimensions.animationMedium,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentPage == index ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentPage == index
                      ? AppColors.accent
                      : AppColors.textTertiary.withOpacity(0.3),
                  boxShadow: _currentPage == index
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXLarge),
          
          // Кнопки навигации
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: GlowingButton(
                    text: "Назад",
                    backgroundColor: AppColors.surface,
                    textColor: AppColors.textPrimary,
                    glowColor: AppColors.textTertiary,
                    icon: Icons.arrow_back,
                    onPressed: () {
                      _pageController.previousPage(
                        duration: AppDimensions.animationMedium,
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                )
              else
                const Expanded(child: SizedBox()),
              
              const SizedBox(width: AppDimensions.paddingMedium),
              
              Expanded(
                flex: 2,
                child: GlowingButton(
                  text: _currentPage == _totalPages - 1 ? "Начать путь" : "Далее",
                  backgroundColor: AppColors.accent,
                  icon: _currentPage == _totalPages - 1 
                      ? Icons.rocket_launch 
                      : Icons.arrow_forward,
                  onPressed: () {
                    if (_currentPage == _totalPages - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: AppDimensions.animationMedium,
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          
          // Кнопка пропуска
          const SizedBox(height: AppDimensions.paddingMedium),
          TextButton(
            onPressed: _completeOnboarding,
            child: Text(
              "Пропустить",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}