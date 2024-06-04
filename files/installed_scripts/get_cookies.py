#!/usr/bin/env python3

import sqlite3
import os
import csv
import sys
from urllib.parse import urlparse

domains = []

def find_cookies_file():
    res = "cookies.sqlite"

    if not os.path.exists(res):
        print(res, "does not exist")
        sys.exit(1)

    return res

def extract_domains():
    domains = []
    # Check if at least one URL has been provided as a command-line argument
    if len(sys.argv) > 1:
        # Iterate over each argument passed to the script (skip the first one, which is the script name)
        for url in sys.argv[1:]:
            # Parse the URL to extract components
            parsed_url = urlparse(url)
            # Extract the domain (netloc) and add to the list
            domain = parsed_url.netloc
            if domain:  # Only add if the domain is successfully extracted
                domains.append(domain)
        
        # Print or process the list of domains
        print("Extracted domains:")
        for domain in domains:
            print(domain)
    else:
        print("Please provide one or more URLs as command-line arguments.")
        sys.exit(1)

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

def main():
    # Define file paths
    #sqlite_file = 'cookies.sqlite'
    extract_domains()
    sqlite_file = find_cookies_file()
    csv_file = 'cookies.csv'
    txt_file = 'cookies.txt'

    # Export cookies to CSV
    export_cookies_to_csv(sqlite_file, csv_file)

    # Convert CSV to cookies.txt format
    convert_csv_to_txt(csv_file, txt_file)

    print("Conversion completed. Check cookies.txt file.")

if __name__ == "__main__":
    main()

