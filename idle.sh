#!/bin/bash

udevadm control --reload-rules
udevadm trigger

# Just an infinite loop to prevent container from exiting
while : ;
do
  echo 'Idling...'
  sleep 600
done
