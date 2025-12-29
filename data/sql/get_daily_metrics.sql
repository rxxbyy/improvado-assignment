CREATE OR REPLACE FUNCTION get_daily_metrics(
  p_from date,
  p_to date
)
RETURNS TABLE (
  date date,
  impressions bigint,
  clicks bigint,
  conversions bigint,
  spend numeric,
  ctr numeric,
  cvr numeric,
  cpc numeric,
  cpa numeric,
  cpm numeric
)
LANGUAGE SQL
STABLE
AS $$
  SELECT
    date,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    SUM(cost) AS spend,

    -- Rates & efficiency metrics
    SUM(clicks)::numeric / NULLIF(SUM(impressions), 0) AS ctr,
    SUM(conversions)::numeric / NULLIF(SUM(clicks), 0) AS cvr,
    SUM(cost) / NULLIF(SUM(clicks), 0) AS cpc,
    SUM(cost) / NULLIF(SUM(conversions), 0) AS cpa,
    (SUM(cost) / NULLIF(SUM(impressions), 0)) * 1000 AS cpm

  FROM campaign_metrics
  WHERE date BETWEEN p_from AND p_to
  GROUP BY date
  ORDER BY date;
$$;
