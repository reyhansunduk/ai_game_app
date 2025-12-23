class StoryState {
  final String currentText;
  final List<String> choices;
  final List<String> history;
  final bool isLoading;
  final String? currentAvatar;
  final String genre;
  final DateTime createdAt;
  final String? saveId;

  StoryState({
    required this.currentText,
    required this.choices,
    required this.history,
    this.isLoading = false,
    this.currentAvatar,
    this.genre = '',
    DateTime? createdAt,
    this.saveId,
  }) : createdAt = createdAt ?? DateTime.now();

  StoryState copyWith({
    String? currentText,
    List<String>? choices,
    List<String>? history,
    bool? isLoading,
    String? currentAvatar,
    String? genre,
    DateTime? createdAt,
    String? saveId,
  }) {
    return StoryState(
      currentText: currentText ?? this.currentText,
      choices: choices ?? this.choices,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      currentAvatar: currentAvatar ?? this.currentAvatar,
      genre: genre ?? this.genre,
      createdAt: createdAt ?? this.createdAt,
      saveId: saveId ?? this.saveId,
    );
  }

  factory StoryState.initial() {
    return StoryState(
      currentText: '',
      choices: [],
      history: [],
      isLoading: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentText': currentText,
      'choices': choices,
      'history': history,
      'currentAvatar': currentAvatar,
      'genre': genre,
      'createdAt': createdAt.toIso8601String(),
      'saveId': saveId,
    };
  }

  factory StoryState.fromJson(Map<String, dynamic> json) {
    return StoryState(
      currentText: json['currentText'] as String,
      choices: List<String>.from(json['choices'] as List),
      history: List<String>.from(json['history'] as List),
      currentAvatar: json['currentAvatar'] as String?,
      genre: json['genre'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      saveId: json['saveId'] as String?,
    );
  }
}
