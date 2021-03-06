#!/bin/bash
#
# Start the server as a service.
# This also takes care of stopping the existing service.
#

set -e

install="$1"
here="`dirname \"$0\"`"

cd "$here"
./stop.sh
if [ "$install" == "--install" ]; then
  ./install.sh || true
fi

(
  cd ..
  source ENV/bin/activate
  if [ -f "$pid_file" ]; then
    >&2 echo "ERROR: Process is file $pid_file exists. Aborting."
    exit 1
  fi

  pid_file="service/service.pid"
  output="service/service.log"

  python3 -u app.py 1>"$output" 2>&1 &
  pid="$!"
  echo "$pid" > "$pid_file"
  sleep 0.5
  if ! ps | grep -qE "(^|\s)$pid\s"; then
    >&2 echo "ERROR: Service exited during start."
    >&2 cat "$output"
    exit 2
  fi
)

