import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Поддержка",
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildHotlinesList(),
            const SizedBox(height: AppDimensions.paddingXLarge),
            _buildTipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 60,
            color: AppColors.accent,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            "Ты не один",
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            "Есть люди, которые готовы выслушать и помочь",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHotlinesList() {
    final hotlines = [
      HotlineData(
        name: "Телефон доверия (Казахстан)",
        number: "150",
        description: "Бесплатная психологическая помощь, круглосуточно",
        region: "Казахстан",
        isEmergency: true,
      ),
      HotlineData(
        name: "Центр психического здоровья",
        number: "+7 727 279 00 00",
        description: "Алматы, консультации специалистов",
        region: "Алматы",
        isEmergency: false,
      ),
      HotlineData(
        name: "Центр семейной терапии",
        number: "+7 7172 79 19 19",
        description: "Нур-Султан, семейные консультации",
        region: "Астана",
        isEmergency: false,
      ),
      HotlineData(
        name: "Линия экстренной помощи",
        number: "112",
        description: "Экстренные службы, круглосуточно",
        region: "Казахстан",
        isEmergency: true,
      ),
      HotlineData(
        name: "Телефон доверия (Россия)",
        number: "8-800-2000-122",
        description: "Бесплатно по России, круглосуточно",
        region: "Россия",
        isEmergency: true,
      ),
      HotlineData(
        name: "Центр кризисной психологии",
        number: "+7 495 575 87 70",
        description: "Москва, профессиональная помощь",
        region: "Москва",
        isEmergency: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Горячие линии",
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        ...hotlines.map((hotline) => _buildHotlineCard(hotline)),
      ],
    );
  }

  Widget _buildHotlineCard(HotlineData hotline) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        border: Border.all(
          color: hotline.isEmergency 
              ? Colors.red.withOpacity(0.3)
              : AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hotline.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (hotline.isEmergency)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "24/7",
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            hotline.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(width: 4),
              Text(
                hotline.region,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          GlowingButton(
            text: "Позвонить ${hotline.number}",
            backgroundColor: hotline.isEmergency 
                ? Colors.red.shade400
                : AppColors.accent,
            width: double.infinity,
            onPressed: () => _makePhoneCall(hotline.number),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Как рассказать близким?",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildTip("Начни с простого", "\"Мне сейчас тяжело, можешь побыть рядом?\""),
          _buildTip("Будь конкретным", "\"Я чувствую тревогу и мне нужна поддержка\""),
          _buildTip("Не бойся просить", "\"Можешь просто послушать меня?\""),
          _buildTip("Выбери время", "Поговори, когда человек свободен и может уделить время"),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            "Помни: просить о помощи — это проявление силы, а не слабости.",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.accent,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}

class HotlineData {
  final String name;
  final String number;
  final String description;
  final String region;
  final bool isEmergency;

  HotlineData({
    required this.name,
    required this.number,
    required this.description,
    required this.region,
    required this.isEmergency,
  });
}