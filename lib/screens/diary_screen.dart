import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../models/diary_entry.dart';
import '../services/database_service.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _noteController = TextEditingController();
  List<DiaryEntry> _entries = [];
  bool _isLoading = true;
  int _selectedMood = 5;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _loadTodayEntry();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    try {
      final entries = await _databaseService.getAllDiaryEntries();
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTodayEntry() async {
    final today = DateTime.now();
    final entry = await _databaseService.getDiaryEntryByDate(today);
    if (entry != null) {
      setState(() {
        _selectedMood = entry.moodRating;
        _noteController.text = entry.note ?? '';
        _selectedDate = entry.date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Дневник",
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTodaySection(),
                  const SizedBox(height: AppDimensions.paddingXLarge),
                  _buildHistorySection(),
                ],
              ),
            ),
    );
  }

  Widget _buildTodaySection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Как ты сегодня?",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            _formatDate(_selectedDate),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildMoodSelector(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildNoteInput(),
          const SizedBox(height: AppDimensions.paddingLarge),
          GlowingButton(
            text: "Сохранить",
            width: double.infinity,
            onPressed: _saveEntry,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Настроение (${_selectedMood}/10)",
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Row(
          children: List.generate(10, (index) {
            final mood = index + 1;
            final isSelected = mood == _selectedMood;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedMood = mood),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.accent
                        : AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.accent,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      mood.toString(),
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
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Очень плохо",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            Text(
              "Отлично",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Хочу сказать...",
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        TextField(
          controller: _noteController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: "Опиши свои мысли и чувства...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              borderSide: BorderSide(color: AppColors.accent.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            filled: true,
            fillColor: AppColors.surfaceLight,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "История записей",
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        if (_entries.isEmpty)
          _buildEmptyHistory()
        else
          _buildEntriesList(),
      ],
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
      child: Column(
        children: [
          Icon(
            Icons.edit_outlined,
            size: 60,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            "Записей пока нет",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            "Сохрани первую запись выше",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(entry.date),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getMoodColor(entry.moodRating),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${entry.moodRating}/10",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (entry.note?.isNotEmpty == true) ...[
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  entry.note!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveEntry() async {
    try {
      final today = DateTime.now();
      final dateOnly = DateTime(today.year, today.month, today.day);
      
      final existingEntry = await _databaseService.getDiaryEntryByDate(dateOnly);
      
      if (existingEntry != null) {
        // Обновляем существующую запись
        final updatedEntry = existingEntry.copyWith(
          moodRating: _selectedMood,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );
        await _databaseService.updateDiaryEntry(updatedEntry);
      } else {
        // Создаём новую запись
        final newEntry = DiaryEntry(
          date: dateOnly,
          moodRating: _selectedMood,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          createdAt: DateTime.now(),
        );
        await _databaseService.insertDiaryEntry(newEntry);
      }

      _loadEntries();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Запись сохранена'),
          backgroundColor: AppColors.accent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сохранения: $e'),
          backgroundColor: Colors.red.shade300,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (date.year == today.year && 
        date.month == today.month && 
        date.day == today.day) {
      return "Сегодня";
    } else if (date.year == yesterday.year && 
               date.month == yesterday.month && 
               date.day == yesterday.day) {
      return "Вчера";
    } else {
      return "${date.day} ${months[date.month - 1]}";
    }
  }

  Color _getMoodColor(int mood) {
    if (mood <= 3) {
      return Colors.red.shade400;
    } else if (mood <= 6) {
      return Colors.orange.shade400;
    } else {
      return AppColors.accent;
    }
  }
}