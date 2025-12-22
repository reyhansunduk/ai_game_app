# ⚡ Hızlı Başlatma Rehberi

## 🎯 Şu Anda Neredeyiz?

✅ Oyun kodları tamamen hazır!
❌ Flutter henüz kurulu değil

## 🚀 3 Adımda Çalıştır

### Adım 1: Flutter'ı Kur (10 dakika)

**Windows için:**

1. **Flutter SDK İndir**
   - [Flutter İndir](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip)
   - Veya: https://docs.flutter.dev/get-started/install/windows

2. **Klasöre Çıkar**
   ```
   C:\flutter klasörüne çıkarın
   ```

3. **PATH'e Ekle**
   - Windows tuşu + "ortam" yazın
   - "Sistem ortam değişkenlerini düzenle" tıklayın
   - "Ortam Değişkenleri" butonuna tıklayın
   - "Path" seçin ve "Düzenle" tıklayın
   - "Yeni" butonuna tıklayın
   - `C:\flutter\bin` yazın
   - Tamam, Tamam, Tamam

4. **Kontrol Et**
   - Yeni bir Command Prompt açın
   ```bash
   flutter doctor
   ```

### Adım 2: Android Studio Kur (15 dakika)

1. **İndir ve Kur**
   - [Android Studio İndir](https://developer.android.com/studio)
   - Kurulumu normal ilerletin

2. **Android SDK Tools**
   - Android Studio'yu aç
   - "More Actions" > "SDK Manager"
   - "SDK Tools" sekmesi
   - "Android SDK Command-line Tools" işaretle
   - "Apply" tıkla

3. **Lisansları Kabul Et**
   ```bash
   flutter doctor --android-licenses
   ```
   Her şeye "y" (yes) yazın

4. **Emulator Oluştur**
   - Android Studio > "More Actions" > "Virtual Device Manager"
   - "Create Device"
   - Pixel 5 seçin > Next
   - API 33 (Android 13) indirin > Next
   - Finish
   - ▶️ Play butonuna basıp emulator'ü başlatın

### Adım 3: Oyunu Çalıştır (2 dakika)

1. **API Key Ekle**
   ```
   .env dosyasını açın
   GEMINI_API_KEY=BURAYA_API_KEYINIZI_YAPIŞTIRIN
   ```

   API Key nereden alınır:
   - https://makersuite.google.com/app/apikey
   - "Create API Key" tıklayın
   - Kopyalayın

2. **Proje Klasörüne Git**
   ```bash
   cd Desktop\ai_game_app
   ```

3. **Paketleri Yükle**
   ```bash
   flutter pub get
   ```

4. **Çalıştır!**
   ```bash
   flutter run
   ```

   İlk seferde 5-10 dakika sürebilir, bekleyin!

## 🎮 Uygulamayı Test Edin

Emulator'de uygulama açıldığında:

1. Ana menüde 4 tür göreceksiniz:
   - 🌲 Macera (Yeşil)
   - 🌙 Korku (Kırmızı)
   - 🚀 Bilim Kurgu (Mavi)
   - 🏰 Fantastik (Mor)

2. Bir türe tıklayın

3. AI hikaye oluşturacak (3-5 saniye)

4. Hikaye ve 3 seçenek göreceksiniz

5. Bir seçim yapın

6. AI devam edecek!

## 📱 Gerçek Telefonunuzda Test

1. **Telefon Ayarları**
   - Ayarlar > Telefon Hakkında
   - "Yapı Numarası"na 7 kez tıklayın
   - Geliştirici seçenekleri açıldı!

2. **USB Hata Ayıklama**
   - Ayarlar > Geliştirici Seçenekleri
   - "USB Hata Ayıklama" açın

3. **Telefonu Bağlayın**
   - USB kabloyla bilgisayara bağlayın
   - Telefonda çıkan izni kabul edin

4. **Çalıştırın**
   ```bash
   flutter devices
   ```
   Telefonunuzu göreceksiniz

   ```bash
   flutter run
   ```

## 📦 APK Oluştur (Arkadaşlarınıza Dağıtın!)

```bash
flutter build apk --release
```

APK konumu:
```
build\app\outputs\flutter-apk\app-release.apk
```

Bu dosyayı telefona atıp kurun, çalışır!

## ❓ Sorun mu Var?

### "flutter: command not found"
- Flutter PATH'e eklendi mi?
- Command Prompt'u kapayıp yeni açtınız mı?

### "No devices found"
- Emulator çalışıyor mu?
- Telefon bağlı mı ve USB ayıklama açık mı?

### "API Key hatası"
- .env dosyasında doğru mu?
- İnternet bağlantınız var mı?
- API Key Google AI Studio'dan aldınız mı?

### Yavaş çalışıyor
- Release modda çalıştırın: `flutter run --release`
- Veya APK oluşturun, gerçek cihazda test edin

## 🎬 Alternatif: VS Code Kullanın

Daha kolay olabilir:

1. **VS Code İndir**
   - https://code.visualstudio.com/

2. **Flutter Extension Kur**
   - VS Code açın
   - Extensions (Ctrl+Shift+X)
   - "Flutter" arayın
   - Install

3. **Projeyi Aç**
   - File > Open Folder
   - ai_game_app seçin

4. **F5 Tuşuna Basın**
   - Emulator seçin
   - Çalışır!

## 💡 Geliştirme İpuçları

- **Hot Reload**: Kod değiştirin, `r` tuşuna basın (anında güncellenir!)
- **Hot Restart**: `R` tuşuna basın (baştan başlar)
- **Çıkış**: `q` tuşu

## 🎯 Kontrol Listesi

- [ ] Flutter kurdum
- [ ] Android Studio kurdum
- [ ] Emulator oluşturdum
- [ ] API Key aldım
- [ ] .env dosyasına yapıştırdım
- [ ] flutter pub get çalıştırdım
- [ ] flutter run çalıştırdım
- [ ] OYUN ÇALIŞIYOR! 🎉

---

**Başarılar! Herhangi bir sorun olursa, hata mesajını gönderin, yardımcı olayım! 🚀**
