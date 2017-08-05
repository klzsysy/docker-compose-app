#!/bin/bash
uid=`id -u`
if [ ${uid} -ne 1501 ]
then
	echo plause use user mobileoffice running
	exit 1
else
	mkdir -p /app/data/filebeat/
fi

