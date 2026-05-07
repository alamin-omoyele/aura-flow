import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  
  void _saveAndClose() {
    if (_nameController.text.isNotEmpty && _targetController.text.isNotEmpty) {
      Navigator.pop(context, {
        'name': _nameController.text,
        'target': _targetController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          'Create New Habit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(77, 182, 172, 1),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What habit do you want to build?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start small, stay consistent.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g., Morning Meditation',
                prefixIcon: const Icon(Icons.fitness_center, color: Color.fromRGBO(77, 182, 172, 1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color.fromRGBO(77, 182, 172, 1), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: 'Target',
                hintText: 'e.g., 15 minutes, 10 pages',
                prefixIcon: const Icon(Icons.flag, color: Color.fromRGBO(77, 182, 172, 1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color.fromRGBO(77, 182, 172, 1), width: 2),
                ),
              ),
            ),
            
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveAndClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(77, 182, 172, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Create Habit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}