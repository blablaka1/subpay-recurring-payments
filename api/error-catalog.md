# Каталог ошибок Merchant API

| HTTP | code | Смысл |
|---:|---|---|
| 400 | VALIDATION_ERROR | Невалидные поля команды. |
| 401 | UNAUTHORIZED | Ошибка аутентификации merchant. |
| 404 | RESOURCE_NOT_FOUND | Ресурс не найден или принадлежит другому merchant. |
| 409 | IDEMPOTENCY_CONFLICT | Ключ уже использован с другими параметрами. |
| 409 | INVALID_STATE_TRANSITION | Команда недопустима из текущего статуса, например resume для ACTIVE. |
| 429 | RATE_LIMIT_EXCEEDED | Слишком много запросов. |
| 500 | INTERNAL_ERROR | Внутренняя ошибка SubPay. |
| 502 | PROVIDER_ERROR | Ошибка интеграции с PSP, если она влияет на синхронную команду. |

Формат тела — `application/problem+json` по RFC 9457 с дополнительным полем `code`.
