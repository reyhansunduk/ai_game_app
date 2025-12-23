import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  // API Key - .env dosyasından alınır
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';

  /// Hikaye başlatır
  Future<Map<String, dynamic>> startStory(String genre) async {
    final prompt = '''
Sen bir interaktif hikaye anlatıcısısın. $genre türünde yeni bir hikaye başlat.

ÖNEMLİ KURALLAR:
1. Hikayeyi Türkçe yaz
2. MUTLAKA 150-200 kelimelik DETAYLI bir açılış yaz
3. MUTLAKA oyuncuya 3 FARKLI seçenek sun
4. Her seçenek farklı bir yöne götürsün
5. Formatı TAM OLARAK takip et

ZORUNLU FORMAT (harfi harfine uymalısın):
HIKAYE: [Buraya uzun ve detaylı hikaye metni yazılacak. En az 150 kelime olmalı. Hikayeyi tam bitir, yarıda kesme.]

SEÇENEK1: [İlk seçenek buraya - açık ve net olmalı]

SEÇENEK2: [İkinci seçenek buraya - açık ve net olmalı]

SEÇENEK3: [Üçüncü seçenek buraya - açık ve net olmalı]

ÖRNEK:
HIKAYE: Karanlık bir ormanda yürüyorsun. Etrafta sadece ağaçların hışırtısı duyuluyor...

SEÇENEK1: Sağdaki patikayı takip et

SEÇENEK2: Soldaki mağaraya gir

SEÇENEK3: Geri dön

Şimdi $genre türünde bir hikaye başlat!
''';

    return await _generateContent(prompt);
  }

  /// Oyuncunun seçimine göre hikayeyi devam ettirir
  Future<Map<String, dynamic>> continueStory(String storyHistory, String choice) async {
    final prompt = '''
Sen bir interaktif hikaye anlatıcısısın. Şimdiye kadar olan olaylar:

$storyHistory

Oyuncunun seçimi: $choice

ÖNEMLİ KURALLAR:
1. Hikayeyi Türkçe yaz
2. Seçimin sonuçlarını MUTLAKA 150-200 kelimede DETAYLI anlat
3. MUTLAKA oyuncuya 3 YENİ seçenek sun
4. Hikayeyi mantıklı şekilde ilerlet
5. Formatı TAM OLARAK takip et
6. Hikaye bitmemişse SONUÇ yazma, devam ettir!

ZORUNLU FORMAT:
HIKAYE: [Buraya seçimin sonucu ve yeni olaylar yazılacak. DETAYLI yaz, en az 150 kelime.]

SEÇENEK1: [İlk yeni seçenek - açık ve net]

SEÇENEK2: [İkinci yeni seçenek - açık ve net]

SEÇENEK3: [Üçüncü yeni seçenek - açık ve net]

NOT: Sadece hikaye gerçekten BİTTİYSE (10+ seçim yapıldıysa) şu formatı kullan:
SONUÇ: [Final metni - hikayenin sonu]
''';

    return await _generateContent(prompt);
  }

  /// Gemini API'ye istek gönderir
  Future<Map<String, dynamic>> _generateContent(String prompt) async {
    // API key kontrolü
    if (_apiKey == 'YOUR_API_KEY_HERE' || _apiKey == 'your_api_key_here' || _apiKey.isEmpty) {
      throw Exception(
        'API KEY EKSİK!\n\n'
        '1. https://makersuite.google.com/app/apikey adresine gidin\n'
        '2. Google hesabınızla giriş yapın\n'
        '3. "Create API Key" butonuna tıklayın\n'
        '4. API key\'i kopyalayın\n'
        '5. .env dosyasına ekleyin:\n'
        '   GEMINI_API_KEY=AIzaSyC...\n\n'
        'Ücretsizdir ve 2 dakika sürer!'
      );
    }

    try {
      final url = Uri.parse(_baseUrl);

      print('🌐 API isteği gönderiliyor...');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
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

      print('📡 API yanıt kodu: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return _parseResponse(text);
      } else if (response.statusCode == 400) {
        throw Exception(
          'Geçersiz API Key!\n\n'
          '.env dosyasındaki API key\'i kontrol edin.\n'
          'Yeni bir key almak için:\n'
          'https://makersuite.google.com/app/apikey'
        );
      } else if (response.statusCode == 429) {
        throw Exception(
          'Çok fazla istek!\n\n'
          'API limit aşıldı. Birkaç dakika bekleyin.'
        );
      } else {
        throw Exception('API hatası: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('API KEY')) {
        rethrow;
      }
      throw Exception('Bağlantı hatası:\n\n$e\n\nİnternet bağlantınızı kontrol edin.');
    }
  }

  /// AI yanıtını parçalara ayırır
  Map<String, dynamic> _parseResponse(String text) {
    String story = '';
    List<String> choices = [];
    bool isEnding = false;

    print('==================== AI RESPONSE ====================');
    print(text);
    print('====================================================');

    // SONUÇ kontrolü
    if (text.toUpperCase().contains('SONUÇ:')) {
      isEnding = true;
      final sonucMatch = RegExp(r'SONUÇ:\s*(.+)', dotAll: true, multiLine: true, caseSensitive: false).firstMatch(text);
      if (sonucMatch != null) {
        story = sonucMatch.group(1)!.trim();
      }
      return {
        'story': story.isNotEmpty ? story : text.trim(),
        'choices': [],
        'isEnding': true,
      };
    }

    // Hikaye metnini al - daha esnek pattern
    final hikayePatterns = [
      r'HIKAYE:\s*(.+?)(?=SEÇENEK\s*1:)',
      r'HIKAYE:\s*(.+?)(?=SEÇENEK1:)',
      r'HIKAYE:\s*(.+?)(?=\n\s*SEÇENEK)',
    ];

    for (var pattern in hikayePatterns) {
      final match = RegExp(pattern, dotAll: true, multiLine: true, caseSensitive: false).firstMatch(text);
      if (match != null && match.group(1) != null) {
        story = match.group(1)!.trim();
        if (story.isNotEmpty) break;
      }
    }

    // Seçenekleri al - her satırı ayrı kontrol et
    final lines = text.split('\n');
    String? choice1, choice2, choice3;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // SEÇENEK1 veya SEÇENEK 1
      if (RegExp(r'^SEÇENEK\s*1:', caseSensitive: false).hasMatch(line)) {
        choice1 = line.replaceFirst(RegExp(r'^SEÇENEK\s*1:\s*', caseSensitive: false), '').trim();
        // Eğer boşsa bir sonraki satırı al
        if (choice1.isEmpty && i + 1 < lines.length) {
          choice1 = lines[i + 1].trim();
        }
      }

      // SEÇENEK2 veya SEÇENEK 2
      if (RegExp(r'^SEÇENEK\s*2:', caseSensitive: false).hasMatch(line)) {
        choice2 = line.replaceFirst(RegExp(r'^SEÇENEK\s*2:\s*', caseSensitive: false), '').trim();
        if (choice2.isEmpty && i + 1 < lines.length) {
          choice2 = lines[i + 1].trim();
        }
      }

      // SEÇENEK3 veya SEÇENEK 3
      if (RegExp(r'^SEÇENEK\s*3:', caseSensitive: false).hasMatch(line)) {
        choice3 = line.replaceFirst(RegExp(r'^SEÇENEK\s*3:\s*', caseSensitive: false), '').trim();
        if (choice3.isEmpty && i + 1 < lines.length) {
          choice3 = lines[i + 1].trim();
        }
      }
    }

    if (choice1 != null && choice1.isNotEmpty) choices.add(choice1);
    if (choice2 != null && choice2.isNotEmpty) choices.add(choice2);
    if (choice3 != null && choice3.isNotEmpty) choices.add(choice3);

    // Eğer hikaye metni boşsa
    if (story.isEmpty) {
      final hikayeIndex = text.toUpperCase().indexOf('HIKAYE:');
      final secenek1Index = text.toUpperCase().indexOf('SEÇENEK');

      if (hikayeIndex != -1 && secenek1Index != -1) {
        story = text.substring(hikayeIndex + 7, secenek1Index).trim();
      } else if (secenek1Index != -1) {
        story = text.substring(0, secenek1Index).trim();
      } else {
        story = text.trim();
      }
    }

    // Son kontrol - en az 3 seçenek olmalı
    if (choices.length < 3 && !isEnding) {
      print('⚠️ UYARI: Sadece ${choices.length} seçenek bulundu! AI yanıtı düzgün parse edilemedi.');
      print('Bulunan seçenekler: $choices');

      // Varsayılan seçenekler ekle
      if (choices.isEmpty) {
        choices = [
          'İleriye doğru ilerle',
          'Etrafı incele',
          'Geri dön'
        ];
      } else {
        while (choices.length < 3) {
          choices.add('Devam et (${choices.length + 1})');
        }
      }
    }

    print('✓ Parsed - Story length: ${story.length} karakter');
    print('✓ Parsed - Choices: ${choices.length} adet');
    print('  1. ${choices.isNotEmpty ? choices[0] : "YOK"}');
    print('  2. ${choices.length > 1 ? choices[1] : "YOK"}');
    print('  3. ${choices.length > 2 ? choices[2] : "YOK"}');

    return {
      'story': story.isNotEmpty ? story : 'Hikaye yüklenemedi. Lütfen tekrar deneyin.',
      'choices': choices,
      'isEnding': isEnding,
    };
  }
}
