#!/usr/bin/python3
import os
import sys
from urllib.parse import urljoin

import requests
from requests.auth import HTTPBasicAuth

BASE_URL = "https://api.atlassian.com"
API_ROOT = f"{BASE_URL}/marketplace/rest/3/"
PARENT_SOFTWARE_ID = "jira"
DEFAULT_PAGE_SIZE = 10
USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36"
)


def print_versions(payload):
    for version in payload.get("versions", []):
        name = version.get("versionNumber", "unknown")
        date = version.get("createdAt", "unknown")
        print(name, date)


def poll_versions(url, auth):
    response = requests.get(url, headers={"User-Agent": USER_AGENT}, auth=auth, timeout=30)
    response.raise_for_status()
    payload = response.json()
    print_versions(payload)
    if "links" in payload and "next" in payload["links"]:
        next_path = payload["links"]["next"]
        if next_path.startswith("http"):
            return next_path
        return urljoin(API_ROOT, next_path.lstrip("/"))
    return None


def resolve_auth():
    email = os.environ.get("ATLASSIAN_EMAIL")
    token = os.environ.get("ATLASSIAN_API_TOKEN")
    if not email or not token:
        print(
            "Missing auth. Set ATLASSIAN_EMAIL and ATLASSIAN_API_TOKEN environment variables.",
            file=sys.stderr,
        )
        sys.exit(1)
    return HTTPBasicAuth(email, token)


all_flag = False
num_versions = DEFAULT_PAGE_SIZE
if len(sys.argv) > 1:
    if sys.argv[1] == "-all":
        all_flag = True
    if len(sys.argv) > 2:
        num_versions = int(sys.argv[2])

auth = resolve_auth()
next_url = (
    f"{API_ROOT}parent-software/"
    f"{PARENT_SOFTWARE_ID}/versions?limit={DEFAULT_PAGE_SIZE}"
)
next_url = poll_versions(next_url, auth)
remaining_versions = num_versions - DEFAULT_PAGE_SIZE
if all_flag:
    while next_url and remaining_versions > 0:
        next_url = poll_versions(next_url, auth)
        remaining_versions -= DEFAULT_PAGE_SIZE