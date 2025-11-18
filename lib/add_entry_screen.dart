import 'package:flutter/material.dart';

// Simple data model for one entry
class NutritionEntry {
  final DateTime dateTime;
  final double carbs;
  final double protein;
  final double fat;

  NutritionEntry({
    required this.dateTime,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  double get totalCalories => carbs * 4 + protein * 4 + fat * 9;
}

// In-memory list of entries (for demo). Later, you can swap this with a DB.
final List<NutritionEntry> nutritionEntries = [];

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  void dispose() {
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final carbsText = _carbsController.text.trim();
    final proteinText = _proteinController.text.trim();
    final fatText = _fatController.text.trim();

    final carbs = double.tryParse(carbsText);
    final protein = double.tryParse(proteinText);
    final fat = double.tryParse(fatText);

    if (carbs == null || protein == null || fat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers for all fields.')),
      );
      return;
    }

    final entry = NutritionEntry(
      dateTime: DateTime.now(),
      carbs: carbs,
      protein: protein,
      fat: fat,
    );

    nutritionEntries.add(entry);

    print('Saved -> Carbs: $carbs, Protein: $protein, Fat: $fat');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved! 🎉')),
    );

    _carbsController.clear();
    _proteinController.clear();
    _fatController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent to let gradient show
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Add Nutrition Entry'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View history',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 198, 255, 228), // soft mint
              Color(0xFFE3F2FD), // soft blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.restaurant_menu,
                      size: 72,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Log Your Nutrition',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Track today's macros in grams. We'll keep a history for you 📊",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Carbs
                    TextField(
                      controller: _carbsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Carbs (g)',
                        hintText: 'e.g. 45',
                        prefixIcon: const Icon(Icons.local_pizza),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Protein
                    TextField(
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Protein (g)',
                        hintText: 'e.g. 30',
                        prefixIcon: const Icon(Icons.emoji_food_beverage),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fat
                    TextField(
                      controller: _fatController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Fat (g)',
                        hintText: 'e.g. 10',
                        prefixIcon: const Icon(Icons.icecream),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveEntry,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save Entry'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const HistoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bar_chart_rounded),
                      label: const Text('View History'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== History Screen ====================

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime dt) {
    final d = DateTime(dt.year, dt.month, dt.day);
    return '${d.month}/${d.day}/${d.year}';
  }

  Map<String, double> _macroPercents(NutritionEntry entry) {
    final total = entry.totalCalories;
    if (total == 0) {
      return {'carbs': 0, 'protein': 0, 'fat': 0};
    }
    final cCal = entry.carbs * 4;
    final pCal = entry.protein * 4;
    final fCal = entry.fat * 9;
    return {
      'carbs': cCal / total,
      'protein': pCal / total,
      'fat': fCal / total,
    };
  }

  Widget _buildSummaryCard(List<NutritionEntry> entries) {
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);

    double todayTotal = 0;
    double totalAll = 0;

    for (final e in entries) {
      totalAll += e.totalCalories;
      final k = DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day);
      if (k == todayKey) {
        todayTotal += e.totalCalories;
      }
    }

    final avgAll =
        entries.isEmpty ? 0 : totalAll / entries.length.toDouble();

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.insights_rounded, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Today's calories: ${todayTotal.toStringAsFixed(0)} kcal",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Average per entry: ${avgAll.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEntryDetails(BuildContext context, NutritionEntry entry) {
    final dateStr =
        '${entry.dateTime.month}/${entry.dateTime.day}/${entry.dateTime.year}';
    final timeStr =
        '${entry.dateTime.hour.toString().padLeft(2, '0')}:${entry.dateTime.minute.toString().padLeft(2, '0')}';
    final percents = _macroPercents(entry);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Text(
                'Entry Details',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$dateStr • $timeStr',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total: ${entry.totalCalories.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(
                      'Carbs: ${entry.carbs.toStringAsFixed(1)}g '
                      '(${(percents['carbs']! * 100).toStringAsFixed(0)}%)',
                    ),
                    avatar: const Icon(Icons.local_pizza, size: 18),
                  ),
                  Chip(
                    label: Text(
                      'Protein: ${entry.protein.toStringAsFixed(1)}g '
                      '(${(percents['protein']! * 100).toStringAsFixed(0)}%)',
                    ),
                    avatar: const Icon(Icons.emoji_food_beverage, size: 18),
                  ),
                  Chip(
                    label: Text(
                      'Fat: ${entry.fat.toStringAsFixed(1)}g '
                      '(${(percents['fat']! * 100).toStringAsFixed(0)}%)',
                    ),
                    avatar: const Icon(Icons.icecream, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: percents['carbs']!.clamp(0, 1),
                minHeight: 8,
              ),
              const SizedBox(height: 4),
              const Text(
                'Carb load (relative in this entry)',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = nutritionEntries.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // newest first

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition History'),
        centerTitle: true,
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'No entries yet.\nAdd something first ✨',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: entries.length + 1, // +1 for summary card
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSummaryCard(entries);
                }

                final realIndex = index - 1;
                final entry = entries[realIndex];

                final currentDateKey = DateTime(
                  entry.dateTime.year,
                  entry.dateTime.month,
                  entry.dateTime.day,
                );

                DateTime? previousDateKey;
                if (realIndex > 0) {
                  final previous = entries[realIndex - 1];
                  previousDateKey = DateTime(
                    previous.dateTime.year,
                    previous.dateTime.month,
                    previous.dateTime.day,
                  );
                }

                final showDateHeader =
                    realIndex == 0 || currentDateKey != previousDateKey;

                final percents = _macroPercents(entry);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Text(
                          _formatDate(entry.dateTime),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    Card(
                      color: const Color(0xFFF7F5FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        onTap: () => _showEntryDetails(context, entry),
                        leading: CircleAvatar(
                          radius: 24,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                entry.totalCalories
                                    .toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'kcal',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          'Carb ${entry.carbs.toStringAsFixed(1)}g • '
                          'Prot ${entry.protein.toStringAsFixed(1)}g • '
                          'Fat ${entry.fat.toStringAsFixed(1)}g',
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tap for details • '
                              'C ${(percents['carbs']! * 100).toStringAsFixed(0)}% '
                              'P ${(percents['protein']! * 100).toStringAsFixed(0)}% '
                              'F ${(percents['fat']! * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${entry.dateTime.hour.toString().padLeft(2, '0')}:'
                          '${entry.dateTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
