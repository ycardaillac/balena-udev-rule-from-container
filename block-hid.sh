#!/bin/sh
# Block USB HID device by writing to parent device's authorized file
LOG_FILE="/tmp/udev.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

DEVPATH="$1"
log "block-hid.sh called with DEVPATH: $DEVPATH"

if [ -z "$DEVPATH" ]; then
    log "ERROR: DEVPATH is empty"
    exit 1
fi

# Get parent device path (strip last component)
PARENT_PATH=$(dirname "$DEVPATH")
AUTHORIZED_FILE="/sys${PARENT_PATH}/authorized"

log "Parent path: $PARENT_PATH"
log "Authorized file path: $AUTHORIZED_FILE"

# Check if authorized file exists before writing
if [ -f "$AUTHORIZED_FILE" ]; then
    CURRENT_VALUE=$(cat "$AUTHORIZED_FILE" 2>/dev/null)
    log "Authorized file exists, current value: $CURRENT_VALUE"
    
    if echo 0 > "$AUTHORIZED_FILE" 2>>"$LOG_FILE"; then
        NEW_VALUE=$(cat "$AUTHORIZED_FILE" 2>/dev/null)
        log "SUCCESS: Wrote 0 to authorized file, new value: $NEW_VALUE"
    else
        log "ERROR: Failed to write to authorized file"
    fi
else
    log "WARNING: Authorized file does not exist: $AUTHORIZED_FILE"
    log "Checking if parent directory exists: $(dirname "$AUTHORIZED_FILE")"
    if [ -d "$(dirname "$AUTHORIZED_FILE")" ]; then
        log "Parent directory exists, listing contents:"
        ls -la "$(dirname "$AUTHORIZED_FILE")" >> "$LOG_FILE" 2>&1
    else
        log "Parent directory does not exist"
    fi
fi

