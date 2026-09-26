#!/bin/bash
# Run verification without formatting or fixing source files.
# Usage: PYTHON=/path/to/python bash tests/run_tests.sh [pytest paths/options]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$SCRIPT_DIR")"

# Explicit paths replace the full-suite default, allowing efficient focused batches.
if [ "$#" -eq 0 ]; then
    set -- tests/
fi
exec "${PYTHON:-python}" -m pytest "$@"
