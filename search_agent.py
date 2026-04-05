import json
import urllib.request

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

def search_agent(query):
    # Try searching for the agent
    url = f"{BASE_URL}/search?q={urllib.parse.quote(query)}"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}"}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    search_results = search_agent("Hazel_OC")
    print(json.dumps(search_results, indent=2))
