import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/data_service.dart';
import '../models/question.dart';
import '../utils/app_colors.dart';

class ContestPlayScreen extends StatefulWidget {
  @override
  _ContestPlayScreenState createState() => _ContestPlayScreenState();
}

class _ContestPlayScreenState extends State<ContestPlayScreen> {
  Timer? _timer;
  int _timeLeft = 30;
  int? _selectedAnswerIndex;
  bool _hasSubmitted = false;
  bool _showCorrectAnswer = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeLeft--;
        });
        
        if (_timeLeft <= 0) {
          _submitAnswer();
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final question = dataService.currentQuestion;
        
        if (question == null) {
          return _buildContestComplete(dataService);
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('Contest'),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _showExitDialog(),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'Score: ${dataService.currentScore}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuestionProgress(dataService),
                SizedBox(height: 16),
                _buildTimer(),
                SizedBox(height: 24),
                _buildQuestionCard(question),
                SizedBox(height: 24),
                _buildAnswerOptions(question),
                Spacer(),
                _buildActionButtons(dataService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionProgress(DataService dataService) {
    final current = dataService.currentQuestionIndex + 1;
    final total = dataService.currentQuestions.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question $current of $total',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _timeLeft <= 10 ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _timeLeft <= 10 ? Colors.red : AppColors.border,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: _timeLeft <= 10 ? Colors.red : AppColors.primary,
          ),
          SizedBox(width: 8),
          Text(
            'Time Left: $_timeLeft seconds',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _timeLeft <= 10 ? Colors.red : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                question.imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: AppColors.background,
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
          ],
          Text(
            question.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(Question question) {
    return Column(
      children: List.generate(question.options.length, (index) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: _hasSubmitted ? null : () => _selectAnswer(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getAnswerColor(index, question.correctAnswerIndex),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getAnswerBorderColor(index, question.correctAnswerIndex),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getAnswerIconColor(index, question.correctAnswerIndex),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question.options[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _getAnswerTextColor(index, question.correctAnswerIndex),
                      ),
                    ),
                  ),
                  if (_hasSubmitted && _showCorrectAnswer) ...[
                    if (index == question.correctAnswerIndex)
                      Icon(Icons.check_circle, color: Colors.white, size: 20)
                    else if (index == _selectedAnswerIndex && _selectedAnswerIndex != question.correctAnswerIndex)
                      Icon(Icons.cancel, color: Colors.white, size: 20),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionButtons(DataService dataService) {
    return Column(
      children: [
        if (!_hasSubmitted)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedAnswerIndex != null ? _submitAnswer : null,
              child: Text(
                'Submit Answer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _nextQuestion(dataService),
              child: Text(
                dataService.hasMoreQuestions ? 'Next Question' : 'View Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContestComplete(DataService dataService) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Contest Complete'),
        leading: Container(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Contest Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your Final Score',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${dataService.currentScore} points',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/leaderboard');
                  },
                  child: Text(
                    'View Leaderboard',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/dashboard',
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                  ),
                  child: Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAnswer(int index) {
    if (!_hasSubmitted) {
      setState(() {
        _selectedAnswerIndex = index;
      });
    }
  }

  void _submitAnswer() {
    if (_hasSubmitted) return;
    
    _stopTimer();
    
    final dataService = Provider.of<DataService>(context, listen: false);
    if (_selectedAnswerIndex != null) {
      dataService.submitAnswer(_selectedAnswerIndex!);
    }
    
    setState(() {
      _hasSubmitted = true;
      _showCorrectAnswer = true;
    });
  }

  void _nextQuestion(DataService dataService) {
    if (dataService.hasMoreQuestions) {
      dataService.nextQuestion();
      setState(() {
        _selectedAnswerIndex = null;
        _hasSubmitted = false;
        _showCorrectAnswer = false;
      });
      _startTimer();
    } else {
      setState(() {});
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit Contest?'),
          content: Text('Are you sure you want to exit? Your progress will be lost.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color _getAnswerColor(int index, int correctIndex) {
    if (!_hasSubmitted || !_showCorrectAnswer) {
      return _selectedAnswerIndex == index ? AppColors.primary.withOpacity(0.1) : Colors.white;
    }
    
    if (index == correctIndex) {
      return AppColors.success;
    } else if (index == _selectedAnswerIndex && _selectedAnswerIndex != correctIndex) {
      return AppColors.error;
    }
    return Colors.white;
  }

  Color _getAnswerBorderColor(int index, int correctIndex) {
    if (!_hasSubmitted || !_showCorrectAnswer) {
      return _selectedAnswerIndex == index ? AppColors.primary : AppColors.border;
    }
    
    if (index == correctIndex) {
      return AppColors.success;
    } else if (index == _selectedAnswerIndex && _selectedAnswerIndex != correctIndex) {
      return AppColors.error;
    }
    return AppColors.border;
  }

  Color _getAnswerIconColor(int index, int correctIndex) {
    if (!_hasSubmitted || !_showCorrectAnswer) {
      return _selectedAnswerIndex == index ? AppColors.primary : AppColors.textSecondary;
    }
    
    if (index == correctIndex) {
      return AppColors.success;
    } else if (index == _selectedAnswerIndex && _selectedAnswerIndex != correctIndex) {
      return AppColors.error;
    }
    return AppColors.textSecondary;
  }

  Color _getAnswerTextColor(int index, int correctIndex) {
    if (!_hasSubmitted || !_showCorrectAnswer) {
      return AppColors.textPrimary;
    }
    
    if (index == correctIndex || (index == _selectedAnswerIndex && _selectedAnswerIndex != correctIndex)) {
      return Colors.white;
    }
    return AppColors.textPrimary;
  }
}