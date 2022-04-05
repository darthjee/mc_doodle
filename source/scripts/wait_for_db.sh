#!/bin/bash

for I in {1..30}; do
  if ( echo "" | telnet $MC_DOODLE_MYSQL_HOST $MC_DOODLE_MYSQL_PORT | grep Escape ); then
    echo done;
    exit 0;
  fi
  sleep 1;
done

exit 1;
