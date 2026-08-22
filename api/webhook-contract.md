# Контракт webhook PSP

Endpoint: `POST /webhooks/psp`

Заголовки:

- `Content-Type: application/json`
- `X-Provider-Signature: <signature>`

Пример:

```json
{
  "event_id": "evt_100045",
  "event_type": "payment.succeeded",
  "created_at": "2026-08-22T12:30:00Z",
  "data": {
    "provider_payment_id": "pay_90001",
    "status": "SUCCEEDED",
    "failure_category": null
  }
}
```

## Обработка

1. Проверить размер body и подпись.
2. Попытаться сохранить `provider_event_id` с UNIQUE constraint.
3. Если событие уже было — вернуть `204`, не выполнять бизнес-изменения повторно.
4. Найти Attempt по `provider_payment_id`.
5. Проверить допустимость перехода статуса.
6. В одной локальной БД-транзакции обновить Attempt/Payment/Subscription.
7. Пометить событие `PROCESSED` и вернуть `204`.

Если событие относится к неизвестному provider payment, оно сохраняется как `REJECTED` для разбора и не создаёт новую подписку/платёж.
