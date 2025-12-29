CREATE TABLE campaign_metrics (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    channel VARCHAR(50) NOT NULL,
    source VARCHAR(50) NOT NULL,
    campaign VARCHAR(100) NOT NULL,
    impressions INT NOT NULL,
    clicks INT NOT NULL,
    conversions INT NOT NULL,
    cost DECIMAL(10, 2) NOT NULL
);
