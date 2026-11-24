import 'package:flutter/material.dart';
import '../data/exercise_recommendations.dart';
import '../models/workout_day.dart';
import '../models/workout_session.dart';
import '../theme/theme_notifier.dart';
import 'home_screen.dart';
import 'main_workout_screen.dart';
import 'progress_screen.dart';

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
