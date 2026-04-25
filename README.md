# Whisper UI

Веб-интерфейс для транскрибации аудио через Whisper и анализа разговоров через LLM.

## Что делает

### Вкладка 1 — Транскрибация
- Загрузка нескольких аудио/видео файлов
- Две модели: **small** (качество) и **base** (быстро, ~6x)
- Языки: русский, английский, украинский, авто
- Форматы: TXT, SRT, VTT
- Прогресс-бар с оценкой оставшегося времени
- Автосохранение в папку проекта (File System Access API, работает в Chrome/Edge по HTTPS)
- Автосоздание `prompt.txt` в папке проекта

### Вкладка 2 — Анализ и чат
- **Сценарий проверки**: текст / PDF (через PDF.js) / фото (через Tesseract OCR)
- **Анализ через LLM**: OpenRouter (Qwen, Llama, Gemini и др.) или DeepSeek API
- **4 шаблона промптов**: свободный отчёт, таблица, тональность, критические нарушения
- **Чат** для уточняющих вопросов после анализа
- Сохранение чата и анализа в папку проекта
- Кастомный ввод любой модели через OpenRouter

## Стек

| Компонент | Что |
|-----------|-----|
| `whisper` | `onerahmet/openai-whisper-asr-webservice`, модель small, порт 9000 |
| `whisper-fast` | то же, модель base, порт 9001 |
| `whisper-ui` | `nginx:alpine`, HTTPS 8443, раздаёт UI и проксирует `/asr` |
| LLM | OpenRouter API или DeepSeek API (ключи хранятся в `localStorage`) |

## Быстрый старт

```bash
git clone https://github.com/Andreyhiitola/whisper-ui.git
cd whisper-ui
Полная инструкция по установке — в SETUP.md.

Деплой изменений
bash
./deploy.sh "описание изменений"
deploy.sh — локальный файл (не в git). Коммитит, пушит на GitHub, по SSH обновляет файлы на сервере и перезапускает контейнер.

Адреса
Сервис	URL
UI	https://192.168.1.73:8443
Whisper API (small)	http://192.168.1.73:9000
Whisper API (base)	http://192.168.1.73:9001
API ключи
Вводятся в интерфейсе (⚙️ Настройки API), хранятся в localStorage браузера. Дефолтные значения можно прописать в html/config.json.

Провайдер	Где получить	Примерная цена
OpenRouter	openrouter.ai/keys	от $0.03/1M токенов (Qwen 7B)
DeepSeek	platform.deepseek.com	~$0.27/1M токенов
Рекомендуемые бесплатные модели (OpenRouter)
meta-llama/llama-3.1-8b-instruct:free

google/gemma-3-27b-it:free

Рекомендуемые платные модели (OpenRouter)
qwen/qwen-2.5-7b-instruct — самый дешёвый, хороший русский

qwen/qwen-2.5-32b-instruct — оптимальный по цене/качеству

qwen/qwen-2.5-72b-instruct — максимальное качество

google/gemini-2.5-flash-lite — быстро и недорого

🔧 Как управлять списком моделей
Модели настраиваются в html/index.html.

Добавить/убрать модель
Найди <select id="qwen-model-select"> (для OpenRouter) или <select id="deepseek-model-select"> (для DeepSeek):

html
<select id="qwen-model-select" onchange="onModelSelectChange('qwen')">
  <option value="ID_модели">Название</option>
  <option value="__custom__">🔧 Другая модель (ввести)...</option>
</select>
Добавить — добавь новую строку <option> с ID модели из OpenRouter Models

Убрать — удали строку <option>

Сменить по умолчанию — измени значение в трёх местах:

loadConfigFromServer() → qwen_model: config.qwen_model || 'новая_модель'

loadSettings() → setModelFromSaved('qwen', ... || 'новая_модель')

html/config.json на сервере → "qwen_model": "новая_модель"

Кастомная модель
Выбери 🔧 Другая модель (ввести)... → введи любой ID модели OpenRouter вручную. Сохраняется в localStorage.

Файлы
text
whisper-ui/
├── html/
│   ├── index.html      # основной интерфейс
│   └── config.json     # дефолтные настройки API
├── nginx/
│   └── default.conf    # конфиг nginx
├── SETUP.md            # полная инструкция по установке
└── README.md
