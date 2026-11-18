#!/usr/bin/env bash

# Prints the first numeric token in the given arguments, or nothing if none.

set -euo pipefail

grep -oE '[0-9]+' <<<"$*" | head -n1 || true
