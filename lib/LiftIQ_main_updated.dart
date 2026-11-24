
import 'dart:async';
import 'package:flutter/material.dart';

// Global Theme Notifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() {
  runApp(const GymRoutineApp());
}

class GymRoutineApp extends StatelessWidget {
  const GymRoutineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LiftIQ',
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF4F5F9),
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              surface: Colors.white,
              secondary: Colors.amber,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F0F12),
            primaryColor: Colors.deepPurpleAccent,
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurpleAccent,
              surface: Color(0xFF1E1E24),
              secondary: Colors.amberAccent,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E24),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            useMaterial3: true,
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), _showMainScreen);
  }

  void _showMainScreen() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement<void, void>(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF171226), Color(0xFF0F0F12), Color(0xFF20163A)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.55),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withValues(alpha: 0.25),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 52,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'LiftIQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Train with purpose. Track every rep.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------- Workout Session Model ----------------------

class WorkoutSession {
  final String workoutName;
  final DateTime completedAt;
  final Duration duration;
  final int completedExercises;
  final int totalExercises;
  final int completedSets;
  final int totalSets;

  WorkoutSession({
    required this.workoutName,
    required this.completedAt,
    required this.duration,
    required this.completedExercises,
    required this.totalExercises,
    required this.completedSets,
    required this.totalSets,
  });
}

// ---------------------- Main Navigation ----------------------

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _showingWorkout = false;
  int _selectedWorkoutIndex = 0;

  final List<WorkoutSession> _completedWorkouts = [];

  final List<WorkoutDay> _workouts = [
    WorkoutDay(
      title: 'Upper A',
      subtitle: 'Chest, Back & Arms',
      exercises: [
        exerciseRecommendations['Chest']![0].clone(),
        exerciseRecommendations['Back']![0].clone(),
        exerciseRecommendations['Arms']![0].clone(),
      ],
    ),
    WorkoutDay(
      title: 'Lower A',
      subtitle: 'Quads & Hamstrings',
      exercises: [
        exerciseRecommendations['Legs']![0].clone(),
        exerciseRecommendations['Legs']![1].clone(),
      ],
    ),
    WorkoutDay(
      title: 'Upper B',
      subtitle: 'Shoulders & Arms',
      exercises: [
        exerciseRecommendations['Chest']![1].clone(),
        exerciseRecommendations['Shoulders']![0].clone(),
      ],
    ),
    WorkoutDay(
      title: 'Lower B',
      subtitle: 'Legs & Calves Focus',
      exercises: [
        exerciseRecommendations['Legs']![2].clone(),
      ],
    ),
  ];

  void _recordWorkout(WorkoutSession session) {
    setState(() {
      _completedWorkouts.insert(0, session);
    });
  }

  void _startWorkout(int index) {
    setState(() {
      _selectedWorkoutIndex = index;
      _showingWorkout = true;
    });
  }

  void _goHome() {
    setState(() {
      _showingWorkout = false;
      _selectedIndex = 0;
    });
  }

  void _createWorkout(String name) {
    if (name.trim().isEmpty) return;

    if (_workouts.any(
      (workout) => workout.title.toLowerCase() == name.trim().toLowerCase(),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A workout with this name already exists.'),
        ),
      );
      return;
    }

    setState(() {
      _workouts.add(
        WorkoutDay(
          title: name.trim(),
          subtitle: 'Custom Workout',
          exercises: [],
        ),
      );
    });
  }

  Future<void> _deleteWorkout(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Workout?'),
        content: Text(
          'Are you sure you want to delete "${_workouts[index].title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _workouts.removeAt(index);
        _showingWorkout = false;
        _selectedIndex = 0;
      });
    }
  }

  void _openProgress() {
    setState(() {
      _selectedIndex = 1;
      _showingWorkout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showingWorkout
          ? MainWorkoutScreen(
              key: ValueKey(_selectedWorkoutIndex),
              workouts: _workouts,
              initialDayIndex: _selectedWorkoutIndex,
              onExit: _goHome,
              onWorkoutFinished: _recordWorkout,
            )
          : IndexedStack(
              index: _selectedIndex,
              children: [
                HomeScreen(
                  workouts: _workouts,
                  onStartWorkout: _startWorkout,
                  onCreateWorkout: _createWorkout,
                  onDeleteWorkout: _deleteWorkout,
                  onOpenProgress: _openProgress,
                ),
                ProgressScreen(
                  completedWorkouts: _completedWorkouts,
                ),
              ],
            ),
      bottomNavigationBar: _showingWorkout
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights),
                  label: 'Progress',
                ),
              ],
            ),
    );
  }
}

