curl -X POST \
  https://uscgbuodo2trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/metadata/entityTypes/ \
  -H 'authorization: Basic dXNjZ2J1b2RvdHJpYWwubWFhei5hbmp1bUBvcmFjbGUuY29tOlRlc3QhMjM0' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 54614520-059c-a81b-fff9-000d6f8ae65a' \
  -d '{
    "entityType": "usr_odo_engine_asap",
    "category": "Applications",
    "typeDisplayName": "ODO Engine - ASAP",
    "parentTargetType": "omc_entity",
    "meClass": "TARGET",
    "propertyTypeList": [
    ],
    "tenantSpecific": true
}'