# Матрица трассировки

| Правило / требование | API / интеграция | Данные | Диаграмма | Тест |
|---|---|---|---|---|
| BR-SUB-003 token only | payment-method API | `payment_method.provider_token` | Context | review/NFR |
| BR-SUB-005 один payment на период | internal scheduler | unique `(subscription_id,billing_period_start)` | Sequence | TC-BIL-001 |
| BR-SUB-006 PSP idempotency | outbound PSP | `provider_idempotency_key` | Sequence | TC-BIL-005 |
| BR-SUB-007 webhook idempotency | `/webhooks/psp` | unique `provider_event_id` | Sequence | TC-BIL-003,004 |
| BR-SUB-008 retries | internal billing | `attempt_no`, `next_retry_at` | BPMN/State | TC-BIL-006,007 |
| BR-SUB-009 permanent failure | webhook/outbound response | payment/subscription status | State | TC-BIL-008 |
| FR-SUB-005 cancel | POST cancel | `subscription.status` | State | TC-SUB-004 |
