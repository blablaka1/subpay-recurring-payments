# REST API и интеграция PSP

Base path merchant API: `/api/v1`.

## Merchant API

| Метод | URI | Назначение |
|---|---|---|
| POST | `/customers/{customerId}/payment-methods` | Сохранить provider token. |
| POST | `/subscriptions` | Создать подписку. Требует `Idempotency-Key`. |
| GET | `/subscriptions/{subscriptionId}` | Получить подписку. |
| POST | `/subscriptions/{subscriptionId}/pause` | Пауза. |
| POST | `/subscriptions/{subscriptionId}/resume` | Возобновление. |
| POST | `/subscriptions/{subscriptionId}/cancel` | Отмена. |
| GET | `/subscriptions/{subscriptionId}/payments` | Платежи подписки. |

## Provider integration

Учебный outbound-контракт:

`POST /provider/payments`

```json
{
  "amount_minor": 199000,
  "currency": "RUB",
  "payment_method_token": "pm_tok_***",
  "idempotency_key": "attempt:<uuid>"
}
```

Ожидаемый ответ может быть `PENDING`, `SUCCEEDED` или `FAILED`.

## Webhook

`POST /webhooks/psp`

Минимальные поля события:

- `event_id`;
- `event_type`;
- `provider_payment_id`;
- `status`;
- `failure_category` при ошибке;
- timestamp.

Перед обработкой проверяется подпись из заголовка `X-Provider-Signature`.
