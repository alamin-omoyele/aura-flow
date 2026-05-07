import 'package:flutter/material.dart';
import '../models/habit.dart';

// This is like a central brain that all screens can talk to
class DataService extends ChangeNotifier {
  // Singleton pattern - only one instance exists
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();
  
  // All the data
  List<Habit> habits = [];
  
  // Settings
  int timerDuration = 25;
  bool hapticFeedback = true;
  bool notificationsEnabled = true;
  String theme = 'Light';
  
  // Add a new habit
  void addHabit(String name, String target) {
    habits.add(Habit(name: name, target: target));
    notifyListeners(); // Tell all screens to update
  }
  
  // Toggle habit completion
  void toggleHabit(int index) {
    if (habits[index].isCompleted) {
      habits[index].uncomplete();
    } else {
      habits[index].complete();
    }
    notifyListeners();
  }
  
  // Delete a habit
  void deleteHabit(int index) {
    habits.removeAt(index);
    notifyListeners();
  }
  
  // Update timer duration
  void setTimerDuration(int minutes) {
    timerDuration = minutes;
    notifyListeners();
  }
  
  // Update haptic feedback setting
  void setHapticFeedback(bool enabled) {
    hapticFeedback = enabled;
    notifyListeners();
  }
  
  // Clear all data
  void clearAllData() {
    habits.clear();
    timerDuration = 25;
    hapticFeedback = true;
    notificationsEnabled = true;
    notifyListeners();
  }
  
  // ========== STATISTICS CALCULATIONS ==========
  
  // Total habits
  int get totalHabits => habits.length;
  
  // Completed habits today
  int get completedToday {
    int count = 0;
    for (var habit in habits) {
      if (habit.isCompleted) count++;
    }
    return count;
  }
  
  // Completion rate percentage
  double get completionRate {
    if (habits.isEmpty) return 0;
    return (completedToday / habits.length) * 100;
  }
  
  // Current streak (simplified - uses today's completion)
  int get currentStreak {
    int streak = 0;
    for (var habit in habits) {
      if (habit.isCompleted) {
        streak++;
      }
    }
    return streak;
  }
  
  // Longest streak ever
  int get longestStreak {
    int maxStreak = 0;
    for (var habit in habits) {
      if (habit.streak > maxStreak) {
        maxStreak = habit.streak;
      }
    }
    return maxStreak;
  }
  
  // Total focus time (sum of all completed focus sessions)
  int get totalFocusHours {
    // Simplified: each focus habit = 1 hour
    int count = 0;
    for (var habit in habits) {
      if (habit.name.contains('Focus') && habit.isCompleted) {
        count++;
      }
    }
    return count;
  }
  
  // Weekly completion data for chart
  Map<String, double> get weeklyData {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    Map<String, double> data = {};
    
    for (var day in days) {
      int completed = 0;
      for (var habit in habits) {
        if (habit.isCompleted) {
          completed++;
        }
      }
      data[day] = (completed / habits.length) * 100;
    }
    return data;
  }
  
  // Recent activity (last 5 completions)
  List<Map<String, dynamic>> get recentActivity {
    List<Map<String, dynamic>> activities = [];
    
    for (var habit in habits) {
      if (habit.isCompleted) {
        activities.add({
          'name': habit.name,
          'target': habit.target,
          'completedDate': DateTime.now(),
          'streak': habit.streak,
        });
      }
    }
    
    // Return last 3 activities
    return activities.take(3).toList();
  }
}