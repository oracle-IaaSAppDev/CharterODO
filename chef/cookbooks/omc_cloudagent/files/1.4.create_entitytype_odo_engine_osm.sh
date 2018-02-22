curl -X POST \
  https://uscgbuodo2trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/metadata/entityTypes/ \
  -H 'authorization: Basic dXNjZ2J1b2RvdHJpYWwubWFhei5hbmp1bUBvcmFjbGUuY29tOlRlc3QhMjM0' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: dc1d4e90-bc02-11d9-7776-bfe04d56c38e' \
  -d '{
    "entityType": "usr_odo_engine_osm",
    "category": "Applications",
    "typeDisplayName": "ODO Engine - OSM",
    "parentTargetType": "omc_entity",
    "meClass": "TARGET",
    "propertyTypeList": [
    ],
    "tenantSpecific": true
}'