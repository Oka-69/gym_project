import 'dart:async';
import 'package:flutter/material.dart';

// Global Theme Notifier for instant toggling
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
          title: 'Gym Routine Tracker',
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

// ---------------------- Main Navigation & New Screens ----------------------

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _showingWorkout = false;
  int _selectedWorkoutIndex = 0;

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
        const SnackBar(content: Text('A workout with this name already exists.')),
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
        content: Text('Are you sure you want to delete "${_workouts[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
                const ProgressScreen(),
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
        title: const Text('LiftIQ', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
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
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
              subtitle: const Text('View your workout activity and stats.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: widget.onOpenProgress,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[400]
        : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Progress',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Workout history, completed sessions and strength statistics '
                'will appear here once progress tracking is connected.',
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedColor, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
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

// ---------------------- Comprehensive Exercise Library ----------------------

final Map<String, List<Exercise>> exerciseRecommendations = {
  'Chest': [
    Exercise(
      name: 'Incline Dumbbell Press',
      targetMuscle: 'Upper Chest',
      imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=300',
      instructions: 'Set bench to 30-45 degrees. Press dumbbells upward, focusing on upper chest contraction.',
      sets: [],
    ),
    Exercise(
      name: 'Barbell Bench Press',
      targetMuscle: 'Mid Chest',
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=300',
      instructions: 'Plant feet on floor, lower bar to sternum, press up explosively.',
      sets: [],
    ),
    Exercise(
      name: 'Flat Dumbbell Press',
      targetMuscle: 'Mid Chest & Stability',
      imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=300',
      instructions: 'Lie on flat bench. Lower dumbbells to chest level and press vertically.',
      sets: [],
    ),
    Exercise(
      name: 'Low-to-High Cable Fly',
      targetMuscle: 'Upper & Inner Chest',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
      instructions: 'Set cables low, bring handles up and together in an arching motion.',
      sets: [],
    ),
    Exercise(
      name: 'Pec Deck Machine Fly',
      targetMuscle: 'Inner Chest Isolation',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
      instructions: 'Sit upright, squeeze handles together in front of chest with slight elbow bend.',
      sets: [],
    ),
    Exercise(
      name: 'Chest Dips',
      targetMuscle: 'Lower Chest & Triceps',
      imageUrl: 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=300',
      instructions: 'Lean forward slightly on dip bars, lower body until upper arms are parallel to floor.',
      sets: [],
    ),
  ],
  'Back': [
    Exercise(
      name: 'Lat Pulldown',
      targetMuscle: 'Lats & Upper Back',
      imageUrl: 'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=300',
      instructions: 'Pull bar down to upper chest while driving elbows down and squeezing lats.',
      sets: [],
    ),
    Exercise(
      name: 'Seated Cable Row',
      targetMuscle: 'Mid Back & Thickness',
      imageUrl: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=300',
      instructions: 'Pull handle towards lower abdomen while squeezing shoulder blades together.',
      sets: [],
    ),
    Exercise(
      name: 'Barbell Bent-Over Row',
      targetMuscle: 'Overall Back Mass',
      imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=300',
      instructions: 'Hinge hips at 45 degrees, pull barbell to lower chest keeping back neutral.',
      sets: [],
    ),
    Exercise(
      name: 'Single-Arm Dumbbell Row',
      targetMuscle: 'Lat Isolation',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300',
      instructions: 'Support knee on bench, pull dumbbell to hip keeping elbow tucked close.',
      sets: [],
    ),
    Exercise(
      name: 'Face Pulls',
      targetMuscle: 'Rear Delts & Upper Traps',
      imageUrl: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=300',
      instructions: 'Attach rope to upper cable, pull towards eyes flaring elbows out.',
      sets: [],
    ),
  ],
  'Legs': [
    Exercise(
      name: 'Hack Squat',
      targetMuscle: 'Quads',
      imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=300',
      instructions: 'Keep back flat against pad, lower to 90 degrees and push up through heels.',
      sets: [],
    ),
    Exercise(
      name: 'Romanian Deadlift',
      targetMuscle: 'Hamstrings & Glutes',
      imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=300',
      instructions: 'Hinge hips backward with soft knees until hamstring stretch is felt.',
      sets: [],
    ),
    Exercise(
      name: 'Leg Press',
      targetMuscle: 'Quads & Glutes',
      imageUrl: 'https://images.unsplash.com/photo-1534367507873-d2d7e24c797f?w=300',
      instructions: 'Place feet shoulder-width, lower sled with control, extend without locking knees.',
      sets: [],
    ),
    Exercise(
      name: 'Barbell Back Squat',
      targetMuscle: 'Quads & Core',
      imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=300',
      instructions: 'Rest bar on upper traps, lower hips below parallel, drive up explosively.',
      sets: [],
    ),
    Exercise(
      name: 'Leg Extension',
      targetMuscle: 'Quad Isolation',
      imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=300',
      instructions: 'Sit on machine, extend legs upward contracting quads fully at top.',
      sets: [],
    ),
    Exercise(
      name: 'Lying Leg Curl',
      targetMuscle: 'Hamstring Isolation',
      imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=300',
      instructions: 'Lie face down, curl pad towards glutes squeezing hamstrings.',
      sets: [],
    ),
    Exercise(
      name: 'Standing Calf Raise',
      targetMuscle: 'Calves',
      imageUrl: 'https://images.unsplash.com/photo-1534367507873-d2d7e24c797f?w=300',
      instructions: 'Raise up on toes, pause at peak contraction, lower heels below platform level.',
      sets: [],
    ),
  ],
  'Arms': [
    Exercise(
      name: 'Cable Curls',
      targetMuscle: 'Biceps',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300',
      instructions: 'Keep elbows tucked to sides, curl handle upward squeezing biceps.',
      sets: [],
    ),
    Exercise(
      name: 'Tricep Rope Pushdown',
      targetMuscle: 'Triceps',
      imageUrl: 'https://images.unsplash.com/photo-1530822847156-5df684ec5ee1?w=300',
      instructions: 'Push rope down and spread ends apart at bottom for full contraction.',
      sets: [],
    ),
    Exercise(
      name: 'Dumbbell Hammer Curls',
      targetMuscle: 'Brachialis & Forearms',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300',
      instructions: 'Hold dumbbells with neutral grip (palms facing each other), curl up to shoulders.',
      sets: [],
    ),
    Exercise(
      name: 'EZ-Bar Skull Crushers',
      targetMuscle: 'Tricep Long Head',
      imageUrl: 'https://images.unsplash.com/photo-1530822847156-5df684ec5ee1?w=300',
      instructions: 'Lie on flat bench, bend elbows to lower bar towards forehead, extend back up.',
      sets: [],
    ),
    Exercise(
      name: 'Incline Dumbbell Curl',
      targetMuscle: 'Bicep Long Head Stretch',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300',
      instructions: 'Sit on incline bench, let arms hang down, curl dumbbells upward without moving shoulders.',
      sets: [],
    ),
  ],
  'Shoulders': [
    Exercise(
      name: 'Dumbbell Lateral Raise',
      targetMuscle: 'Side Delts',
      imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=300',
      instructions: 'Raise dumbbells outward to shoulder height with a slight elbow bend.',
      sets: [],
    ),
    Exercise(
      name: 'Overhead Dumbbell Press',
      targetMuscle: 'Front & Side Delts',
      imageUrl: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=300',
      instructions: 'Press dumbbells overhead from ear level until arms extend fully.',
      sets: [],
    ),
    Exercise(
      name: 'Arnold Press',
      targetMuscle: 'All Shoulder Heads',
      imageUrl: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=300',
      instructions: 'Start with palms facing you at chest, rotate palms outward as you press overhead.',
      sets: [],
    ),
    Exercise(
      name: 'Rear Delt Cable Fly',
      targetMuscle: 'Rear Delts',
      imageUrl: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=300',
      instructions: 'Cross cables at chest height, pull handles back horizontally across chest.',
      sets: [],
    ),
  ],
  'Core': [
    Exercise(
      name: 'Cable Kneeling Crunch',
      targetMuscle: 'Upper Abs',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
      instructions: 'Kneel in front of cable machine, hold rope behind neck, flex spine downward.',
      sets: [],
    ),
    Exercise(
      name: 'Hanging Leg Raise',
      targetMuscle: 'Lower Abs',
      imageUrl: 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=300',
      instructions: 'Hang from pull-up bar, lift knees or straight legs up towards chest.',
      sets: [],
    ),
  ],
};

// ---------------------- Main Screen ----------------------
class MainWorkoutScreen extends StatefulWidget {
  final List<WorkoutDay> workouts;
  final int initialDayIndex;
  final VoidCallback onExit;

  const MainWorkoutScreen({
    super.key,
    required this.workouts,
    required this.initialDayIndex,
    required this.onExit,
  });

  @override
  State<MainWorkoutScreen> createState() => _MainWorkoutScreenState();
}

class _MainWorkoutScreenState extends State<MainWorkoutScreen> {
  int _selectedDayIndex = 0;
  late List<WorkoutDay> _workoutProgram;

  // Allows the Home screen to select a workout day.
  void selectDay(int index) {
    if (!mounted || index < 0 || index >= _workoutProgram.length) {
      return;
    }

    setState(() {
      _selectedDayIndex = index;
    });
  }

  // Rest Timer Variables
  Timer? _restTimer;
  int _restSeconds = 90;
  bool _isTimerActive = false;
  String _activeExerciseName = '';

  @override
  void initState() {
    super.initState();
    _workoutProgram = widget.workouts;
    _selectedDayIndex = widget.initialDayIndex;
  }

  void _startRestTimer(String exerciseName) {
    _restTimer?.cancel();
    setState(() {
      _restSeconds = 90;
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
          'GYM ROUTINE',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
        elevation: 1,
        actions: [
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

          // Day Selection Tab Bar
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    'Add Exercise',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: isDark ? Colors.white12 : Colors.black12),

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF282834) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black45 : Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  )
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: isDark
                              ? Colors.amberAccent
                              : Colors.deepOrange,
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
                                color:
                                    isDark ? Colors.grey : Colors.grey[600],
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
}

// ---------------------- Exercise Selector Modal with Search ----------------------

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
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
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
                      backgroundColor: isDark
                          ? const Color(0xFF282834)
                          : Colors.grey[200],
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
                      errorBuilder: (context, error, stackTrace) => Container(
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
                    errorBuilder: (context, error, stackTrace) => Container(
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