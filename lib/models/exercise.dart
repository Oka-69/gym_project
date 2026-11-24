import 'exercise_set.dart';

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
