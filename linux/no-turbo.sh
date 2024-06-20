#!/usr/bin/env bash

DEBUG=0

# This turns off Intel turbo boost because the BIOS won't let us do it in there
# Requirements: CONFIG_X86_INTEL_PSTATE

until [ -e /sys/devices/system/cpu/intel_pstate/no_turbo ]; do
	if [ "$DEBUG" -eq "1" ]; then
		printf "Waiting for no_turbo to appear...\n"
	fi
	sleep 5
done

OUTPUT=`cat /sys/devices/system/cpu/intel_pstate/no_turbo`

if [ "$OUTPUT" -ne "1" ]; then
	until [ "$OUTPUT" -eq "1" ]; do
		echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
		OUTPUT=`cat /sys/devices/system/cpu/intel_pstate/no_turbo`
		if [ "$OUTPUT" -ne "1" ]; then
			if [ "$DEBUG" -eq "1" ]; then
			printf "Turbo did not get disabled, trying again...\n"
			fi
			sleep 5
		else
			if [ "$DEBUG" -eq "1" ]; then
				printf "Turbo should now be disabled...\n"
			fi
		fi
	done
else
	if [ "$DEBUG" -eq "1" ]; then
	        printf "Turbo is already disabled.\n"
	fi
fi
