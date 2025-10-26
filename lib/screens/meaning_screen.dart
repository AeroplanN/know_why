import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../models/meaning.dart';
import '../services/database_service.dart';

class MeaningScreen extends StatefulWidget {
  const MeaningScreen({Key? key}) : super(key: key);

  @override
  State<MeaningScreen> createState() => _MeaningScreenState();
}

class _MeaningScreenState extends State<MeaningScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Meaning> _meanings = [];
  bool _isLoading = true;

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки данных: $e'),
            backgroundColor: Colors.red.shade300,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Мои смыслы",
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.supportText,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.supportText,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            )
          : Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildMeaningsList()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMeaningDialog,
        backgroundColor: AppColors.accent,
        child: const Icon(
          Icons.add,
          color: AppColors.supportText,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        children: [
          Text(
            _meanings.isEmpty 
                ? "Создай свою коллекцию смыслов"
                : "Помни, зачем ты живёшь",
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.supportText.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          if (_meanings.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              "У тебя ${_meanings.length} ${_getMeaningsCountText(_meanings.length)}",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.supportText.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMeaningsList() {
    if (_meanings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: _meanings.length,
      itemBuilder: (context, index) {
        final meaning = _meanings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
          child: MeaningCard(
            title: meaning.title,
            description: meaning.description,
            onTap: () => _showMeaningDetail(meaning),
            onLongPress: () => _showMeaningOptions(meaning),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 80,
              color: AppColors.supportText.withOpacity(0.3),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Text(
              "Пока здесь пусто",
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.supportText.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              "Добавь то, что даёт тебе силы жить:\n• Близкие люди\n• Мечты и цели\n• Особые моменты\n• Всё, что важно именно тебе",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.supportText.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingXLarge),
            GlowingButton(
              text: "Добавить первый смысл",
              backgroundColor: AppColors.accent,
              onPressed: _showAddMeaningDialog,
            ),
          ],
        ),
      ),
    );
  }

  void _showMeaningDetail(Meaning meaning) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meaning.title,
                      style: AppTextStyles.heading2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              if (meaning.description?.isNotEmpty == true) ...[
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  meaning.description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.paddingLarge),
              Text(
                "Ты написал это, потому что это важно.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.accent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMeaningOptions(Meaning meaning) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              meaning.title,
              style: AppTextStyles.heading2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.accent),
              title: const Text("Редактировать"),
              onTap: () {
                Navigator.pop(context);
                _showEditMeaningDialog(meaning);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Удалить"),
              onTap: () {
                Navigator.pop(context);
                _deleteMeaning(meaning);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMeaningDialog() {
    _showMeaningDialog();
  }

  void _showEditMeaningDialog(Meaning meaning) {
    _showMeaningDialog(meaning: meaning);
  }

  void _showMeaningDialog({Meaning? meaning}) {
    final titleController = TextEditingController(text: meaning?.title ?? '');
    final descriptionController = TextEditingController(text: meaning?.description ?? '');

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                meaning == null ? "Новый смысл" : "Редактировать",
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Заголовок",
                  hintText: "Например: Моя семья",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                ),
                maxLength: 50,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Описание (необязательно)",
                  hintText: "Почему это важно для тебя?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                ),
                maxLines: 3,
                maxLength: 200,
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Отмена"),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: GlowingButton(
                      text: meaning == null ? "Добавить" : "Сохранить",
                      onPressed: () => _saveMeaning(
                        meaning,
                        titleController.text,
                        descriptionController.text,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMeaning(Meaning? existing, String title, String description) async {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите заголовок')),
      );
      return;
    }

    try {
      final now = DateTime.now();
      
      if (existing == null) {
        // Создание нового смысла
        final meaning = Meaning(
          title: title.trim(),
          description: description.trim().isEmpty ? null : description.trim(),
          createdAt: now,
        );
        await _databaseService.insertMeaning(meaning);
      } else {
        // Обновление существующего
        final updatedMeaning = existing.copyWith(
          title: title.trim(),
          description: description.trim().isEmpty ? null : description.trim(),
          updatedAt: now,
        );
        await _databaseService.updateMeaning(updatedMeaning);
      }

      Navigator.of(context).pop();
      _loadMeanings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сохранения: $e'),
          backgroundColor: Colors.red.shade300,
        ),
      );
    }
  }

  Future<void> _deleteMeaning(Meaning meaning) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Удалить смысл?"),
        content: Text("Вы уверены, что хотите удалить \"${meaning.title}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Отмена"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Удалить"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _databaseService.deleteMeaning(meaning.id!);
        _loadMeanings();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка удаления: $e'),
              backgroundColor: Colors.red.shade300,
            ),
          );
        }
      }
    }
  }

  String _getMeaningsCountText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return "смысл";
    } else if ((count % 10 >= 2 && count % 10 <= 4) && 
               (count % 100 < 10 || count % 100 >= 20)) {
      return "смысла";
    } else {
      return "смыслов";
    }
  }
}