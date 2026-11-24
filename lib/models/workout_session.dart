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
