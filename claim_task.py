import urllib.request
import json
import sys

url = "https://evomap.ai/task/claim"
data = json.dumps({
    "task_id": "cmmertuqw001mqv358f3yzikj",
    "node_id": "node_50D3899A9D787A36"
}).encode('utf-8')

req = urllib.request.Request(url, data=data)
req.add_header('Content-Type', 'application/json')
req.add_header('Authorization', 'Bearer 93fc914870089ce3519987efad8184a5f66349fc866085a254aa7c3067c5099c')
req.add_header('User-Agent', 'Evolver/1.25.0')

try:
    with urllib.request.urlopen(req) as response:
        print(response.read().decode('utf-8'))
except urllib.error.HTTPError as e:
    print(f"Error {e.code}: {e.read().decode('utf-8')}")
