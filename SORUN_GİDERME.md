# 🔧 Sorun Giderme Rehberi

## En Sık Karşılaşılan Sorunlar

### 1. ❌ "API key hatası" veya "Bağlantı hatası"

**Belirtiler:**
- Hikaye oluşturulmuyor
- "Hata: API hatası" mesajı görünüyor
- Seçenekler çıkmıyor

**Çözüm:**

1. `.env` dosyasını kontrol edin:
   ```env
   GEMINI_API_KEY=AIzaSyC_sizin_gercek_keyiniz
   ```
   - `your_api_key_here` yazıyorsa DEĞİŞTİRİN
   - API key boşluk içermemeli
   - `=` işaretinden sonra boşluk olmamalı

2. API key doğru mu kontrol edin:
   - https://makersuite.google.com/app/apikey adresine gidin
   - Key'inizi kontrol edin veya yeni bir tane oluşturun

3. Uygulamayı YENİDEN BAŞLATIN:
   ```bash
   # Uygulamayı durdurun (CTRL+C)
   flutter clean
   flutter pub get
   flutter run
   ```

4. İnternet bağlantınızı kontrol edin

---

### 2. 🎭 Avatar Seçim Ekranı Açılmıyor

**Belirtiler:**
- Oyunu başlattığınızda siyah ekran
- Avatar seçimi görünmüyor
- Ekran donuyor

**Çözüm:**

1. Hot reload YERİNE tam yeniden başlatın:
   ```bash
   flutter run
   ```

2. Cache temizleyin:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. Tarayıcı/cihazı değiştirin:
   ```bash
   flutter run -d chrome   # Web için
   flutter run -d android  # Android için
   ```

---

### 3. 📝 Seçim Butonları Görünmüyor

**Belirtiler:**
- Hikaye metni var ama seçenekler yok
- "Ne yapmak istersiniz?" yazısı görünmüyor
- "Hikaye Sona Erdi" butonu var (olmaması gerekir)

**Çözüm:**

1. **Console loglarını kontrol edin:**
   ```bash
   flutter run -v
   ```

   Şunları arayın:
   - `AI Response:` - AI'dan yanıt geldi mi?
   - `Parsed - Choices: 3 adet` - 3 seçenek parse edildi mi?
   - `Uyarı: Sadece X seçenek bulundu!` - Parse sorunu

2. **API yanıtı hatalıysa:**
   - API key limitini aşmış olabilirsiniz
   - Yeni bir API key oluşturun
   - Birkaç dakika bekleyip tekrar deneyin

3. **Parse sorunu varsa:**
   - Uygulama en son versiyonda mı?
   - `git pull` yapın
   - `flutter pub get` çalıştırın

---

### 4. 💾 Kayıt/Yükleme Çalışmıyor

**Belirtiler:**
- "Hikaye kaydedildi!" mesajı gelmiyor
- Kayıtlı oyunlar listesi boş
- Yüklenen oyun hatalı

**Çözüm:**

1. Uygulama izinlerini kontrol edin (mobil)
2. Tarayıcı cookies/local storage temizleyin (web)
3. Uygulamayı yeniden başlatın
4. Farklı bir kayıt adı deneyin

---

### 5. 🔊 Ses Çalışmıyor

**Belirtiler:**
- Müzik veya ses efektleri duyulmuyor
- Ses butonları çalışmıyor

**Çözüm:**

1. **Ses dosyaları eklendi mi kontrol edin:**
   - `assets/sounds/` klasöründe MP3 dosyaları olmalı
   - Yoksa normal - ses opsiyoneldir

2. **Ses açık mı kontrol edin:**
   - AppBar'daki müzik ve ses butonlarına basın
   - Kapalıysa açık hale getirin

3. **Cihaz sesi açık mı:**
   - Cihazınızın ses seviyesini artırın
   - Sessiz modda değil mi kontrol edin

---

### 6. 📱 Uygulama Yavaş Çalışıyor

**Belirtiler:**
- Animasyonlar takılıyor
- Butonlara basınca geç tepki veriyor
- Hikaye yüklenmesi uzun sürüyor

