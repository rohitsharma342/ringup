import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class LeaderboardItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool showPodium;

  LeaderboardItem({
    required this.entry,
    this.showPodium = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: entry.isCurrentUser ? 4 : 1,
        color: entry.isCurrentUser 
            ? AppConstants.primaryColor.withOpacity(0.1) 
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          side: entry.isCurrentUser 
              ? BorderSide(color: AppConstants.primaryColor, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Row(
            children: [
              _buildRankSection(),
              SizedBox(width: 12),
              _buildAvatarSection(),
              SizedBox(width: 12),
              _buildUserInfoSection(),
              Spacer(),
              _buildScoreSection(),
              if (entry.isCurrentUser) ..[
                SizedBox(width: 8),
                Icon(
                  Icons.star,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankSection() {
    Widget rankWidget;
    
    if (showPodium && entry.rank <= 3) {
      IconData medalIcon;
      Color medalColor;
      
      switch (entry.rank) {
        case 1:
          medalIcon = Icons.emoji_events;
          medalColor = Color(0xFFFFD700); // Gold
          break;
        case 2:
          medalIcon = Icons.military_tech;
          medalColor = Color(0xFFC0C0C0); // Silver
          break;
        case 3:
          medalIcon = Icons.workspace_premium;
          medalColor = Color(0xFFCD7F32); // Bronze
          break;
        default:
          medalIcon = Icons.star;
          medalColor = Colors.grey;
      }
      
      rankWidget = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: medalColor.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: medalColor,
            width: 2,
          ),
        ),
        child: Icon(
          medalIcon,
          color: medalColor,
          size: 20,
        ),
      );
    } else {
      rankWidget = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: entry.isCurrentUser 
              ? AppConstants.primaryColor 
              : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '#${entry.rank}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entry.isCurrentUser 
                  ? Colors.white 
                  : AppConstants.textPrimary,
            ),
          ),
        ),
      );
    }
    
    return rankWidget;
  }

  Widget _buildAvatarSection() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (entry.isCurrentUser)
            BoxShadow(
              color: AppConstants.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(entry.avatarUrl),
        backgroundColor: Colors.grey[300],
        onBackgroundImageError: (exception, stackTrace) {
          // Handle image loading error
        },
        child: entry.avatarUrl.isEmpty 
            ? Icon(
                Icons.person,
                color: Colors.grey[600],
              ) 
            : null,
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  entry.username,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: entry.isCurrentUser 
                        ? FontWeight.bold 
                        : FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (entry.isCurrentUser) ..[
                SizedBox(width: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'You',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 2),
          Text(
            'User ID: ${entry.userId}',
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${entry.score}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: entry.isCurrentUser 
                ? AppConstants.primaryColor 
                : AppConstants.textPrimary,
          ),
        ),
        Text(
          'points',
          style: TextStyle(
            fontSize: 12,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }
}