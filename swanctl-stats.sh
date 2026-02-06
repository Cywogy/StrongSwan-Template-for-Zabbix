#!/bin/bash
RUN=`sudo swanctl --stats --raw`
case "$1" in
	"workers")
		workers=`echo $RUN | sed 's/^.* workers/workers/' | sed 's/queues.*//g'`
		workers_total=`echo $workers | awk -F '=' '{print $2}' | grep -oE "[0-9]{1,5}"`
		workers_idle=`echo $workers | awk -F '=' '{print $3}' | grep -oE "[0-9]{1,5}"`
		workers_active_critical=`echo $workers | awk -F '=' '{print $4}' | grep -oE "[0-9]{1,5}"`
		workers_active_high=`echo $workers | awk -F '=' '{print $5}' | grep -oE "[0-9]{1,5}"`
		workers_active_medium=`echo $workers | awk -F '=' '{print $6}' | grep -oE "[0-9]{1,5}"`
		workers_active_low=`echo $workers | awk -F '=' '{print $7}' | grep -oE "[0-9]{1,5}"`
		echo "{\"workers\":[{\"total\": $workers_total, \"idle\": \"$workers_idle\", \"active\": {\"critical\": \"$workers_active_critical \", \"high\": \"$workers_active_high\", \"medium\": \"$workers_active_medium\", \"low\": \"$workers_active_low\"}}]}"
	;;
	"queues")
		queues=`echo $RUN | sed 's/^.* queues/queues/' | sed 's/scheduled.*//g'`
		queues_critical=`echo $queues | awk -F '=' '{print $2}' | grep -oE "[0-9]{1,5}"`
		queues_high=`echo $queues | awk -F '=' '{print $3}' | grep -oE "[0-9]{1,5}"`
		queues_medium=`echo $queues | awk -F '=' '{print $4}' | grep -oE "[0-9]{1,5}"`
		queues_low=`echo $queues | awk -F '=' '{print $5}' | grep -oE "[0-9]{1,5}"`
		echo "{\"queues\":[{\"critical\":\"$queues_critical\",\"high\":\"$queues_high\",\"medium\":\"$queues_medium\",\"low\":\"$queues_low\"}]}"
	;;
	"scheduled")
		echo $RUN | sed 's/ikesas.*//g' | sed 's/^.* scheduled=//' 
	;;
	"ikesas")
		ikesas=`echo $RUN | sed 's/^.* ikesas/ikesas/' | sed 's/plugins.*//g'`
		ikesas_total=`echo $ikesas | awk -F '=' '{print $2}' | grep -oE "[0-9]{1,5}"`
		ikesas_ho=`echo $ikesas | awk -F '=' '{print $3}' | grep -oE "[0-9]{1,5}"`
		echo "{\"ikesas\": {\"total\":\"$ikesas_total\",\"halfopen\":\"$ikesas_ho\"}}"
	;;
esac
