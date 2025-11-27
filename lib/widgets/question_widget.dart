import 'package:flutter/material.dart';
import '../models/question.dart';
import '../utils/constants.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final int? selectedAnswerIndex;
  final Function(int) onAnswerSelected;
  final int timeRemaining;
  final bool isAnswerSubmitted;

  QuestionWidget({
    required this.question,
    required this.selectedAnswerIndex,
    required this.onAnswerSelected,
    required this.timeRemaining,
    required this.isAnswerSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionSection(),
        SizedBox(height: 24),
        _buildOptionsSection(),
        if (isAnswerSubmitted && question.explanation.isNotEmpty) ..[
          SizedBox(height: 24),
          _buildExplanationSection(),
        ],
      ],
    );
  }

  Widget _buildQuestionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.quiz,
                color: AppConstants.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Question',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${question.points} pts',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            question.questionText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppConstants.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return _buildOptionCard(index, option);
      }).toList(),
    );
  }

  Widget _buildOptionCard(int index, String option) {
    final isSelected = selectedAnswerIndex == index;
    final isCorrect = index == question.correctAnswerIndex;
    final showResult = isAnswerSubmitted;
    
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = AppConstants.textPrimary;
    Widget? trailingIcon;

    if (showResult) {
      if (isCorrect) {
        cardColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green[800]!;
        trailingIcon = Icon(Icons.check_circle, color: Colors.green);
      } else if (isSelected && !isCorrect) {
        cardColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        textColor = Colors.red[800]!;
        trailingIcon = Icon(Icons.cancel, color: Colors.red);
      }
    } else if (isSelected) {
      cardColor = AppConstants.primaryColor.withOpacity(0.1);
      borderColor = AppConstants.primaryColor;
      textColor = AppConstants.primaryColor;
      trailingIcon = Icon(Icons.radio_button_checked, color: AppConstants.primaryColor);
    } else {
      trailingIcon = Icon(Icons.radio_button_unchecked, color: Colors.grey[400]);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: showResult ? null : () => onAnswerSelected(index),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.all(AppConstants.padding),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: borderColor,
              width: isSelected || (showResult && isCorrect) ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected || (showResult && isCorrect) 
                      ? borderColor.withOpacity(0.1) 
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: isSelected || (showResult && isCorrect) 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(width: 8),
              if (trailingIcon != null) trailingIcon,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.padding),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue[700],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Explanation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            question.explanation,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[800],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}