# Marketing Analytics Dashboard
## Improvado Assignment

The project is primarily focused on data generation, ensuring the coherence
of marketing data, and using SQL to manipulate it and extract insights, 
rather than on UI complexity.

## Tech Stack

- **Frontend**
  - Astro
  - Astro Server Islands
  - React (for data tables and charts)
  - MUI DataGrid

- **Backend**
  - Supabase
  - PostgreSQL
  - SQL RPC functions

## Data Model Overview

The core table is `campaign_metrics`, which stores **daily campaign-level marketing data** across multiple dimensions:

**Dimensions**

- Date
- Channel (Programmatic, Paid Search, Paid Social, Organic)
- Source (Google Ads, Facebook Ads, LinkedIn Ads, Amazon Ad Server, etc.)
- Campaign

**Metrics**

- Impressions
- Clicks
- Conversions
- Spend

All higher-level metrics (CTR, CPC, CPM, CVR, CPA) are **derived**, not stored.

## Data generation
Dummy data is generated using the `data/generation/domain.py` file, which specifies metric behavior by profile.

On `data/generation/generate.py`, we use `python-faker` to generate fake campaign names and titles. 
Python’s `random` module is then used to create uniformly distributed data within the predefined ranges.
This script will generate 100,000 rows of fake marketing data which then are stored in a `.csv` file
using Python's `pandas` module.

### Channel Performance Profiles

To generate realistic dummy data, each marketing channel is assigned a performance profile.
These profiles define **expected metric ranges** and **available data sources** per channel.

#### Programmatic
- **CTR:** 0.1% – 0.4%
- **CVR:** 0.1% – 0.5%
- **CPC:** $0.20 – $1.00
- **Daily Impressions:** 50,000 – 200,000
- **Sources:** Amazon Ad Server, StackAdapt

#### Paid Search
- **CTR:** 2% – 5%
- **CVR:** 5% – 15%
- **CPC:** $2.00 – $6.00
- **Daily Impressions:** 2,000 – 10,000
- **Sources:** Google Ads, Bing Ads, Yahoo Ads

#### Paid Social
- **CTR:** 0.8% – 2%
- **CVR:** 0.5% – 2%
- **CPC:** $0.50 – $2.00
- **Daily Impressions:** 10,000 – 50,000
- **Sources:** Facebook Ads, Instagram Ads, Twitter Ads

#### Organic
- **CTR:** 5% – 15%
- **CVR:** 10% – 25%
- **CPC:** $0.00 – $0.20
- **Daily Impressions:** 500 – 3,000
- **Sources:** Google

### Dataset
The dataset generated and used for this dashboard can be found on: `data/generation/data.csv`.

## SQL queries as functions
All the SQL queries are stored in Supabase as functions which are called by the Front-End using RPC.

The schema and all SQL queries used are in the `data/sql/` directory.

### Metric Definitions & Formulas

All marketing KPIs in this project are **derived metrics**, calculated from the base fields (`impressions`, `clicks`, `conversions`, `spend`).
No ratios are stored directly in the database to avoid aggregation errors.

#### Click-Through Rate (CTR)
```
CTR = clicks / impressions
```

#### Conversion Rate (CVR)
```
CVR = conversions / clicks
```

#### Cost Per Click (CPC)
```
CPC = spend / clicks
```

#### Cost Per Mille (CPM)
```
CPM = (spend / impressions) * 1000
```

#### Cost Per Acquisition (CPA)
```
CPA = spend / conversions
```

All rate-based metrics are returned as decimal values from SQL (e.g. 0.034 = 3.4%) and formatted as percentages at the frontend level.

### Assumptions & Limitations

This project intentionally makes several simplifying assumptions to keep the focus on
**data modeling, metric correctness, and SQL analytics**, rather than on simulation complexity.

The dashboard calculations are based on a static year period which can be changed on the code but there's
no additional functionality for this at frontend level to keep it simple.

## Live Dashboard
A live version of the dashboard can be accessed here:  
https://improvado-assignment.netlify.app/
