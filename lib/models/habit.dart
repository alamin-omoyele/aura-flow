// This is the blueprint for what a Habit looks like
class Habit {
  String name;      // Name of the habit (e.g., "Morning Meditation")
  String target;    // Target (e.g., "15 minutes")
  bool isCompleted; // Is it done today?
  int streak;       // How many days in a row?
  DateTime createdDate; // When was it created?
  List<DateTime> completedDates; // Which days were completed
  
  Habit({
    required this.name,
    required this.target,
    this.isCompleted = false,
    this.streak = 0,
    DateTime? createdDate,
    List<DateTime>? completedDates,
  }) : createdDate = createdDate ?? DateTime.now(),
       completedDates = completedDates ?? [];
  
  // Mark this habit as completed for today
  void complete() {
    isCompleted = true;
    streak++;
    completedDates.add(DateTime.now());
  }
  
  // Mark as not completed
  void uncomplete() {
    isCompleted = false;
    streak--;
    completedDates.remove(DateTime.now());
  }
}