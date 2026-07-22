#!/bin/bash
# prd-sentinel-hook.sh
# PostToolUse hook: only acts when prd-sentinel.json itself was the file
# written/edited. Enforces minimum quality bar for PRD output.

INPUT=$(cat)
LOG_FILE="hook-log.txt"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Which file did this tool call actually touch?
WRITTEN_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# Stay silent for any write/edit that isn't prd-sentinel.json.
if [ -z "$WRITTEN_PATH" ] || [ "$(basename "$WRITTEN_PATH")" != "prd-sentinel.json" ]; then
  exit 0
fi

SENTINEL_FILE="$WRITTEN_PATH"

if [ ! -f "$SENTINEL_FILE" ]; then
  MSG="[$TIMESTAMP] FAIL: prd-sentinel.json not found. PRD command may not have completed."
  echo "$MSG" | tee -a "$LOG_FILE" >&2
  exit 1
fi

HAS_SUCCESS_CRITERIA=$(jq -r '.has_measurable_success_criteria' "$SENTINEL_FILE")
HAS_PROBLEM_STATEMENT=$(jq -r '.has_problem_statement' "$SENTINEL_FILE")
HAS_GOALS=$(jq -r '.has_goals' "$SENTINEL_FILE")
HAS_PERSONAS=$(jq -r '.has_personas' "$SENTINEL_FILE")
HAS_USERSTORES_USECASES=$(jq -r '.has_user_stories_or_use_cases' "$SENTINEL_FILE")
HAS_ACCEPTANCE_CRITERIA=$(jq -r '.has_acceptance_criteria' "$SENTINEL_FILE")
HAS_NFR_WITH_VERIFICATION=$(jq -r '.has_nfr_with_verification' "$SENTINEL_FILE")
HAS_OUT_OF_SCOPE=$(jq -r '.has_explicit_out_of_scope' "$SENTINEL_FILE")

EXIT_CODE=0
 
fail_if_false() {
  local value="$1"
  local message="$2"
  if [ "$value" != "true" ]; then
    echo "[$TIMESTAMP] FAIL: $message" | tee -a "$LOG_FILE" >&2
    EXIT_CODE=1
  fi
}

fail_if_false "$HAS_SUCCESS_CRITERIA" "PRD does not contain measurable success criteria."
fail_if_false "$HAS_PROBLEM_STATEMENT" "PRD does not contain a clear problem statement."
fail_if_false "$HAS_GOALS" "PRD does not contain attainable goals."
fail_if_false "$HAS_PERSONAS" "PRD does not identify target user personas."
fail_if_false "$HAS_USERSTORES_USECASES" "PRD does not contain detailed user stories or use cases."
fail_if_false "$HAS_ACCEPTANCE_CRITERIA" "PRD does not contain useful acceptance criteria."
fail_if_false "$HAS_NFR_WITH_VERIFICATION" "PRD does not contain verified non-functional requirements."
fail_if_false "$HAS_OUT_OF_SCOPE" "PRD does not contain an explicit out-of-scope section."

# --- Word count check ---
WORD_COUNT=$(jq -r '.word_count // 0' "$SENTINEL_FILE")
if [ "$WORD_COUNT" -le 1000 ]; then
  MSG="[$TIMESTAMP] FAIL: PRD word count ($WORD_COUNT) does not exceed 1000."
  echo "$MSG" | tee -a "$LOG_FILE" >&2
  EXIT_CODE=1
fi

# --- Required sections check ---
REQUIRED_SECTIONS=(
  "Product Overview"
  "Features"
  "Non-Functional Requirements"
  "Key Implementation Details"
  "Scope Boundaries"
  "Open Questions"
  "Change Log"
)

MISSING_SECTIONS=()
for SECTION in "${REQUIRED_SECTIONS[@]}"; do
  FOUND=$(jq --arg s "$SECTION" '.sections_present | index($s) != null' "$SENTINEL_FILE")
  if [ "$FOUND" != "true" ]; then
    MISSING_SECTIONS+=("$SECTION")
  fi
done

if [ ${#MISSING_SECTIONS[@]} -gt 0 ]; then
  MISSING_LIST=$(printf ", %s" "${MISSING_SECTIONS[@]}")
  MISSING_LIST=${MISSING_LIST:2}
  MSG="[$TIMESTAMP] FAIL: PRD is missing required section(s): $MISSING_LIST"
  echo "$MSG" | tee -a "$LOG_FILE" >&2
  EXIT_CODE=1
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "[$TIMESTAMP] PASS: PRD sentinel checks passed." | tee -a "$LOG_FILE"
else
  echo "[$TIMESTAMP] FAIL: One or more PRD sentinel checks failed." | tee -a "$LOG_FILE" >&2
fi
 
exit $EXIT_CODE