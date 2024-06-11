#!/usr/bin/env python3

# ======================= GLOBALS ========================

DEBUG = True

# ======================= IMPORTS ========================

import base64
import requests
import random
import sys
import os
import json
import ast
from urllib.parse import urlparse
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import padding
from Crypto.Cipher import AES
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad

# ======================= CRYPTO FUNCTIONS ========================

def aes_cbc_decrypt_nopadding(ldata: bytes, key: bytes, iv: bytes) -> bytes:
    cipher = AES.new(key, AES.MODE_CBC, iv)
    decrypted_data = cipher.decrypt(ldata)
    return decrypted_data

def decryptKey(a: bytes, key: bytes) -> bytes:
    return aes_ecb_decrypt_nopadding(a, key)

def aes_ecb_decrypt_nopadding(ldata: bytes, key: bytes) -> bytes:
    cipher = AES.new(key, AES.MODE_ECB)
    return cipher.decrypt(ldata)

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
        return None

def UrlBASE642Bin(ldata: str) -> bytes:
    return base64.urlsafe_b64decode(ldata + "==")

def Bin2UrlBASE64(ldata: bytes) -> str:
    return base64.urlsafe_b64encode(ldata).decode('utf-8').rstrip('=')

def bin2i32a(bin_data: bytes) -> list:
    return [int.from_bytes(bin_data[i:i + 4], byteorder='big') for i in range(0, len(bin_data), 4)]

def i32a2bin(i32a: list) -> bytes:
    return b''.join([i.to_bytes(4, byteorder='big') for i in i32a])

AES_ZERO_IV = i32a2bin([0,0,0,0])


# ======================= FILESYSTEM CLASSES ========================

class FileSystemEntity:
    def __init__(self, fid, name, timestamp):
        self.fid = fid
        self.name = name
        self.timestamp = timestamp

    def get_size(self):
        raise NotImplementedError("Subclasses must implement this method")
    
    def _format_size(self, size_bytes):
        for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
            if size_bytes < 1024.0:
                break
            size_bytes /= 1024.0
        formatted_size = "{:.4g}".format(size_bytes)
        # _str_after_decimal = formatted_size.split(".")[1]
        # if len(_str_after_decimal) > 1 and _str_after_decimal[-1] == '0':
            # formatted_size = "{:.3g}".format(size_bytes)
        return f"{formatted_size} {unit}"

    def __str__(self):
        return self.name

class File(FileSystemEntity):
    def __init__(self, fid, name, size, file_id, timestamp):
        super().__init__(fid, name, timestamp)
        self.size = size
    
    def is_folder(self):
        return False

    def get_size_real(self):
        return self.size

    def get_size(self):
        return self._format_size(self.size)

    def __str__(self):
        # return self.name
        return f"File: {self.name}, Size: {self.get_size()} bytes, Timestamp: {self.timestamp}"

class Folder(FileSystemEntity):
    def __init__(self, fid, name, timestamp):
        super().__init__(fid, name, timestamp)
        self.contents = []

    def is_folder(self):
        return True

    def add(self, entity):
        self.contents.append(entity)

    def get_size_real(self):
        return sum(entity.get_size_real() for entity in self.contents)
    
    def get_size(self):
        size_bytes = sum(entity.get_size_real() for entity in self.contents)
        return self._format_size(size_bytes)

    def __iter__(self):
        return FolderIterator(self)

    def list_contents(self):
        def count_files_and_folders(folder):
            num_files = sum(1 for entity in folder.contents if isinstance(entity, File))
            num_folders = sum(1 for entity in folder.contents if isinstance(entity, Folder))
            for entity in folder.contents:
                if isinstance(entity, Folder):
                    sub_files, sub_folders = count_files_and_folders(entity)
                    num_files += sub_files
                    num_folders += sub_folders
            return num_files, num_folders

        num_files, num_folders = count_files_and_folders(self)
        # print(f"Number of files: {num_files}, Number of folders: {num_folders}")
        return f"{num_files} files, {num_folders} folders"

    def __str__(self):
        # contents_str = "\n  ".join(str(entity) for entity in self.contents)
        
        child_folders = [str(entity) for entity in self.contents if entity.is_folder()]
        contents_str = "\n".join(child_folders)

        if len(child_folders) > 0:
            contents_str = "\n" + contents_str
        # contents_str = "\n".join(str(entity) for entity in self.contents if entity.is_folder())

        return f"{self.name} [{self.get_size()}] [{self.list_contents()}]{contents_str}"

