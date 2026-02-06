#!/bin/bash
RUN=`sudo swanctl --list-sas --raw`

case "$1" in
    "childsas")
        child_sas_blocks=$(echo "$RUN" | sed -n 's/.*child-sas {\(.*\)}$/\1/p')

        result="["

        while read -r block; do
            name=$(echo "$block" | grep -oP 'name=\K[^\s]+')
            bytes_in=$(echo "$block" | grep -oP 'bytes-in=\K[0-9]+')
            bytes_out=$(echo "$block" | grep -oP 'bytes-out=\K[0-9]+')
            packets_in=$(echo "$block" | grep -oP 'packets-in=\K[0-9]+')
            packets_out=$(echo "$block" | grep -oP 'packets-out=\K[0-9]+')

            result+="{\"name\": \"$name\", \"bytes_in\": \"$bytes_in\", \"bytes_out\": \"$bytes_out\", \"packets_in\": \"$packets_in\", \"packets_out\": \"$packets_out\"},"
        done <<< "$child_sas_blocks"

        result=$(echo "$result" | sed 's/,$//')
        result+="]"

        echo "$result"
    ;;
esac