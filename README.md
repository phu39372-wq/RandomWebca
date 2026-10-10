# Random Webcam (iOS)

Приложение показывает случайную публичную веб-камеру из официальной базы
[Windy Webcams API](https://api.windy.com/webcams/docs) (~65 000 камер,
владельцы которых согласились на публикацию через сервис Windy).

## 1. Получите бесплатный API-ключ

1. Зарегистрируйтесь на https://api.windy.com/keys
2. Создайте ключ для "Webcams API"
3. Скопируйте его — он понадобится на следующих шагах

## 2. Локальная сборка в Xcode (самый простой путь)

1. Установите Xcode (из App Store, бесплатно, нужен Mac)
2. Откройте `RandomWebcam.xcodeproj`
3. Откройте файл `Config.xcconfig` в корне проекта и вставьте ключ:
   ```
   WINDY_API_KEY = ваш_ключ_сюда
   ```
4. Подключите свой Apple ID: Xcode → Settings → Accounts → добавить Apple ID
   (подходит и бесплатный личный Apple ID, не обязательно платный Developer-аккаунт)
5. В настройках таргета (RandomWebcam → Signing & Capabilities) выберите
   свою команду (Team) — Xcode сам создаст бесплатный сертификат разработки
6. Подключите iPhone по кабелю, выберите его как устройство сборки (вверху окна)
7. Нажмите ▶️ (Run) — приложение соберётся и установится на телефон

   **Важно:** с бесплатным Apple ID приложение будет работать 7 дней,
   затем нужно пересобрать (Developer-аккаунт за $99/год убирает это ограничение).

## 3. Сборка через GitHub Actions + установка через Sideloadly (без Mac)

В репозитории уже есть workflow `.github/workflows/build.yml`, который
собирает **неподписанный .ipa** для реального устройства. Подпись добавляется
локально на вашем компьютере программой Sideloadly вашим бесплатным Apple ID.

1. Залейте этот проект к себе на GitHub:
   ```bash
   cd RandomWebcam
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/ВАШ_ЮЗЕРНЕЙМ/RandomWebcam.git
   git push -u origin main
   ```
2. В репозитории: Settings → Secrets and variables → Actions →
   New repository secret:
   - Name: `WINDY_API_KEY`
   - Value: ваш ключ с api.windy.com/keys
3. Вкладка Actions → выберите workflow → Run workflow (или просто подождите
   после push — сборка запустится сама, займёт 4–6 минут)
4. Когда появится зелёная галочка: откройте запуск → прокрутите вниз до
   Artifacts → скачайте `RandomWebcam-ipa` → распакуйте, внутри `RandomWebcam.ipa`

### Установка на iPhone через Sideloadly

1. Скачайте и установите [Sideloadly](https://sideloadly.io/) (Windows/Mac)
2. Подключите iPhone кабелем, разблокируйте его
3. Перетащите `RandomWebcam.ipa` на иконку IPA в окне Sideloadly
4. Выберите свой Apple ID (бесплатный подходит), нажмите Start, введите пароль
5. На iPhone: Настройки → Основные → VPN и управление устройством →
   выберите свой Apple ID → Довериться
6. Если попросит режим разработчика: Настройки → Конфиденциальность и
   безопасность → Режим разработчика → включить → перезагрузить → подтвердить

**Ограничение бесплатного Apple ID:** приложение будет работать 7 дней,
затем нужно будет пересобрать и переустановить тем же способом (Sideloadly
умеет делать это в один клик повторно). Платный Developer-аккаунт ($99/год)
убирает это ограничение.

## Структура проекта

```
RandomWebcam/
├── RandomWebcam.xcodeproj/     # проект Xcode
├── RandomWebcam/
│   ├── RandomWebcamApp.swift   # точка входа
│   ├── RandomCamView.swift     # экран UI
│   ├── WebcamAPI.swift         # клиент Windy Webcams API
│   ├── WebcamViewModel.swift   # логика загрузки + ретраи
│   ├── Assets.xcassets/
│   └── Info.plist
├── Config.xcconfig             # сюда вставляется API-ключ (не коммитьте с реальным ключом!)
└── .github/workflows/build.yml # CI-сборка
```
