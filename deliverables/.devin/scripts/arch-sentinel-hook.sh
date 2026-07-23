#!/bin/bash
# arch-sentinel-hook.sh
# PostToolUse hook: only acts when arch-sentinel.json itself was the file
# written/edited. Enforces minimum quality bar for ARCHITECTURE document output.

INPUT=$(cat)
LOG_FILE="hook-log.txt"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Which file did this tool call actually touch?
WRITTEN_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# Stay silent for any write/edit that isn't arch-sentinel.json.
if [ -z "$WRITTEN_PATH" ] || [ "$(basename "$WRITTEN_PATH")" != "arch-sentinel.json" ]; then
  exit 0
fi

SENTINEL_FILE="$WRITTEN_PATH"

if [ ! -f "$SENTINEL_FILE" ]; then
  MSG="[$TIMESTAMP] FAIL: arch-sentinel.json not found. ARCHITECTURE command may not have completed."
  echo "$MSG" | tee -a "$LOG_FILE" >&2
  exit 1
fi

HAS_SYSTEM_CONTEXT_MAP=$(jq -r '.has_system_context_map' "$SENTINEL_FILE")
HAS_C4_SYSTEM_CONTEXT_DIAGRAM=$(jq -r '.has_c4_system_context_diagram' "$SENTINEL_FILE")
HAS_C4_CONTAINER_DIAGRAM=$(jq -r '.has_c4_container_diagram' "$SENTINEL_FILE")
HAS_C4_COMPONENT_DIAGRAM=$(jq -r '.has_c4_component_diagram' "$SENTINEL_FILE")
HAS_FLOW_DIAGRAM=$(jq -r '.has_flow_diagram' "$SENTINEL_FILE")
HAS_INTEGRATIONS=$(jq -r '.has_integrations' "$SENTINEL_FILE")
HAS_INTEGRATION_PATTERNS=$(jq -r '.has_integration_patterns' "$SENTINEL_FILE")
HAS_QUALITY_ATTRIBUTES=$(jq -r '.has_quality_attributes' "$SENTINEL_FILE")
HAS_DEPLOYMENT=$(jq -r '.has_deployment' "$SENTINEL_FILE")
HAS_SECURITY_CONSIDERATIONS=$(jq -r '.has_security_considerations' "$SENTINEL_FILE")
HAS_ARCHITECTURE_DECISIONS=$(jq -r '.has_architecture_decisions' "$SENTINEL_FILE)

EXIT_CODE=0
 
fail_if_false() {
  local value="$1"
  local message="$2"
  if [ "$value" != "true" ]; then
    echo "[$TIMESTAMP] FAIL: $message" | tee -a "$LOG_FILE" >&2
    EXIT_CODE=2
  fi
}

fail_if_false "$HAS_SYSTEM_CONTEXT_MAP" "Architecture does not contain a system context map."
fail_if_false "$HAS_C4_SYSTEM_CONTEXT_DIAGRAM" "Architecture does not contain a C4 system context diagram."
fail_if_false "$HAS_C4_CONTAINER_DIAGRAM" "Architecture does not contain a C4 container diagram."
fail_if_false "$HAS_C4_COMPONENT_DIAGRAM" "Architecture does not contain a C4 component diagram."
fail_if_false "$HAS_FLOW_DIAGRAM" "Architecture does not contain a flow diagram."
fail_if_false "$HAS_INTEGRATIONS" "Architecture does not contain integrations."
fail_if_false "$HAS_INTEGRATION_PATTERNS" "Architecture does not contain integration patterns."
fail_if_false "$HAS_QUALITY_ATTRIBUTES" "Architecture does not contain quality attributes."
fail_if_false "$HAS_DEPLOYMENT" "Architecture does not contain deployment."
fail_if_false "$HAS_SECURITY_CONSIDERATIONS" "Architecture does not contain security considerations."
fail_if_false "$HAS_ARCHITECTURE_DECISIONS" "Architecture does not contain architecture decisions."

# --- Word count check ---
WORD_COUNT=$(jq -r '.word_count // 0' "$SENTINEL_FILE")
if [ "$WORD_COUNT" -le 1000 ]; then
  MSG="[$TIMESTAMP] FAIL: ARCHITECTURE word count ($WORD_COUNT) does not exceed 1000."
  echo "$MSG" | tee -a "$LOG_FILE" >&2
  EXIT_CODE=2
fi

# --- Required sections check ---
REQUIRED_SECTIONS=(
  "High-Level Architecture"
  "System Context Map"
  "System Breakdown using C4 Modeling"
  "Conceptual DB Design"
  "Integrations"
  "Security Considerations"
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
  MSG="[$TIMESTAMP] FAIL: ARCHITECTURE is missing required section(s): $MISSING_LIST"
  echo "$MSG" | tee -a "$LOG_FILE" >&2
  EXIT_CODE=2
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "[$TIMESTAMP] PASS: ARCHITECTURE sentinel checks passed." | tee -a "$LOG_FILE"
else
  echo "[$TIMESTAMP] FAIL: One or more ARCHITECTURE sentinel checks failed." | tee -a "$LOG_FILE" >&2
fi
 
exit $EXIT_CODE