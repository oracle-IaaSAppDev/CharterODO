# cloudagent

Instructions
------------

!!Script assumes /home/oracle/scripts/odo directory already exists!!
!!Run as the "oracle" user!!

0. Create entity types in the OMC tenant
	These only need to be created when a new tenant is provisioned before any of the campaigns and their respective engines are created.
0.1. usr_odo_engine.json
0.2. usr_odo_engine_osm.json
0.3. usr_odo_engine_asap.json
0.4. usr_odo_campaign.json

1. Post Engine Creation (db objects/omc entities)
1.1. prereq_scripts.sh
		Installs a cronjob to run these scripts below every 5 minutes.
		Marks all *.sh scripts as executable.
1.1.1. prereq_db_directory.sql
		Script to create a database directory where some of the json files will be created.

1.2. create_odoentities.sh
1.2.1. add_odocampaign.sh
		Add the odo campaign. It's name is derived from the hostname. Please note, a campaign will only be created with the first engine.
1.2.2. add_odoengine.sh
		Add the odo engine. It's name is derived from the hostname.
1.2.2.1. get_engine_name.py
		Determine the engine incarnation, i.e. 0.0, 0.1 etc
1.2.3. add_odoengineosm.sh
		Add the odo engine's osm module. It's name is derived from the hostname.
1.2.4. add_odoenginedbinstance.sh
		Add the odo engine's database instance. It's name is derived from the hostname.
1.2.5. add_odoengineasap.sh
		Add the odo engine's asap module. It's name is derived from the hostname.
1.2.6. add_associations.sh
		Add associations between the different entities.
1.2.7. check_entity.sh
		Check if an entity exists.
1.2.8. add_associations.sh
		Add associations between entities.

2. Post Engine Creation - On Metric Collection
2.1. collect_metrics.sh
2.1.1. odoengine_metric_ordersummary.sql
		Collect and generate JSON file with Order Summary.
2.1.2. odoengine_metric_partition_count.sql
		Collect and generate JSON file with Partition Counts.
2.1.3. odoengine_capacity.sh
		Collect and generate JSON files for tablespace, order id, and root file system capacity utilizations
2.1.3.1. odoengine_capacity_tablespace.sql
2.1.3.2. odoengine_capacity_orderids.sql
2.1.4. collect_status.sh
		Collect and generate JSON files for the status for ASAP, OSM, DB Instance, and the over-all Engine.
2.1.5. monitor_engine.sh
		Determines whether an engine needs to be placed in awol mode.
2.1.5.1. taint.sh
		Taints the engine (BMCS thread).


		
How to execute
--------------
$ mkdir -o /home/oracle/scripts/odo
$ chmod +x /home/oracle/scripts/odo/*.sh
$ /home/oracle/scripts/odo/prereq_scripts.sh
$ /home/oracle/scripts/odo/create_odoentities.sh


3. Scripts running in Cron, outside of engines via an administrative server.
3.1. engine_down_status.py
	If an engine hasn't reported in within 15 minutes, mark it as AWOL.
3.2. aggregate_campaign_metrics.py
	Aggregate each campaign's engine metrics at a campaign level.

