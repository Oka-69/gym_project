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
