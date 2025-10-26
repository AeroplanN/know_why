import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dailyReminders = true;
  bool _meaningReminders = false;
  String _selectedLanguage = "Русский";
  String _selectedTheme = "Тёмная";
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  final List<String> _languages = ["Русский", "Қазақша"];
  final List<String> _themes = ["Светлая", "Тёмная", "Тёплая"];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyReminders = prefs.getBool('daily_reminders') ?? true;
      _meaningReminders = prefs.getBool('meaning_reminders') ?? false;
      _selectedLanguage = prefs.getString('language') ?? "Русский";
      _selectedTheme = prefs.getString('theme') ?? "Тёмная";
      
      final hour = prefs.getInt('reminder_hour') ?? 20;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Настройки",
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
            _buildNotificationsSection(),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildAppearanceSection(),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildLanguageSection(),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
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
            "Уведомления",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildSettingTile(
            title: "Ежедневные напоминания",
            subtitle: "Мягкое напоминание о заботе о себе",
            trailing: Switch(
              value: _dailyReminders,
              onChanged: _setDailyReminders,
              activeColor: AppColors.accent,
            ),
          ),
          if (_dailyReminders) ...[
            const SizedBox(height: AppDimensions.paddingMedium),
            _buildTimePicker(),
          ],
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildSettingTile(
            title: "Напоминания о смыслах",
            subtitle: "Напомнить о твоих важных причинах",
            trailing: Switch(
              value: _meaningReminders,
              onChanged: _setMeaningReminders,
              activeColor: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return ListTile(
      leading: const Icon(Icons.schedule, color: AppColors.accent),
      title: const Text("Время напоминания"),
      subtitle: Text(_formatTime(_reminderTime)),
      onTap: _selectTime,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildAppearanceSection() {
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
            "Внешний вид",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildSettingTile(
            title: "Тема оформления",
            subtitle: _selectedTheme,
            trailing: const Icon(Icons.chevron_right, color: AppColors.accent),
            onTap: _showThemeDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
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
            "Язык",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildSettingTile(
            title: "Язык интерфейса",
            subtitle: _selectedLanguage,
            trailing: const Icon(Icons.chevron_right, color: AppColors.accent),
            onTap: _showLanguageDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
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
            "О приложении",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildSettingTile(
            title: "Версия",
            subtitle: "1.0.0",
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            "\"ЗНАЮ ЗАЧЕМ\" создано, чтобы напоминать: ты важен.",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildSettingTile(
            title: "Поддержка",
            subtitle: "Связаться с разработчиками",
            trailing: const Icon(Icons.chevron_right, color: AppColors.accent),
            onTap: _showSupportDialog,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          _buildSettingTile(
            title: "Конфиденциальность",
            subtitle: "Все данные хранятся только на твоём устройстве",
            trailing: const Icon(Icons.chevron_right, color: AppColors.accent),
            onTap: _showPrivacyDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _setDailyReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminders', value);
    setState(() {
      _dailyReminders = value;
    });
  }

  Future<void> _setMeaningReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('meaning_reminders', value);
    setState(() {
      _meaningReminders = value;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('reminder_hour', picked.hour);
      await prefs.setInt('reminder_minute', picked.minute);
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Выберите тему"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themes.map((theme) => RadioListTile<String>(
            title: Text(theme),
            value: theme,
            groupValue: _selectedTheme,
            activeColor: AppColors.accent,
            onChanged: (value) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('theme', value!);
              setState(() {
                _selectedTheme = value;
              });
              Navigator.of(context).pop();
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Выберите язык"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: _selectedLanguage,
            activeColor: AppColors.accent,
            onChanged: (value) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', value!);
              setState(() {
                _selectedLanguage = value;
              });
              Navigator.of(context).pop();
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Поддержка"),
        content: const Text(
          "Если у вас есть вопросы или предложения, вы можете связаться с нами:\n\n"
          "Email: support@znaju-zachem.app\n"
          "Телеграм: @znaju_zachem_support",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Закрыть"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Конфиденциальность"),
        content: const Text(
          "Все ваши данные (записи, смыслы, дни силы) хранятся только на вашем устройстве. "
          "Мы не собираем, не передаём и не анализируем вашу личную информацию.\n\n"
          "Ваша приватность и безопасность для нас приоритет.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Понятно"),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}