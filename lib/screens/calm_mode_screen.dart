import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/breathing_animation.dart';
import '../widgets/custom_widgets.dart';

class CalmModeScreen extends StatefulWidget {
  const CalmModeScreen({Key? key}) : super(key: key);

  @override
  State<CalmModeScreen> createState() => _CalmModeScreenState();
}

class _CalmModeScreenState extends State<CalmModeScreen> 
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  bool _isActive = false;
  int _timeRemaining = 0;
  String _selectedDuration = "5 минут";
  
  final List<String> _durations = ["2 минуты", "5 минут", "10 минут", "15 минут"];
  final List<String> _calmMessages = [
    "Мир не требует от тебя ничего",
    "Просто побудь здесь и сейчас",
    "Ты в безопасности",
    "Каждый вдох приносит покой",
    "Позволь себе просто быть",
    "Нет ничего, что нужно делать прямо сейчас",
    "Ты достоин отдыха и покоя",
    "Этот момент принадлежит только тебе",
  ];
  
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    _waveController.repeat();
    
    _startMessageRotation();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _startMessageRotation() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % _calmMessages.length;
        });
        _startMessageRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.calmModeBg,
      body: SafeArea(
        child: _isActive ? _buildActiveMode() : _buildSetupMode(),
      ),
    );
  }

  Widget _buildSetupMode() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
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
              Expanded(
                child: Text(
                  "Тихий режим",
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.supportText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Для симметрии
            ],
          ),
          const Spacer(),
          _buildWelcomeSection(),
          const SizedBox(height: AppDimensions.paddingXLarge),
          _buildDurationSelector(),
          const SizedBox(height: AppDimensions.paddingXLarge),
          _buildStartButton(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildActiveMode() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        children: [
          const Spacer(),
          _buildActiveContent(),
          const Spacer(),
          _buildStopButton(),
          const SizedBox(height: AppDimensions.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _waveAnimation,
          builder: (context, child) {
            return Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentLight.withOpacity(0.6),
                    AppColors.accentLight.withOpacity(0.2),
                    AppColors.accentLight.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentLight.withOpacity(_waveAnimation.value * 0.5),
                    blurRadius: 20 + (_waveAnimation.value * 10),
                    spreadRadius: 5 + (_waveAnimation.value * 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.spa,
                size: 60,
                color: AppColors.supportText,
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.paddingLarge),
        Text(
          "Время остановиться",
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.supportText,
            fontSize: 26,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Text(
          "Дай себе немного покоя",
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.supportText.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Сколько времени нужно?",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.supportText,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Wrap(
            spacing: AppDimensions.paddingMedium,
            runSpacing: AppDimensions.paddingSmall,
            children: _durations.map((duration) {
              final isSelected = duration == _selectedDuration;
              return GestureDetector(
                onTap: () => setState(() => _selectedDuration = duration),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium,
                    vertical: AppDimensions.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.accent
                        : AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                    border: Border.all(
                      color: AppColors.accent,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      color: isSelected 
                          ? AppColors.supportText
                          : AppColors.accent,
                      fontWeight: isSelected 
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return GlowingButton(
      text: "Начать тихий режим",
      backgroundColor: AppColors.accent,
      width: double.infinity,
      onPressed: _startCalmMode,
    );
  }

  Widget _buildActiveContent() {
    return Column(
      children: [
        // Таймер
        if (_timeRemaining > 0) ...[
          Text(
            _formatTime(_timeRemaining),
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.supportText,
              fontSize: 48,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
        ],
        // Дыхательная анимация
        const BreathingAnimation(
          size: 200,
          color: AppColors.accentLight,
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        // Сообщение поддержки
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: Text(
              _calmMessages[_currentMessageIndex],
              key: ValueKey(_currentMessageIndex),
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.supportText,
                height: 1.6,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStopButton() {
    return GlowingButton(
      text: "Закончить",
      backgroundColor: AppColors.textSecondary.withOpacity(0.6),
      textColor: AppColors.supportText,
      glowColor: AppColors.textSecondary,
      width: double.infinity,
      onPressed: _stopCalmMode,
    );
  }

  void _startCalmMode() {
    final durationMap = {
      "2 минуты": 120,
      "5 минут": 300,
      "10 минут": 600,
      "15 минут": 900,
    };
    
    setState(() {
      _isActive = true;
      _timeRemaining = durationMap[_selectedDuration] ?? 300;
    });
    
    _startTimer();
  }

  void _startTimer() {
    if (_timeRemaining > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isActive) {
          setState(() {
            _timeRemaining--;
          });
          if (_timeRemaining > 0) {
            _startTimer();
          } else {
            _completeCalmMode();
          }
        }
      });
    }
  }

  void _stopCalmMode() {
    setState(() {
      _isActive = false;
      _timeRemaining = 0;
    });
  }

  void _completeCalmMode() {
    setState(() {
      _isActive = false;
      _timeRemaining = 0;
    });
    
    // Показываем сообщение о завершении
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppColors.accent,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Text(
                "Прекрасно!",
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Text(
                "Ты дал себе время для покоя. Это важно и ценно.",
                style: AppTextStyles.bodyMedium.copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              GlowingButton(
                text: "Закрыть",
                backgroundColor: AppColors.accent,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
}