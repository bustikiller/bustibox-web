#!/usr/bin/env bash

## source environmient variables for later use
source /home/ubuntu/bustibox-web/secrets/environment_variables.sh

BACKUPS_DIR=/home/ubuntu/backups

## Change directory to backups dir
cd $BACKUPS_DIR

backup_name=bustibox-`date +%Y-%m-%d"_"%H_%M_%S`
docker exec -t bustibox-web_db_1 pg_dump -c -U $POSTGRES_USER -d bustibox-web > $backup_name.sql
tar -czvf $BACKUPS_DIR/$backup_name.tar.gz $backup_name.sql

## Remove raw SQL backups
rm -v ./*.sql

## Configure file backup with rclone
rclone copy --immutable /home/ubuntu/bustibox/private_files bustibox:files
rclone copy --immutable $BACKUPS_DIR bustibox:databases

## Cleanup after backups
rm -v ./*.tar.gz

## Return to previous directory
cd -
