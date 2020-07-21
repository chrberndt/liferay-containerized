#!/bin/sh

# See https://docs.docker.com/config/containers/multi-service_container/

# Start Tomcat in debug mode
./bundles/tomcat-9.0.17/bin/catalina.sh jpda start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Tomcat: $status"
  exit $status
fi

# Start deploy task from Gradle Wrapper in watch mode
./gradlew -t deploy &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Gradle Wrapper: $status"
  exit $status
fi

# Start tail on Tomcat logs
tail -f bundles/tomcat-9.0.17/logs/catalina.out &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start tail on Tomcat logs: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 30 seconds

while sleep 30; do
  ps aux | grep tomcat | grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux | grep gradlew | grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux | grep tail | grep -q -v grep
  PROCESS_3_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done
