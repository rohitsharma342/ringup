class User {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;
  final int totalScore;
  final int contestsWon;
  final int contestsParticipated;
  final DateTime joinDate;
  final List<String> badges;
  
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.totalScore,
    required this.contestsWon,
    required this.contestsParticipated,
    required this.joinDate,
    required this.badges,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      totalScore: json['totalScore'] ?? 0,
      contestsWon: json['contestsWon'] ?? 0,
      contestsParticipated: json['contestsParticipated'] ?? 0,
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toString()),
      badges: List<String>.from(json['badges'] ?? []),
    );
  }
}

class LeaderboardEntry {
  final String userId;
  final String username;
  final String avatarUrl;
  final int score;
  final int rank;
  final bool isCurrentUser;
  
  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.score,
    required this.rank,
    this.isCurrentUser = false,
  });
  
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      score: json['score'] ?? 0,
      rank: json['rank'] ?? 0,
      isCurrentUser: json['isCurrentUser'] ?? false,
    );
  }
}