// ---------------------- Home Screen ----------------------

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

// ---------------------- Progress Screen ----------------------

class ProgressScreen extends StatelessWidget {
  final List<WorkoutSession> completedWorkouts;

  const ProgressScreen({
    super.key,
    required this.completedWorkouts,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) return '${hours}h ${minutes}m';
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day} ${months[date.month - 1]} ${date.year} • '
        '$hour:$minute $period';
  }

  Widget _statCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primary, size: 25),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalSets = completedWorkouts.fold<int>(
      0,
      (total, workout) => total + workout.completedSets,
    );

    final totalExercises = completedWorkouts.fold<int>(
      0,
      (total, workout) => total + workout.completedExercises,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Progress',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: completedWorkouts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insights,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Your progress starts here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Finish your first workout to see your workout history '
                      'and statistics here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'YOUR ACTIVITY',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Keep getting stronger.',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),

                // Statistics
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        context,
                        icon: Icons.fitness_center,
                        label: 'Workouts',
                        value: '${completedWorkouts.length}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        context,
                        icon: Icons.check_circle_outline,
                        label: 'Sets completed',
                        value: '$totalSets',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        context,
                        icon: Icons.sports_gymnastics,
                        label: 'Exercises',
                        value: '$totalExercises',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),
                const Text(
                  'Workout History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ...completedWorkouts.map((workout) {
                  final progress = workout.totalSets == 0
                      ? 0.0
                      : workout.completedSets / workout.totalSets;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.15),
                                child: Icon(
                                  Icons.fitness_center,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      workout.workoutName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(workout.completedAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Set completion',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${workout.completedSets}/${workout.totalSets}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor:
                                  isDark ? Colors.white12 : Colors.black12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _historyDetail(
                                  context,
                                  Icons.timer_outlined,
                                  _formatDuration(workout.duration),
                                  'Duration',
                                ),
                              ),
                              Expanded(
                                child: _historyDetail(
                                  context,
                                  Icons.fitness_center,
                                  '${workout.completedExercises}/${workout.totalExercises}',
                                  'Exercises',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget _historyDetail(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[400]
        : Colors.grey[600];

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: muted),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------- Models ----------------------

class ExerciseSet {
  int setNumber;
  double weight;
  int reps;
  bool isCompleted;

  ExerciseSet({
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });
}

class Exercise {
  final String name;
  final String targetMuscle;
  final String imageUrl;
  final String instructions;
  final List<ExerciseSet> sets;

  Exercise({
    required this.name,
    required this.targetMuscle,
    required this.imageUrl,
    required this.instructions,
    required this.sets,
  });

  Exercise clone() {
    return Exercise(
      name: name,
      targetMuscle: targetMuscle,
      imageUrl: imageUrl,
      instructions: instructions,
      sets: [
        ExerciseSet(setNumber: 1, weight: 20, reps: 10),
        ExerciseSet(setNumber: 2, weight: 25, reps: 10),
        ExerciseSet(setNumber: 3, weight: 30, reps: 8),
      ],
    );
  }
}

class WorkoutDay {
  final String title;
  final String subtitle;
  final List<Exercise> exercises;

  WorkoutDay({
    required this.title,
    required this.subtitle,
    required this.exercises,
  });
}

// ---------------------- Exercise Library ----------------------

final Map<String, List<Exercise>> exerciseRecommendations = {
  'Chest': [
    Exercise(
      name: 'Incline Dumbbell Press',
      targetMuscle: 'Upper Chest',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Incline_Dumbbell_Press/0.jpg',
      instructions: 'Set bench to 30-45 degrees. Press dumbbells upward, focusing on upper chest contraction.',
      sets: [],
    ),
    Exercise(
      name: 'Barbell Bench Press',
      targetMuscle: 'Mid Chest',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bench_Press_-_Medium_Grip/0.jpg',
      instructions: 'Plant feet on floor, lower bar to sternum, press up explosively.',
      sets: [],
    ),
    Exercise(
      name: 'Flat Dumbbell Press',
      targetMuscle: 'Mid Chest & Stability',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Bench_Press/0.jpg',
      instructions: 'Lie on flat bench. Lower dumbbells to chest level and press vertically.',
      sets: [],
    ),
    Exercise(
      name: 'Low-to-High Cable Fly',
      targetMuscle: 'Upper & Inner Chest',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Low_Cable_Crossover/0.jpg',
      instructions: 'Set cables low, bring handles up and together in an arching motion.',
      sets: [],
    ),
    Exercise(
      name: 'Pec Deck Machine Fly',
      targetMuscle: 'Inner Chest Isolation',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Butterfly/0.jpg',
      instructions: 'Sit upright, squeeze handles together in front of chest with slight elbow bend.',
      sets: [],
    ),
    Exercise(
      name: 'Chest Dips',
      targetMuscle: 'Lower Chest & Triceps',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dips_-_Chest_Version/0.jpg',
      instructions: 'Lean forward slightly on dip bars, lower body until upper arms are parallel to floor.',
      sets: [],
    ),
    Exercise(
      name: 'Push-Ups',
      targetMuscle: 'Chest, Triceps & Front Delts',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Push-Up/0.jpg',
      instructions: 'Start in a high plank with hands just wider than shoulder-width. Keep your body straight, lower your chest under control, then press the floor away to return to the top.',
      sets: [],
    ),
    Exercise(
      name: 'Cable Crossover',
      targetMuscle: 'Chest',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Crossover/0.jpg',
      instructions: 'Set the pulleys high and stand in the middle. With a slight bend in your elbows, bring the handles down and together in front of your torso. Return slowly until you feel a comfortable chest stretch.',
      sets: [],
    ),
  ],
  'Back': [
    Exercise(
      name: 'Lat Pulldown',
      targetMuscle: 'Lats & Upper Back',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Wide-Grip_Lat_Pulldown/0.jpg',
      instructions: 'Pull bar down to upper chest while driving elbows down and squeezing lats.',
      sets: [],
    ),
    Exercise(
      name: 'Seated Cable Row',
      targetMuscle: 'Mid Back & Thickness',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Seated_Cable_Rows/0.jpg',
      instructions: 'Pull handle towards lower abdomen while squeezing shoulder blades together.',
      sets: [],
    ),
    Exercise(
      name: 'Barbell Bent-Over Row',
      targetMuscle: 'Overall Back Mass',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Bent_Over_Barbell_Row/0.jpg',
      instructions: 'Hinge hips at 45 degrees, pull barbell to lower chest keeping back neutral.',
      sets: [],
    ),
    Exercise(
      name: 'Single-Arm Dumbbell Row',
      targetMuscle: 'Lat Isolation',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/One-Arm_Dumbbell_Row/0.jpg',
      instructions: 'Support knee on bench, pull dumbbell to hip keeping elbow tucked close.',
      sets: [],
    ),
    Exercise(
      name: 'Face Pulls',
      targetMuscle: 'Rear Delts & Upper Traps',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Face_Pull/0.jpg',
      instructions: 'Attach rope to upper cable, pull towards eyes flaring elbows out.',
      sets: [],
    ),
    Exercise(
      name: 'Pull-Ups',
      targetMuscle: 'Lats & Upper Back',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Pullups/0.jpg',
      instructions: 'Hang from the bar with a comfortable overhand grip. Pull your chest toward the bar by driving your elbows down, then lower until your arms are extended with control.',
      sets: [],
    ),
    Exercise(
      name: 'Chest-Supported Row',
      targetMuscle: 'Mid Back & Lats',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Incline_Bench_Pull/0.jpg',
      instructions: 'Set an incline bench around 30–45 degrees and lie chest-down with a dumbbell in each hand. Row the weights toward your hips while keeping your chest on the bench, then lower slowly.',
      sets: [],
    ),
  ],
  'Legs': [
    Exercise(
      name: 'Hack Squat',
      targetMuscle: 'Quads',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Hack_Squat/0.jpg',
      instructions: 'Keep back flat against pad, lower to 90 degrees and push up through heels.',
      sets: [],
    ),
    Exercise(
      name: 'Romanian Deadlift',
      targetMuscle: 'Hamstrings & Glutes',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Romanian_Deadlift/0.jpg',
      instructions: 'Hinge hips backward with soft knees until hamstring stretch is felt.',
      sets: [],
    ),
    Exercise(
      name: 'Leg Press',
      targetMuscle: 'Quads & Glutes',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Press/0.jpg',
      instructions: 'Place feet shoulder-width, lower sled with control, extend without locking knees.',
      sets: [],
    ),
    Exercise(
      name: 'Barbell Back Squat',
      targetMuscle: 'Quads & Core',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Squat/0.jpg',
      instructions: 'Rest bar on upper traps, lower hips below parallel, drive up explosively.',
      sets: [],
    ),
    Exercise(
      name: 'Leg Extension',
      targetMuscle: 'Quad Isolation',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Extensions/0.jpg',
      instructions: 'Sit on machine, extend legs upward contracting quads fully at top.',
      sets: [],
    ),
    Exercise(
      name: 'Lying Leg Curl',
      targetMuscle: 'Hamstring Isolation',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Lying_Leg_Curls/0.jpg',
      instructions: 'Lie face down, curl pad towards glutes squeezing hamstrings.',
      sets: [],
    ),
    Exercise(
      name: 'Standing Calf Raise',
      targetMuscle: 'Calves',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Standing_Calf_Raises/0.jpg',
      instructions: 'Raise up on toes, pause at peak contraction, lower heels below platform level.',
      sets: [],
    ),
    Exercise(
      name: 'Bulgarian Split Squat',
      targetMuscle: 'Quads & Glutes',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Split_Squat_with_Dumbbells/0.jpg',
      instructions: 'Stand in a split stance with your rear foot resting on a bench. Lower your hips under control while keeping your front foot planted and knee tracking with your toes. Drive through the front foot to stand.',
      sets: [],
    ),
    Exercise(
      name: 'Hip Thrust',
      targetMuscle: 'Glutes',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Hip_Thrust/0.jpg',
      instructions: 'Rest your upper back against a bench with feet flat and knees bent. Drive through your heels to raise your hips until your torso is nearly parallel to the floor. Squeeze your glutes, then lower with control.',
      sets: [],
    ),
  ],
  'Arms': [
    Exercise(
      name: 'Cable Curls',
      targetMuscle: 'Biceps',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Hammer_Curls_-_Rope_Attachment/0.jpg',
      instructions: 'Keep elbows tucked to sides, curl handle upward squeezing biceps.',
      sets: [],
    ),
    Exercise(
      name: 'Tricep Rope Pushdown',
      targetMuscle: 'Triceps',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Triceps_Pushdown/0.jpg',
      instructions: 'Push rope down and spread ends apart at bottom for full contraction.',
      sets: [],
    ),
    Exercise(
      name: 'Dumbbell Hammer Curls',
      targetMuscle: 'Brachialis & Forearms',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Alternate_Hammer_Curl/0.jpg',
      instructions: 'Hold dumbbells with neutral grip (palms facing each other), curl up to shoulders.',
      sets: [],
    ),
    Exercise(
      name: 'EZ-Bar Skull Crushers',
      targetMuscle: 'Tricep Long Head',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/EZ-Bar_Skullcrusher/0.jpg',
      instructions: 'Lie on flat bench, bend elbows to lower bar towards forehead, extend back up.',
      sets: [],
    ),
    Exercise(
      name: 'Incline Dumbbell Curl',
      targetMuscle: 'Bicep Long Head Stretch',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Incline_Dumbbell_Curl/0.jpg',
      instructions: 'Sit on incline bench, let arms hang down, curl dumbbells upward without moving shoulders.',
      sets: [],
    ),
    Exercise(
      name: 'EZ-Bar Curl',
      targetMuscle: 'Biceps',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/EZ-Bar_Curl/0.jpg',
      instructions: 'Stand tall holding an EZ-bar with a comfortable underhand grip. Keep your elbows close to your sides, curl the bar without swinging, then lower slowly.',
      sets: [],
    ),
    Exercise(
      name: 'Overhead Cable Triceps Extension',
      targetMuscle: 'Triceps Long Head',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Rope_Overhead_Triceps_Extension/0.jpg',
      instructions: 'Face away from a low cable pulley holding a rope behind your head. Keep your upper arms close to your ears and extend your elbows until your arms are straight. Return slowly.',
      sets: [],
    ),
  ],
  'Shoulders': [
    Exercise(
      name: 'Dumbbell Lateral Raise',
      targetMuscle: 'Side Delts',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Side_Lateral_Raise/0.jpg',
      instructions: 'Raise dumbbells outward to shoulder height with a slight elbow bend.',
      sets: [],
    ),
    Exercise(
      name: 'Overhead Dumbbell Press',
      targetMuscle: 'Front & Side Delts',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Shoulder_Press/0.jpg',
      instructions: 'Press dumbbells overhead from ear level until arms extend fully.',
      sets: [],
    ),
    Exercise(
      name: 'Arnold Press',
      targetMuscle: 'All Shoulder Heads',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Arnold_Dumbbell_Press/0.jpg',
      instructions: 'Start with palms facing you at chest, rotate palms outward as you press overhead.',
      sets: [],
    ),
    Exercise(
      name: 'Rear Delt Cable Fly',
      targetMuscle: 'Rear Delts',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Rear_Delt_Fly/0.jpg',
      instructions: 'Cross cables at chest height, pull handles back horizontally across chest.',
      sets: [],
    ),
    Exercise(
      name: 'Machine Shoulder Press',
      targetMuscle: 'Front & Side Delts',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Machine_Shoulder_Military_Press/0.jpg',
      instructions: 'Adjust the seat so the handles start around shoulder height. Brace your torso and press upward without shrugging, then lower slowly to the starting position.',
      sets: [],
    ),
    Exercise(
      name: 'Reverse Pec Deck',
      targetMuscle: 'Rear Delts',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Reverse_Machine_Flyes/0.jpg',
      instructions: 'Face the pec-deck pad and hold the handles with arms slightly bent. Move your arms out and back in a controlled arc, squeezing your rear delts, then return slowly.',
      sets: [],
    ),
  ],
  'Core': [
    Exercise(
      name: 'Cable Kneeling Crunch',
      targetMuscle: 'Upper Abs',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Crunch/0.jpg',
      instructions: 'Kneel in front of cable machine, hold rope behind neck, flex spine downward.',
      sets: [],
    ),
    Exercise(
      name: 'Hanging Leg Raise',
      targetMuscle: 'Lower Abs',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Hanging_Leg_Raise/0.jpg',
      instructions: 'Hang from pull-up bar, lift knees or straight legs up towards chest.',
      sets: [],
    ),
    Exercise(
      name: 'Plank',
      targetMuscle: 'Core & Abdominals',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Plank/1.jpg',
      instructions: 'Support your body on your forearms and toes. Keep your elbows under your shoulders and your body in a straight line. Brace your abs and glutes; avoid letting your hips sag or rise.',
      sets: [],
    ),
    Exercise(
      name: 'Cable Woodchop',
      targetMuscle: 'Obliques & Core',
      imageUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Standing_Cable_Wood_Chop/0.jpg',
      instructions: 'Set a cable high and stand sideways to the machine. Hold the handle with both hands and pull it diagonally down across your body while rotating your torso under control. Return slowly and repeat on both sides.',
      sets: [],
    ),
  ],
};

// ---------------------- Main Workout Screen ----------------------

class MainWorkoutScreen extends StatefulWidget {
  final List<WorkoutDay> workouts;
  final int initialDayIndex;
  final VoidCallback onExit;
  final ValueChanged<WorkoutSession> onWorkoutFinished;

  const MainWorkoutScreen({
    super.key,
    required this.workouts,
    required this.initialDayIndex,
    required this.onExit,
    required this.onWorkoutFinished,
  });

  @override
  State<MainWorkoutScreen> createState() => _MainWorkoutScreenState();
}

class _MainWorkoutScreenState extends State<MainWorkoutScreen> {
  int _selectedDayIndex = 0;
  late List<WorkoutDay> _workoutProgram;

  Timer? _restTimer;
  int _restSeconds = 90;
  int _selectedRestDuration = 90;
  bool _isTimerActive = false;
  bool _isFinishing = false;
  String _activeExerciseName = '';

  final Stopwatch _workoutStopwatch = Stopwatch();

  void selectDay(int index) {
    if (!mounted || index < 0 || index >= _workoutProgram.length) {
      return;
    }

    setState(() {
      _selectedDayIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _workoutProgram = widget.workouts;
    _selectedDayIndex = widget.initialDayIndex;
    _workoutStopwatch.start();
  }

  void _startRestTimer(String exerciseName) {
    _restTimer?.cancel();

    setState(() {
      _restSeconds = _selectedRestDuration;
      _isTimerActive = true;
      _activeExerciseName = exerciseName;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSeconds > 0) {
        if (mounted) {
          setState(() {
            _restSeconds--;
          });
        }
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _restTimer?.cancel();

    if (mounted) {
      setState(() {
        _isTimerActive = false;
      });
    }
  }

  Future<void> _confirmFinishWorkout() async {
    if (_isFinishing) return;

    final shouldFinish = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Finish Workout?'),
        content: const Text(
          'Are you sure you want to finish this workout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep Training'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Finish Workout'),
          ),
        ],
      ),
    );

    if (shouldFinish != true || !mounted) return;

    setState(() {
      _isFinishing = true;
      _isTimerActive = false;
    });

    _restTimer?.cancel();
    _workoutStopwatch.stop();

    // Only count the workout currently selected.
    final currentWorkout = _workoutProgram[_selectedDayIndex];
    final exercises = currentWorkout.exercises;

    final completedSets = exercises
        .expand((exercise) => exercise.sets)
        .where((set) => set.isCompleted)
        .length;

    final totalSets = exercises.fold<int>(
      0,
      (total, exercise) => total + exercise.sets.length,
    );

    final completedExercises = exercises.where((exercise) {
      return exercise.sets.isNotEmpty &&
          exercise.sets.every((set) => set.isCompleted);
    }).length;

    final session = WorkoutSession(
      workoutName: currentWorkout.title,
      completedAt: DateTime.now(),
      duration: _workoutStopwatch.elapsed,
      completedExercises: completedExercises,
      totalExercises: exercises.length,
      completedSets: completedSets,
      totalSets: totalSets,
    );

    // Save this workout in the Progress screen.
    widget.onWorkoutFinished(session);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutCompletionScreen(
          workoutName: session.workoutName,
          duration: session.duration,
          completedExercises: session.completedExercises,
          totalExercises: session.totalExercises,
          completedSets: session.completedSets,
          totalSets: session.totalSets,
          onDone: () {
            Navigator.of(context).pop();
            widget.onExit();
          },
        ),
      ),
    );
  }

  String _formatTimerText(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _openExerciseSelectorModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ExerciseRecommendationSelector(
          onExerciseSelected: (selectedExercise) {
            setState(() {
              _workoutProgram[_selectedDayIndex]
                  .exercises
                  .add(selectedExercise.clone());
            });

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Added ${selectedExercise.name} to '
                  '${_workoutProgram[_selectedDayIndex].title}!',
                ),
                backgroundColor: Theme.of(context).primaryColor,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _workoutStopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentDay = _workoutProgram[_selectedDayIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onExit,
        ),
        title: const Text(
          'LIFTIQ WORKOUT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: OutlinedButton.icon(
              onPressed: _confirmFinishWorkout,
              icon: const Icon(Icons.flag_rounded, size: 16),
              label: const Text('Finish'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: isDark ? Colors.amberAccent : Colors.deepPurple,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // Day Selection
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _workoutProgram.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedDayIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(
                      _workoutProgram[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.grey : Colors.black87),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Theme.of(context).primaryColor,
                    backgroundColor:
                        isDark ? const Color(0xFF1E1E24) : Colors.grey[200],
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDayIndex = index;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Day Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentDay.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      currentDay.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _openExerciseSelectorModal(context),
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Exercise',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: isDark ? Colors.white12 : Colors.black12),

          // Rest Duration Selector
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'REST BETWEEN SETS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Selected: ${_selectedRestDuration >= 60 ? '${_selectedRestDuration ~/ 60} min${_selectedRestDuration % 60 == 0 ? '' : ' ${_selectedRestDuration % 60}s'}' : '${_selectedRestDuration}s'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _restChip(30, '30s', isDark),
                    _restChip(45, '45s', isDark),
                    _restChip(60, '1m', isDark),
                    _restChip(90, '1.5m', isDark),
                    _restChip(120, '2m', isDark),
                    _restChip(180, '3m', isDark),
                  ],
                ),
              ],
            ),
          ),

          Divider(color: isDark ? Colors.white10 : Colors.black12),

          // Exercise List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: currentDay.exercises.length,
              itemBuilder: (context, exIndex) {
                final exercise = currentDay.exercises[exIndex];

                return ExerciseCard(
                  exercise: exercise,
                  onSetCompleted: () {
                    _startRestTimer(exercise.name);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isTimerActive
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF282834) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black45 : Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color:
                              isDark ? Colors.amberAccent : Colors.deepOrange,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resting after $_activeExerciseName',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.grey
                                    : Colors.grey[600],
                              ),
                            ),
                            Text(
                              _formatTimerText(_restSeconds),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.amberAccent
                                    : Colors.orange[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _restSeconds += 15;
                            });
                          },
                          child: Text(
                            '+15s',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: _stopTimer,
                          child: const Text(
                            'Skip Rest',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _restChip(int seconds, String label, bool isDark) {
    final isSelected = _selectedRestDuration == seconds;
    final primary = Theme.of(context).colorScheme.primary;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.white70 : Colors.black87),
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: primary,
      backgroundColor: isDark ? const Color(0xFF282834) : Colors.grey[200],
      side: BorderSide(
        color: isSelected ? primary : (isDark ? Colors.white12 : Colors.black12),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedRestDuration = seconds;
          });
        }
      },
    );
  }
}

