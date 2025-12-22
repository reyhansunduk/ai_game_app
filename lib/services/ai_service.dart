import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // API Key - .env dosyasından veya const'tan alınır
  // ÖNEMLI: GitHub'a yüklemeden önce .env dosyasını kullanın!
  // Şimdilik hard-coded (sadece test için)
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent';

  /// Hikaye başlatır
  Future<Map<String, dynamic>> startStory(String genre) async {
    final prompt = '''
Sen bir interaktif hikaye anlatıcısısın. $genre türünde yeni bir hikaye başlat.

Kurallar:
1. Hikayeyi Türkçe yaz
2. Yaklaşık 150-200 kelimelik ilgi çekici bir açılış yaz
3. Oyuncuya 3 farklı seçenek sun
4. Her seçenek farklı bir yöne götürsün

Cevabını şu formatta ver:
HIKAYE: [hikaye metni buraya]
SEÇENEK1: [ilk seçenek]
SEÇENEK2: [ikinci seçenek]
SEÇENEK3: [üçüncü seçenek]
''';

    return await _generateContent(prompt);
  }

  /// Oyuncunun seçimine göre hikayeyi devam ettirir
  Future<Map<String, dynamic>> continueStory(String storyHistory, String choice) async {
    final prompt = '''
Sen bir interaktif hikaye anlatıcısısın. Şimdiye kadar olan olaylar:

$storyHistory

Oyuncunun seçimi: $choice

Bu seçime göre hikayeyi devam ettir. Kurallar:
1. Hikayeyi Türkçe yaz
2. Seçimin sonuçlarını ve yeni olayları 150-200 kelimede anlat
3. Oyuncuya 3 yeni seçenek sun
4. Hikayeyi mantıklı şekilde ilerlet
5. Eğer hikaye doğal bir sona erme noktasına geldiyse, "SONUÇ:" ile başlayan bir final yaz ve seçenek sunma

Cevabını şu formatta ver:
HIKAYE: [hikaye metni buraya]
SEÇENEK1: [ilk seçenek]
SEÇENEK2: [ikinci seçenek]
SEÇENEK3: [üçüncü seçenek]

veya hikaye bittiyse:
SONUÇ: [final metni]
''';

    return await _generateContent(prompt);
  }

  /// Gemini API'ye istek gönderir
  Future<Map<String, dynamic>> _generateContent(String prompt) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.9,
            'maxOutputTokens': 1000,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return _parseResponse(text);
      } else {
        throw Exception('API hatası: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  /// AI yanıtını parçalara ayırır
  Map<String, dynamic> _parseResponse(String text) {
    String story = '';
    List<String> choices = [];
    bool isEnding = false;

    // SEÇENEK1, SEÇENEK2, SEÇENEK3 ara
    final secenek1Match = RegExp(r'SEÇENEK1:\s*(.+?)(?=\n|SEÇENEK2:|$)', dotAll: true).firstMatch(text);
    final secenek2Match = RegExp(r'SEÇENEK2:\s*(.+?)(?=\n|SEÇENEK3:|$)', dotAll: true).firstMatch(text);
    final secenek3Match = RegExp(r'SEÇENEK3:\s*(.+?)(?=\n|$)', dotAll: true).firstMatch(text);

    if (secenek1Match != null) choices.add(secenek1Match.group(1)!.trim());
    if (secenek2Match != null) choices.add(secenek2Match.group(1)!.trim());
    if (secenek3Match != null) choices.add(secenek3Match.group(1)!.trim());

    // Hikaye veya sonuç metnini al
    if (text.contains('SONUÇ:')) {
      isEnding = true;
      final sonucMatch = RegExp(r'SONUÇ:\s*(.+?)(?=SEÇENEK|$)', dotAll: true).firstMatch(text);
      if (sonucMatch != null) {
        story = sonucMatch.group(1)!.trim();
      }
    } else if (text.contains('HIKAYE:')) {
      final hikayeMatch = RegExp(r'HIKAYE:\s*(.+?)(?=SEÇENEK|$)', dotAll: true).firstMatch(text);
      if (hikayeMatch != null) {
        story = hikayeMatch.group(1)!.trim();
      }
    } else {
      // Format yoksa ilk SEÇENEK'e kadar olan kısmı hikaye olarak al
      final firstSecenek = text.indexOf('SEÇENEK');
      if (firstSecenek > 0) {
        story = text.substring(0, firstSecenek).trim();
      } else {
        story = text.trim();
      }
    }

    return {
      'story': story.trim(),
      'choices': choices,
      'isEnding': isEnding,
    };
  }
}
