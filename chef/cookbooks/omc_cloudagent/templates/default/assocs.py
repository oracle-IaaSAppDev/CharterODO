import requests, json, socket

odocampaign_meId = ''
odoengine_meId = ''
odoengineasap_meId = ''
odoenginedbinstance_meId = ''
odoengineosm_meId = ''

print 'odoengine_meId:', odoengine_meId
print 'odoengineasap_meId:', odoengineasap_meId
print 'odoenginedbinstance_meId:', odoenginedbinstance_meId
print 'odoengineosm_meId:', odoengineosm_meId

campaignName = socket.gethostname().split('-')[0]
print 'campaignName:', campaignName

headers = {
    'content-type': "application/json",
    'authorization': "Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==",
    'cache-control': "no-cache"
    }

get_campaignmeIdurl = 'https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/?entityName=' + campaignName + '&entityType=usr_odo_campaign'

r = requests.get(get_campaignmeIdurl, headers=headers)
campaignJson = r.json()

for campaignentry in campaignentity['items']:
#	print 'campaign entityid: ' + campaignentry['entityId'] + ', entity name: ' + campaignentry['entityName']
	odocampaign_meId = campaignentry['entityId']
	print 'odocampaign_meId:', odocampaign_meId

