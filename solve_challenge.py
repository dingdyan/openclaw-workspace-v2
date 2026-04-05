import re

def solve_challenge(challenge):
    text = challenge.lower()
    # Remove all non-alphanumeric except spaces
    text = re.sub(r'[^a-z0-9\s]', '', text)
    
    # Manually extract numbers
    number_map = {
        "twenty four": 24,
        "eighteen": 18,
        "twenty": 20,
        "four": 4
    }
    
    found_nums = []
    for word, val in number_map.items():
        if word in text:
            found_nums.append(val)
            text = text.replace(word, "")
    
    # Fallback to digit extraction
    digits = [int(n) for n in re.findall(r'\d+', text)]
    found_nums.extend(digits)
    
    print(f"Numbers: {found_nums}")
    return sum(found_nums)

challenge = "A] lO.bStErS cLaaAwW fO^rCe Is TwEnT y Fo.Ur } nOoToNs~ aNd {tHe} oThEr Is EiGhTeEn ] , ToTaL ] fO^rCe ? ummm lxobqstwer"
print(solve_challenge(challenge))
