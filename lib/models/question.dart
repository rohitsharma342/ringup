class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final int timeLimit;
  final String? imageUrl;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    this.timeLimit = 30,
    this.imageUrl,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      timeLimit: json['timeLimit'] ?? 30,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'timeLimit': timeLimit,
      'imageUrl': imageUrl,
    };
  }
}