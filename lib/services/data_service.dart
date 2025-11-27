import 'package:flutter/foundation.dart';
import '../models/contest.dart';
import '../models/question.dart';
import '../models/notification.dart';
import '../models/leaderboard.dart';
import '../utils/error_handler.dart';

class DataService extends ChangeNotifier {
  List<Contest> _contests = [];
  List<Question> _currentQuestions = [];
  List<AppNotification> _notifications = [];
  List<LeaderboardEntry> _leaderboard = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _currentScore = 0;
  int _currentQuestionIndex = 0;
  String? _currentContestId;
  bool _isLoading = false;
  String? _errorMessage;

  List<Contest> get contests => _filterContests();
  List<Question> get currentQuestions => _currentQuestions;
  List<AppNotification> get notifications => _notifications;
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int get currentScore => _currentScore;
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get currentContestId => _currentContestId;
  Question? get currentQuestion => _currentQuestionIndex < _currentQuestions.length ? _currentQuestions[_currentQuestionIndex] : null;
  bool get hasMoreQuestions => _currentQuestionIndex < _currentQuestions.length - 1;
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  DataService() {
    _loadStaticData();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _loadStaticData() async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500));
      
      _contests = [
        Contest(
          id: '1',
          title: 'General Knowledge Challenge',
          description: 'Test your knowledge across various topics',
          category: 'General',
          imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          participantCount: 1250,
          maxParticipants: 2000,
          startTime: DateTime.now().subtract(Duration(hours: 1)),
          endTime: DateTime.now().add(Duration(hours: 2)),
          prizes: ['₹10,000', '₹5,000', '₹2,000'],
          isTrending: true,
        ),
        Contest(
          id: '2',
          title: 'Science Quiz Masters',
          description: 'Dive deep into the world of science',
          category: 'Science',
          imageUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400',
          participantCount: 850,
          maxParticipants: 1500,
          startTime: DateTime.now().add(Duration(hours: 1)),
          endTime: DateTime.now().add(Duration(hours: 4)),
          prizes: ['₹15,000', '₹7,500', '₹3,000'],
          isTrending: true,
        ),
        Contest(
          id: '3',
          title: 'History Buffs Unite',
          description: 'Journey through time with historical questions',
          category: 'History',
          imageUrl: 'https://images.unsplash.com/photo-1461360370896-922624d12aa1?w=400',
          participantCount: 620,
          maxParticipants: 1000,
          startTime: DateTime.now().add(Duration(hours: 3)),
          endTime: DateTime.now().add(Duration(hours: 6)),
          prizes: ['₹8,000', '₹4,000', '₹2,000'],
        ),
        Contest(
          id: '4',
          title: 'Sports Trivia Championship',
          description: 'For all the sports enthusiasts out there',
          category: 'Sports',
          imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400',
          participantCount: 950,
          maxParticipants: 1200,
          startTime: DateTime.now().add(Duration(hours: 2)),
          endTime: DateTime.now().add(Duration(hours: 5)),
          prizes: ['₹12,000', '₹6,000', '₹3,000'],
        ),
        Contest(
          id: '5',
          title: 'Technology Today',
          description: 'Stay updated with the latest in tech',
          category: 'Technology',
          imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400',
          participantCount: 1100,
          maxParticipants: 1800,
          startTime: DateTime.now().add(Duration(hours: 4)),
          endTime: DateTime.now().add(Duration(hours: 7)),
          prizes: ['₹20,000', '₹10,000', '₹5,000'],
          isTrending: true,
        ),
      ];

      _notifications = [
        AppNotification(
          id: '1',
          title: 'Contest Starting Soon!',
          message: 'General Knowledge Challenge starts in 1 hour. Get ready!',
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          type: 'contest',
          contestId: '1',
        ),
        AppNotification(
          id: '2',
          title: 'Prize Won!',
          message: 'Congratulations! You won ₹2,000 in the last contest.',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          type: 'prize',
          isRead: true,
        ),
        AppNotification(
          id: '3',
          title: 'New Contest Available',
          message: 'Science Quiz Masters is now open for registration.',
          timestamp: DateTime.now().subtract(Duration(hours: 3)),
          type: 'contest',
          contestId: '2',
        ),
      ];

      _leaderboard = [
        LeaderboardEntry(
          userId: '1',
          username: 'QuizMaster2024',
          score: 950,
          rank: 1,
          prize: '₹10,000',
        ),
        LeaderboardEntry(
          userId: '2',
          username: 'BrainStorm',
          score: 920,
          rank: 2,
          prize: '₹5,000',
        ),
        LeaderboardEntry(
          userId: '3',
          username: 'SmartPlayer',
          score: 890,
          rank: 3,
          prize: '₹2,000',
        ),
        LeaderboardEntry(
          userId: '4',
          username: 'You',
          score: 850,
          rank: 4,
          isCurrentUser: true,
        ),
        LeaderboardEntry(
          userId: '5',
          username: 'KnowledgeSeeker',
          score: 820,
          rank: 5,
        ),
      ];
      
      _setLoading(false);
    } catch (error, stackTrace) {
      _setLoading(false);
      _setError('Failed to load data. Please try again.');
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  Future<void> refreshData() async {
    await _loadStaticData();
  }

  List<Contest> _filterContests() {
    try {
      List<Contest> filtered = _contests;

      if (_selectedCategory != 'All') {
        filtered = filtered.where((contest) => contest.category == _selectedCategory).toList();
      }

      if (_searchQuery.isNotEmpty) {
        filtered = filtered.where((contest) => 
          contest.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contest.description.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      }

      return filtered;
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
      return [];
    }
  }

  void setCategory(String category) {
    try {
      _selectedCategory = category;
      notifyListeners();
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  void setSearchQuery(String query) {
    try {
      _searchQuery = query;
      notifyListeners();
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  Future<void> startContest(String contestId) async {
    try {
      _setLoading(true);
      _currentContestId = contestId;
      _currentQuestionIndex = 0;
      _currentScore = 0;
      await _loadQuestionsForContest(contestId);
      _setLoading(false);
      notifyListeners();
    } catch (error, stackTrace) {
      _setLoading(false);
      _setError('Failed to start contest. Please try again.');
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  Future<void> _loadQuestionsForContest(String contestId) async {
    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 800));
      
      _currentQuestions = [
        Question(
          id: '1',
          text: 'What is the capital of France?',
          options: ['London', 'Berlin', 'Paris', 'Madrid'],
          correctAnswerIndex: 2,
          imageUrl: 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400',
        ),
        Question(
          id: '2',
          text: 'Which planet is known as the Red Planet?',
          options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
          correctAnswerIndex: 1,
        ),
        Question(
          id: '3',
          text: 'Who painted the Mona Lisa?',
          options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
          correctAnswerIndex: 2,
        ),
        Question(
          id: '4',
          text: 'What is the largest ocean on Earth?',
          options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
          correctAnswerIndex: 3,
        ),
        Question(
          id: '5',
          text: 'In which year did World War II end?',
          options: ['1944', '1945', '1946', '1947'],
          correctAnswerIndex: 1,
        ),
      ];
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
      throw error;
    }
  }

  void submitAnswer(int selectedIndex) {
    try {
      if (currentQuestion != null) {
        if (selectedIndex == currentQuestion!.correctAnswerIndex) {
          _currentScore += 100;
        }
      }
      notifyListeners();
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  void nextQuestion() {
    try {
      if (hasMoreQuestions) {
        _currentQuestionIndex++;
      }
      notifyListeners();
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  void markNotificationAsRead(String notificationId) {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  void markAllNotificationsAsRead() {
    try {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      notifyListeners();
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
    }
  }

  List<Contest> get trendingContests {
    try {
      return _contests.where((contest) => contest.isTrending).toList();
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
      return [];
    }
  }

  List<String> get categories => ['All', 'General', 'Science', 'History', 'Sports', 'Technology'];

  Contest? getContestById(String id) {
    try {
      return _contests.firstWhere((contest) => contest.id == id);
    } catch (e) {
      return null;
    }
  }
}