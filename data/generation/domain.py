CHANNEL_PROFILES = {
    "Programmatic": {
        "ctr": (0.001, 0.004),
        "cvr": (0.001, 0.005),
        "cpc": (0.2, 1.0),
        "impressions": (50_000, 200_000),
        "sources": ["Amazon Ad Server", "StackAdapt"]
    },
    "Paid Search": {
        "ctr": (0.02, 0.05),
        "cvr": (0.05, 0.15),
        "cpc": (2.0, 6.0),
        "impressions": (2_000, 10_000),
        "sources": ["Google Ads", "Bing Ads", "Yahoo Ads"]
    },
    "Paid Social": {
        "ctr": (0.008, 0.02),
        "cvr": (0.005, 0.02),
        "cpc": (0.5, 2.0),
        "impressions": (10_000, 50_000),
        "sources": ["Facebook Ads", "Instagram Ads", "Twitter Ads"]
    },
    "Organic": {
        "ctr": (0.05, 0.15),
        "cvr": (0.1, 0.25),
        "cpc": (0.0, 0.2),
        "impressions": (500, 3_000),
        "sources": ["Google"]
    }
}
