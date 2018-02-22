1. Create Entities
	Engine -> 1.1.create_entitytype_odo_engine
	Campaign -> 1.1.create_entitytype_odo_engine
	Asap -> 1.1.create_entitytype_odo_engine
	OSM -> 1.1.create_entitytype_odo_engine

2. Create Dashboards/Widgets
	ODO -> 2.1.import_odo_dashboard.html
	Campaign -> 2.2.import_odo_campaign_dashboard.html
	Engine -> 2.3.import_odo_engine_dashboard.html

3. Edit following scripts and replace references for 
	3.a. uscgbuodo2trial to the new tenant
	3.b. authorization tokens, for example "dXNjZ2J1b2RvMnRyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==" with a new one

--./files/entity_check.py:4
--./files/kill.sh:24
--./files/add_odoengineasap.sh:38
--./files/campaign_decommission_status.sh:6
--./files/add_odoengineosm.sh:48
--./files/add_odoengine.sh:55
--./files/add_associations.sh:
--./files/create_odoentities.sh:
--./files/collect_metrics.sh:41
--./files/get_engine_name.py:11
--./files/add_odoenginedbinstance.sh:48
--./files/AgentInstall.sh:56:tenantId=uscgbuodotrial
--./files/add_odocampaign.sh:62
--./files/monitor_engine.sh:61
--./templates/default/engine_down_status.py
--./templates/default/aggregate_campaign_metrics.py:14
--./templates/default/assocs.py:24

4. Create alert rules
	ODO 

5. Note new registration key:

RF7eyGlELpZsSC78Cl8Z8MDtx4


{
	"groupName": "sometest",
	"groupType": "Dynamic",
    "members": [],
    "tags" : {
        "campaign" : "robinlaidanegg-0.0_engine"
            }
}