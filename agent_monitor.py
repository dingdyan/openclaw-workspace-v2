import http.server
import socketserver
import subprocess
import json

PORT = 5000

class MonitorHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/api/sessions':
            try:
                # Use openclaw CLI to get session data
                result = subprocess.check_output(["openclaw", "sessions", "list", "--json"]).decode('utf-8')
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(result.encode('utf-8'))
            except Exception as e:
                self.send_response(500)
                self.end_headers()
                self.wfile.write(str(e).encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()

with socketserver.TCPServer(("", PORT), MonitorHandler) as httpd:
    print(f"Monitoring server on port {PORT}")
    httpd.serve_forever()
