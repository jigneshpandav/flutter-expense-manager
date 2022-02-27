#!/usr/bin/env bash

set -euo pipefail

# Remove previous pid files
rm -f /tmp/flutter.pid

# Run in a loop a hot reload call in a subshell
(while true
do
    # Wait for flutter to start before monitoring pid
    while [[ ! -f /tmp/flutter.pid ]]; do sleep 1; done;

    # Send hot reload signal when files change
    find lib/ -name '*.dart' | entr -n -d -p kill -USR1 $(cat /tmp/flutter.pid)
done) &

# Run all devices under 1 pid
flutter run -d all --pid-file /tmp/flutter.pid