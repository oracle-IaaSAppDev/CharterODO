import requests, json, socket

## Variables

# Static Variables
thishost = socket.gethostname()
mylist = []
maxlist = 0

# URLs and Headers
get_entity = "https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/"

headers = {
    'content-type': "application/json",
    'authorization': "Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==",
    'cache-control': "no-cache"
    }
    
r = requests.get(get_entity, headers=headers)
entity = r.json()

#loop through all engines, find any that match the existing host name and determine its latest incarnation
for entry in reversed(entity['items']):
	if entry['entityType'] == 'usr_odo_engine' and thishost in entry['entityName']:
		mylist.append(entry['entityName'])
try:
	maxlist = (max(mylist).split(".")[1]).split("_")[0]
	#Find the latest incarnation and add one to it
	maxlist = int(maxlist) + 1
except Exception as inst:
	#if no incarnations exist, it'll be the first one
	maxlist = 0
	
print maxlist
