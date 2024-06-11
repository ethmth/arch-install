#!/usr/bin/env python3

# https://mega.nz/folder/0z43kaoC#apUUDxeKcint2uZeeuSGwg

import base64
import requests
import random
import sys
import json
from urllib.parse import urlparse
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import padding

DEBUG = True

def main():
    if len(sys.argv) != 2:
        print("URL expected as only system argument")
        sys.exit(1)

    url = sys.argv[1]
    parsed_url = urlparse(url)

    n = parsed_url.path.split("/")[-1]
    folder_key = parsed_url.fragment    
    seqno = (random.getrandbits(64) - 2**63) & int("0xffffffff", 16)

    headers = {
        'Content-type': 'text/plain;charset=UTF-8',
        'User-Agent': 'Mozilla/5.0',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
        'Accept': 'text/html, image/gif, image/jpeg, *; q=.2, */*; q=.2',
        'Connection': 'keep-alive',
    }

    data = '[{"a":"f", "c":"1", "r":"1", "ca":"1"}]'

    params = {
        'id': seqno, # FROM IDK
        'n': n, # FROM URL
    }

    data = None
    if not DEBUG:
        response = requests.post('https://g.api.mega.co.nz/cs', params=params, headers=headers, data=data)
        data = response.json()
    else:
        with open('response.json', 'r') as file:
            data = json.load(file)
    
    # print(json.dumps(data, indent=4))
    with open('response.json', 'w') as file:
        json.dump(data, file, indent=4)

    # String dec_node_k = Bin2UrlBASE64(decryptKey(UrlBASE642Bin(node_k[1]), _urlBase64KeyDecode(folder_key)));

    print(folder_key)
    print(base64.urlsafe_b64decode(folder_key + "=="))
    # HashMap at = _decAttr((String) node.get("a"), _urlBase64KeyDecode(dec_node_k));
    
    

if __name__ == "__main__":
    main()