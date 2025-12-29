CREATE OR REPLACE FUNCTION get_campaign_performance(
  p_from date,
  p_to date
)
RETURNS TABLE (
  campaign text,
  impressions bigint,
  impressions_delta_pct numeric,
  ctr numeric,
  ctr_delta_pct numeric
)
LANGUAGE SQL
STABLE
AS $$
WITH params AS (
  SELECT
    p_from AS cur_from,
    p_to AS cur_to,
    (p_to - p_from + 1) AS days
),

-- Current period aggregation
current_period AS (
  SELECT
    campaign,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks
  FROM campaign_metrics, params
  WHERE date BETWEEN params.cur_from AND params.cur_to
  GROUP BY campaign
),

-- Previous period aggregation
previous_period AS (
  SELECT
    campaign,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks
  FROM campaign_metrics, params
  WHERE date BETWEEN
    (params.cur_from - params.days)
    AND
    (params.cur_from - 1)
  GROUP BY campaign
)

SELECT
  c.campaign,
  c.impressions,

  -- % delta impressions
  (c.impressions - p.impressions)::numeric
    / NULLIF(p.impressions, 0) AS impressions_delta_pct,

  -- CTR (current period)
  c.clicks::numeric / NULLIF(c.impressions, 0) AS ctr,

  -- % delta CTR
  (
    (c.clicks::numeric / NULLIF(c.impressions, 0))
    -
    (p.clicks::numeric / NULLIF(p.impressions, 0))
  )
  /
  NULLIF(
    (p.clicks::numeric / NULLIF(p.impressions, 0)),
    0
  ) AS ctr_delta_pct

FROM current_period c
LEFT JOIN previous_period p
  ON c.campaign = p.campaign
ORDER BY c.impressions DESC;
$$;
