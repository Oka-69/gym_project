import 'package:flutter/material.dart';
import '../data/exercise_recommendations.dart';
import '../models/exercise.dart';

class ExerciseRecommendationSelector extends StatefulWidget {
  final Function(Exercise) onExerciseSelected;

  const ExerciseRecommendationSelector({
    super.key,
    required this.onExerciseSelected,
  });

  @override
  State<ExerciseRecommendationSelector> createState() =>
      _ExerciseRecommendationSelectorState();
}

class _ExerciseRecommendationSelectorState
    extends State<ExerciseRecommendationSelector> {
  String _selectedMuscleGroup = 'Chest';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final availableMuscles = exerciseRecommendations.keys.toList();
    final rawList = exerciseRecommendations[_selectedMuscleGroup] ?? [];

    final filteredList = rawList.where((ex) {
      final query = _searchQuery.toLowerCase();
      return ex.name.toLowerCase().contains(query) ||
          ex.targetMuscle.toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.80,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Exercise Library',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search exercise name or muscle...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey[500],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF282834) : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableMuscles.length,
                itemBuilder: (context, index) {
                  final muscle = availableMuscles[index];
                  final isSelected = _selectedMuscleGroup == muscle;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(muscle),
                      selected: isSelected,
                      selectedColor:
                          isDark ? Colors.amberAccent : Colors.deepPurple,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? (isDark ? Colors.black : Colors.white)
                            : (isDark ? Colors.white : Colors.black87),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor:
                          isDark ? const Color(0xFF282834) : Colors.grey[200],
                      onSelected: (selected) {
                        setState(() {
                          _selectedMuscleGroup = muscle;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                        'No exercises found matching "$_searchQuery"',
                        style: TextStyle(
                          color: isDark ? Colors.grey : Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final exercise = filteredList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF282834)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    exercise.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 60,
                                      height: 60,
                                      color: Theme.of(context).primaryColor,
                                      child: const Icon(
                                        Icons.fitness_center,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        exercise.targetMuscle,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.amberAccent
                                              : Colors.deepPurple,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        exercise.instructions,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.grey
                                              : Colors.grey[600],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 32,
                                  ),
                                  onPressed: () =>
                                      widget.onExerciseSelected(exercise),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
