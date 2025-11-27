import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/data_service.dart';
import '../models/contest.dart';
import '../utils/app_colors.dart';

class TrendingCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final trendingContests = dataService.trendingContests;
        
        if (trendingContests.isEmpty) {
          return SizedBox.shrink();
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Trending Contests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            CarouselSlider.builder(
              itemCount: trendingContests.length,
              options: CarouselOptions(
                height: 200,
                viewportFraction: 0.85,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              itemBuilder: (context, index, realIndex) {
                final contest = trendingContests[index];
                return _buildTrendingCard(context, contest, dataService);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrendingCard(BuildContext context, Contest contest, DataService dataService) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            _buildBackgroundImage(contest),
            _buildGradientOverlay(),
            _buildContent(context, contest, dataService),
            _buildTrendingBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(Contest contest) {
    return Positioned.fill(
      child: Image.network(
        contest.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.primary.withOpacity(0.7),
            child: Center(
              child: Icon(
                Icons.quiz,
                size: 60,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Contest contest, DataService dataService) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            contest.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            contest.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.people,
                size: 16,
                color: Colors.white.withOpacity(0.9),
              ),
              SizedBox(width: 4),
              Text(
                '${contest.participantCount} joined',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
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
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: contest.canJoin ? () => _joinContest(context, contest, dataService) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: contest.canJoin ? Colors.white : Colors.white.withOpacity(0.3),
                    foregroundColor: contest.canJoin ? AppColors.primary : Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _getJoinButtonText(contest),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingBadge() {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 12,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              'HOT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _joinContest(BuildContext context, Contest contest, DataService dataService) {
    if (!contest.canJoin) {
      String message = 'Cannot join contest: ';
      if (contest.isFull) {
        message += 'Contest is full';
      } else if (contest.hasExpired) {
        message += 'Contest has expired';
      } else if (contest.hasJoined) {
        message += 'Already joined';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    dataService.startContest(contest.id);
    Navigator.pushNamed(context, '/contest-play');
  }

  String _getJoinButtonText(Contest contest) {
    if (contest.hasJoined) {
      return 'Continue';
    } else if (contest.isFull) {
      return 'Full';
    } else if (contest.hasExpired) {
      return 'Ended';
    } else {
      return 'Join Now';
    }
  }
}