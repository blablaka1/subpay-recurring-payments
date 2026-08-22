-- Подписки, которые пора списывать
SELECT subscription_id
FROM subscription
WHERE status = 'ACTIVE'
  AND next_charge_at <= now()
ORDER BY next_charge_at
FOR UPDATE SKIP LOCKED
LIMIT 100;

-- Количество attempts по payment
SELECT payment_id, COUNT(*) AS attempts
FROM payment_attempt
WHERE payment_id = :payment_id
GROUP BY payment_id;

-- Необработанные webhook
SELECT *
FROM webhook_event
WHERE processing_status = 'RECEIVED'
ORDER BY received_at;
