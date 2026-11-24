import 'dart:async';
import 'package:flutter/material.dart';
import '../data/exercise_recommendations.dart';
import '../models/workout_day.dart';
import '../models/workout_session.dart';
import '../theme/theme_notifier.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_recommendation_selector.dart';
import 'workout_completion_screen.dart';

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
