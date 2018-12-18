#!/bin/bash
#
# Stop the server as a service.
#

set -e

here="`dirname \"$0\"`"
pid_file="$here/service.pid"

cd "$here"

if [ -f "$pid_file" ]; then
  pid="`cat "$pid_file"`"
  if [ -z "$pid" ]; then
    >&2 echo "ERROR: No process ID given. Aborting."
    exit 1
  fi
  kill -9 $pid || true
  # wait for the process to exit
  # see https://stackoverflow.com/a/19396161
  sleep .01
  while [ -e /proc/$pid ]
  do
    echo -n .
    sleep .01
  done
  rm "$pid_file"
fi

if [ -f "$pid_file" ]; then
  >&2 echo "ERROR: Could not delete pid file."
fi
