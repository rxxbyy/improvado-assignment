CREATE OR REPLACE FUNCTION get_source_performance(
  p_from date,
  p_to date
)
RETURNS TABLE (
  source text,
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
      (p_to - p_from + 1) as days
  ),

  -- current period
  current_period AS (
    SELECT
      source,
      SUM(impressions) as impressions,
      SUM(clicks) as clicks
    FROM campaign_metrics, params
    WHERE date BETWEEN params.cur_from AND params.cur_to
    GROUP BY source
  ),

  -- previous period
  previous_period AS (
    SELECT
      source,
      SUM(impressions) as impressions,
      SUM(clicks) as clicks
    FROM campaign_metrics, params
    WHERE date BETWEEN
      (params.cur_from - params.days)
      AND
      (params.cur_from - 1)
    GROUP BY source
  )

  SELECT 
    c.source,
    c.impressions,

    -- delta impressions percentage
    (c.impressions - p.impressions)::numeric
      / NULLIF(p.impressions, 0) as impressions_delta_pct,
    
    -- current ctr
    c.clicks::numeric / NULLIF(c.impressions, 0) as ctr,

    -- delta ctr percentage
    (
      ( c.clicks::numeric / NULLIF(c.impressions, 0) ) 
      - ( p.clicks::numeric / NULLIF(p.impressions, 0) )
    )
    /
    (
      NULLIF(p.clicks::numeric / NULLIF(p.impressions, 0), 0)
    ) AS ctr_delta_pct
  FROM current_period c
  LEFT JOIN previous_period p
    ON c.source = p.source
  ORDER BY c.impressions DESC;
$$;

-- Note: percentages on deltas are calculated using
-- (CURRENT_VALUE - PREVIOUS_VALUE) / PREVIOUS VALUE
-- On the Front-End we make a normalization of the percentages using
-- v *= 100