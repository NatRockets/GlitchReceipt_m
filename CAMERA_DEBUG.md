# Отладка камеры QR сканнера

## Проблема
При нажатии "Start Scanning" проигрывается звук, но камера не открывается.

## Возможные причины

### 1. **Разрешение уже было отклонено постоянно**
**Решение:**
- Перейти в Settings → Glitch Receipt → Camera
- Убедиться что разрешение установлено в "Allow"
- Вернуться в приложение и попробовать снова

### 2. **Проблема с инициализацией камеры**
**Решение:**
- Закрыть приложение полностью
- Перезагрузить девайс
- Открыть приложение и попробовать снова

### 3. **Проверка логов**
Для отладки:

```bash
# Запустить приложение с логами
flutter run -v

# В XCode (если используется):
# Product → Scheme → Edit Scheme
# Run → Arguments
# Добавить: -com.apple.CoreMediaIO.VolumeLogging 1
```

## Ожидаемые логи при успешном сканировании

```
[QR Scanner] _startScanning called, mounted: true
[QR Scanner] Feedback played
[QR Scanner] Checking camera permission...
[QR Scanner] Camera permission status: PermissionStatus.granted
[QR Scanner] Final permission granted: true
[QR Scanner] Starting camera controller...
[QR Scanner] Camera controller started
[QR Scanner] Delay completed
[QR Scanner] Setting _isScanning = true
[QR Scanner] build() called, _isScanning: true
[QR Scanner] Barcode detected: 1 codes found
[QR Scanner] QR code value: 100.50
[QR Scanner] Valid amount detected: 100.50
```

## Логи при проблеме с разрешением

```
[QR Scanner] _startScanning called, mounted: true
[QR Scanner] Checking camera permission...
[QR Scanner] Camera permission status: PermissionStatus.denied
[QR Scanner] Permission denied, requesting...
[QR Scanner] Permission request result: PermissionStatus.denied
[QR Scanner] Final permission granted: false
```

Если видите это - нужно принять разрешение в системном диалоге iOS

## Логи при постоянном отказе

```
[QR Scanner] Final permission granted: false
[QR Scanner] Final status check: PermissionStatus.permanentlyDenied
[QR Scanner] isDenied: false, isPermanentlyDenied: true
[QR Scanner] Permission permanently denied, showing settings dialog
```

Если видите это - нужно включить разрешение в Settings

## Что было добавлено для отладки

### 1. Логирование в критических точках:
- Инициализация контроллера
- Запрос разрешений
- Запуск/остановка камеры
- Обнаружение QR кодов
- Состояние UI (_isScanning)

### 2. Улучшенные диалоги ошибок:
- Показывают детальное описание ошибки
- Содержат код ошибки
- Предлагают явное действие (Settings, OK и т.д.)

### 3. Защита от множественного срабатывания:
- Флаг `_isProcessingQR` предотвращает обработку нескольких кодов одновременно
- Задержка 300мс перед возобновлением сканирования

### 4. Обработка состояний:
- Проверка `mounted` перед setState
- Корректная остановка/запуск контроллера
- Правильная инициализация в initState

## Тестирование QR кодов

### Генератор QR кодов:
1. Перейти на https://www.qr-code-generator.com/
2. Выбрать "Text"
3. Ввести число (например: 100.50)
4. Сгенерировать и распечатать/отобразить

### Формат сумм:
- ✅ `100.50`
- ✅ `100,50`
- ✅ `50`
- ❌ `abc` (невалидная сумма)
- ❌ `` (пустое значение)
- ❌ `0` (сумма должна быть > 0)

## Если проблема не решена

1. Проверить что Info.plist содержит:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs access to your camera to scan QR codes</string>
   ```

2. В Xcode: Product → Clean Build Folder

3. Пересобрать:
   ```bash
   flutter clean
   flutter pub get
   flutter run -v
   ```

4. Проверить что на девайсе iOS 13.0+

5. Убедиться что используется реальный девайс (симулятор может иметь проблемы с камерой)
