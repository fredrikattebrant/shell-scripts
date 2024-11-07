#!/usr/bin/python3
import requests
import sys

def print_versions(json):
    for version in json['_embedded']['versions']:
        name=version['name']
        date=version['releaseDate']
        print(name, date)

def poll_versions(url):
    response = requests.get("https://marketplace.atlassian.com" + url)
    json = response.json()
    print_versions(json)
    if '_links' in json and 'next' in json['_links']:
      return json['_links']['next']['href']
    return None


all_flag = False
num_versions = 10
if len(sys.argv) > 1:
    if sys.argv[1] == "-all":
        all_flag = True
    if len(sys.argv) > 2:
        num_versions = int(sys.argv[2])

next = poll_versions("/rest/2/products/key/jira-software/versions")
remaining_versions = num_versions - 10
if all_flag:
    while next and remaining_versions > 0:
        next = poll_versions(next)
        remaining_versions -= 10