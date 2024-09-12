#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------

### restore
BACKUP_BSON_FILE_PATH=
mongorestore -u $USER --authenticationDatabase admin --db=$YOUR_BACKUP_DB $BACKUP_BSON_FILE_PATH
