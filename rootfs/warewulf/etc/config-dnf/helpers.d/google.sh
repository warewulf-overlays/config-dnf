#!/bin/bash

# Author: griznog
# Purpose: Clean out old Google signing keys.

# Google manages their keys via a cron job, which we disable because it's a
# stupid way to manage the keys. This cleans up any stale keys that may be
# lingering in the node image.

for key in $(rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' | awk '/Google/ {print $1}'); do 
  rpm --erase --allmatches $key
done
