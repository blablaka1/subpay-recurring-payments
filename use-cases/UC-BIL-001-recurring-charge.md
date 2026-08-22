# UC-BIL-001. Плановое регулярное списание

## Цель
Выполнить очередной ежемесячный платёж по активной подписке.

## Основной актор
Планировщик SubPay (Scheduler).

## Смежная система
Внешний PSP.

## Предусловия

- Subscription = `ACTIVE`;
- `next_charge_at <= now()`;
- у подписки есть активный payment method token.

## Основной сценарий

1. Scheduler выбирает наступившую подписку.
2. Сервис пытается создать Payment для текущего расчётного периода.
3. Уникальное ограничение `(subscription_id, billing_period_start)` гарантирует, что второй scheduler не создаст дубликат.
4. Payment создаётся `CREATED`.
5. Создаётся Attempt №1 со стабильным `provider_idempotency_key`.
6. Payment переводится в `PROCESSING`.
7. SubPay отправляет PSP сумму, валюту, token и idempotency key.
8. PSP принимает запрос и возвращает provider payment id / `PENDING`.
9. Позже PSP отправляет подписанный webhook `payment.succeeded`.
10. SubPay проверяет подпись и уникальность `provider_event_id`.
11. Attempt и Payment получают `SUCCEEDED`.
12. SubPay рассчитывает новый `next_charge_at` и сохраняет его в Subscription.
13. Webhook endpoint возвращает 204.

## Альтернативные сценарии

### A1. Повтор scheduler
На шаге 3 вставка второго Payment конфликтует с unique key. Сервис читает существующий Payment и завершает обработку без нового списания.

### A2. Timeout при вызове PSP
На шаге 7 нет ответа. Состояние реального платежа неизвестно. SubPay не создаёт новую Attempt, а повторяет тот же provider request с тем же `provider_idempotency_key` либо запрашивает статус по provider payment id, если он известен.

### A3. Temporary failure
Webhook/ответ PSP содержит временную причину. Attempt = `FAILED`, Payment остаётся `PROCESSING`, создаётся `next_retry_at = now()+24h`. Если attempts < 3, будет новая Attempt.

### E1. Permanent failure
PSP сообщает постоянный отказ. Payment = `FAILED`, Subscription = `PAST_DUE`, retry не планируется.

### E2. Retry exhausted
После третьей неуспешной Attempt Payment = `FAILED`, Subscription = `PAST_DUE`.

### E3. Невалидная подпись webhook
Событие не обрабатывается, возвращается 401/400 согласно интеграционному контракту, факт ошибки логируется без секретов.

### A4. Повтор webhook
`provider_event_id` уже сохранён. Сервис возвращает 204 и не повторяет изменение состояния.
