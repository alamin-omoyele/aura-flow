import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../services/data_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration _duration = const Duration(minutes: 25);
  Duration _remaining = const Duration(minutes: 25);
  bool _isRunning = false;
  bool _isComplete = false;
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  void _loadSettings() {
    final dataService = Provider.of<DataService>(context, listen: false);
    setState(() {
      _duration = Duration(minutes: dataService.timerDuration);
      _remaining = Duration(minutes: dataService.timerDuration);
    });
  }
  
  void _startTimer() {
    if (_remaining.inSeconds == 0) {
      setState(() {
        _remaining = _duration;
        _isComplete = false;
      });
    }
    
    setState(() {
      _isRunning = true;
      _isComplete = false;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = _remaining - const Duration(seconds: 1);
        } else {
          _stopTimer();
          _onTimerComplete();
        }
      });
    });
  }
  
  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }
  
  void _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _isRunning = false;
    });
  }
  
  void _resetTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _isRunning = false;
      _isComplete = false;
      _remaining = _duration;
    });
  }
  
  void _onTimerComplete() {
    setState(() {
      _isComplete = true;
    });
    
    _showCompletionDialog();
  }
  
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(77, 182, 172, 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_emotions,
                color: Color.fromRGBO(77, 182, 172, 1),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Great Job! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'You completed a ${_duration.inMinutes} minute focus session!',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color: const Color.fromRGBO(77, 182, 172, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }
  
  String _formatTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(_remaining.inMinutes.remainder(60));
    String seconds = twoDigits(_remaining.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  
  double _getProgress() {
    return 1 - (_remaining.inSeconds / _duration.inSeconds);
  }
  
  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          'Focus Timer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(77, 182, 172, 1),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Timer Circle
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        children: [
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 260,
                              height: 260,
                              child: CircularProgressIndicator(
                                value: _getProgress(),
                                strokeWidth: 12,
                                backgroundColor: const Color.fromRGBO(77, 182, 172, 0.1),
                                color: const Color.fromRGBO(77, 182, 172, 1),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(),
                                  style: const TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _isRunning ? 'Focusing... 🧘' : 'Ready to focus ✨',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: FloatingActionButton(
                            onPressed: _isRunning ? _pauseTimer : _startTimer,
                            backgroundColor: const Color.fromRGBO(77, 182, 172, 1),
                            child: Icon(
                              _isRunning ? Icons.pause : Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: FloatingActionButton(
                            onPressed: _resetTimer,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(
                              Icons.refresh,
                              size: 40,
                              color: const Color.fromRGBO(77, 182, 172, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Inspiration quote
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(77, 182, 172, 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.format_quote, color: const Color.fromRGBO(77, 182, 172, 0.5)),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              '"The secret of getting ahead is getting started."',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}