import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedRange = 'Week';
  
  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    
    return Container(
      color: const Color(0xFFF8FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16), // Reduced from 24 to 16
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your journey over time.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Segmented Control
              _buildSegmentedControl(),
              
              const SizedBox(height: 24),
              
              // Stats Grid (with Flexible layout)
              _buildStatsGrid(dataService),
              
              const SizedBox(height: 24),
              
              // Chart Section (Fixed overflow)
              _buildChartSection(dataService),
              
              const SizedBox(height: 24),
              
              // Recent Activity (Fixed constraints)
              _buildRecentActivity(dataService),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E8E9),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton('Week'),
          ),
          Expanded(
            child: _buildSegmentButton('Month'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSegmentButton(String label) {
    bool isSelected = _selectedRange == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRange = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF191C1D) : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatsGrid(DataService dataService) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4, // Changed from 1.5 to 1.4 for better fit
      children: [
        _buildStatCard(
          icon: Icons.donut_large,
          iconColor: const Color.fromRGBO(77, 182, 172, 1),
          title: 'Completion Rate',
          value: dataService.completionRate.toInt().toString(),
          unit: '%',
        ),
        _buildStatCard(
          icon: Icons.local_fire_department,
          iconColor: const Color(0xFFF57F17),
          title: 'Current Streak',
          value: dataService.currentStreak.toString(),
          unit: 'days',
        ),
        _buildStatCard(
          icon: Icons.emoji_events,
          iconColor: const Color(0xFFF57F17),
          title: 'Longest Streak',
          value: dataService.longestStreak.toString(),
          unit: 'days',
        ),
        _buildStatCard(
          icon: Icons.timer,
          iconColor: const Color(0xFF4D5A9C),
          title: 'Total Focus',
          value: dataService.totalFocusHours.toString(),
          unit: 'h',
        ),
      ],
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191C1D),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildChartSection(DataService dataService) {
    final weeklyData = dataService.weeklyData;
    final maxValue = weeklyData.values.isEmpty ? 1 : weeklyData.values.reduce((a, b) => a > b ? a : b);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Completions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 20),
          
          // Bar Chart - Fixed with Flexible and SingleChildScrollView for horizontal scroll if needed
          SizedBox(
            height: 160,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: days.asMap().entries.map((entry) {
                  int index = entry.key;
                  String day = entry.value;
                  double value = weeklyData[day] ?? 0;
                  double heightPercent = maxValue > 0 ? value / maxValue : 0;
                  bool isHighest = value == maxValue && maxValue > 0;
                  
                  return Container(
                    width: 50, // Fixed width for each bar
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bar
                        Container(
                          height: 120 * (heightPercent.isNaN ? 0 : heightPercent),
                          width: 36,
                          decoration: BoxDecoration(
                            color: isHighest
                                ? const Color.fromRGBO(77, 182, 172, 1)
                                : const Color.fromRGBO(77, 182, 172, 0.2),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Label
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isHighest ? FontWeight.w600 : FontWeight.normal,
                            color: isHighest
                                ? const Color.fromRGBO(77, 182, 172, 1)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentActivity(DataService dataService) {
    final activities = dataService.recentActivity;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
          ),
        ),
        const SizedBox(height: 16),
        if (activities.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'No activities yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete some habits to see them here!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildActivityCard(activities[index]),
              );
            },
          ),
      ],
    );
  }
  
  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(77, 182, 172, 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color.fromRGBO(77, 182, 172, 1),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Target: ${activity['target']} • ${activity['streak']} day streak',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Check icon
          Icon(
            Icons.check_circle,
            color: Colors.green.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }
}