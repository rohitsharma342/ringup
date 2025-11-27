class LeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int score;
  final int rank;
  final bool isCurrentUser;
  final String? prize;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.score,
    required this.rank,
    this.isCurrentUser = false,
    this.prize,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      score: json['score'],
      rank: json['rank'],
      isCurrentUser: json['isCurrentUser'] ?? false,
      prize: json['prize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'score': score,
      'rank': rank,
      'isCurrentUser': isCurrentUser,
      'prize': prize,
    };
  }
}