import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade900,
              Colors.blue.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Başlık
                  Icon(
                    Icons.auto_stories,
                    size: 100,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'AI Hikaye Oyunu',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.purple.shade300,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Seçimlerinle Şekillenen Hikayeler',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Türler
                  _GenreButton(
                    title: 'Macera',
                    icon: Icons.landscape,
                    color: Colors.green,
                    onPressed: () => _startGame(context, 'Macera'),
                  ),
                  const SizedBox(height: 16),
                  _GenreButton(
                    title: 'Korku',
                    icon: Icons.brightness_3,
                    color: Colors.red,
                    onPressed: () => _startGame(context, 'Korku'),
                  ),
                  const SizedBox(height: 16),
                  _GenreButton(
                    title: 'Bilim Kurgu',
                    icon: Icons.rocket_launch,
                    color: Colors.blue,
                    onPressed: () => _startGame(context, 'Bilim Kurgu'),
                  ),
                  const SizedBox(height: 16),
                  _GenreButton(
                    title: 'Fantastik',
                    icon: Icons.castle,
                    color: Colors.purple,
                    onPressed: () => _startGame(context, 'Fantastik'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, String genre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(genre: genre),
      ),
    );
  }
}

class _GenreButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _GenreButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
