#!/usr/bin/env python3

import sqlite3
import os
import csv
import sys

def find_cookies_file():
    res = "cookies.sqlite"

    if not os.path.exists(res):
        print(res, "does not exist")
        sys.exit(1)

    return res

def export_cookies_to_csv(sqlite_file, csv_file):
    """Exports cookies from SQLite to CSV format."""
    # Connect to the SQLite database
    conn = sqlite3.connect(sqlite_file)
    cursor = conn.cursor()

    # Query to extract needed cookie information
    query = """
    SELECT host, path, isSecure, expiry, name, value FROM moz_cookies;
    """

    # Execute the query and fetch all results
    cursor.execute(query)
    cookies = cursor.fetchall()

    # Write the results to a CSV file
    with open(csv_file, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['domain', 'path', 'secure', 'expiry', 'name', 'value'])
        for cookie in cookies:
            writer.writerow(cookie)

    # Close the connection to the database
    conn.close()

def convert_csv_to_txt(csv_file, txt_file):
    """Converts CSV format to the cookies.txt format."""
    with open(csv_file, 'r') as csvfile, open(txt_file, 'w') as txtfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            domain = row['domain']
            path = row['path']
            secure = 'TRUE' if row['secure'] == '1' else 'FALSE'
            expiry = row['expiry']
            name = row['name']
            value = row['value']
            txtfile.write(f"{domain}\tTRUE\t{path}\t{secure}\t{expiry}\t{name}\t{value}\n")

# Define file paths
#sqlite_file = 'cookies.sqlite'
sqlite_file = 'cookies.sqlite'
csv_file = 'cookies.csv'
txt_file = 'cookies.txt'

# Export cookies to CSV
export_cookies_to_csv(sqlite_file, csv_file)

# Convert CSV to cookies.txt format
convert_csv_to_txt(csv_file, txt_file)

print("Conversion completed. Check cookies.txt file.")

