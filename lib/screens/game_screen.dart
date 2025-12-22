import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/story_state.dart';

class GameScreen extends StatefulWidget {
  final String genre;

  const GameScreen({super.key, required this.genre});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AIService _aiService = AIService();
  StoryState _state = StoryState.initial();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startNewStory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Yeni hikaye başlatır
  Future<void> _startNewStory() async {
    setState(() {
      _state = _state.copyWith(isLoading: true);
    });

    try {
      final result = await _aiService.startStory(widget.genre);
      setState(() {
        _state = StoryState(
          currentText: result['story'],
          choices: result['choices'],
          history: [result['story']],
          isLoading: false,
        );
      });
      _scrollToBottom();
    } catch (e) {
      _showError(e.toString());
    }
  }

  /// Seçim yapıldığında hikayeyi devam ettirir
  Future<void> _makeChoice(String choice) async {
    setState(() {
      _state = _state.copyWith(isLoading: true);
    });

    try {
      // Hikaye geçmişini oluştur
      final storyHistory = _state.history.join('\n\n');

      final result = await _aiService.continueStory(storyHistory, choice);

      setState(() {
        final newHistory = List<String>.from(_state.history);
        newHistory.add('OYUNCU SEÇİMİ: $choice');
        newHistory.add(result['story']);

        _state = StoryState(
          currentText: result['story'],
          choices: result['isEnding'] ? [] : result['choices'],
          history: newHistory,
          isLoading: false,
        );
      });
      _scrollToBottom();
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String error) {
    setState(() {
      _state = _state.copyWith(isLoading: false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hata: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.genre} Hikayesi'),
        backgroundColor: Colors.purple.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Yeniden Başlat'),
                  content: const Text('Hikayeyi baştan başlatmak istiyor musunuz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startNewStory();
                      },
                      child: const Text('Evet'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            // Hikaye metni
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_state.currentText.isNotEmpty)
                      _StoryCard(text: _state.currentText),
                    if (_state.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Seçenekler
            if (_state.choices.isNotEmpty && !_state.isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  border: Border(
                    top: BorderSide(
                      color: Colors.purple.shade300,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Ne yapmak istersiniz?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ..._state.choices.asMap().entries.map((entry) {
                      final index = entry.key;
                      final choice = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _ChoiceButton(
                          number: index + 1,
                          text: choice,
                          onPressed: () => _makeChoice(choice),
                        ),
                      );
                    }),
                  ],
                ),
              ),

            // Oyun bitti
            if (_state.choices.isEmpty && !_state.isLoading && _state.currentText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  border: Border(
                    top: BorderSide(
                      color: Colors.purple.shade300,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Hikaye Sona Erdi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _startNewStory,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Yeni Oyun'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.home),
                            label: const Text('Ana Menü'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String text;

  const _StoryCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.95),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final int number;
  final String text;
  final VoidCallback onPressed;

  const _ChoiceButton({
    required this.number,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: Colors.purple.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
