#!/bin/bash
set -x
if [ ! -f "/opt/scope/scope.json" ]; then
  echo "init scope"
  cd /opt/scope/
  bit init --bare
fi

/usr/bin/sudo /usr/sbin/sshd -D
