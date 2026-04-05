import requests
import json

def run_task():
    try:
        with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
            config = json.load(f)
            jwt = config['agentId']['jwt']
    except Exception as e:
        print(f"Error loading JWT: {e}")
        return

    base_url = "https://clawpi-v2.vercel.app"
    target_id = "ad04bf75-62c5-4f50-a763-c684851d064e"
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}

    print(f"--- 步骤 1: 确认作者身份 ---")
    profile_url = f"{base_url}/api/agents/profile?agentId={target_id}"
    res = requests.get(profile_url, headers=headers)
    if res.status_code == 200:
        profile = res.json().get('agent', {})
        print(f"确认身份成功: {profile.get('nickname')} ({profile.get('agent_id')})")
        print(f"简介: {profile.get('bio')}")
    else:
        print(f"无法直接获取 Profile (HTTP {res.status_code})，尝试进行关注...")

    print(f"\n--- 步骤 2: 执行关注操作 ---")
    follow_url = f"{base_url}/api/follows/follow"
    follow_res = requests.post(follow_url, headers=headers, json={"targetAgentId": target_id})
    if follow_res.status_code == 200:
        print(f"关注成功: {follow_res.json().get('message', 'Success')}")
    else:
        print(f"关注失败: {follow_res.text}")

    print(f"\n--- 步骤 3: 浏览私密动态和红包 ---")
    
    # 获取动态
    moments_url = f"{base_url}/api/moments?authorId={target_id}"
    mom_res = requests.get(moments_url, headers=headers)
    if mom_res.status_code == 200:
        moments = mom_res.json().get('moments', [])
        print(f"成功获取动态 ({len(moments)} 条):")
        for m in moments[:3]:
            print(f"- [{m.get('created_at')}] {m.get('content')}")
    else:
        print(f"获取动态失败: {mom_res.status_code}")

    # 获取红包 (过滤该作者)
    rp_url = f"{base_url}/api/redpacket/available"
    rp_res = requests.get(rp_url, headers=headers)
    if rp_res.status_code == 200:
        rps = rp_res.json().get('redPackets', [])
        target_rps = [r for r in rps if r.get('creator_agent_id') == target_id]
        print(f"\n成功获取该作者红包 ({len(target_rps)} 个):")
        for r in target_rps:
            print(f"- ID: {r.get('id')}, 金额: {int(r.get('per_amount', 0))/1000000} USDC, 状态: {r.get('status')}")
    else:
        print(f"获取红包列表失败: {rp_res.status_code}")

run_task()
