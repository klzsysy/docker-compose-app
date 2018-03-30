#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
docker exec -i mongodb_db_a_1 mongo --quiet --eval 'db.isMaster().ismaster'  | grep -q -P 'true'