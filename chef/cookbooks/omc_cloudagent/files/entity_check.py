import requests, json, datetime, sys

thisentityId = 0
get_base_entityurl = "https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/?entityName="

headers = {
    'content-type': "application/json",
    'authorization': "Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==",
    'cache-control': "no-cache"
    }

get_entityurl = get_base_entityurl + sys.argv[1] + '&entityType=' + sys.argv[2]

r = requests.get(get_entityurl, headers=headers)
entity = r.json()

for entityentry in entity['items']:
        thisentityId = entityentry['entityId']

print thisentityId
