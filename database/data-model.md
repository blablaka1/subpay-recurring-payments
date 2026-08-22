# Модель данных

| Таблица | Назначение |
|---|---|
| `merchant` | Клиент B2B API. |
| `customer` | Клиент merchant. |
| `payment_method` | Токенизированный платёжный метод. |
| `subscription` | Настройки регулярного списания. |
| `payment` | Платёж одного расчётного периода. |
| `payment_attempt` | Одна бизнес-попытка оплаты через PSP. |
| `webhook_event` | Журнал уникальных событий PSP. |
| `api_idempotency` | Идемпотентность merchant-команд создания. |

## Важные ограничения

- `customer` уникален внутри merchant по внешнему `external_customer_id`;
- payment method принадлежит одному customer;
- один payment на `(subscription_id, billing_period_start)`;
- `provider_event_id` webhook уникален;
- `provider_idempotency_key` attempt уникален.
