#!/usr/bin/env bash
# Reads the hook event JSON from stdin, extracts the file path,
# and appends "<timestamp>  <file>" to hook-log.txt

FILE_PATH=$(jq -r '.tool_input.file_path // .tool_input.path // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "${TIMESTAMP}  ${FILE_PATH}" >> "${DEVIN_PROJECT_DIR:-.}/hook-log.txt"