// ---------------------- Workout Completion Screen ----------------------

class WorkoutCompletionScreen extends StatelessWidget {
  final String workoutName;
  final Duration duration;
  final int completedExercises;
  final int totalExercises;
  final int completedSets;
  final int totalSets;
  final VoidCallback onDone;

  const WorkoutCompletionScreen({
    super.key,
    required this.workoutName,
    required this.duration,
    required this.completedExercises,
    required this.totalExercises,
    required this.completedSets,
    required this.totalSets,
    required this.onDone,
  });

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }

    return '${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withValues(alpha: 0.13),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 72,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'WORKOUT COMPLETED!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Great work. You showed up and put in the effort.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                workoutName,
                style: TextStyle(
                  color: primary,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 36),
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      context,
                      icon: Icons.timer_outlined,
                      label: 'DURATION',
                      value: formattedDuration,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryCard(
                      context,
                      icon: Icons.fitness_center,
                      label: 'EXERCISES',
                      value: '$completedExercises / $totalExercises',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _summaryCard(
                context,
                icon: Icons.check_circle_outline,
                label: 'SETS COMPLETED',
                value: '$completedSets / $totalSets',
                fullWidth: true,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: onDone,
                  icon: const Icon(Icons.home_rounded),
                  label: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool fullWidth = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- Exercise Selector Modal ----------------------

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

// ---------------------- Exercise Card Widget ----------------------

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
