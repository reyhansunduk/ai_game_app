import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart'; // flutter pub get çalıştırın
import '../services/ai_service.dart';
import '../services/audio_service.dart';
import '../services/save_service.dart';
import '../models/story_state.dart';

class GameScreen extends StatefulWidget {
  final String genre;
  final StoryState? loadedState;

  const GameScreen({super.key, required this.genre, this.loadedState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final AIService _aiService = AIService();
  final AudioService _audioService = AudioService();
  final SaveService _saveService = SaveService();
  StoryState _state = StoryState.initial();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  String? _selectedAvatar;

  // Avatar seçenekleri
  final List<String> _avatars = [
    '🧙‍♂️', '🧙‍♀️', '🧝‍♂️', '🧝‍♀️', '🧛‍♂️', '🧛‍♀️',
    '🦸‍♂️', '🦸‍♀️', '🧑‍🚀', '👨‍🚀', '🤠', '👸',
    '🤴', '👷', '🕵️', '💂', '🧑‍🔬', '👨‍🔬'
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Eğer yüklenmiş bir state varsa kullan
    if (widget.loadedState != null) {
      _state = widget.loadedState!;
      _selectedAvatar = _state.currentAvatar;
      _fadeController.forward();
      _audioService.playBackgroundMusic(widget.genre);
    } else {
      // Avatar seçimi göster
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAvatarSelection();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Avatar seçim dialogu
  Future<void> _showAvatarSelection() async {
    print('🎭 Avatar seçim dialogu açılıyor...');

    final selected = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Karakterini Seç',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bir karakter seçerek maceraya başla!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: _avatars.length,
                    itemBuilder: (context, index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print('✅ Avatar seçildi: ${_avatars[index]}');
                            Navigator.pop(context, _avatars[index]);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.purple.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _avatars[index],
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (selected != null) {
      print('🎭 Avatar "${selected}" seçildi, hikaye başlıyor...');
      setState(() {
        _selectedAvatar = selected;
      });

      try {
        await _audioService.playSfx('story_start');
      } catch (e) {
        print('⚠️ Ses efekti çalma hatası (normal): $e');
      }

      try {
        await _audioService.playBackgroundMusic(widget.genre);
      } catch (e) {
        print('⚠️ Müzik çalma hatası (normal): $e');
      }

      _startNewStory();
    } else {
      print('❌ Avatar seçilmedi, ana menüye dönülüyor...');
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Yeni hikaye başlatır
  Future<void> _startNewStory() async {
    print('📖 Yeni hikaye başlatılıyor: ${widget.genre}');

    setState(() {
      _state = _state.copyWith(isLoading: true);
    });

    try {
      final result = await _aiService.startStory(widget.genre);

      print('✅ Hikaye alındı!');
      print('   Story length: ${result['story']?.length ?? 0}');
      print('   Choices count: ${result['choices']?.length ?? 0}');

      setState(() {
        _state = StoryState(
          currentText: result['story'] ?? 'Hikaye yüklenemedi.',
          choices: result['choices'] ?? [],
          history: [result['story'] ?? ''],
          isLoading: false,
          currentAvatar: _selectedAvatar,
          genre: widget.genre,
        );
      });
      _fadeController.forward();
      _scrollToBottom();
      _autoSave();
    } catch (e) {
      print('❌ Hikaye başlatma hatası: $e');
      _showError(e.toString());
    }
  }

  /// Seçim yapıldığında hikayeyi devam ettirir
  Future<void> _makeChoice(String choice) async {
    await _audioService.playSfx('choice');

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
          currentAvatar: _selectedAvatar,
          genre: widget.genre,
        );
      });

      if (result['isEnding']) {
        await _audioService.playSfx('story_end');
      } else {
        await _audioService.playSfx('page_turn');
      }

      _scrollToBottom();
      _autoSave();
    } catch (e) {
      _showError(e.toString());
    }
  }

  /// Otomatik kayıt
  Future<void> _autoSave() async {
    await _saveService.saveStory(_state, isAutoSave: true);
  }

  /// Manuel kayıt
  Future<void> _saveGame() async {
    final success = await _saveService.saveStory(_state);
    if (success) {
      await _audioService.playSfx('success');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hikaye kaydedildi!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      _showError('Kayıt başarısız oldu');
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

    // Detaylı hata dialogu göster
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(width: 12),
            const Text(
              'Hata Oluştu',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            error.replaceAll('Exception: ', ''),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam', style: TextStyle(color: Colors.blue)),
          ),
          if (error.contains('API KEY'))
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Ana menüye dön
              },
              child: const Text('Ana Menü', style: TextStyle(color: Colors.orange)),
            ),
        ],
      ),
    );
  }

  /// Yeniden başlatma dialogu
  void _showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeniden Başlat'),
        content: const Text('Hikayeyi baştan başlatmak istiyor musunuz? Mevcut ilerleme kaybolacak.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAvatarSelection();
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    );
  }

  /// Kayıt yükleme dialogu
  Future<void> _showLoadDialog() async {
    final saves = await _saveService.listSaves();

    if (!mounted) return;

    if (saves.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kaydedilmiş hikaye bulunamadı'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kayıt Yükle'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: saves.length,
            itemBuilder: (context, index) {
              final save = saves[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    save.state.currentAvatar ?? '📖',
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(save.title),
                  subtitle: Text(
                    save.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _saveService.deleteSave(save.id);
                      Navigator.pop(context);
                      _showLoadDialog();
                    },
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final loadedState = await _saveService.loadSave(save.id);
                    if (loadedState != null && mounted) {
                      setState(() {
                        _state = loadedState;
                        _selectedAvatar = loadedState.currentAvatar;
                      });
                      await _audioService.playSfx('success');
                    }
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (_selectedAvatar != null) ...[
              Text(_selectedAvatar!, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text('${widget.genre} Hikayesi')),
          ],
        ),
        backgroundColor: Colors.purple.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_audioService.isMusicEnabled ? Icons.music_note : Icons.music_off),
            onPressed: () {
              setState(() {
                _audioService.toggleMusic();
              });
            },
            tooltip: 'Müzik',
          ),
          IconButton(
            icon: Icon(_audioService.isSfxEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: () {
              setState(() {
                _audioService.toggleSfx();
              });
            },
            tooltip: 'Ses Efektleri',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _state.currentText.isNotEmpty ? _saveGame : null,
            tooltip: 'Kaydet',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'restart':
                  _showRestartDialog();
                  break;
                case 'load':
                  _showLoadDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'restart',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Yeniden Başlat'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'load',
                child: Row(
                  children: [
                    Icon(Icons.folder_open, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Kayıt Yükle'),
                  ],
                ),
              ),
            ],
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
                      FadeTransition(
                        opacity: _fadeController,
                        child: _StoryCard(text: _state.currentText),
                      ), // .animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                    if (_state.isLoading)
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hikaye yazılıyor...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ), // .animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.3)),
                  ],
                ),
              ),
            ),

            // Seçenekler
            if (_state.choices.isNotEmpty && !_state.isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  border: Border(
                    top: BorderSide(
                      color: Colors.purple.shade300,
                      width: 2,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Ne yapmak istersiniz?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ), // .animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
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
                        ), // .animate(delay: ((index + 1) * 150).ms).fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
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

class _ChoiceButton extends StatefulWidget {
  final int number;
  final String text;
  final VoidCallback onPressed;

  const _ChoiceButton({
    required this.number,
    required this.text,
    required this.onPressed,
  });

  @override
  State<_ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<_ChoiceButton> {
  bool _isHovered = false;

  Color _getChoiceColor() {
    switch (widget.number) {
      case 1:
        return Colors.blue.shade700;
      case 2:
        return Colors.purple.shade700;
      case 3:
        return Colors.deepPurple.shade700;
      default:
        return Colors.purple.shade700;
    }
  }

  IconData _getChoiceIcon() {
    switch (widget.number) {
      case 1:
        return Icons.looks_one;
      case 2:
        return Icons.looks_two;
      case 3:
        return Icons.looks_3;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getChoiceColor();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            elevation: _isHovered ? 8 : 4,
            shadowColor: color.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.white.withOpacity(_isHovered ? 0.5 : 0.2),
                width: _isHovered ? 2 : 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.9)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getChoiceIcon(),
                    color: color,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
