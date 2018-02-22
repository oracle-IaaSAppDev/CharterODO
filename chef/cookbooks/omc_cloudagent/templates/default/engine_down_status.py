import requests, json, datetime, time
from requests import ReadTimeout, ConnectTimeout, HTTPError, Timeout, ConnectionError

## Variables

# Static Variables
dateNow = (datetime.datetime.now()).strftime('%Y-%m-%dT%H:%M:%SZ')

# URLs and Headers
get_entity = "https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/"
get_entitydetails = "https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/"
put_entitystatus = "https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/"

headers = {
    'content-type': "application/json",
    'authorization': "Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==",
    'cache-control': "no-cache"
    }
    
r = requests.get(get_entity, headers=headers)
entity = r.json()
for entry in entity['items']:
	if entry['entityType'] == 'usr_odo_engine':
		#print '   engine name: ' + entry['entityName'] + ', engine display name: ' + entry['entityDisplayName'] + ', engine status: ' + entry['availabilityStatus']
		
		get_entitymetricurl = get_entitydetails + entry['entityId']
		r = requests.get(get_entitymetricurl, headers=headers)
		entitydetails = r.json()
		for key, value in entitydetails.items():
			#print key, value
			if key == 'availabilityStatusTimestamp':
				entitystatusdate = datetime.datetime.strptime(value, '%Y-%m-%dT%H:%M:%S.%fZ')
				#print 'entitystatusdate: ', entitystatusdate, type(entitystatusdate)
				#print 'current time: ', datetime.datetime.utcnow(), type(datetime.datetime.utcnow())
				#print 'diff:', (datetime.datetime.utcnow() - entitystatusdate)
				#print 'diff seconds:',(datetime.datetime.utcnow() - entitystatusdate).seconds
				
				# If the engine hasn't updated in over 15 minutes, mark it as AWOL
				if (datetime.datetime.utcnow() - entitystatusdate).seconds > 900:
					# Ignore any engines in Decommission state
					if "_decom" not in (entry['entityDisplayName']):
						#print entry['entityName'], 'hasn''t reported in over 15 minutes.'
				
						jsonData = {
    						"collectionTs" : "" + dateNow + "",
    						"entityId": ""+ entry['entityId'] + "",
    						"entityName" : "" + entry['entityName'] + "",
    						"entityType" : "usr_odo_engine",
    						"entityDisplayName" : "" + entry['entityName'] + "_awol",
    						"namespace" : "EMAAS",
    						"availabilityStatus": "DOWN"
						}	
						print 'new name: ', entry['entityName'] + "_awol"
						data = json.dumps(jsonData)
						print(data)
						r = requests.put(put_entitystatus, headers=headers, json=jsonData, verify=True)
