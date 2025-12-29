CREATE OR REPLACE FUNCTION get_dashboard_summary(
  p_from date,
  p_to date
)
RETURNS TABLE (
  spend numeric,
  impressions bigint,
  clicks bigint,
  conversions bigint,
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
    SUM(cost),
    SUM(impressions),
    SUM(clicks),
    SUM(conversions),
    SUM(clicks)::numeric / NULLIF(SUM(impressions), 0),
    SUM(conversions)::numeric / NULLIF(SUM(clicks), 0),
    SUM(cost) / NULLIF(SUM(clicks), 0),
    SUM(cost) / NULLIF(SUM(conversions), 0),
    (SUM(cost) / NULLIF(SUM(impressions), 0)) * 1000
  FROM campaign_metrics
  WHERE date BETWEEN p_from AND p_to;
$$;
