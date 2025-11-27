import 'package:flutter/material.dart';
import '../models/contest.dart';
import '../utils/app_colors.dart';

class ContestCard extends StatelessWidget {
  final Contest contest;
  final VoidCallback onJoin;

  const ContestCard({
    Key? key,
    required this.contest,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
          _buildContestImage(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 8),
                _buildDescription(),
                SizedBox(height: 12),
                _buildMetaInfo(),
                SizedBox(height: 16),
                _buildActionSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            contest.imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: AppColors.background,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.textSecondary,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              contest.category,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (contest.isTrending)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Trending',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            contest.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (contest.hasJoined)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Joined',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      contest.description,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetaInfo() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.people,
              size: 16,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 4),
            Text(
              '${contest.participantCount}/${contest.maxParticipants} participants',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Spacer(),
            Icon(
              Icons.access_time,
              size: 16,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 4),
            Text(
              _getTimeStatus(),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildProgressBar(),
        SizedBox(height: 8),
        _buildPrizeInfo(),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = contest.participantCount / contest.maxParticipants;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spots filled',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 0.8 ? AppColors.warning : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildPrizeInfo() {
    return Row(
      children: [
        Icon(
          Icons.emoji_events,
          size: 16,
          color: AppColors.warning,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            'Prizes: ${contest.prizes.take(3).join(', ')}${contest.prizes.length > 3 ? '...' : ''}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: contest.canJoin ? onJoin : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: contest.canJoin ? AppColors.primary : AppColors.textSecondary,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _getJoinButtonText(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.share,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor() {
    switch (contest.category.toLowerCase()) {
      case 'science':
        return Colors.blue;
      case 'history':
        return Colors.brown;
      case 'sports':
        return Colors.orange;
      case 'technology':
        return Colors.purple;
      case 'general':
      default:
        return AppColors.primary;
    }
  }

  String _getTimeStatus() {
    final now = DateTime.now();
    if (contest.hasExpired) {
      return 'Ended';
    } else if (now.isBefore(contest.startTime)) {
      final diff = contest.startTime.difference(now);
      if (diff.inHours < 1) {
        return 'Starts in ${diff.inMinutes}m';
      } else if (diff.inDays < 1) {
        return 'Starts in ${diff.inHours}h';
      } else {
        return 'Starts in ${diff.inDays}d';
      }
    } else {
      return 'Live';
    }
  }

  String _getJoinButtonText() {
    if (contest.hasJoined) {
      return 'Continue';
    } else if (contest.isFull) {
      return 'Contest Full';
    } else if (contest.hasExpired) {
      return 'Contest Ended';
    } else {
      return 'Join Contest';
    }
  }
}