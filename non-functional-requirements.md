# Нефункциональные требования

| ID | Требование |
|---|---|
| NFR-001 | API доступно только по HTTPS. |
| NFR-002 | API merchant авторизуется сервисным access token; каждый ресурс проверяется на принадлежность merchant. |
| NFR-003 | SubPay не принимает и не логирует PAN/CVV. |
| NFR-004 | Подпись webhook проверяется до разбора бизнес-содержимого события. |
| NFR-005 | Повтор webhook с тем же `provider_event_id` должен быть безопасным. |
| NFR-006 | Timeout вызова PSP — 5 секунд; сетевой timeout не считается подтверждённым отказом платежа и требует безопасного повторного запроса с тем же idempotency key. |
| NFR-007 | 95-й перцентиль обычных GET/POST API (без ожидания PSP) — до 500 мс при штатной нагрузке. |
| NFR-008 | В логах должны быть `request_id`, `merchant_id`, `subscription_id`, `payment_id`, `attempt_id`, но не секреты и provider token целиком. |
| NFR-009 | Webhook endpoint должен иметь rate limiting и ограничение размера body. |
| NFR-010 | Ошибки внешнего API возвращаются в `application/problem+json`. |
