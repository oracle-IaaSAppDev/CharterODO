import requests, json, datetime
from requests import ReadTimeout, ConnectTimeout, HTTPError, Timeout, ConnectionError

## Variables

# Static Variables
dateNow = (datetime.datetime.now()).strftime('%Y-%m-%dT%H:%M:%SZ')

# URLs and Headers
get_groupurl = "https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/groups/"
get_base_campaignentityurl = "https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/?entityName="
get_base_groupentityurl = "https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/groups/"
get_base_entitymetricurl = "https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/tm-data/mes/"
post_base_entitymetriccurl = "https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/tm-data/mes/"

headers = {
    'content-type': "application/json",
    'authorization': "Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==",
    'cache-control': "no-cache"
    }

# Running Counters; reset to 0
ordersTotal = ordersFailed = ordersOpen = ordersSuccessful = 0
campaignentityId = ''
# 1: Get all Groups
r = requests.get(get_groupurl, headers=headers)
group = r.json()
for groupentry in group['items']:
	# Zero out all order metric
	ordersTotal = ordersFailed = ordersOpen = ordersSuccessful = 0
#	print 'groupId: ' + groupentry['groupId'] + ', groupName: ' + groupentry['groupName']
#	print 'groupName: ' + groupentry['groupName']

# 2: Groups, essentially are a different type of entity. We need to retrieve the entity or meId 
#    for the usr_odo_campaign entity respective to this group.
	get_campaignentityurl = get_base_campaignentityurl + groupentry['groupName'] + '&entityType=usr_odo_campaign'
	r = requests.get(get_campaignentityurl, headers=headers)
	campaignentity = r.json()

	for campaignentry in campaignentity['items']:
#		print 'campaign entityid: ' + campaignentry['entityId'] + ', entity name: ' + campaignentry['entityName']
		campaignentityId = campaignentry['entityId']

# 2: Get all entities for the group, and filter for ODO Engines 
	get_groupentityurl = get_base_groupentityurl + groupentry['groupId']
	r = requests.get(get_groupentityurl, headers=headers)
	groupentity = r.json()
# 3: For each engine, retrieve order counts
	for entry in groupentity['members']:
		if entry['entityType'] == 'usr_odo_engine':
#			print '   engine name: ' + entry['entityName']
			#print 'entityType: ' + entry['entityType'] + ', entityId: ' + entry['entityId'] + ', entityName: ' + entry['entityName']
			get_entitymetricurl = get_base_entitymetricurl + entry['entityId'] + '/metricgroups/engine_order_counts'
# 4: For each engine, retrieve order counts
			r = requests.get(get_entitymetricurl, headers=headers)
			entitymetric = r.json()
# 5: Keep a running total of each metric's value per group
			# Order counts are always printed in the following order:
			# [u'total_orders', u'open_orders', u'successful_orders', u'failed_orders']
			for key, value in entitymetric.items():
				if key == 'metricColumnValues':
					#print key, value
					#print key.replace('metric','human')
					ordersTotal = ordersTotal + value[0][0]
					ordersOpen = ordersOpen + value[0][1]
					ordersSuccessful = ordersSuccessful + value[0][2]
					ordersFailed = ordersFailed + value[0][3]
	jsonData = [{
    			"collectionTs" : "" + dateNow + "",
    			"entityType" : "usr_odo_campaign",
    			"metricGroup" : "campaign_order_counts",
    			"metricNames" : [
          			"total_orders",
          			"open_orders",
          			"successful_orders",
          			"failed_orders"
    			],
    			"metricValues" : [
      			[
        			ordersTotal,
        			ordersOpen,
                	ordersSuccessful,
                	ordersFailed
      			]
    			]
		}]
#	print jsonData
# 6: Upload these metric values to the group, i.e. campaign
	post_entitymetriccurl = post_base_entitymetriccurl + campaignentityId + '/metricGroups'
	r = requests.post(post_entitymetriccurl, headers=headers, json=jsonData, verify=True)
	print post_entitymetriccurl
