import base64
import json
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import padding
import sys
from Crypto.Cipher import AES
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad


def aes_cbc_decrypt_nopadding(data: bytes, key: bytes, iv: bytes) -> bytes:
    cipher = AES.new(key, AES.MODE_CBC, iv)
    decrypted_data = cipher.decrypt(data)
    return decrypted_data

def decryptKey(a: bytes, key: bytes) -> bytes:
    return aes_ecb_decrypt_nopadding(a, key)

def aes_ecb_decrypt_nopadding(data: bytes, key: bytes) -> bytes:
    cipher = AES.new(key, AES.MODE_ECB)
    return cipher.decrypt(data)

def _urlBase64KeyDecode(key: str) -> bytes:
    try:
        key_bin = UrlBASE642Bin(key)

        if len(key_bin) < 32:
            return key_bin[:16]
        else:
            key_i32a = bin2i32a(key_bin[:32])
            k = [key_i32a[0] ^ key_i32a[4], key_i32a[1] ^ key_i32a[5], key_i32a[2] ^ key_i32a[6], key_i32a[3] ^ key_i32a[7]]
            return i32a2bin(k)
    except Exception as ex:
        # logger.error(ex)
        return None

def UrlBASE642Bin(data: str) -> bytes:
    return base64.urlsafe_b64decode(data + "==")

def Bin2UrlBASE64(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).decode('utf-8').rstrip('=')

def bin2i32a(bin_data: bytes) -> list:
    return [int.from_bytes(bin_data[i:i + 4], byteorder='big') for i in range(0, len(bin_data), 4)]

def i32a2bin(i32a: list) -> bytes:
    return b''.join([i.to_bytes(4, byteorder='big') for i in i32a])

AES_ZERO_IV = i32a2bin([0,0,0,0])


# Provided data and key
folder_key = 'apUUDxeKcint2uZeeuSGwg'
data = {
    "h": "975izBhA",
    "p": "1y52TTbY",
    "u": "k267seRCb_8",
    "t": 0,
    "a": "_Y7cW73fp5F0NvIJGkfjHlrLusI65kMiHvEU00GzVmUNi25J7PNRA9jM3joZDpF-Itc7btxH9mrZjJm3GaTxIFrPnLTR847rnhszJ2woGccK6bHnZLqORR-M4wOC0At5",
    "k": "0rxgDQiS:3BuniY2Re_JZfftK7Pse-N6MjDIfmhKhck7pxsTbapw",
    "s": 491918278,
    "fa": "930:0*zCZfN2m1P6M/930:1*K4LkSW_uN00/446:8*fprzR4K0VU4",
    "ts": 1717799962
}


node_k = data["k"].split(":")


dec_node_k = Bin2UrlBASE64(decryptKey(UrlBASE642Bin(node_k[1]), _urlBase64KeyDecode(folder_key)))


encAttr = data["a"]

decrypted_at = aes_cbc_decrypt_nopadding(UrlBASE642Bin(encAttr), _urlBase64KeyDecode(dec_node_k), AES_ZERO_IV)

print(decrypted_at)
print(decrypted_at.decode())

# HashMap at = _decAttr((String) node.get("a"), _urlBase64KeyDecode(dec_node_k));

# Convert key to bytes
# key_bytes = base64.urlsafe_b64decode(key + '==')

# print(key_bytes)
# sys.exit(0)
# Assuming 'a' field is the encrypted data
# encrypted_data = base64.urlsafe_b64decode(data["a"] + '==')

# print(encrypted_data)
sys.exit(0)

# IV might be included in the 'k' field or separate, for this example we assume it's separate
iv = base64.urlsafe_b64decode(data["h"] + '==')

# Create cipher
cipher = Cipher(algorithms.AES(key_bytes), modes.CBC(iv), backend=default_backend())
decryptor = cipher.decryptor()

# Decrypt data
decrypted_data = decryptor.update(encrypted_data) + decryptor.finalize()

# Unpad decrypted data
unpadder = padding.PKCS7(algorithms.AES.block_size).unpadder()
unpadded_data = unpadder.update(decrypted_data) + unpadder.finalize()

# Convert to JSON (if the decrypted data is a JSON string)
decrypted_json = json.loads(unpadded_data.decode('utf-8'))

print(decrypted_json)