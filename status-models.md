# Модели статусов

## Subscription

```text
ACTIVE <-> PAUSED
  |  \      |
  |   \     v
  |    -> CANCELED
  v
PAST_DUE -> ACTIVE   (после ручного/успешного восстановления)
PAST_DUE -> CANCELED
```

Статусы: `ACTIVE`, `PAUSED`, `PAST_DUE`, `CANCELED`.

## Payment

```text
CREATED -> PROCESSING -> SUCCEEDED
              |
              v
            FAILED
```

`FAILED` ставится только когда retry больше не разрешён или получен permanent failure.

## Attempt

Статусы: `CREATED`, `SENT`, `PENDING`, `SUCCEEDED`, `FAILED`.
