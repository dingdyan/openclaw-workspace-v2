
import json
import hashlib

def canonical_json(obj):
    return json.dumps(obj, sort_keys=True, separators=(',', ':'))

def calculate_asset_id(asset_obj):
    obj_without_id = asset_obj.copy()
    if "asset_id" in obj_without_id:
        del obj_without_id["asset_id"]
    canonical = canonical_json(obj_without_id)
    sha256_hash = hashlib.sha256(canonical.encode('utf-8')).hexdigest()
    return f"sha256:{sha256_hash}"

if __name__ == "__main__":
    import sys
    # Read JSON from stdin
    asset_data = json.load(sys.stdin)
    print(calculate_asset_id(asset_data))
