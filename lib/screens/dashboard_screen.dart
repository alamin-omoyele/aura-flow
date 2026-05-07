import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'add_habit_screen.dart';
import 'timer_screen.dart';
import '../services/data_service.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> _quotes = [
    '"Build better habits, one focused session at a time."',
    '"Small steps every day lead to big results."',
    '"You didn\'t come this far to only come this far."',
    '"Focus on being productive, not busy."',
    '"The secret of getting ahead is getting started."',
    '"Don\'t watch the clock; do what it does. Keep going."',
  ];
  
  late String _currentQuote;
  
  @override
  void initState() {
    super.initState();
    _pickRandomQuote();
  }
  
  void _pickRandomQuote() {
    final random = Random();
    int randomIndex = random.nextInt(_quotes.length);
    setState(() {
      _currentQuote = _quotes[randomIndex];
    });
  }
  
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
  
  void _openAddHabitScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );
    
    if (result != null) {
      final dataService = Provider.of<DataService>(context, listen: false);
      dataService.addHabit(result['name'], result['target']);
    }
  }
  
  void _openTimerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TimerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    final habits = dataService.habits;
    
    return Container(
      color: const Color(0xFFF8FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromRGBO(77, 182, 172, 0.1),
                      const Color.fromRGBO(77, 182, 172, 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color.fromRGBO(77, 182, 172, 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentQuote,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openTimerScreen,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color.fromRGBO(77, 182, 172, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer_outlined, size: 24),
                          const SizedBox(width: 12),
                          const Text(
                            'Start Focus Session',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _openAddHabitScreen,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: const Color.fromRGBO(77, 182, 172, 1),
                        side: const BorderSide(
                          color: Color.fromRGBO(77, 182, 172, 1),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, size: 24),
                          const SizedBox(width: 12),
                          const Text(
                            'Create New Habit',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Today's Habits Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today\'s Habits',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(77, 182, 172, 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${habits.length} habits',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(77, 182, 172, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Habits List
              if (habits.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No habits yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap "Create New Habit" to get started!',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Dismissible(
                        key: Key(habits[index].name),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onDismissed: (direction) {
                          dataService.deleteHabit(index);
                        },
                        child: _buildHabitCard(context, index),
                      ),
                    );
                  },
                ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHabitCard(BuildContext context, int index) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final habit = dataService.habits[index];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => dataService.toggleHabit(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: habit.isCompleted
                      ? const Color.fromRGBO(77, 182, 172, 1)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: habit.isCompleted
                    ? const Color.fromRGBO(77, 182, 172, 1)
                    : Colors.transparent,
              ),
              child: habit.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Habit name and target
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decoration: habit.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: habit.isCompleted ? Colors.grey.shade500 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.flag, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      'Target: ${habit.target}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Streak badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(77, 182, 172, 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department, size: 14, color: const Color.fromRGBO(77, 182, 172, 1)),
                const SizedBox(width: 4),
                Text(
                  '${habit.streak}d',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(77, 182, 172, 1),
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