# 🚀 Hızlı Başlangıç Rehberi

Hiç Flutter bilmiyorsanız, bu rehberi takip edin!

## 📝 Adım 1: Flutter'ı Yükleyin

### Windows için:

1. [Flutter İndirme Sayfası](https://docs.flutter.dev/get-started/install/windows)'na gidin
2. "Get the Flutter SDK" bölümünden zip dosyasını indirin
3. Zip dosyasını açın ve `C:\flutter` gibi bir yere yerleştirin
4. Sistem değişkenlerine ekleyin:
   - Windows Arama'da "ortam değişkenleri" yazın
   - "Sistem ortam değişkenlerini düzenle" seçin
   - "Ortam Değişkenleri" butonuna tıklayın
   - "Path" değişkenini bulun ve "Düzenle" tıklayın
   - "Yeni" butonuna tıklayın
   - `C:\flutter\bin` yazın ve Tamam'a basın

5. Komut İstemi'ni açın ve kontrol edin:
```bash
flutter --version
```

### Android Studio'yu Yükleyin (Android için gerekli)

1. [Android Studio](https://developer.android.com/studio) indirin
2. Kurulumu yapın
3. Android Studio'yu açın
4. "More Actions" > "SDK Manager"
5. "Android SDK Command-line Tools" seçin ve yükleyin
6. Komut İstemi'nde çalıştırın:
```bash
flutter doctor --android-licenses
```
Tüm lisansları kabul edin (y tuşuna basın)

## 📱 Adım 2: Emulator Kurun

### Android Emulator:

1. Android Studio'yu açın
2. "More Actions" > "Virtual Device Manager"
3. "Create Device" tıklayın
4. Bir telefon modeli seçin (örn: Pixel 5)
5. Sistem imajı indirin (örn: API 33)
6. "Finish" tıklayın
7. Play butonuna basarak emulator'ü başlatın

## 🔑 Adım 3: Google Gemini API Key Alın

1. [Google AI Studio](https://makersuite.google.com/app/apikey) açın
2. Google hesabınızla giriş yapın
3. "Create API Key" butonuna tıklayın
4. API Key'i kopyalayın
5. Proje klasöründeki `.env` dosyasını açın
6. `GEMINI_API_KEY=BURAYA_KOPYALAYIN` şeklinde yapıştırın

Örnek:
```
GEMINI_API_KEY=AIzaSyABcDeFg1234567890HiJkLmNoPqRsTuVw
```

## 🎮 Adım 4: Projeyi Çalıştırın

1. Komut İstemi veya Terminal'i açın
2. Proje klasörüne gidin:
```bash
cd Desktop\ai_game_app
```

3. Paketleri yükleyin:
```bash
flutter pub get
```

4. Cihazları kontrol edin:
```bash
flutter devices
```

5. Uygulamayı çalıştırın:
```bash
flutter run
```

İlk çalıştırma biraz uzun sürebilir (5-10 dakika). Sabırlı olun!

## 📱 Adım 5: Telefonunuzda Test Edin

### Gerçek Android telefonda çalıştırmak için:

1. Telefonunuzda "Ayarlar" > "Telefon Hakkında"
2. "Yapı Numarası"na 7 kez dokunun (Geliştirici seçenekleri aktif olur)
3. "Geliştirici Seçenekleri"ne girin
4. "USB Hata Ayıklama"yı açın
5. Telefonu bilgisayara USB ile bağlayın
6. Telefonda çıkan izin isteğini kabul edin
7. Komut İstemi'nde:
```bash
flutter devices
```
Telefonunuzu göreceksiniz.

8. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📦 Adım 6: APK Oluşturun

Telefonunuza kurmak için APK oluşturun:

```bash
flutter build apk --release
```

APK konumu: `build\app\outputs\flutter-apk\app-release.apk`

Bu dosyayı telefonunuza atın ve kurun!

## ❓ Sık Sorulan Sorular

### "flutter: command not found" hatası
- Flutter'ı PATH'e eklediniz mi kontrol edin
- Komut İstemi'ni kapatıp tekrar açın
- `flutter doctor` çalıştırın

### "No devices found" hatası
- Emulator çalışıyor mu kontrol edin
- Telefon USB ile bağlı mı kontrol edin
- USB Hata Ayıklama açık mı kontrol edin

### Uygulama başlamıyor
- `flutter clean` çalıştırın
- `flutter pub get` çalıştırın
- Tekrar `flutter run` çalıştırın

### API hatası alıyorum
- `.env` dosyasında API Key doğru mu kontrol edin
- İnternet bağlantınız var mı kontrol edin
- API Key'in aktif olduğundan emin olun

## 🎓 Flutter Öğrenmek İsterseniz

- [Flutter Resmi Dokümantasyon](https://docs.flutter.dev/)
- [Flutter Türkçe Kaynaklar](https://flutter.dev/community)
- YouTube'da "Flutter Dersleri Türkçe" arayın

## 💡 İpuçları

1. **Hot Reload**: Kod değiştirdiğinizde `r` tuşuna basın, anında güncellenir
2. **Hot Restart**: `R` (büyük) tuşuna basın, uygulama yeniden başlar
3. **Hata Mesajları**: Kırmızı hata mesajlarını okuyun, genellikle çözümü söyler
4. **VS Code**: Daha iyi geliştirme deneyimi için VS Code + Flutter eklentisi kullanın

## 🆘 Yardım Lazımsa

1. Hata mesajını Google'da aratın (İngilizce)
2. [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter) kontrol edin
3. Flutter Discord kanallarına katılın
4. Bu proje için issue açın GitHub'da

---

**Başarılar! İlk Flutter uygulamanız hayırlı olsun! 🎉**
