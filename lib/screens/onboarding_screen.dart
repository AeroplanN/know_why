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

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Ты не один",
      subtitle: "Это место, где можно просто быть",
      description: "Здесь нет давления быть счастливым. Здесь можно проживать трудные моменты безопасно.",
      icon: Icons.cloud_outlined,
    ),
    OnboardingPage(
      title: "Записывай свои мысли",
      subtitle: "Каждое чувство важно",
      description: "Веди дневник, отмечай настроение, сохраняй то, что помогает тебе помнить о смысле.",
      icon: Icons.edit_outlined,
    ),
    OnboardingPage(
      title: "Помни, зачем ты живёшь",
      subtitle: "Твой смысл — твоя сила",
      description: "Создавай коллекцию того, что даёт тебе силы. Возвращайся к этому в трудные моменты.",
      icon: Icons.favorite_outline,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.onboardingGradient,
        ),
        child: SafeArea(
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
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 120,
            color: AppColors.supportText.withOpacity(0.8),
          ),
          const SizedBox(height: AppDimensions.paddingXLarge),
          Text(
            page.title,
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.supportText,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            page.subtitle,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.supportText.withOpacity(0.9),
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            page.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.supportText.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
      child: Column(
        children: [
          // Индикаторы страниц
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _totalPages,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppColors.supportText
                      : AppColors.supportText.withOpacity(0.3),
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
                    backgroundColor: AppColors.supportText.withOpacity(0.2),
                    textColor: AppColors.supportText,
                    glowColor: AppColors.supportText,
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                )
              else
                const Expanded(child: SizedBox()),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: GlowingButton(
                  text: _currentPage == _totalPages - 1 ? "Начать" : "Далее",
                  backgroundColor: AppColors.accent,
                  onPressed: () {
                    if (_currentPage == _totalPages - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ],
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

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
}