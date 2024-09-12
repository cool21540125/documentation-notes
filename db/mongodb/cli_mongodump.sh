#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------

### backup
mongodump -u $USER -p --out $BACKUP_BSON_FILE_PATH --db $YOUR_BACKUP_DB
