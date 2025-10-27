import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/breathing_animation.dart';
import '../models/meaning.dart';
import '../services/database_service.dart';

class NowScreen extends StatefulWidget {
  const NowScreen({Key? key}) : super(key: key);

  @override
  State<NowScreen> createState() => _NowScreenState();
}

class _NowScreenState extends State<NowScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Meaning> _meanings = [];
  bool _isLoading = true;
  bool _showBreathing = false;

  @override
  void initState() {
    super.initState();
    _loadMeanings();
  }

  Future<void> _loadMeanings() async {
    try {
      final meanings = await _databaseService.getAllMeanings();
      setState(() {
        _meanings = meanings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nowScreenBg,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              )
            : _showBreathing
                ? _buildBreathingView()
                : _buildMainView(),
      ),
    );
  }

  Widget _buildMainView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: AppDimensions.paddingXLarge),
          _buildComfortSection(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildBreathingSection(),
          if (_meanings.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildMeaningsSection(),
          ],
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildHelpSection(),
        ],
      ),
    );
  }

  Widget _buildBreathingView() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _showBreathing = false),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.supportText,
              ),
            ),
            const Spacer(),
          ],
        ),
        const Spacer(),
        const BreathingAnimation(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: GlowingButton(
            text: "Закончить",
            backgroundColor: AppColors.textSecondary.withOpacity(0.6),
            textColor: AppColors.supportText,
            glowColor: AppColors.textSecondary,
            width: double.infinity,
            onPressed: () => setState(() => _showBreathing = false),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.supportText,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Text(
          "Всё будет хорошо",
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.supportText,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Text(
          "Ты справишься с этим",
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.supportText.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildComfortSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite,
            size: 40,
            color: AppColors.accentLight,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            "Сейчас трудно, и это нормально",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.supportText,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            "Ты не обязан быть сильным каждую секунду. Позволь себе чувствовать то, что чувствуешь.",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.supportText.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: AppColors.accentLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Давай подышим вместе",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.supportText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            "Простое дыхание поможет успокоиться",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.supportText.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          GlowingButton(
            text: "Начать дыхательную практику",
            backgroundColor: AppColors.accentLight,
            width: double.infinity,
            onPressed: () => setState(() => _showBreathing = true),
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningsSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Помни, зачем ты живёшь",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.supportText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          ...(_meanings.take(3).map((meaning) => Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accentLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Expanded(
                      child: Text(
                        meaning.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.supportText,
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Если очень тяжело",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.supportText,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            "Не оставайся один. Обратись за помощью.",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.supportText.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Row(
            children: [
              Expanded(
                child: GlowingButton(
                  text: "150",
                  backgroundColor: Colors.red.shade400,
                  height: 40,
                  onPressed: () {
                    // Логика звонка
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: GlowingButton(
                  text: "Поддержка",
                  backgroundColor: AppColors.accent,
                  height: 40,
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Переход к экрану поддержки
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