import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onSetCompleted;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onSetCompleted,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  void _showInstructionModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.exercise.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          widget.exercise.targetMuscle,
                          style: TextStyle(
                            color: isDark
                                ? Colors.amberAccent
                                : Colors.deepPurple,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'How to Perform:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.exercise.instructions,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey : Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.exercise.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                      width: 50,
                      height: 50,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exercise.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.exercise.targetMuscle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.amberAccent
                              : Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _showInstructionModal(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'SET',
                    style: TextStyle(
                      color: isDark ? Colors.grey : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'KG',
                    style: TextStyle(
                      color: isDark ? Colors.grey : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'REPS',
                    style: TextStyle(
                      color: isDark ? Colors.grey : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Text(
                    'DONE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.grey : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: isDark ? Colors.white10 : Colors.black12),
            ...widget.exercise.sets.map((setInfo) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#${setInfo.setNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${setInfo.weight} kg',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${setInfo.reps}',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: setInfo.isCompleted,
                        onChanged: (bool? val) {
                          setState(() {
                            setInfo.isCompleted = val ?? false;
                          });

                          if (setInfo.isCompleted) {
                            widget.onSetCompleted();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
