import http.server
import socketserver
import json
import random

PORT = 5000

class DashboardHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/api/stats':
            data = {
                "sessions": [
                    {"key": "MAIN", "model": "gemini-pro", "totalTokens": 1200},
                    {"key": "WALL-C", "model": "gpt-4", "totalTokens": 450},
                    {"key": "WALL-E", "model": "llama-3", "totalTokens": 800},
                    {"key": "WALL-R", "model": "qwen-coder", "totalTokens": 600}
                ]
            }
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(data).encode('utf-8'))
        elif self.path == '/' or self.path == '/dashboard.html':
            self.path = 'dashboard.html'
            return http.server.SimpleHTTPRequestHandler.do_GET(self)
        else:
            self.send_response(404)
            self.end_headers()

with socketserver.TCPServer(("", PORT), DashboardHandler) as httpd:
    print(f"Dashboard running at http://localhost:{PORT}/")
    httpd.serve_forever()
