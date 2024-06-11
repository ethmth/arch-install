#!/usr/bin/env python3

import requests

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
    'id': '', # FROM IDK
    'n': '', # FROM URL
}
response = requests.post('https://g.api.mega.co.nz/cs', params=params, headers=headers, data=data)
