CREATE OR REPLACE FUNCTION get_impressions_by_channel_month(
  p_from date,
  p_to date
)
RETURNS TABLE (
  month date,
  channel text,
  impressions bigint
)
LANGUAGE SQL
STABLE
AS $$
  SELECT
    date_trunc('month', date) as month,
    channel,
    SUM(impressions) as impressions
  FROM campaign_metrics
  WHERE date >= p_from AND date < p_to
  GROUP BY channel, month
  ORDER BY month ASC, channel ASC
$$;