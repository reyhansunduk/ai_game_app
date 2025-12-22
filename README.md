# 🎮 AI Hikaye Oyunu

Google Gemini AI ile güçlendirilmiş interaktif hikaye tabanlı mobil oyun. Seçimlerinize göre yapay zeka tarafından oluşturulan benzersiz hikayeleri deneyimleyin!

## ✨ Özellikler

- 🤖 **AI Destekli Hikayeler**: Google Gemini AI her oyunda farklı hikayeler oluşturur
- 🎭 **4 Farklı Tür**: Macera, Korku, Bilim Kurgu ve Fantastik
- 🎯 **Seçim Bazlı Gameplay**: Her seçiminiz hikayeyi farklı yöne götürür
- 📱 **Modern Arayüz**: Gradient renkler ve smooth animasyonlar
- 🔄 **Sonsuz Tekrar**: Her oyun farklı bir deneyim sunar
- 🇹🇷 **Türkçe**: Tamamen Türkçe hikayeler

## 📋 Gereksinimler

- Flutter 3.0 veya üzeri
- Dart 3.0 veya üzeri
- Android SDK (Android için)
- Xcode (iOS için)
- Google Gemini API Key (ÜCRETSİZ)

## 🚀 Kurulum

### 1. Flutter'ı Yükleyin

Eğer Flutter yüklü değilse:

**Windows:**
```bash
# Flutter'ı indirin: https://docs.flutter.dev/get-started/install/windows
# İndirdiğiniz zip'i açın ve bir klasöre yerleştirin
# Sistem değişkenlerine PATH ekleyin: C:\flutter\bin
```

**macOS/Linux:**
```bash
# Flutter'ı indirin: https://docs.flutter.dev/get-started/install
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
```

Flutter kurulumunu kontrol edin:
```bash
flutter doctor
```

### 2. Projeyi Hazırlayın

Proje klasöründe paketleri yükleyin:
```bash
cd ai_game_app
flutter pub get
```

### 3. Google Gemini API Key Alın (ÜCRETSİZ!)

1. [Google AI Studio](https://makersuite.google.com/app/apikey) adresine gidin
2. Google hesabınızla giriş yapın
3. "Create API Key" butonuna tıklayın
4. API Key'inizi kopyalayın

### 4. API Key'i Ayarlayın

`.env` dosyasını açın ve API key'inizi ekleyin:

```env
GEMINI_API_KEY=BURAYA_API_KEYINIZI_YAPIŞTIRIN
```

**ÖNEMLİ:** `.env` dosyasını asla GitHub'a yüklemeyin! (Zaten .gitignore'da)

### 5. Uygulamayı Çalıştırın

**Android Emulator veya Gerçek Cihazda:**
```bash
flutter run
```

**Belirli bir cihazda:**
```bash
# Mevcut cihazları listele
flutter devices

# Belirli cihazda çalıştır
flutter run -d <device-id>
```

## 📱 APK Oluşturma

Android için APK oluşturmak için:

```bash
# Release APK
flutter build apk --release

# APK konumu: build/app/outputs/flutter-apk/app-release.apk
```

APK dosyasını Android telefonunuza yükleyip kurabilirsiniz!

## 🎮 Nasıl Oynanır?

1. Uygulamayı açın
2. Ana menüden bir tür seçin (Macera, Korku, Bilim Kurgu, Fantastik)
3. AI hikayeyi başlatacak ve size seçenekler sunacak
4. Beğendiğiniz seçeneğe dokunun
5. Hikaye seçiminize göre devam edecek
6. Hikaye doğal bir sona gelene kadar devam edin
7. "Yeni Oyun" ile aynı türde farklı bir hikaye başlatın veya "Ana Menü"ye dönün

## 🏗️ Proje Yapısı

```
lib/
├── main.dart              # Uygulama giriş noktası
├── models/
│   └── story_state.dart   # Hikaye durum modeli
├── screens/
│   ├── home_screen.dart   # Ana menü ekranı
│   └── game_screen.dart   # Oyun ekranı
└── services/
    └── ai_service.dart    # Google Gemini AI entegrasyonu
```

## 🔧 Özelleştirme

### Farklı AI Modeli Kullanma

`lib/services/ai_service.dart` dosyasında `_baseUrl` değişkenini değiştirebilirsiniz:

```dart
// Gemini Pro yerine başka model
static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
```

### Yeni Türler Ekleme

`lib/screens/home_screen.dart` dosyasına yeni buton ekleyin:

```dart
_GenreButton(
  title: 'Romantik',
  icon: Icons.favorite,
  color: Colors.pink,
  onPressed: () => _startGame(context, 'Romantik'),
),
```

### Hikaye Uzunluğunu Değiştirme

`lib/services/ai_service.dart` dosyasında prompt içindeki kelime sayısını değiştirin:

```dart
// "Yaklaşık 150-200 kelimelik" yerine
"Yaklaşık 300-400 kelimelik ilgi çekici bir açılış yaz"
```

## 🐛 Sorun Giderme

### "API hatası: 400" Hatası
- API Key'inizi kontrol edin
- `.env` dosyasında doğru formatta olduğundan emin olun
- Google AI Studio'da API Key'in aktif olduğunu kontrol edin

### "Bağlantı hatası" Hatası
- İnternet bağlantınızı kontrol edin
- Google Gemini API servisinin çalıştığını kontrol edin

### Türkçe karakterler düzgün görünmüyor
- `pubspec.yaml` dosyasında encoding UTF-8 olarak ayarlı mı kontrol edin
- Projeyi temizleyip yeniden derleyin: `flutter clean && flutter pub get`

### Uygulama yavaş çalışıyor
- Release modda derleyin: `flutter run --release`
- Veya APK oluşturup gerçek cihazda test edin

## 📚 Kullanılan Teknolojiler

- **Flutter**: Cross-platform mobil uygulama framework'ü
- **Google Gemini AI**: Ücretsiz AI model (hikaye üretimi)
- **http**: API istekleri için
- **flutter_dotenv**: Ortam değişkenleri yönetimi
- **provider**: State management (opsiyonel)

## 🎯 Gelecek Özellikler

- [ ] Hikaye kaydetme/yükleme
- [ ] Ses efektleri
- [ ] Karakter avatarları
- [ ] Başarımlar (achievements)
- [ ] Hikaye paylaşma
- [ ] Çoklu dil desteği
- [ ] Dark/Light tema
- [ ] Offline mod (önceden hazırlanmış hikayeler)

## 📄 Lisans

Bu proje MIT lisansı altında açık kaynaklıdır. İsterseniz değiştirip geliştirebilirsiniz!

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Özellik branch'i oluşturun (`git checkout -b feature/harika-ozellik`)
3. Değişikliklerinizi commit edin (`git commit -m 'Harika özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/harika-ozellik`)
5. Pull Request açın

## 📞 İletişim

Sorularınız için issue açabilirsiniz!

## 🙏 Teşekkürler

- Google Gemini AI ekibine ücretsiz API için
- Flutter ekibine harika framework için
- Sizi oynayacağınız için! 🎮

---

**İyi Oyunlar! 🎮✨**
