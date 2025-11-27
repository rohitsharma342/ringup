class Contest {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final int participantCount;
  final int maxParticipants;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> prizes;
  final bool isTrending;
  final bool isActive;
  final bool hasJoined;

  Contest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.participantCount,
    required this.maxParticipants,
    required this.startTime,
    required this.endTime,
    required this.prizes,
    this.isTrending = false,
    this.isActive = true,
    this.hasJoined = false,
  });

  bool get isFull => participantCount >= maxParticipants;
  bool get hasExpired => DateTime.now().isAfter(endTime);
  bool get canJoin => !isFull && !hasExpired && !hasJoined;

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      participantCount: json['participantCount'],
      maxParticipants: json['maxParticipants'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      prizes: List<String>.from(json['prizes']),
      isTrending: json['isTrending'] ?? false,
      isActive: json['isActive'] ?? true,
      hasJoined: json['hasJoined'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'participantCount': participantCount,
      'maxParticipants': maxParticipants,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'prizes': prizes,
      'isTrending': isTrending,
      'isActive': isActive,
      'hasJoined': hasJoined,
    };
  }
}