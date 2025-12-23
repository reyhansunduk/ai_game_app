# Kurulum ve Çalıştırma Rehberi

## 📋 Gereksinimler

- Flutter SDK (3.0 veya üzeri)
- Dart SDK (3.0 veya üzeri)
- Android Studio / VS Code
- Google Gemini API Key

---

## 🚀 Hızlı Başlangıç

### 1. Paketleri Yükleyin

```bash
flutter pub get
```

### 2. API Key Ayarlayın

`.env` dosyasını düzenleyin ve API anahtarınızı ekleyin:

```env
GEMINI_API_KEY=your_actual_api_key_here
```

**API Key Nasıl Alınır:**
1. https://makersuite.google.com/app/apikey adresine gidin
2. Google hesabınızla giriş yapın
3. "Create API Key" butonuna tıklayın
4. Anahtarı kopyalayın ve `.env` dosyasına yapıştırın

### 3. Uygulamayı Çalıştırın

```bash
flutter run
```

---

## 📱 Platform Bazlı Çalıştırma

### Android

```bash
flutter run -d android
```

### iOS (macOS gerektirir)

```bash
flutter run -d ios
```

### Web

```bash
flutter run -d chrome
```

### Windows

```bash
flutter run -d windows
```

---

## 🔧 Sorun Giderme

### Paket Yükleme Sorunları

Eğer `flutter pub get` hatası alırsanız:

```bash
flutter clean
flutter pub get
```

### Build Hataları

Cache'i temizleyin:

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Ses Çalışmıyor

Ses dosyaları opsiyoneldir. Eğer ses eklemek isterseniz:
1. `assets/sounds/README.md` dosyasını okuyun
2. Gerekli ses dosyalarını ekleyin
3. Uygulamayı yeniden derleyin

### API Key Hatası

Eğer "API key hatası" alırsanız:
1. `.env` dosyasının proje kök dizininde olduğundan emin olun
2. API key'in doğru olduğunu kontrol edin
3. API key'de boşluk veya ekstra karakter olmadığından emin olun

---

## 🎮 İlk Kullanım

1. **Uygulamayı Açın**
   - Ana menü açılacak

2. **Tür Seçin**
   - Macera, Korku, Bilim Kurgu veya Fantastik

3. **Avatar Seçin**
   - 18 farklı emoji karakterden birini seçin

4. **Oyuna Başlayın**
   - AI hikaye oluşturacak
   - 3 seçenekten birini seçin
   - Hikaye seçimlerinize göre şekillenecek

5. **Kayıt Sistemi**
   - Otomatik kayıt: Her hamleden sonra
   - Manuel kayıt: AppBar > Kaydet butonu
   - Kayıt yükle: Ana menü > "Kayıtlı Oyunlar"

---

## 🔊 Ses Dosyaları Ekleme (Opsiyonel)

### Adım 1: Ses Dosyalarını Hazırlayın

Aşağıdaki dosyaları edinin (MP3 formatında):

**Arka Plan Müzikleri:**
- adventure_bg.mp3
- horror_bg.mp3
- scifi_bg.mp3
- fantasy_bg.mp3
- default_bg.mp3

**Ses Efektleri:**
- choice_click.mp3
- story_start.mp3
- story_end.mp3
- page_turn.mp3
- success.mp3
- danger.mp3
- click.mp3

### Adım 2: Dosyaları Ekleyin

Tüm ses dosyalarını `assets/sounds/` klasörüne kopyalayın.

### Adım 3: Uygulamayı Yeniden Derleyin

```bash
flutter clean
flutter pub get
flutter run
```

**Ücretsiz Ses Kaynakları:**
- https://freesound.org
- https://www.zapsplat.com
- https://pixabay.com/music
- https://incompetech.com/music

---

## 📦 Build Alma

### Android APK

```bash
flutter build apk --release
```

APK dosyası: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Google Play için)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

Web build: `build/web/` klasöründe

---

## 🎯 Performans İpuçları

### Release Modda Çalıştırma

Daha hızlı performans için:

```bash
flutter run --release
```

### Profile Modu (Debug için)

```bash
flutter run --profile
```

---

## 📊 Test Etme

### Birim Testler

```bash
flutter test
```

### Widget Testleri

```bash
flutter test test/widget_test.dart
```

---

## 🔄 Güncelleme

Yeni güncellemeleri almak için:

```bash
git pull
flutter pub get
flutter clean
flutter run
```

---

## 💡 Geliştirme İpuçları

### Hot Reload

Geliştirme sırasında değişiklikleri anında görmek için `r` tuşuna basın.

### Hot Restart

Uygulamayı yeniden başlatmak için `R` tuşuna basın.

### Flutter Doctor

Kurulumu kontrol etmek için:

```bash
flutter doctor
```

### Bağımlılık Güncellemeleri

```bash
flutter pub outdated
flutter pub upgrade
```

---

## 🐛 Hata Ayıklama

### Debug Modu

```bash
flutter run --debug
```

### Verbose Logging

```bash
flutter run -v
```

### Logs Görüntüleme

```bash
flutter logs
```

---

## 📞 Destek

Sorun yaşıyorsanız:

1. `flutter doctor` çalıştırın
2. Hata mesajlarını kaydedin
3. GitHub Issues'da sorun açın
4. Aşağıdaki bilgileri ekleyin:
   - Flutter versiyonu
   - Dart versiyonu
   - Platform (Android/iOS/Web)
   - Hata mesajı

---

## ✅ Başarılı Kurulum Kontrolü

Kurulum başarılı ise:
- ✅ `flutter pub get` hatasız çalışır
- ✅ Uygulama açılır
- ✅ Ana menü görünür
- ✅ Tür seçimi çalışır
- ✅ Avatar seçimi açılır
- ✅ Hikaye oluşturulur (API key doğruysa)
- ✅ Seçimler çalışır
- ✅ Kayıt sistemi çalışır

---

## 🎉 Hazırsınız!

Artık AI Hikaye Oyunu'nu kullanmaya hazırsınız. İyi eğlenceler!
