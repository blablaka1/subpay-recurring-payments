CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE merchant (
    merchant_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(120) NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','BLOCKED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE customer (
    customer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES merchant(merchant_id),
    external_customer_id VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (merchant_id, external_customer_id)
);

CREATE TABLE payment_method (
    payment_method_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customer(customer_id),
    provider_token VARCHAR(255) NOT NULL,
    masked_label VARCHAR(64),
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','DISABLED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE subscription (
    subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES merchant(merchant_id),
    customer_id UUID NOT NULL REFERENCES customer(customer_id),
    payment_method_id UUID NOT NULL REFERENCES payment_method(payment_method_id),
    amount_minor BIGINT NOT NULL CHECK (amount_minor BETWEEN 10000 AND 10000000),
    currency CHAR(3) NOT NULL DEFAULT 'RUB' CHECK (currency='RUB'),
    interval_code VARCHAR(16) NOT NULL DEFAULT 'MONTHLY' CHECK (interval_code='MONTHLY'),
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE','PAUSED','PAST_DUE','CANCELED')),
    next_charge_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_subscription_due ON subscription(status, next_charge_at);

CREATE TABLE payment (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID NOT NULL REFERENCES subscription(subscription_id),
    billing_period_start DATE NOT NULL,
    amount_minor BIGINT NOT NULL CHECK (amount_minor > 0),
    currency CHAR(3) NOT NULL DEFAULT 'RUB' CHECK (currency='RUB'),
    status VARCHAR(16) NOT NULL CHECK (status IN ('CREATED','PROCESSING','SUCCEEDED','FAILED')),
    failure_category VARCHAR(32),
    next_retry_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ,
    UNIQUE (subscription_id, billing_period_start)
);

CREATE TABLE payment_attempt (
    attempt_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID NOT NULL REFERENCES payment(payment_id),
    attempt_no SMALLINT NOT NULL CHECK (attempt_no BETWEEN 1 AND 3),
    provider_idempotency_key VARCHAR(120) NOT NULL UNIQUE,
    provider_payment_id VARCHAR(120),
    status VARCHAR(16) NOT NULL CHECK (status IN ('CREATED','SENT','PENDING','SUCCEEDED','FAILED')),
    failure_category VARCHAR(32),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (payment_id, attempt_no)
);

CREATE TABLE webhook_event (
    webhook_event_id BIGSERIAL PRIMARY KEY,
    provider_event_id VARCHAR(150) NOT NULL UNIQUE,
    event_type VARCHAR(80) NOT NULL,
    provider_payment_id VARCHAR(120),
    received_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    processed_at TIMESTAMPTZ,
    processing_status VARCHAR(16) NOT NULL DEFAULT 'RECEIVED'
        CHECK (processing_status IN ('RECEIVED','PROCESSED','REJECTED'))
);

CREATE TABLE api_idempotency (
    idempotency_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES merchant(merchant_id),
    idempotency_key VARCHAR(100) NOT NULL,
    request_hash CHAR(64) NOT NULL,
    resource_type VARCHAR(32) NOT NULL,
    resource_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (merchant_id, idempotency_key)
);
