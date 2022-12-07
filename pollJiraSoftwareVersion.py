#!/usr/bin/python3
import requests
response = requests.get("https://marketplace.atlassian.com/rest/2/products/key/jira-software/versions")
json = response.json()

for version in json['_embedded']['versions']:
    name=version['name']
    date=version['releaseDate']
    print(name, date)
    print()