**Çözüm:**

1. **Release modda çalıştırın:**
   ```bash
   flutter run --release
   ```

2. **Debug bilgileri kapamak:**
   - Debug banner'ı zaten kapalı
   - Print loglarını azaltın

3. **Cihaz performansı:**
   - Eski cihazlarda yavaş olabilir
   - Web'de Chrome kullanın (hızlıdır)

---

### 7. 🌐 Web'de Çalışmıyor

**Belirtiler:**
- Chrome'da hata veriyor
- Fetch hatası
- CORS hatası

**Çözüm:**

1. **CORS problemi için:**
   ```bash
   flutter run -d chrome --web-browser-flag "--disable-web-security"
   ```

2. **Cache temizle:**
   - Tarayıcı cache'ini temizleyin (CTRL+SHIFT+DEL)
   - Hard refresh yapın (CTRL+SHIFT+R)

3. **Farklı tarayıcı deneyin:**
   ```bash
   flutter run -d edge
   ```

---

## Debug Komutları

### Genel Durum Kontrolü
```bash
flutter doctor -v
```

### Bağlı Cihazları Göster
```bash
flutter devices
```

### Cache Temizle
```bash
flutter clean
rm -rf build/
```

### Paketleri Güncelle
```bash
flutter pub upgrade
```

### Verbose Log
```bash
flutter run -v
```

---

## Console'da Görebileceğiniz Mesajlar

### ✅ Normal Mesajlar:
```
AI Response: HIKAYE: ... SEÇENEK1: ...
Parsed - Story: ...
Parsed - Choices: 3 adet
```

### ⚠️ Uyarı Mesajları:
```
UYARI: .env dosyası yüklenemedi
Uyarı: Sadece 2 seçenek bulundu!
Müzik çalma hatası: ...
```

### ❌ Hata Mesajları:
```
API hatası: 400 - Invalid API key
Bağlantı hatası: SocketException
Hata: Null check operator used on null value
```

---

## Hata Mesajı Anlamları

| Hata | Anlam | Çözüm |
|------|-------|-------|
| `Invalid API key` | API key yanlış | .env dosyasını kontrol edin |
| `SocketException` | İnternet yok | Bağlantınızı kontrol edin |
| `Null check operator` | Veri eksik | Uygulamayı yeniden başlatın |
| `404` | API endpoint bulunamadı | Model adını kontrol edin |
| `429` | Çok fazla istek | Birkaç dakika bekleyin |

---

## Hala Çalışmıyor mu?

1. **Tüm adımları tekrar deneyin:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Flutter versiyonunu kontrol edin:**
   ```bash
   flutter --version
   # 3.0 veya üzeri olmalı
   ```

3. **Yeni bir API key oluşturun:**
   - Eski key'i silin
   - https://makersuite.google.com/app/apikey
   - Yeni key oluşturun
   - .env'e ekleyin

4. **GitHub Issues'da sorun bildirin:**
   - Console loglarını ekleyin
   - Flutter versiyonunuzu belirtin
   - Hangi platformda çalıştırdığınızı yazın

---

## Performans İyileştirme

### Daha Hızlı Yanıt için:
- `gemini-2.0-flash-exp` modelini kullanın (varsayılan)
- `maxOutputTokens` değerini düşürün (500'e)
- `temperature` değerini azaltın (0.7'ye)

### Daha İyi Animasyonlar için:
- Release modda çalıştırın
- Gereksiz widget rebuild'leri azaltın
- Profile modda test edin: `flutter run --profile`

---

## 🆘 Acil Yardım

Hiçbir şey işe yaramadıysa:

1. Projeyi yeniden klonlayın
2. Flutter'ı güncelleyin: `flutter upgrade`
3. Tüm bağımlılıkları silin: `rm pubspec.lock`
4. Tekrar yükleyin: `flutter pub get`
5. Temiz başlat: `flutter run`

---

**Unutmayın**: En yaygın sorun API key'in doğru girilmemesidir. İlk olarak bunu kontrol edin!
