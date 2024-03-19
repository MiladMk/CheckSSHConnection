#!/bin/bash

echo -e "Enter password for servers: "
read Pass ;
IFS=$'\r\n' GLOBIGNORE='*' command eval  'users=($(cat ip.txt))'
for myip in "${users[@]}";
do
  SERVER=$myip
  PORT=8088
  sshpass -p $Pass ssh -q -o ConnectTimeout=10  root@$SERVER -p $PORT exit
  EXIT_STATUS=$?
  if [ "$EXIT_STATUS" -eq "0" ]
  then
    echo "Connected to server $SERVER on port $PORT was successful"
  elif [ "$EXIT_STATUS" -eq "1" ]
  then
    echo "Failed to connect to server $SERVER on port $PORT"
    echo "Error: Invalid command line argument"
    elif [ "$EXIT_STATUS" -eq "2" ]
  then
    echo "Failed to connect to server $SERVER on port $PORT"
    echo "Error: Conflicting arguments given"
    elif [ "$EXIT_STATUS" -eq "3" ]
  then
    echo "Failed to connect to server $SERVER on port $PORT"
    echo "Error: General runtime error"
    elif [ "$EXIT_STATUS" -eq "4" ]
  then
    echo "Failed to connect to server $SERVER on port $PORT"
    echo "Error: Unrecognized response from ssh (parse error)"
    elif [ "$EXIT_STATUS" -eq "5" ]
  then
    echo "Failed to connect to server $SERVER on port $PORT"
    echo "Error: Invalid/incorrect password"
    elif [ "$EXIT_STATUS" -eq "6" ]
  then
    echo "Failed to connect to server $SERVER on port $PORT"
    echo "Error: Host public key is unknown. sshpass exits without confirming the new key."
  else
    echo "Failed to connect to server $SERVER on port $PORT"
    echo "Error: 255"
  fi
done
