curl -X POST \
  https://uscgbuodo2trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/metadata/entityTypes \
  -H 'authorization: Basic dXNjZ2J1b2RvdHJpYWwubWFhei5hbmp1bUBvcmFjbGUuY29tOlRlc3QhMjM0' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: aebd3a8c-9f1c-197f-1e9e-f464c2bc3f08' \
  -d '{
    "entityType": "usr_odo_campaign",
    "category": "Applications",
    "typeDisplayName": "ODO Campaign",
    "parentTargetType": "omc_entity",
    "meClass": "TARGET",
    "metricGroupTypeList": [
        	{
            "entityTypeName": "usr_odo_campaign",
            "metricGroupName": "campaign_order_counts",
            "metricGroupDisplayName": "Campaign Order Counts",
            "metricGroupClass": "PERFORMANCE",
            "columnList": [
                {
                    "metricColumnName": "total_orders",
                    "metricColumnDisplayName": "Total Orders",
                    "unitType": "OMC_SYS_STANDARD_GENERAL_NA",
                    "metricColumnClass": "NUM",
                    "isKey": false,
                    "uiPriority": 1,
                    "baselineable": false,
                    "isIndexed": false,
                    "derivationMethod": "BASIC",
                    "unitStr": "n/a",
                    "alertable": false,
                    "derivationSources": [],
                    "metricColumnAliasList": [],
                    "knownValueList": [],
                    "ligDwnSmplKeys": 0,
                    "displayInUI": true
                },
    		{
                    "metricColumnName": "open_orders",
                    "metricColumnDisplayName": "Open Orders",
                    "unitType": "OMC_SYS_STANDARD_GENERAL_NA",
                    "metricColumnClass": "NUM",
                    "isKey": false,
                    "uiPriority": 1,
                    "baselineable": false,
                    "isIndexed": false,
                    "derivationMethod": "BASIC",
                    "unitStr": "n/a",
                    "alertable": false,
                    "derivationSources": [],
                    "metricColumnAliasList": [],
                    "knownValueList": [],
                    "ligDwnSmplKeys": 0,
                    "displayInUI": true
                },
                {
                    "metricColumnName": "successful_orders",
                    "metricColumnDisplayName": "Successful Orders",
                    "unitType": "OMC_SYS_STANDARD_GENERAL_NA",
                    "metricColumnClass": "NUM",
                    "isKey": false,
                    "uiPriority": 1,
                    "baselineable": false,
                    "isIndexed": false,
                    "derivationMethod": "BASIC",
                    "unitStr": "n/a",
                    "alertable": false,
                    "derivationSources": [],
                    "metricColumnAliasList": [],
                    "knownValueList": [],
                    "ligDwnSmplKeys": 0,
                    "displayInUI": true
                },
    			{
                    "metricColumnName": "failed_orders",
                    "metricColumnDisplayName": "Failed Orders",
                    "unitType": "OMC_SYS_STANDARD_GENERAL_NA",
                    "metricColumnClass": "NUM",
                    "isKey": false,
                    "uiPriority": 1,
                    "baselineable": false,
                    "isIndexed": false,
                    "derivationMethod": "BASIC",
                    "unitStr": "n/a",
                    "alertable": false,
                    "derivationSources": [],
                    "metricColumnAliasList": [],
                    "knownValueList": [],
                    "ligDwnSmplKeys": 0,
                    "displayInUI": true
                }
            ],
            "config": false,
            "displayInUI": true,
            "fullPath": "campaign_order_counts",
            "stm": true,
            "curationLevel": 1,
            "extension": false,
            "dataCollectionType": 0,
            "metricGroupType": "STANDARD",
            "rollupDisabled": 0,
            "keyColumnNames": []
        	},
            {
    			"columnList" : [
      			{
        			"columnClass" : "STRING",
        			"metricColumnDisplayName" : "Create Date",
        			"metricColumnName" : "create_date"
      			}
								],
    			"entityTypeName" : "usr_odo_campaign",
    			"metricGroupClass" : "PERFORMANCE",
    			"metricGroupDisplayName" : "Campaign Inception",
				"metricGroupName" : "campaign_inception"
			}
    ],
    "propertyTypeList": [
    ],
    "tenantSpecific": true
}'