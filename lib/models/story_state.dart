class StoryState {
  final String currentText;
  final List<String> choices;
  final List<String> history;
  final bool isLoading;

  StoryState({
    required this.currentText,
    required this.choices,
    required this.history,
    this.isLoading = false,
  });

  StoryState copyWith({
    String? currentText,
    List<String>? choices,
    List<String>? history,
    bool? isLoading,
  }) {
    return StoryState(
      currentText: currentText ?? this.currentText,
      choices: choices ?? this.choices,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
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
}
