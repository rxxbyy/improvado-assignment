from domain import CHANNEL_PROFILES
from faker import Faker
import pandas as pd
import random

fake = Faker()

def fake_campaign_name(channel: str) -> str:
    """ Generate a fake campaign name based on the channel """
    if channel == "Paid Search":
        return f"{fake.word().title()} Keywords"
    if channel == "Paid Social":
        return fake.catch_phrase()
    return fake.bs().title()

def generate_row_metrics_by_channel(channel: str) -> dict[str, float]:
    """ Generate fake metrics """
    impressions = random.randint(*CHANNEL_PROFILES[channel]['impressions'])
    ctr = random.uniform(*CHANNEL_PROFILES[channel]['ctr'])
    clicks = int(impressions * ctr)

    cvr = random.uniform(*CHANNEL_PROFILES[channel]['cvr'])
    conversions = int(clicks * cvr)

    cpc = random.uniform(*CHANNEL_PROFILES[channel]['cpc'])
    cost = round(clicks * cpc, 2)

    row = {
        "date": fake.date(),
        "channel": channel,
        "source": random.choice(CHANNEL_PROFILES[channel]['sources']),
        "campaign": fake_campaign_name(channel),
        "impressions": impressions,
        "clicks": clicks,
        "conversions": conversions,
        "cost": cost,
    }

    return row

def main() -> None:
    data = []
    for _ in range(100_000):
        data.append(generate_row_metrics_by_channel(random.choice(list(CHANNEL_PROFILES.keys()))))
    pd.DataFrame(data).to_csv("data.csv", index=False)

if __name__ == "__main__":
    main()
