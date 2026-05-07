import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _timerDurations = ['5', '15', '25', '30', '45', '60'];
  
  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    
    return Container(
      color: const Color(0xFFF8FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your preferences and data.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Timer Duration
              _buildSectionTitle('Timer'),
              const SizedBox(height: 12),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildSettingsRow(
                  icon: Icons.timer,
                  title: 'Timer Duration',
                  trailing: Row(
                    children: [
                      Text(
                        '${dataService.timerDuration} min',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  onTap: () => _showTimerDurationPicker(context, dataService),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Feedback
              _buildSectionTitle('Feedback'),
              const SizedBox(height: 12),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      icon: Icons.vibration,
                      title: 'Haptic Feedback',
                      subtitle: 'Vibrate when timer completes',
                      trailing: _buildToggleSwitch(
                        value: dataService.hapticFeedback,
                        onChanged: (value) {
                          dataService.setHapticFeedback(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Data
              _buildSectionTitle('Data'),
              const SizedBox(height: 12),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildDangerRow(
                  icon: Icons.delete_forever,
                  title: 'Clear All Data',
                  subtitle: 'Delete all habits and reset settings',
                  onTap: () => _confirmClearData(context, dataService),
                ),
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Colors.grey.shade600,
      ),
    );
  }
  
  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(77, 182, 172, 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: const Color.fromRGBO(77, 182, 172, 1),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            trailing,
          ],
        ),
      ),
    );
  }
  
  Widget _buildToggleSwitch({
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value
              ? const Color.fromRGBO(77, 182, 172, 1)
              : Colors.grey.shade300,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDangerRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: Colors.red.shade400,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade400,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showTimerDurationPicker(BuildContext context, DataService dataService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Timer Duration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _timerDurations.map((duration) {
                  int minutes = int.parse(duration);
                  bool isSelected = dataService.timerDuration == minutes;
                  return GestureDetector(
                    onTap: () {
                      dataService.setTimerDuration(minutes);
                      Navigator.pop(context);
                      _showSnackBar(context, 'Timer set to $duration minutes');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromRGBO(77, 182, 172, 1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '$duration min',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _confirmClearData(BuildContext context, DataService dataService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear All Data?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: const Text(
          'This will permanently delete all your habits and reset all settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              dataService.clearAllData();
              Navigator.pop(context);
              _showSnackBar(context, 'All data cleared');
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }
}