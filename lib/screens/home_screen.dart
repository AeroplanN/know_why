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

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: AppDimensions.paddingMedium),
        Text(
          "Привет",
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          "Сегодня просто живи",
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => _navigateToScreen(const SettingsScreen()),
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuGrid() {
    final menuItems = [
      MenuItemData(
        title: "Мне тяжело",
        icon: Icons.favorite_outline,
        screen: const NowScreen(),
        color: AppColors.accent,
      ),
      MenuItemData(
        title: "Мой смысл",
        icon: Icons.lightbulb_outline,
        screen: const MeaningScreen(),
        color: AppColors.accentLight,
      ),
      MenuItemData(
        title: "Дневник",
        icon: Icons.edit_outlined,
        screen: const DiaryScreen(),
        color: AppColors.accent,
      ),
      MenuItemData(
        title: "Поддержка",
        icon: Icons.phone_outlined,
        screen: const SupportScreen(),
        color: AppColors.accentLight,
      ),
      MenuItemData(
        title: "Дни силы",
        icon: Icons.calendar_today_outlined,
        screen: const StrengthScreen(),
        color: AppColors.accent,
      ),
      MenuItemData(
        title: "Тихий режим",
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
        childAspectRatio: 1.2,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return MenuCard(
          title: item.title,
          icon: item.icon,
          borderColor: item.color,
          onTap: () => _navigateToScreen(item.screen),
        );
      },
    );
  }

  Widget _buildBreathingSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        children: [
          Text(
            "Остановись и подыши",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          const PulsingWidget(
            child: Icon(
              Icons.self_improvement,
              size: 40,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          GlowingButton(
            text: "Дыхательная практика",
            backgroundColor: AppColors.accent.withOpacity(0.8),
            width: double.infinity,
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

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final Widget screen;
  final Color color;

  MenuItemData({
    required this.title,
    required this.icon,
    required this.screen,
    required this.color,
  });
}