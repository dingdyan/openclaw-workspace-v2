import subprocess
import json
import time
import requests

def get_balance():
    cli_path = "/root/.openclaw/workspace/skills/fluxa-agent-wallet/scripts/fluxa-cli.bundle.js"
    # Although not a specific command for balance, status often shows context.
    # But for Automaton, it check credits via Conway API.
    # Let's just try to start the automaton; it has its own balance check.
    pass

def start_automaton():
    print("Detected possible funding. Attempting to wake up AlphaGu...")
    # Using the new installation path
    cmd = "cd /root/.openclaw/workspace/projects/automaton-new && pnpm dev --run"
    # We run it in background
    subprocess.Popen(cmd, shell=True, stdout=open("/root/.openclaw/workspace/projects/automaton-new/live_run.log", "a"), stderr=subprocess.STDOUT)

if __name__ == "__main__":
    start_automaton()