class FolderIterator:
    def __init__(self, folder):
        self.folder = folder
        self.index = 0
        self.stack = []

    def __next__(self):
        if not self.stack:
            self.stack.append(iter(self.folder.contents))
        while self.stack:
            try:
                entity = next(self.stack[-1])
                if isinstance(entity, File):
                    return entity
                elif isinstance(entity, Folder):
                    self.stack.append(iter(entity.contents))
            except StopIteration:
                self.stack.pop()
        raise StopIteration

# ======================= THE REST ========================


def decode_file(ldata: dict, folder_key: str):

    is_folder = False
    if int(ldata["t"]) != 0:
        is_folder = True

    node_k = ldata["k"].split(":")
    dec_node_k = Bin2UrlBASE64(decryptKey(UrlBASE642Bin(node_k[1]), _urlBase64KeyDecode(folder_key)))
    encAttr = ldata["a"]
    decrypted_at = aes_cbc_decrypt_nopadding(UrlBASE642Bin(encAttr), _urlBase64KeyDecode(dec_node_k), AES_ZERO_IV)

    fname_dict = json.loads((decrypted_at.decode().split("MEGA")[-1]).strip("\0"))
    fname = fname_dict["n"]

    file_info = {
        "is_folder": is_folder,
        "id": ldata['h'],
        "parent": ldata['p'],
        "name": fname,
        "timestamp": int(ldata["ts"])
    }

    if not is_folder:
        file_info["size"] = int(ldata["s"])

    return file_info

def get_root_folder(file_list):
    if len(file_list) < 1:
        return

    entity_map = {}

    root_name = file_list[0]["name"]
    root_timestamp = file_list[0]["timestamp"]
    root_id = file_list[0]["id"]

    root_folder = Folder(root_id, root_name, root_timestamp)
    entity_map[root_id] = root_folder

    def get_or_create_folder(folder_id, parent_id, name, timestamp):
        if folder_id not in entity_map:
            parent_folder = entity_map[parent_id]
            new_folder = Folder(folder_id, name, timestamp)
            parent_folder.add(new_folder)
            entity_map[folder_id] = new_folder
        return entity_map[folder_id]

    for item in file_list:
        is_folder = item['is_folder']
        parent_id = item['parent']
        entity_id = item['id']
        name = item['name']
        timestamp = item['timestamp']

        if not is_folder:
            size = item['size']
            entity_map[parent_id].add(File(entity_id, name, size, entity_id, timestamp))
        else:
            get_or_create_folder(entity_id, parent_id, name, timestamp)
    
    return root_folder


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
        'id': seqno,
        'n': n,
    }

    response_data = None
    if not DEBUG:
        response = requests.post('https://g.api.mega.co.nz/cs', params=params, headers=headers, data=data)
        response_data = response.json()
    else:
        with open('response.json', 'r') as file:
            response_data = json.load(file)
    
    with open('response.json', 'w') as file:
        json.dump(response_data, file, indent=4)

    file_list = []
    for entry in response_data[0]['f']:
        file_info = decode_file(entry, folder_key)
        file_list.append(file_info)

    with open('file_list.json', 'w') as file:
        json.dump(file_list, file, indent=4)

    root_folder = get_root_folder(file_list)

    print(root_folder)

    root_folder.list_contents()

if __name__ == "__main__":
    main()