# Acceptance cases

| ID | Сценарий | Ожидаемый результат |
|---|---|---|
| TC-SUB-001 | Создание MONTHLY подписки 1 990 ₽ | `ACTIVE`, `next_charge_at` заполнен. |
| TC-SUB-002 | Сумма 99 ₽ | 400/бизнес-валидация, подписка не создаётся. |
| TC-SUB-003 | Повтор POST с тем же Idempotency-Key | Вторая подписка не создаётся. |
| TC-BIL-001 | Два scheduler одновременно берут один период | Ровно один Payment благодаря unique key. |
| TC-BIL-002 | PSP возвращает PENDING, затем success webhook | Payment `SUCCEEDED`, next_charge_at перенесён. |
| TC-BIL-003 | Повтор success webhook | Изменения не дублируются; ответ 204. |
| TC-BIL-004 | Невалидная подпись webhook | Событие не влияет на Payment. |
| TC-BIL-005 | Timeout outbound запроса | Не создаётся новая business Attempt; повтор идёт с тем же provider idempotency key. |
| TC-BIL-006 | Temporary failure #1 | Payment остаётся `PROCESSING`, назначен retry +24h. |
| TC-BIL-007 | Три temporary failures | Payment `FAILED`, Subscription `PAST_DUE`. |
| TC-BIL-008 | Permanent failure первой попытки | Без retry; Payment `FAILED`, Subscription `PAST_DUE`. |
| TC-SUB-004 | CANCELED subscription наступила по времени | Новый Payment не создаётся. |
| TC-SEC-001 | Merchant запрашивает чужую subscription | Ресурс не раскрывается. |
