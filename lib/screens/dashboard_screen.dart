import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/trending_carousel.dart';
import '../widgets/user_summary_panel.dart';
import '../widgets/contest_card.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<DataService>(context, listen: false)
          .setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          Constants.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Consumer<DataService>(
            builder: (context, dataService, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                  if (dataService.unreadNotificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${dataService.unreadNotificationCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchBar(),
                  SizedBox(height: 16),
                  _buildCategoryFilter(),
                ],
              ),
            ),
            UserSummaryPanel(),
            SizedBox(height: 8),
            TrendingCarousel(),
            SizedBox(height: 16),
            _buildContestList(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search contests...',
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return Container(
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<String>(
            value: dataService.selectedCategory,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.category, color: AppColors.textSecondary),
            ),
            items: dataService.categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                dataService.setCategory(value);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildContestList() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final contests = dataService.contests;
        
        if (contests.isEmpty) {
          return Container(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  'No contests found',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Try adjusting your search or category filter',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'All Contests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: contests.length,
              itemBuilder: (context, index) {
                return ContestCard(
                  contest: contests[index],
                  onJoin: () => _joinContest(contests[index].id),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.only(top: 32),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            '© 2024 ${Constants.appName}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            Constants.tagline,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _joinContest(String contestId) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final contest = dataService.getContestById(contestId);
    
    if (contest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contest not found')),
      );
      return;
    }

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

    dataService.startContest(contestId);
    Navigator.pushNamed(context, '/contest-play');
  }
}