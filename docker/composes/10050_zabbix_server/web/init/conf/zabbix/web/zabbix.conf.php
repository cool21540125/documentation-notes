<?php
// Zabbix GUI configuration file.
global $DB, $HISTORY;

$DB['TYPE']     = getenv('DB_SERVER_TYPE');
$DB['SERVER']   = getenv('DB_SERVER_HOST');
$DB['PORT']     = getenv('DB_SERVER_PORT');
$DB['DATABASE'] = getenv('DB_SERVER_DBNAME');
$DB['USER']     = getenv('DB_SERVER_USER');
$DB['PASSWORD'] = getenv('DB_SERVER_PASS');

$ZBX_SERVER      = getenv('ZBX_SERVER_HOST');
$ZBX_SERVER_PORT = getenv('ZBX_SERVER_PORT');
$ZBX_SERVER_NAME = getenv('ZBX_SERVER_NAME');

$IMAGE_FORMAT_DEFAULT	= IMAGE_FORMAT_PNG;

// Elasticsearch url (can be string if same url is used for all types).
$history_url = str_replace("'","\"",getenv('ZBX_HISTORYSTORAGEURL'));
$HISTORY['url']   = (json_decode($history_url)) ? json_decode($history_url, true) : $history_url;

// Value types stored in Elasticsearch.
$storage_types = str_replace("'","\"",getenv('ZBX_HISTORYSTORAGETYPES'));
$HISTORY['types'] = (json_decode($storage_types)) ? json_decode($storage_types, true) : array();