#!/opt/homebrew/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$CURRENT_DIR/scripts/monitor-session-activity.sh" </dev/null >/dev/null 2>&1 &
