import requests
from bs4 import BeautifulSoup
from datetime import datetime, timezone
import time
import random
from fake_useragent import UserAgent
import urllib.parse

INSTANCES = [
    "https://nitter.poast.org",
    "https://nitter.perennialte.ch",
    "https://nitter.1d4.us",
    "https://nitter.privacydev.net",
    "https://nitter.unixfox.eu"
]

ua = UserAgent()
API_KEY = "4G45705TRGVFDSERFSDVCRGVFDGBFVCCWPIN3N3YMC55HN5222VHL3A3ZJQVEF5WGX81"

def time_ago(date_str):
    try:
        if "·" in date_str:
            dt = datetime.strptime(date_str, "%b %d, %Y · %I:%M %p UTC")
            dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
        now = datetime.now(timezone.utc)
        delta = now - dt
        if delta.days >= 30: return f"{delta.days // 30} months ago"
        if delta.days > 0: return f"{delta.days} days ago"
        if delta.seconds >= 7200: return f"{delta.seconds // 3600} hours ago"
        if delta.seconds >= 3600: return "1 hour ago"
        if delta.seconds >= 120: return f"{delta.seconds // 60} minutes ago"
        return "just now"
    except:
        return "unknown"

def get_hiring_tweets(limit=10):
    query = '(hiring OR hire OR needed OR seeking) (designer OR developer OR dev OR "full stack" OR UI OR UX) lang:en -is:retweet since:2025-11-01'
    encoded = urllib.parse.quote(query)

    random.shuffle(INSTANCES)

    for base in INSTANCES:
        url = f"{base}/search?f=tweets&q={encoded}"
        headers = {
            "User-Agent": ua.random,
            "Accept": "text/html,application/xhtml+xml",
            "Accept-Language": "en-US,en;q=0.9",
            "Referer": "https://google.com/",
            "Connection": "keep-alive"
        }

        print(f"[{datetime.now().strftime('%H:%M:%S')}] Trying {base.split('//')[1]}...")

        try:
            session = requests.Session()
            session.headers.update(headers)
            r = session.get(url, timeout=20)
            
            if r.status_code != 200:
                print(f"→ Failed ({r.status_code})")
                continue

            soup = BeautifulSoup(r.text, 'lxml')
            items = soup.find_all('div', class_='timeline-item')
            
            if not items:
                print("→ No tweets found on this instance")
                continue

            tweets = []
            for item in items[:limit]:
                try:
                    user_tag = item.find('a', class_='username')
                    username = user_tag.text.strip() if user_tag else "unknown"
                    
                    text_tag = item.find('div', class_='tweet-content')
                    text = text_tag.text.strip() if text_tag else ""
                    
                    link_tag = item.find('a', class_='tweet-link')
                    if link_tag:
                        href = link_tag['href']
                        tweet_id = href.split('/')[-1].split('#')[0]
                        link = f"https://twitter.com{href.split('#')[0]}"
                    else:
                        tweet_id = link = "unknown"
                    
                    date_tag = item.find('span', class_='tweet-date')
                    date_str = date_tag.find('a')['title'] if date_tag and date_tag.find('a') else "unknown"
                    
                    if username != "unknown" and text:
                        tweets.append({
                            'user': username,
                            'text': text,
                            'link': link,
                            'created_at': date_str,
                            'id': tweet_id
                        })
                except Exception as e:
                    continue

            if tweets:
                print(f"SUCCESS! Got {len(tweets)} real hiring tweets from {base.split('//')[1]}")
                return tweets

        except Exception as e:
            print(f"→ Error: {str(e)[:50]}")
            continue

    print("All instances failed. Try again in 5 minutes.")
    return []

# === RUN IT ===
if __name__ == "__main__":
    tweets = get_hiring_tweets(limit=10)
    if tweets:
        print("\n" + "="*80)
        print("LATEST HIRING TWEETS (REAL LINKS + TIME AGO)")
        print("="*80)
        for i, t in enumerate(tweets, 1):
            print(f"{i}. {t['user']}")
            print(f"    {t['text'][:140]}")
            print(f"    Link: {t['link']}")
            print(f"    Posted: {time_ago(t['created_at'])}\n")
    else:
        print("No tweets found.")