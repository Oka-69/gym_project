import 'package:flutter/material.dart';
import '../models/workout_day.dart';
import '../theme/theme_notifier.dart';

class HomeScreen extends StatefulWidget {
  final List<WorkoutDay> workouts;
  final ValueChanged<int> onStartWorkout;
  final ValueChanged<String> onCreateWorkout;
  final ValueChanged<int> onDeleteWorkout;
  final VoidCallback onOpenProgress;

  const HomeScreen({
    super.key,
    required this.workouts,
    required this.onStartWorkout,
    required this.onCreateWorkout,
    required this.onDeleteWorkout,
    required this.onOpenProgress,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedWorkoutIndex;

  Future<void> _showCreateWorkoutDialog() async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Workout'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter workout name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (name != null && name.trim().isNotEmpty) {
      final oldLength = widget.workouts.length;
      widget.onCreateWorkout(name);

      if (widget.workouts.length > oldLength) {
        setState(() {
          _selectedWorkoutIndex = widget.workouts.length - 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LiftIQ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: isDark ? Colors.amberAccent : Colors.deepPurple,
            ),
            onPressed: () {
              themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'READY TO TRAIN?',
            style: TextStyle(
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Build your strength.',
            style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a workout and keep track of every set.',
            style: TextStyle(color: mutedColor, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateWorkoutDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Workout'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your workout plan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...List.generate(widget.workouts.length, (index) {
            final workout = widget.workouts[index];
            final isSelected = _selectedWorkoutIndex == index;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.15)
                  : null,
              child: ListTile(
                onTap: () {
                  setState(() => _selectedWorkoutIndex = index);
                },
                leading: const CircleAvatar(
                  child: Icon(Icons.fitness_center),
                ),
                title: Text(
                  workout.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${workout.subtitle} • ${workout.exercises.length} exercises',
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => widget.onDeleteWorkout(index),
                ),
              ),
            );
          }),
          if (_selectedWorkoutIndex != null &&
              _selectedWorkoutIndex! < widget.workouts.length) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    widget.onStartWorkout(_selectedWorkoutIndex!),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Workout'),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Track your progress'),
              subtitle: const Text(
                'View your workout activity and stats.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: widget.onOpenProgress,
            ),
          ),
        ],
      ),
    );
  }
}
