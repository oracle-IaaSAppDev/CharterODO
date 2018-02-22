#!/bin/bash

export basedir=/home/oracle/scripts/odo
source $basedir/odomeIds

export jenkinshost="129.146.6.189:8080"
export jenkinscreds="mccoold:A11mine1"

odoengine_id=`echo $odoengine_name | cut -f2 -d- | cut -f1 -d.`

crumb=`curl "http://${jenkinscreds}@${jenkinshost}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)"`
curl -H $crumb -X POST http://${jenkinscreds}@${jenkinshost}/job/taint/build --data-urlencode json='{"parameter": [{"name":"CAMPAIGN", "value":"'"${odocampaign_name}"'"},{"name":"ENGINE", "value":"'"${odoengine_id}"'"}]}'

