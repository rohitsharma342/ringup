import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../models/leaderboard.dart';
import '../utils/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          return Column(
            children: [
              _buildContestSelector(context, dataService),
              Expanded(
                child: _buildLeaderboardList(dataService.leaderboard),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContestSelector(BuildContext context, DataService dataService) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: dataService.currentContestId ?? dataService.contests.first.id,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.emoji_events, color: AppColors.primary),
          labelText: 'Select Contest',
        ),
        items: dataService.contests
            .map((contest) => DropdownMenuItem(
                  value: contest.id,
                  child: Text(
                    contest.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            // In a real app, this would fetch leaderboard for selected contest
          }
        },
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No leaderboard data available',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Complete a contest to see rankings',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildLeaderboardItem(entry, index);
      },
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: entry.isCurrentUser ? AppColors.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: entry.isCurrentUser 
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildRankBadge(entry.rank),
            SizedBox(width: 16),
            _buildAvatar(entry),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: entry.isCurrentUser ? AppColors.primary : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (entry.isCurrentUser)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.stars,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${entry.score} points',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (entry.prize != null) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 16,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Prize: ${entry.prize}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    IconData icon;
    
    switch (rank) {
      case 1:
        badgeColor = Color(0xFFFFD700); // Gold
        icon = Icons.looks_one;
        break;
      case 2:
        badgeColor = Color(0xFFC0C0C0); // Silver
        icon = Icons.looks_two;
        break;
      case 3:
        badgeColor = Color(0xFFCD7F32); // Bronze
        icon = Icons.looks_3;
        break;
      default:
        badgeColor = AppColors.textSecondary;
        icon = Icons.person;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: rank <= 3
            ? Icon(
                icon,
                color: Colors.white,
                size: 24,
              )
            : Text(
                '#$rank',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }

  Widget _buildAvatar(LeaderboardEntry entry) {
    if (entry.avatarUrl != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(entry.avatarUrl!),
        backgroundColor: AppColors.background,
      );
    }
    
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Text(
        entry.username.isNotEmpty ? entry.username[0].toUpperCase() : '?',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}