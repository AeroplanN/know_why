import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../models/strength_day.dart';
import '../services/database_service.dart';

class StrengthScreen extends StatefulWidget {
  const StrengthScreen({Key? key}) : super(key: key);

  @override
  State<StrengthScreen> createState() => _StrengthScreenState();
}

class _StrengthScreenState extends State<StrengthScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<StrengthDay> _strengthDays = [];
  int _consecutiveDays = 0;
  bool _isLoading = true;
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final days = await _databaseService.getAllStrengthDays();
      final consecutive = await _databaseService.getConsecutiveStrengthDays();
      setState(() {
        _strengthDays = days;
        _consecutiveDays = consecutive;
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Дни силы",
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
                  _buildStatsSection(),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  _buildTodaySection(),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  _buildCalendarSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsSection() {
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
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Всего дней",
                  _strengthDays.length.toString(),
                  Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: _buildStatCard(
                  "Подряд",
                  _consecutiveDays.toString(),
                  Icons.local_fire_department_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            _consecutiveDays > 0 
                ? "Ты прожил $_consecutiveDays ${_getDaysText(_consecutiveDays)} подряд"
                : "Каждый прожитый день — это уже победа",
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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.accent,
            size: 32,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            value,
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.accent,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySection() {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final hasTodayEntry = _strengthDays.any((day) => 
        day.date.year == todayKey.year && 
        day.date.month == todayKey.month && 
        day.date.day == todayKey.day);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        children: [
          Text(
            hasTodayEntry 
                ? "Сегодня отмечен как день силы!"
                : "Отметь сегодня как день силы",
            style: AppTextStyles.heading2.copyWith(
              color: hasTodayEntry ? AppColors.accent : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            hasTodayEntry
                ? "Ты справился с этим днём — это важно"
                : "Ты живёшь, дышишь, существуешь — это уже победа",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          GlowingButton(
            text: hasTodayEntry ? "Убрать отметку" : "Отметить день",
            backgroundColor: hasTodayEntry 
                ? AppColors.textSecondary.withOpacity(0.6)
                : AppColors.accent,
            width: double.infinity,
            onPressed: () => _toggleTodayEntry(hasTodayEntry),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left, color: AppColors.accent),
              ),
              Text(
                _formatMonthYear(_currentMonth),
                style: AppTextStyles.heading2,
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right, color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Понедельник = 0
    
    final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    
    return Column(
      children: [
        // Заголовки дней недели
        Row(
          children: weekDays.map((day) => Expanded(
            child: Text(
              day,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )).toList(),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        // Календарная сетка
        ...List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = (weekIndex * 7) + dayIndex - firstWeekday + 1;
              
              if (dayNumber < 1 || dayNumber > lastDayOfMonth.day) {
                return const Expanded(child: SizedBox(height: 40));
              }
              
              final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final hasEntry = _strengthDays.any((day) => 
                  day.date.year == date.year && 
                  day.date.month == date.month && 
                  day.date.day == date.day);
              
              final isToday = _isToday(date);
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => _toggleDayEntry(date, hasEntry),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: hasEntry 
                          ? AppColors.accent
                          : isToday 
                              ? AppColors.accent.withOpacity(0.2)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: isToday && !hasEntry
                          ? Border.all(color: AppColors.accent, width: 1)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          color: hasEntry 
                              ? AppColors.supportText
                              : isToday
                                  ? AppColors.accent
                                  : AppColors.textPrimary,
                          fontWeight: hasEntry || isToday 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }).where((row) {
          // Убираем пустые строки в конце
          return (row as Row).children.any((child) => 
              child is Expanded && child.child is GestureDetector);
        }).toList(),
      ],
    );
  }

  Future<void> _toggleTodayEntry(bool hasTodayEntry) async {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    _toggleDayEntry(todayKey, hasTodayEntry);
  }

  Future<void> _toggleDayEntry(DateTime date, bool hasEntry) async {
    try {
      if (hasEntry) {
        // Удаляем запись
        final existingDay = _strengthDays.firstWhere((day) => 
            day.date.year == date.year && 
            day.date.month == date.month && 
            day.date.day == date.day);
        await _databaseService.deleteStrengthDay(existingDay.id!);
      } else {
        // Добавляем запись
        final strengthDay = StrengthDay(
          date: date,
          createdAt: DateTime.now(),
        );
        await _databaseService.insertStrengthDay(strengthDay);
      }
      
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red.shade300,
        ),
      );
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year && 
           date.month == today.month && 
           date.day == today.day;
  }

  String _formatMonthYear(DateTime date) {
    final months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  String _getDaysText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return "день";
    } else if ((count % 10 >= 2 && count % 10 <= 4) && 
               (count % 100 < 10 || count % 100 >= 20)) {
      return "дня";
    } else {
      return "дней";
    }
  }
}