#!/bin/bash
# Script pour lancer Chrome sans CORS (DEV UNIQUEMENT)
google-chrome --disable-web-security --user-data-dir="/tmp/chrome_dev_session" --disable-site-isolation-trials http://localhost:8080
