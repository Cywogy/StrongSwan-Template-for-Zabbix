#!/bin/bash
RUN=$(sudo swanctl --list-sas --raw)

case "$1" in
    "childsas")
        result="["
        first=true

        while IFS= read -r sa; do
            [[ -z "$sa" ]] && continue

            name=$(echo "$sa"        | grep -oP 'name=\K[^\s}]+')
            bytes_in=$(echo "$sa"    | grep -oP 'bytes-in=\K[0-9]+')
            bytes_out=$(echo "$sa"   | grep -oP 'bytes-out=\K[0-9]+')
            packets_in=$(echo "$sa"  | grep -oP 'packets-in=\K[0-9]+')
            packets_out=$(echo "$sa" | grep -oP 'packets-out=\K[0-9]+')

            [[ -z "$name" ]] && continue

            $first || result+=","
            first=false
            result+="{\"name\": \"$name\", \"bytes_in\": \"${bytes_in:-0}\", \"bytes_out\": \"${bytes_out:-0}\", \"packets_in\": \"${packets_in:-0}\", \"packets_out\": \"${packets_out:-0}\"}"
        done < <(echo "$RUN" | grep -oP '[\w-]+-\d+ \{[^}]+\}')

        result+="]"
        echo "$result"
    ;;
esac
