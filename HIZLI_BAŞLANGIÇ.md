# 🚀 Hızlı Başlangıç Rehberi

## ÖNEMLİ: API Key Kurulumu

Oyunun çalışması için Google Gemini API Key gereklidir. Aşağıdaki adımları takip edin:

### 1. API Key Alın (Ücretsiz)

1. https://makersuite.google.com/app/apikey adresine gidin
2. Google hesabınızla giriş yapın
3. **"Create API Key"** butonuna tıklayın
4. **"Create API key in new project"** seçin
5. API keyi kopyalayın (örnek: `AIzaSyC...`)

### 2. API Key'i Projeye Ekleyin

1. Proje klasöründe `.env` dosyasını açın
2. `your_api_key_here` kısmını silip kopyaladığınız API key'i yapıştırın:

```env
GEMINI_API_KEY=AIzaSyC_sizin_gercek_api_keyiniz_buraya
```

3. Dosyayı kaydedin

### 3. Paketleri Yükleyin

Terminalde şu komutu çalıştırın:

```bash
flutter pub get
```

### 4. Uygulamayı Çalıştırın

```bash
flutter run
```

---

## ✅ Sorun Giderme

### "API key hatası" alıyorsanız:

1. `.env` dosyasının proje kök dizininde olduğundan emin olun
2. API key'de boşluk veya ekstra karakter olmadığını kontrol edin
3. API key'in `GEMINI_API_KEY=` şeklinde başladığından emin olun
4. Uygulamayı durdurup yeniden başlatın (`flutter run`)

### "Seçenekler görünmüyor" sorunu:

1. API key'in doğru girildiğinden emin olun
2. İnternet bağlantınızı kontrol edin
3. Console loglarına bakın (hata mesajları görebilirsiniz)
4. API key limitini aşmadığınızdan emin olun

### Avatar seçimi açılmıyor:

1. Uygulamayı tamamen kapatıp yeniden başlatın
2. Hot reload yerine `flutter run` kullanın
3. Cache'i temizleyin: `flutter clean && flutter pub get && flutter run`

---

## 🎮 Oyun Nasıl Oynanır

1. **Ana Menü**: Bir tür seçin (Macera, Korku, Bilim Kurgu, Fantastik)
2. **Avatar Seçimi**: Karakterinizi seçin (18 seçenek)
3. **Hikaye**: AI tarafından oluşturulan hikaye görünür
4. **Seçimler**: Altta 3 seçenek çıkar - birini seçin
5. **Devam**: Hikaye seçimlerinize göre şekillenir
6. **Kaydet**: İstediğiniz zaman AppBar'dan kaydedin
7. **Yükle**: Kayıtlı oyunlardan kaldığınız yerden devam edin

---

## 📱 Platform Seçimi

### Android
```bash
flutter run -d android
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

## 🔊 Ses Dosyaları (Opsiyonel)

Ses dosyaları olmadan da oyun çalışır. Ses eklemek isterseniz:

1. `assets/sounds/README.md` dosyasını okuyun
2. Gerekli MP3 dosyalarını `assets/sounds/` klasörüne ekleyin
3. Uygulamayı yeniden derleyin

---

## 💡 İpuçları

- **Otomatik Kayıt**: Her seçiminizden sonra otomatik olarak kaydedilir
- **Manuel Kayıt**: AppBar'daki kaydet ikonuna basın 💾
- **Ses Kontrolü**: AppBar'dan müzik ve ses efektlerini açıp kapatabilirsiniz
- **Yeniden Başlat**: Menü > Yeniden Başlat

---

## 🐛 Hata Ayıklama

Debug modunda çalıştırmak için:

```bash
flutter run -v
```

Console'da şunları göreceksiniz:
- `AI Response: ...` - AI'dan gelen yanıt
- `Parsed - Story: ...` - İşlenmiş hikaye
- `Parsed - Choices: X adet` - Bulunan seçenek sayısı

---

## ✨ Yeni Özellikler

- ✅ Avatar seçimi (18 karakter)
- ✅ Hikaye kaydetme/yükleme
- ✅ Ses efektleri ve müzik sistemi
- ✅ Gelişmiş UI animasyonları
- ✅ Her seçim farklı renk
- ✅ Otomatik kayıt

---

## 📞 Destek

Sorun yaşıyorsanız:

1. `KURULUM_VE_ÇALIŞTIRMA.md` dosyasını okuyun
2. Console loglarına bakın
3. `flutter doctor` komutunu çalıştırın
4. GitHub Issues'da sorun açın

---

## 🎉 Hazırsınız!

API key'i doğru girdiyseniz, oyun tam anlamıyla çalışacaktır. İyi eğlenceler!

**Önemli**: API key'inizi kimseyle paylaşmayın ve GitHub'a yüklemeyin!
